#!/bin/bash
for i in {1..26}; do
    colrm $i $i <input | sort | uniq -c | grep '2 '
done
