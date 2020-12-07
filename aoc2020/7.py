#!/usr/bin/env python3

import re, sys

class Id:
    def __init__(self):
        self.dic = {}
        self.id = 0

    def gen(self, key):
        if key not in self.dic:
            self.dic[key] = self.id
            self.id += 1
        return self.dic[key]

def bfs(g, x):
    s = set()
    q = [x]
    while len(q) > 0:
        i = q.pop()
        for j in range(len(g)):
            if g[j][i] > 0:
                s.add(j)
                q.append(j)
    return len(s)

def dfs(g, i):
    sum = 0
    for j in range(len(g)):
        if g[i][j] > 0:
            sum += g[i][j] + g[i][j] * dfs(g, j)
    return sum

if __name__ == '__main__':
    lines = [line.strip() for line in sys.stdin]
    pattern = re.compile(r'([\w ]+) bags contain ([\w, ]+).')
    bags = re.compile(r'(\d+) ([\w ]+) bags?')
    idgen = Id()
    g = [[0]*len(lines) for _ in range(len(lines))]

    for line in lines:
        m1 = pattern.match(line)
        i = idgen.gen(m1.group(1))
        if m1.group(1) == 'shiny gold':
            target = i
        if m1.group(2) == 'no other bags':
            continue
        for d in m1.group(2).split(', '):
            m2 = bags.match(d)
            count, bag = m2.groups()
            g[i][idgen.gen(bag)] = int(count)

    print(bfs(g, target))
    print(dfs(g, target))
