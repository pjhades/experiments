#!/usr/bin/env python3

import sys, functools

def stdin():
    def w(x): return ''.join(sorted(x))
    def p(x): return [w(y) for y in x.strip().split()]
    def l(x): return [p(y) for y in x.strip().split('|')]
    return [l(line) for line in sys.stdin]

def part1(data):
    def calc(acc, item):
        return acc + len(list(filter(lambda x:len(x) in [2,3,4,7], item[1])))
    return functools.reduce(calc, data, 0)

def identify(pats, outs):
    _1 = next(filter(lambda x:len(x)==2, pats))
    _7 = next(filter(lambda x:len(x)==3, pats))
    _4 = next(filter(lambda x:len(x)==4, pats))
    _8 = next(filter(lambda x:len(x)==7, pats))
    _9 = next(filter(lambda x:len(x)==6 and set(_4)<set(x), pats))
    _3 = next(filter(lambda x:len(x)==5 and len(set(x)-set(_7))==2, pats))
    _0 = ''.join(sorted(list(set(_8) - (set(_4) & (set(_3) - set(_7))))))
    _6 = next(filter(lambda x:len(x)==6 and x!=_9 and x!=_0, pats))
    _5 = next(filter(lambda x:len(x)==5 and x!=_3 and set(x)<set(_9), pats))
    _2 = next(filter(lambda x:len(x)==5 and x!=_3 and x!=_5, pats))
    d = { _1:1, _2:2, _3:3, _4:4, _5:5, _6:6, _7:7, _8:8, _9:9, _0:0 }
    return int(''.join([str(d[x]) for x in outs]))

def part2(data):
    def calc(acc, item):
        return acc + identify(*item)
    return functools.reduce(calc, data, 0)

data = stdin()
print(part1(data))
print(part2(data))
