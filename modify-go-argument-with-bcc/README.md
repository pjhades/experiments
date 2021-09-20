In terminal 1, run the program:
```
$ go build nonsense.go
$ ./nonsense
```

In terminal 2, run the script:
```
$ sudo ./inject.py $(pidof nonsense)
```
