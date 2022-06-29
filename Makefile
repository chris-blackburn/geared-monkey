CC := clang
CFLAGS := -std=c99 -pedantic -nostdlib -fno-builtin -Wall -Werror -Os --target=wasm32
LDFLAGS := -Wl,--no-entry -Wl,--export-all

TARGET := test.wasm
SRCS := test.c
OBJS := $(patsubst %.c,%.o,$(SRCS))

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

.PHONY: clean
clean:
	rm -rf $(TARGET)
	rm -rf $(OBJS)
