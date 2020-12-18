#!/usr/bin/env jconsole

in  =: LF,}:stdin''
sub =: 3 : 0
  y=. 'x' (I.'('=y) } y
  y=. '(' (I.')'=y) } y
  y=. ')' (I.'x'=y) } y
  y
)
eval =: ".@sub@;@|.@;:
echo +/ eval;._1 in

pri  =: '(*+' i. ]
top3 =: (_3}.]) , <@":@".@;@(_3{.])

it =: 4 : 0
  if.     -. (>x) e. '+*()'       do.  y=. y,x
  elseif. 3 > #y                  do.  y=. y,x
  elseif. '('=>x                  do.  y=. y,x
  elseif. ')'=>x                  do.
    while. '('~:_2{::y do.
      y=. top3 y
    end.
    y=. (_2}.y) , {:y 
  elseif. (pri >x) > (pri _2{::y) do.  y=. y,x
  else.
    y=. (top3 y) , x
  end.
  y
)

eval2 =: 3 : 0
  y=. '' it F.. ] y
  while. 1<#y do.
    y=. top3 y
  end.
  0".>y
)

echo +/ eval2@;:;._1 in

exit''
