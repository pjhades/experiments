#!/usr/bin/awk -f
{
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

END {
    print sum;
}
