#!/usr/bin/env jconsole

insts=: 'nop','jmp',:'acc'
input=: [;._1 LF,}: stdin''
encode=: (1 0)"_ ` ((0". (3}. ])) , 0:) ` (1 , 0". 3}. ]) @. (insts"_ i. 3{. ])
iden=: =i.#input
code=: encode"1 input
begin=: 0,0,(#input)$0
loop=: 0: ` (0= (0{ 1{:: ]) { 2}. 1{:: ]) @. (#@input"_ > 0{ 1{:: ])
exec=: (0{:: ]); (1{:: ]) + (0{ 1{:: ]) { 0{:: ]
echo 1{ 1{:: exec^:loop^:_ (code,.iden);begin

ops=: 0". 3}."1 input
nop=: 3 : '(y{ops) (<y;0)} code'
jmp=: 3 : '1 (<y;0)} code'
change=: nop ` jmp ` (code"_) @. (insts"_ i. 3{. ] { input"_)
NB. feed all the changed programs to the exec loop
begin2=: ((change"0 i.#input) ,."2 2 iden) ;"2 1 begin
results=: 2{."(1) 1{::"1 exec^:loop^:_"1 begin2
echo 1{ (((0{"1 ]) i. #@input"_) { ]) results

exit''
