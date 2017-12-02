#!/usr/bin/awk -f
{
    if (part == 1) {
        max = min = $1;
        for (i = 2; i <= NF; i++) {
            if ($i > max) max = $i;
            if ($i < min) min = $i;
        }
        sum += max - min;
    }
    else {
        done = 0;
        # don't judge me on the complexity
        for (i = 1; i <= NF && !done; i++) {
            for (j = 1; j <= NF && !done; j++) {
                if (i == j) continue;
                if ($i > $j && $i % $j == 0) { sum += $i / $j; done = 1; }
                if ($i < $j && $j % $i == 0) { sum += $j / $i; done = 1; }
            }
        }
    }
}

END {
    print sum;
}
