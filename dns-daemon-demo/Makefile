CC ?= gcc
CFLAGS ?= -std=c11 -Wall -Werror -Wextra -g -D_GNU_SOURCE

ddd: src/*.c src/*.h
	$(CC) $(CFLAGS) -o $@ src/*.c

test/test_dns: test/test_dns.c
	$(CC) $(CFLAGS) -o $@ $^

TESTS := test/test_dns

test: $(TESTS)
	$(foreach t,$(TESTS),./$(t);)

.PHONY: clean
clean:
	$(RM) src/*.o $(TESTS) ddd
