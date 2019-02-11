#!/bin/bash

URI="http://127.0.0.1:3000/"

info() {
	echo -e "\E[33m$@\033[0m"
}

error() {
	echo -e "\E[31m$@\033[0m"
}

success() {
	echo -e "\E[32m$@\033[0m"
}

assert_equal() {
    # assert_equal <line> <val1> <val2>
	line=$1
    val1=$2
	val2="$3"
    if [[ "$val1" == "$val2" ]]; then
        echo -n .
        return
	else
		error "\nLine $1: Failure, \"$val1\" mismatches \"$val2\""
		exit 1
	fi
}

assert_not_equal() {
    # assert_not_equal <line> <val1> <val2>
	line=$1
    val1=$2
	val2="$3"
    if [[ "$val1" != "$val2" ]]; then
        echo -n .
        return
	else
		error "\nLine $1: Failure, \"$val1\" matches \"$val2\""
		exit 1
	fi
}

function test_url() {
    # test_url <METHOD> <URL> <DATA>
	METHOD=$1
	URL=$2
	if [ -z $3 ]; then
		curl -X $METHOD $URI/$URL 2>/dev/null
	else
		DATA="$3"
		curl -X $METHOD --data "$DATA" $URI/$URL 2>/dev/null
	fi
	return $?
}

which curl > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
	error "Executable curl not found"
	exit 1
fi

res=$(test_url GET )
if [[ $? -ne 0 ]]; then
	error "CRut is not responding at $URI.\nIs it running?"
	exit 1
fi

## Try the GET
res=$(test_url GET non-existing key=value)
assert_equal $LINENO "$res" "Not Found"

success "\nTest run successfully"
