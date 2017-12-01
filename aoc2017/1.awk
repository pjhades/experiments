#!/usr/bin/awk -f
# for part 2, run `echo XXX | ./1.awk -v divisor=2`
{
    step = divisor ? length($0) / divisor : 1;
    s = sprintf("%s%s", $0, $0);
    split(s, a, "");
    sum = 0;
    for (i = 1; i <= length($0); i++) {
        if (a[i] == a[i + step])
            sum += a[i];
    }
    print sum;
}
