#!/usr/bin/env python3
memo = {}
def fish(day, num):
    cnt = 0
    rep = (day - (num + 1)) // 7
    for i in range(rep):
        remain = day - (num + 1) - 7 * i
        if remain in memo:
            cnt += memo[remain]
        else:
            val = fish(remain, 8) 
            memo[remain] = val
            cnt += val
    return cnt + rep + 1

nums = [int(x) for x in input().strip().split(',')]
print(len(nums) + sum([fish(80, num) for num in nums]))
print(len(nums) + sum([fish(256, num) for num in nums]))
