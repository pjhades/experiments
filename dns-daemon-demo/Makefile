CC ?= gcc
CFLAGS ?= -std=c11 -Wall -Werror -Wextra -g -D_GNU_SOURCE

ddd: *.c
	$(CC) $(CFLAGS) -o $@ $^

.PHONY: clean
clean:
	$(RM) *.o ddd
