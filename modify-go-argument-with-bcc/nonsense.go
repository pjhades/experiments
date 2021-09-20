package main

import (
    "fmt"
    "time"
)

//go:noinline
func say(s []byte) {
    fmt.Println(string(s))
}

func main() {
    for {
        say([]byte("hello world"))
        time.Sleep(time.Second)
    }
}
