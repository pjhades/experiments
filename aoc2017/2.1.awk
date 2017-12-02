#!/usr/bin/awk -f
{
    max = min = $1;
    for (i = 2; i <= NF; i++) {
        if ($i > max) max = $i;
        if ($i < min) min = $i;
    }
    sum += max - min;
}

END {
    print sum;
}
