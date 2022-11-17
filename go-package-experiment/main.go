package main

import (
    "fmt"

    // We import foo but the package under it
    // is actually called numbers
    "gopkgexp/foo"

    // These are two packages with the same name
    // but the import paths differ
    three "gopkgexp/bar/three"
    four "gopkgexp/baz/three"
)

func main() {
    fmt.Printf("%d\n", numbers.One() + numbers.Two())
    fmt.Printf("%d\n", three.Three())
    fmt.Printf("%d\n", four.Four())
}
