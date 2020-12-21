#!/usr/bin/env python
import re, sys, functools
if __name__ == '__main__':
    sure = {}
    unsure = {}
    repeat = {}
    for line in sys.stdin:
        m = re.match(r'^([\w ]+)( \(contains ([\w, ]+)\))?$', line.strip())
        a = m.group(1).split(' ')
        b = m.group(3).split(', ') if m.group(3) else []
        for x in b:
            unsure[x] = unsure[x] & set(a) if x in unsure else set(a)
        for x in a:
            repeat[x] = repeat[x] + 1 if x in repeat else 1
    while len(unsure) > 0:
        for k in list(filter(lambda k:len(unsure[k])==1, unsure)):
            x = unsure[k].pop()
            sure[x] = k
            del unsure[k]
            for q in unsure:
                unsure[q] -= {x}
    print(functools.reduce(lambda acc,k: acc+(repeat[k] if k not in sure else 0), repeat, 0))
    # 2 wrong, sort by allergen, fuck you aoc bullshit
    print(','.join(sorted([k for k in sure], key=lambda k:sure[k])))
