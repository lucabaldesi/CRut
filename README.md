# CRut, a ReST application framework
CRut is web application framework for services written in C.
It is realized so to save the more resources as possible and to be run on Internet-of-Things devices.
It has been developed for the [PeerStreamer-ng](http://peerstreamer.eu) web application, a service for real-time P2P streaming.

Developers are asked to define and couple HTTP request patterns (i.e., URI) and methods.
CRut also serves the files placed in the _Public/_ folder.

By default, CRut runs on port 3000.

## Compile and run
```
make
./crut
```
Point your web browser at _http://localhost:3000_.

## Create your routes
The HTTP request patters comprise of

 * an HTTP method;
 * a regex for the URL.

HTTP methods are: GET, PUT, POST, UPDATE, DELETE, OPTION, HEAD.
Regex allows the specification of a broad range of HTTP resource patters; for example, if you want to match the resource with URL _/channels/BBC_, you can write: "/channels/[A-z0-9]+$".
The previous regex will match all the URLs of the form _/channels/<id>_ where _<id>_ is any string comprising of lower and upper case letters and numbers.

A path handler is a C function pointer with type 
```
void (*path_handler)(struct mg_connection *nc, struct http_message *hm);
```

A route is the triple __HTTP method, URL regex, path handler__.
Routes are defined so to react to specific HTTP requests with some C code.
Routes can be defined in the _src/routes.c_ file with the following line:
```
res |= router_add_route(r, "POST", "^[/]+channels/[A-z0-9]+$", path_handler); 
```
where _res_ and _r_ are scope specific variable to be used as-is.

## Define your handlers
Defining a path handler is easy as opening _src/path_handlers.c_ and writing:
```
void path_handler(struct mg_connection *nc, struct http_message *hm)
{
		mg_http_short_answer(nc, 200);
}
```
The example code above will answer to incoming HTTP requests with a polite "HTTP 200 OK" message.

Handlers can take advantage from some helpers for getting request variable values;

 * mg_uri_field(hm, pos) returns a char array pointer with the value of the URI field specified by _pos_; for example, for the request _/channels/BBC_, with _pos=1_ it will return "BBC".
 * mg_get_http_var(&hm->body, "data", buff, BUFF_LENGTH) stores in the buffer pointed by _buff_ the value of the HTTP variable "data" encoded in the request.

The helpers also include some functions for answering:

 * mg_http_short_answer(nc, code); will send the HTTP request with the status code _code_ and the brief corresponding message;
 * mg_http_text_answer(nc, code, body); adds the possibility to also specify the response message;
 * mg_http_json_answer(nc, code, body); adds the possibility to specify a JSON body (it automatically set the Content-type header).
 * mg_http_answer(nc, code, content_type, body); sends an HTTP requests setting the content type and the response body.

## SSL
CRut supports SSL, just enable it at compilation time:
```
ENABLE_SSL=1 make
```

## Tests
CRut comes with a unit-test suite (in _/Test_).
To run all of them at once type:
```
make tests
```
It requires [valgrind](http://valgrind.org/) to be installed and present in the PATH.

CRut can also be compiled in debug mode for enabling extra output:
```
DEBUG=1 make
```

## Tutorials
A [tutorial](https://ans.disi.unitn.it/users/baldesi//programming/c/rest/raspberry-pi/web/crut/2019/02/13/web-interface-for-raspberry-pi-gpio.html) about using CRut to create a web app turning Raspberry pi leds on and off is avaiable.
