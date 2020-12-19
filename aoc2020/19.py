#!/usr/bin/env python3
import re, sys, functools

tree = {}
memo = {}
part2 = False
maxlen = 0

def parse_trans(line):
    k, v = line.split(': ')
    k = int(k)
    if v[0] == '"':
        v = v.replace('"', '')
    else:
        v = list(map(lambda x: int(x) if x != '|' else x, v.split(' ')))
    tree[k] = v

def build_regex(i):
    if type(tree[i]) is not list:
        memo[i] = tree[i]
        return tree[i]

    regex = []
    if part2 and i == 8:
        return f'({build_regex(42)})+'
    if part2 and i == 11:
        re42, re31 = build_regex(42), build_regex(31)
        for i in range(1, maxlen + 1):
            regex.append(f'((({re42}){{{i}}})(({re31}){{{i}}}))')
        return '|'.join(regex)
    for j in tree[i]:
        if j == '|':
            regex.append(j)
        else:
            if j not in memo:
                memo[j] = build_regex(j)
            regex.append(f'({memo[j]})')
    return ''.join(regex)

def match(patstr, lines):
    pat = re.compile(f'^{patstr}$')
    return functools.reduce(lambda acc, x: acc + (1 if pat.match(x) else 0), lines, 0)

if __name__ == '__main__':
    for line in sys.stdin:
        line = line.strip()
        if line == '':
            break
        parse_trans(line);
    lines = [line.strip() for line in sys.stdin]
    pat = build_regex(0)
    print(match(pat, lines))
    part2 = True
    maxlen = functools.reduce(lambda acc, x: acc if acc > len(x) else len(x), lines, 0)
    memo.clear()
    pat = build_regex(0)
    print(match(pat, lines))
