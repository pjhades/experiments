#!/usr/bin/env jconsole

input=: 0&".;._1 LF,}: stdin''
two=: ,@:(* -.@=)@:(+/~)
bad=: (25+ 0 i.~ 26 ({: e. two@}:)\ input) { input
sum=: ] (+/ , <./ + >./)\ input"_
echo bad
echo {:"1 ({~ (bad I.@:= {."1)) ,/ sum"(0) 2}.i.#input

exit''
