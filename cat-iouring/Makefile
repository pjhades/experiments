cat: cat.c
	gcc -std=c11 -Wall -Werror -Wpedantic -g -o $@ $^

test: cat
	bash -c 'diff -u <(./cat cat.c) <(cat cat.c)'

.PHONY: clean
clean:
	rm -f cat
