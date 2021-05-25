CC ?= gcc
CFLAGS ?= -std=c11 -Wall -Werror -Wextra -g -D_GNU_SOURCE

ddd: src/*.c src/*.h
	$(CC) $(CFLAGS) -o $@ src/*.c

.PHONY: clean
clean:
	$(RM) src/*.o ddd
