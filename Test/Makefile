SRC=$(wildcard *.c)
OBJS=$(SRC:.c=.test)

TARGET_SRC += $(wildcard ../src/*.c) 
TARGET_OBJS=$(TARGET_SRC:.c=.o)

LDFLAGS+=-lm
CFLAGS += -g -W -Wall -Wno-unused-function -Wno-unused-parameter -O0 -I../src -I../Lib/mongoose

all: $(TARGET_SRC) $(TARGET_OBJS) $(OBJS)

%.test: %.c $(TARGET_OBJS) 
	$(CC) -o $@ $< $(CFLAGS) $(TARGET_OBJS) ../Lib/mongoose/mongoose.o $(LIBS) $(LDFLAGS)

clean:
	rm -f *.test $(LIBS)

.PHONY: all clean

