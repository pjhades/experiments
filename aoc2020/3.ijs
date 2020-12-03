#!/usr/bin/env jconsole

input=: >}: LF splitstring stdin''

trees=: 3 : 0
  +/ '#'= (<@:;/"1 ($input) |"1 1 y *"(1 0) i. >.({.$input)%{.y) { input
)

echo trees 1 3
echo */ trees"(1) 1 1,1 3,1 5,1 7,:2 1

exit''
