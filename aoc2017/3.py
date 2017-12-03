#!/usr/bin/env python3

from itertools import takewhile, accumulate, count

def n_to_xy(n):
    if n == 1:
        return [0, 0]
    circle = len(list(takewhile(lambda x:x<n-1, accumulate(count(8, 8)))))+1
    start = 4 * circle * (circle - 1) + 2
    edge_len = circle * 8 // 4
    pos_in_circle = n - start
    pos_in_edge = pos_in_circle % edge_len
    edge = pos_in_circle // edge_len
    mid = start + edge_len * edge - 1 + edge_len // 2
    if edge == 0:
        return [circle, n - mid]
    if edge == 1:
        return [mid - n, circle]
    if edge == 2:
        return [-circle, mid - n]
    return [n - mid, -circle]

def xy_to_n(x, y):
    if [x, y] == [0, 0]:
        return 1
    circle = max(abs(x), abs(y))          # which circle is the point in?
    start = 4 * circle * (circle - 1) + 2 # what's the starting number in this circle?
    edge_len = circle * 8 // 4            # divide the circle into 4 equal parts
    if x == circle and y > -circle:       # compute the number in the center
        return (start + edge_len * 0 - 1 + edge_len // 2) + y
    if y == circle and x < circle:
        return (start + edge_len * 1 - 1 + edge_len // 2) - x
    if x == -circle and y < circle:
        return (start + edge_len * 2 - 1 + edge_len // 2) - y
    return (start + edge_len * 3 - 1 + edge_len // 2) + x

def part1(n):
    x, y = n_to_xy(n)
    return abs(x) + abs(y)

def neighbors(x, y):
    return list(map(lambda a:xy_to_n(*a), [[x+dx, y+dy] for dx in [-1, 0, 1] for dy in [-1, 0, 1] if [dx, dy] != [0, 0]]))

def part2(limit):
    d = {1: 1, 2: 1, 3: 2, 4: 4}
    i = 5
    while True:
        s = sum(map(lambda a:d[a], filter(lambda a:a<i, neighbors(*n_to_xy(i)))))
        if s > limit:
            return s
        d[i] = s
        i += 1

if __name__ == '__main__':
    print(part1(325489))
    print(part2(325489))
