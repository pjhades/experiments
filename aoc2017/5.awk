#!/usr/bin/awk -f

{
    map[NR] = $0
}

END {
    step = 0;
    current = 1;
    while (current >= 1 && current <= NR) {
        delta = (part == 1 || map[current] < 3 ? 1 : -1)
        map[current] += delta;
        current = current + map[current] - delta;
        step += 1;
    }
    print step;
}
