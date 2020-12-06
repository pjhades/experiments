#!/usr/bin/env jconsole

data=: LF,LF,}:stdin''
echo +/ ((LF,LF) E. data) <:@#@~.;._1 data

count=: #;.1 @ ~: @ /:~
size=: +/@(LF=])
echo +/ ((LF,LF) E. data) ([: <: [: +/ count = size);._1 data

exit''
