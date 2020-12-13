#!/usr/bin/env jconsole

raw=: stdin''
parse=: (#~ 0~:]) @ (0&".;._2) @ (I.@(LF=]) })
in=: ',' parse raw
echo (#~ 0~:]) (}. * (* [=<./) @ (}.-}.|{.)) in

in2=: 1&".;._1 ',', , }. ];._2 raw
geta=: (([-|),[) ` (0,[) @. ((1=[)+.(0=]))

g0   =: , ,. =@i.@2:
iter =: {: ,: {. - {: * <.@%&{./
gcd  =: (}.@{.) @ (iter^:(*@{.@{:)^:_) @ g0

NB. ugly implementation
crt=: 4 : 0
  M=: */y
  m=: M % y
  t=: 0{"1 m gcd"0 0 y
  inc=: ] + M* >.@(- % M"_)
  dec=: ] - M* <:@>.@(]%M"_)
  int=: 3 : 'inc`dec @. (y>0) y'
  x: int +/ x*t*m
)

am=: in2 geta"0 0 i.#in2
'a m'=: ((0{"1]) ; (1{"1])) am

echo a crt m

exit''
