#!/usr/bin/awk -f

{
    sum = 0;
    score = 0;
    cancelled = 0;
    garbage = 0;
    escape = 0;
    split($0, s, "");
    for (i = 1; i <= length(s); i++) {
        if (!garbage) {
            if (s[i] == "{") {
                score++;
                sum += score;
            }
            else if (s[i] == "}")
                score--;
            else if (s[i] == "<")
                garbage = 1;
        }
        else {
            if (escape)
                escape = 0;
            else if (s[i] == "!")
                escape = 1;
            else if (s[i] == ">")
                garbage = 0;
            else
                cancelled++;
        }
    }
    print sum;
    print cancelled;
}
