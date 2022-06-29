TARGET := geared-monkey.wasm
SRC := src
INC := include
SRCS := $(shell find $(SRC) -type f -name "*.c")
OBJS := $(patsubst %.c,%.wo,$(SRCS))

CC := clang
LD := wasm-ld
CFLAGS := --target=wasm32 \
		  -std=c99 \
		  -pedantic \
		  -nostdlib \
		  -nostdinc \
		  -fno-builtin \
		  -fvisibility=hidden \
		  -Wall \
		  -Werror \
		  -Os \
		  -I$(INC)
LDFLAGS := --no-entry --lto-O3

.PHONY: all
all:: $(TARGET)

%.wo: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

$(TARGET): $(OBJS)
	$(LD) -o $@ $^ $(LDFLAGS)

.PHONY: serve
serve:
	python3 -m http.server

.PHONY: clean
clean:
	rm -rf $(TARGET)
	rm -rf $(OBJS)
