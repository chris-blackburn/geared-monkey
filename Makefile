TARGET := tabitha.wasm
SRC := src
INC := include
SRCS := $(shell find $(SRC) -type f -name "*.c")
OBJS := $(patsubst %.c,%.wo,$(SRCS))
DEPS := $(patsubst %.c,%.d,$(SRCS))

CC := clang
LD := wasm-ld
CFLAGS := --target=wasm32 \
		  -std=c11 \
		  -pedantic \
		  -nostdlib \
		  -nostdinc \
		  -fno-builtin \
		  -fvisibility=hidden \
		  -Wall \
		  -Werror \
		  -Os \
		  -I$(INC)
LDFLAGS := --no-entry --export-dynamic --allow-undefined --lto-O3

.PHONY: all
all:: $(TARGET)

-include $(DEPS)

%.wo: %.c
	$(CC) -c -o $@ $< $(CFLAGS) -MMD -MP

$(TARGET): $(OBJS)
	$(LD) -o $@ $^ $(LDFLAGS)

.PHONY: serve
serve:
	python3 -m http.server

.PHONY: clean
clean:
	rm -rf $(TARGET)
	rm -rf $(OBJS)
	rm -rf $(DEPS)
