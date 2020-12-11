#!/usr/bin/env jconsole

parse=: ('L'=]) + 2*'#'=]
aug=: 3 : '0, ((0:,],0:)"1 y), 0'
input=: parse;._1 LF,}: stdin''
center=: (<1;1) { ]
empty=: center ` 2: @. (0= 2 e. ,@])
occup=: center ` 1: @. (5<: [: +/ 2= ,@[)
update=: center ` empty ` occup @. center
step=: (1 1,:3 3) update;._3 aug@]
NB. part 1 is sweet
NB.echo +/ 2= , step^:_ input

delta=: _1 _1,_1 0,_1 1,0 1,1 1,1 0,1 _1,:0 _1
NB. i j fetch m
fetch=: <@;/@[ { ]

NB. i j ray m;di dj
ray=: 4 : 0
  a=. 0
  x=. x + 1{::y
  while. (a=0) *. (1 1-:x>:0) *. (1 1-:x<$(0{::y)) do.
    a=. x fetch 0{::y
    x=. x + 1{::y
  end.
  a return.
)

NB. i j rays m
rays=: [ ray"_ 1 ] ;"_ 1 delta"_
empty2=: fetch ` 2: @. (0= 2 e. rays)
occup2=: fetch ` 1: @. (5<: [: +/ 2= rays)
update2=: fetch ` empty2 ` occup2 @. fetch
index=: ,/ @: ((i.@{.) ,"0 0/ (i.@{:)) &: $

step2=: 3 : 0
  idx=: index y
  (-{:$y) ]\ idx update2"1 _ y
)

echo +/ 2= , step2^:_ input

exit''
