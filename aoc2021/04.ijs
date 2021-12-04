parts=: (LF,LF) splitstring stdin''
nums=: ".;._1',',>{.parts
boards=: (".@>@cutopen@>) }.parts

u=: [ ; (>@{:@]) +. boards=[
w=: ([: (+./"1) 5= +/"1)
win=: +.&w |:"2
mul=: (>@{.@]) * ([#boards"_) +/@,@:* ([: -. [#>@{:@])

v1=: 3 : 0
vec=. win >@{: y
(vec mul y) [ 1 Z: +./vec
)

v2=: 3 : 0
now=. win >@{: y
vec=. now*.-.win ((>@{:)*.(>@{.) -.@= boards"_) y
(vec mul y) [ 1 Z: (#boards)=+/now
)

echo (({.nums);0$~$boards) (u F.. v1) nums
echo (({.nums);0$~$boards) (u F.. v2) nums
