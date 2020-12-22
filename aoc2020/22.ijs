#!/usr/bin/env jconsole

in=: (((-:@#){.]) ; (-:@#)}.]) {."1 (#~ (0 0) -.@-:"(1 1) ]) 0&".;._1 LF,}:stdin''
it=: 3 : 0
  'd1 d2'=. y
  _2 Z: 0=d1 (*&#) d2
  if.   d1 (<&{.) d2 do. (}.d1) ; (}.d2),({.d2),{.d1
  else.                  ((}.d1),({.d1),{.d2) ; }.d2 end.
)
score=: +/@(* >:@i.@-@#)
smoutput score +/> it F. ] in

have=: {. <: #@}.
recur=: 3 : 0
  'd1 d2 w'=. y
  seen=. ''
  while. 0~:d1 (*&#) d2 do.
    if. (<d1;d2) e. seen do.
      d1;d2;0 return.
    end.
    seen=. (<d1;d2),seen
    if. d1 (*.&have) d2 do.
      s1=. ({.d1){.(}.d1)
      s2=. ({.d2){.(}.d2)
      's1 s2 w'=. recur s1;s2;_
    else.
      w=. d1 (<&{.) d2
    end.
    assert w~:_
    if. w=1 do. 'd1 d2'=. (}.d1) ; (}.d2),({.d2),{.d1
    else.       'd1 d2'=. ((}.d1),({.d1),{.d2) ; }.d2 end.
  end.
  d1;d2;0~:#d2
)

smoutput score ((2{::]){::]) recur in,<_

exit''
