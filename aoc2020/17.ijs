#!/usr/bin/env jconsole

in     =: ('#'=]);._1 LF,}:stdin''
update =: (3=+/@,@]) ` (1= 2 4 I. +/@,@])
aug    =: 0,0,0,~0,~]
aug3d  =: aug"1@aug"2@aug
aug4d  =: aug"1@aug"2@aug"3@aug
step3d =: update @. ((<1;1;1){])
step4d =: update @. ((<1;1;1;1){])
it3d   =: ((1 1 1,:3 3 3) step3d;._3 ])@aug3d
it4d   =: ((1 1 1 1,:3 3 3 3) step4d;._3 ])@aug4d
echo +/ , it3d^:6 ,:in
echo +/ , it4d^:6 ,:,:in

exit''
