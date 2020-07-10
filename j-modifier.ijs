#!/usr/bin/env jconsole

NB. Explicitly define an adverb.
NB. u is the parameter for the modified verb on the left of
NB. the adverb.
NB. x and y are the parmeter of the output verb.
insert=: 1 : 0
  (0: ` ({. u (u insert)@:}.) @. (>&0@#)) y
)

NB. test
assert (+ insert i.999) -: (+/ i.999)
assert (+ insert 0$0) -: (+/ 0$0)

exit 0
