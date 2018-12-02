#!/usr/bin/env python3
import itertools, sys
nums = [int(x) for x in sys.stdin]
s, h = 0, set([0])
for x in itertools.cycle(nums):
    s += x
    if s in h:
        print(s);
        break
    else:
        h.add(s)
