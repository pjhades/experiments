#!/usr/bin/env jconsole

load 'regex'

r0    =: 'mem\[([[:digit:]]+)\] = ([[:digit:]]+)'
r1    =: 'mask = ([X01]+)'
match =: (,:/"1 @ }. @ rxmatch) <;.0 ]
ext   =: 1 : '((m-#y) # x) , y'
s0    =: (1 2$_ _) ; 0 0
raw   =: stdin''
sum   =: x: @ (+/) @: ({."1 ({:/.) {:"1) @ }. @ (0{::])

NB. part 1 opcode mem=0, mask=1
f0    =: #.@('0'=])
f1    =: #.@('1'=])
pmsk  =: (1,f0,f1) @ > @ (r1&match)
pval  =: (0 , (0".0{::]) , 0".1{::]) @ (r0&match)
parse =: pval ` pmsk @. (+./@('mask =' E. ]))
domsk =: (0{::]) ; }.@[
domem =: 4 : 0
  msk0 =. 1 (36 ext) -. #: 0} 1{::y
  msk1 =. 0 (36 ext)    #: 1} 1{::y
  v    =. #. msk1+. msk0*. 0 (36 ext) #: 2{x
  ((0{::y) , (1{x),v) ; 1{::y
)
it    =: 4 : 'x domem`domsk@.({.x) y'
input =: ,/ parse;._2 raw
echo s0 it F.. sum input

NB. part 2
fx     =: #.@('X'=])
pmsk2  =: (1,fx,f1) @ > @ (r1&match)
parse2 =: pval ` pmsk2 @. (+./@('mask =' E. ]))
domem2 =: 4 : 0
  msk1  =. 0 (36 ext) #: 1} 1{::y
  idx   =. I. 0 (36 ext) #: 0} 1{::y
  float =. 0 ((#idx) ext)"0 1 #: i. 2^#idx
  k     =. msk1 +. 0 (36 ext) #: 1{x
  kvs   =. (#. float (idx })"1 1 k) ,"(0 0) 2{x
  ((0{::y) , kvs) ; 1{::y
)
it2    =: 4 : 'x domem2`domsk@.({.x) y'
input2 =: ,/ parse2;._2 raw
echo s0 it2 F.. sum input2

exit''
