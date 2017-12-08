#!/usr/bin/gawk -f
# run this with `./8.awk <input | awk -f -` to release its power

BEGIN {
    printf("END {\n");
}

{
    match($0, /([a-z]+) (inc|dec) (-?[0-9]+) if (.+)/, a);
    op = a[2] == "inc" ? "+=" : "-=";
    stmt = sprintf("if (%s) %s %s %s", a[4], a[1], op, a[3]);
    printf("    %s; h[\"%s\"] = %s; if (!max2 || %s > max2) max2 = %s;\n", stmt, a[1], a[1], a[1], a[1]);
}

END {
    printf("    for (r in h)\n");
    printf("        if (!max1 || h[r] > max1)\n");
    printf("            max1 = h[r];\n");
    printf("    print max1;\n");
    printf("    print max2;\n");
    printf("}");
}
