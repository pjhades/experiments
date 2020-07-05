#!/usr/bin/env jconsole
require 'format/printf'

NB. char array
a=: 0 : 0
1 2 3
4 5 6
7 8 9
)

NB. split input string with cut ;.
NB. partition a with the last character of a (2),
NB. and apply < on each partition with the fret removed (_2)
b=: <;._2 a

NB. read input number from stdin
NB. stdlib shortcut for 1!:1&3
NB. partition and call a custom parsing function, here we call
NB. numbers x ". y to extract numbers from y with default value x
NB. this works on both numbers and arrays
data=: (0&".);._2 (stdin '')
'num=%j\nnum+1=%j' printf data;data+1

exit 0
