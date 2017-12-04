#!/usr/bin/awk -f

function x(s) {
    split(s, a, "");
    delete t;
    for (j = 1; j <= length(a); j++)
        t[a[j]]++;
    ret = "";
    for (k in t)
        ret = sprintf("%s%s%d", ret, k, t[k]);
    return ret;
}

{
    delete h;
    for (i = 1; i <= NF; i++)
        h[part == 1 ? $i : x($i)] = 1;
    count += length(h) == NF;
}

END {
    print count;
}
