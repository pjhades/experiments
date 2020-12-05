#!/usr/bin/env jconsole

input=: _10]\ (#~ LF&~:) stdin''
row=: #.@('B'&=)@(7&{."1)
seat=: #.@('R'&=)@(_3&{."1)
ids=: (seat + 8*row) input
echo >./ ids
echo <: ({~ {.@I.@(~: {. + i.@#)) _,~/:~ ids

exit''
