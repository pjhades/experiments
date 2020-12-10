#!/usr/bin/env jconsole

v=: 0&".;._1 LF,}: stdin''
v=: 0, (/:~v), 3+>./v
echo */ #/.~ 2 -~/\ v

loop=: # ~: #@v"_
valid=: 1= (0 3) I. ]
dp=: [ , [: +/ ] * [: valid (#@] { v"_) - (#@] {. v"_)
echo {: dp^:loop^:_ (1)

exit''
