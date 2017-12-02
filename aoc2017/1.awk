#!/usr/bin/awk -f
{
    step = part == 1 ? 1 : length($0) / 2;
    s = sprintf("%s%s", $0, $0);
    split(s, a, "");
    sum = 0;
    for (i = 1; i <= length($0); i++) {
        if (a[i] == a[i + step])
            sum += a[i];
    }
    print sum;
}
