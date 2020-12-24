#!/usr/bin/env jconsole

M=: ('ne';'a'),('se';'c'),('sw';'b'),:'nw';'d'
in=: M&stringreplace;._1 LF,}:stdin''
equ=: +/@:=
ab=: ((1  1) * 'a' equ ]) + (_1 _1) * 'b' equ ]
cd=: ((0 _1) * 'c' equ ]) + ( 0  1) * 'd' equ ]
ew=: ((1  0) * 'e' equ ]) + (_1  0) * 'w' equ ]
coord=: ab + ew + cd
s0=: (~. #~ 1=#/.~) coord"1 in
smoutput #s0

MAX=: >./ >./"1 | s0
g=: |.|: 1 (<"1 ;/"1 s0 + MAX) } (>:+:MAX,MAX)$0 NB. set initial state
aug=: 0,0,0,~0,~]
b=: 1=0 2 I. <:@(+/)@}:@}.@,
w=: 2=+/@}:@}.@,
up=: w`b@.((<1;1){])
it=: (1 1,:3 3) up;._3 aug"1@aug@]
smoutput +/,it^:100 g

exit''
