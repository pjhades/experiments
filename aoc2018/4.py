#!/usr/bin/env python3
from datetime import datetime
import sys, re

events = []
for line in sys.stdin:
    m = re.match(r'\[(.+?)\] (.+)', line.strip())
    date, act = m.groups()
    date = datetime.strptime(date, '%Y-%m-%d %H:%M')
    ts = int(date.timestamp())
    minute = date.minute
    events.append((ts, minute, act))
events.sort(key=lambda x:x[0])

class Guard:
    def __init__(self, guard_id):
        self.id = guard_id
        self.sleep = [0] * 60
        self.nr_sleep = 0
        self.max_sleep_minute = -1

guards = {}
guard_id = -1
sleep_start = -1
max_sleep_id = -1

freq_sleep_minute = -1
freq_sleep_id = -1

for ts, minute, act in events:
    m = re.search(r'Guard #(\d+) begins shift', act)
    if m:
        guard_id = int(m.group(1))
        if guard_id not in guards:
            guards[guard_id] = Guard(guard_id)
    elif act == 'falls asleep':
        sleep_start = minute
    else:
        g = guards[guard_id]
        for i in range(sleep_start, minute):
            g.sleep[i] += 1
            g.nr_sleep += 1

            if freq_sleep_id == -1 or g.sleep[i] > guards[freq_sleep_id].sleep[freq_sleep_minute]:
                freq_sleep_id = guard_id
                freq_sleep_minute = i

            if max_sleep_id == -1 or g.nr_sleep > guards[max_sleep_id].nr_sleep:
                max_sleep_id = guard_id
            if g.max_sleep_minute == -1 or g.sleep[i] > g.sleep[g.max_sleep_minute]:
                g.max_sleep_minute = i

print(max_sleep_id * guards[max_sleep_id].max_sleep_minute)
print(freq_sleep_id * freq_sleep_minute)
