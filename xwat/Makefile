CC = gcc
CFLAGS = -g -std=c11
LDFLAGS = -lxcb -lxcb-icccm
EXE = xwat

$(EXE): *.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

.PHONY: clean
clean:
	rm -f $(EXE) *.o
