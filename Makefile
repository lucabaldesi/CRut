mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

SRC=$(wildcard src/*.c)
OBJS=$(SRC:.c=.o)

EXE=crut

LIB_CFLAGS+=-I$(current_dir)/src/ -I$(current_dir)/Lib/mongoose/ 

ifdef ENABLE_SSL
CFLAGS+=-DMG_ENABLE_SSL 
LDFLAGS+=  -lssl -lcrypto 
MONGOOSE_OPTS+=-DMG_SSL_IF=MG_SSL_IF_OPENSSL
endif

ifdef DEBUG
CFLAGS+=-g -W -Wall -Wno-unused-function -Wno-unused-parameter -O0
else
CFLAGS+=-O6
endif

LIBS+=$(current_dir)/Lib/mongoose/mongoose.o 
MONGOOSE_OPTS+=-DMG_DISABLE_MQTT -DMG_DISABLE_JSON_RPC -DMG_DISABLE_SOCKETPAIR  -DMG_DISABLE_CGI

LDFLAGS+= -lm 

all: $(EXE) 

$(EXE): $(LIBS) $(OBJS) crut.c
	$(CC) -o $(EXE)  crut.c $(OBJS) $(current_dir)/Lib/mongoose/mongoose.o $(CFLAGS) $(LIB_CFLAGS) $(LDFLAGS)

%.o: %.c 
	$(CC) $< -o $@ -c $(LIB_CFLAGS) $(CFLAGS) 

$(current_dir)/Lib/mongoose/mongoose.o:
	git submodule init $(current_dir)/Lib/mongoose/
	git submodule update $(current_dir)/Lib/mongoose/
	make -C $(current_dir)/Lib/mongoose/ CFLAGS="$(CFLAGS)" MONGOOSE_OPTS="$(MONGOOSE_OPTS)"

tests: $(LIBS) $(OBJS) 
	make -C $(current_dir)/Test/
	$(current_dir)/Test/run_tests.sh

clean:
	rm -f *.o $(EXE) $(OBJS) $(LIBS)

.PHONY: all clean 
