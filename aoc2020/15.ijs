#!/usr/bin/env jconsole

in =: 0&".;._1 ',',}:stdin''
R  =: 30000000
t  =: (>:R)$0
sn =: {:in
sr =: #in
set=: 3 : 't=: ({:y) ({.y)} t'
do =: 3 : 'sr<R'
it =: 3 : 0
  p =.sn{t
  set sn,sr
  sn=: (sr-p)* -.0=p
  sr=: >:sr
)

set"1 (,. ,. (>:@i.@#)) }:in
it^:do^:_ ''   NB. faster than fold
echo sn

exit''
