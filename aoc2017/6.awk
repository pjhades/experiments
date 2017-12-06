#!/usr/bin/awk -f

function hash(a) {
    v = "";
    for (i = 1; i <= length(a); i++)
        v = sprintf("%s.%d", v, a[i]);
    return v;
}

function max(a) {
    m = a[1];
    ret = 1;
    for (j = 2; j <= length(a); j++) {
        if (a[j] > m) {
            m = a[j];
            ret = j;
        }
    }
    return ret;
}

function redistribute(arr) {
    idx = max(arr);
    remaining = arr[idx];
    arr[idx] = 0;
    while (remaining > 0) {
        idx = idx % NF + 1;
        arr[idx]++;
        remaining--;
    }
    steps++;
}

{
    split($0, arr, FS);
    hv = hash(arr);
    done = 0;
    seen[hv] = 1;
    while (1) {
        redistribute(arr);
        hv = hash(arr);
        if (seen[hv])
            break;
        seen[hv] = 1;
    }

    if (part != 1) {
        steps = 0;
        target = hv;
        while (seen[hv] == 1) {
            redistribute(arr);
            if (hash(arr) == target)
                break;
        }
    }
}

END {
    print steps;
}
