#!/usr/bin/env jconsole

raw=: stdin''
parse=: (#~ 0~:]) @ (0&".;._2) @ (I.@(LF=]) })
in=: ',' parse raw
echo (#~ 0~:]) (}. * (* [=<./) @ (}.-}.|{.)) in

in2=: 1&".;._1 ',', , }. ];._2 raw
geta=: (([-|),[) ` (0,[) @. ((1=[)+.(0=]))

am=: in2 geta"0 0 i.#in2
'a m'=: ((0{"1]) ; (1{"1])) am
M=: */m

g0   =: , ,. =@i.@2:
iter =: {: ,: {. - {: * <.@%&{./
gcd  =: (}.@{.) @ (iter^:(*@{.@{:)^:_) @ g0

mi=: M % m
t=: 0{"1 mi gcd"0 0 m

inc=: ] + M* >.@(- % M"_)
dec=: ] - M* <:@>.@(]%M"_)
int=: 3 : 'inc`dec @. (y>0) y'

echo x: int +/ a*t*mi

exit''
