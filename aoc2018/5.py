#!/usr/bin/env python3
def pair(a, b):
    return abs(ord(a)-ord(b)) == 32

def react(s, remove='?'):
    stack = []
    for x in s:
        if x.lower() == remove:
            continue
        if len(stack) > 0 and pair(stack[-1], x):
            stack.pop()
        else:
            stack.append(x)
    return len(stack)

s = input()
# part 1
print(react(s))
# part 2
minlen = len(s)
for x in range(ord('a'), ord('z')+1):
    l = react(s, remove=chr(x))
    if l < minlen:
        minlen = l
print(minlen)
