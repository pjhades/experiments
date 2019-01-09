#!/bin/bash
# fuck you, os x
./lib-clang $1 \
    -isystem /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include \
    -isystem /Library/Developer/CommandLineTools/usr/lib/clang/10.0.0/include
