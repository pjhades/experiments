#!/usr/bin/env jconsole

insts=: 'nop','jmp',:'acc'
prog=: |: ((insts i. 0{::"1 ]) ,: 0". 1{::"1]) (([: (<;._1~ ' ' E. ]) ' ', ]);._1~ LF E. ]) LF,}:stdin''

NB. op inst pc,acc
nop=: ] + (1 0)"_
jmp=: ] + [,0:
acc=: ] + 1,[
all=: nop`jmp`acc

NB. run pc,acc;prog;done
run=: 3 : 0
  'pa prog done'=. y
  'opcode op'=. (0{pa) { prog
  done=. 1 (0{pa) } done
  (op (all @. opcode) pa) ; prog ; done
)
NB. loop pc,acc;prog;done
loop=: 3 : 0
  pc=. 0{0{::y
  0: ` (0= pc { 2{:: ]) @. (pc<#2{::y) y
)
NB. part 1
echo 1{ 0{:: ]  run^:loop^:_ (0 0); prog; (#prog)$0

NB. index change prog
change=: 4 : 0
  opcode=. (<x;0){y
  (-.`-.`] @. opcode opcode) (<x;0) } y
)
progs=: (0 0) ;"1 1 ((i.#prog) change"0 2 prog) ;"2 1 (#prog)$0
NB. part 2
echo (1{ ((0{"1 (0{::"1 ])) i. #@prog"_) { 0{::"1 ]) run^:loop^:_"1 progs

exit''
