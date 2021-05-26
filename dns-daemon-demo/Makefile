CC = gcc
CFLAGS = -std=c11 -Wall -Werror -Wextra -g -D_GNU_SOURCE

ddd: src/*.c src/*.h
	$(CC) $(CFLAGS) -o $@ src/*.c

test/test_dns: test/test_dns.c
	$(CC) $(CFLAGS) -o $@ $^

UNITTESTS = test/test_dns
INTEGRATION = test/integration/test_query

test: $(UNITTESTS)
	$(foreach t,$(UNITTESTS),./$(t);)
	$(foreach t,$(INTEGRATION),./$(t);)

.PHONY: clean
clean:
	$(RM) src/*.o $(UNITTESTS) ddd
