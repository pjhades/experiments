#!/usr/bin/env jconsole

input=. >}: LF splitstring stdin''
'range char str'=. 0 1 2 { |: ' ' splitstring"1 1 input
'i j'=. 0". > 0 1 { |: '-' splitstring"1 1 range
char=.{."1 char

echo +/ (>:&i *. <:&j) +/"1 char=str
echo +/ 1= +/"1 char= (<:i,.j) {"1 1 str

exit''
