In terminal 1, run the program:
```
$ go build nonsense.go
$ ./nonsense
```

In terminal 2, run the script:
```
$ sudo ./inject.py $(realpath ./nonsense) $(pidof nonsense)
```
The output of terminal 1 should be modified:
```
...
hello world
hello world
what?world
what?world
what?world
what?world
...
```
