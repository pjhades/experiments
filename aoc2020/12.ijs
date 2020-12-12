#!/usr/bin/env jconsole

CMD=: 'NSEWLRF'
parse=: (CMD i. 0{ ]) , (0". }.)
input=: parse;._1 LF,}:stdin''

manh=: [: +/ [: | 2{. ]
rotl=: _1 1 * |.
rotr=: 1 _1 * |.

n=: 4 : '((2{.x) + y *  0  1) , 2}.x'
s=: 4 : '((2{.x) + y *  0 _1) , 2}.x'
e=: 4 : '((2{.x) + y *  1  0) , 2}.x'
w=: 4 : '((2{.x) + y * _1  0) , 2}.x'
l=: 4 : '(2{.x) , rotl^:(y%90) 2}.x'
r=: 4 : '(2{.x) , rotr^:(y%90) 2}.x'
f=: 4 : '((2{.x) + y * 2}.x) , 2}.x'
move=: 4 : 'y n`s`e`w`l`r`f @. (0{x) 1{x'
NB. We're in J 9.01. In J 9.02 we should swap u and v
echo 0 0 1 0 (move F.. manh) input

n2=: 4 : '(2{.x) , (2}.x) + y *  0  1'
s2=: 4 : '(2{.x) , (2}.x) + y *  0 _1'
e2=: 4 : '(2{.x) , (2}.x) + y *  1  0'
w2=: 4 : '(2{.x) , (2}.x) + y * _1  0'
move2=: 4 : 'y n2`s2`e2`w2`l`r`f @. (0{x) 1{x'

echo 0 0 10 1 (move2 F.. manh) input

exit''
