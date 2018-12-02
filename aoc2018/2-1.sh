#!/bin/bash

two=0
three=0
while read s; do
    temp=$(echo $s | tr -d '\n' | sed 's/\([a-z]\)/\1\n/g' | sort | uniq -c)
    (echo $temp | grep -P '\s*2\s+' &>/dev/null) && two=$((two+1))
    (echo $temp | grep -P '\s*3\s+' &>/dev/null) && three=$((three+1))
done
echo $((two*three))
