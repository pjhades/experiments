CC ?= gcc
CFLAGS ?= -std=c11 -Wall -Werror -Wextra -g

ddd: *.c *.h
	$(CC) $(CFLAGS) -o $@ *.c

.PHONY: clean
clean:
	$(RM) *.o ddd
