echo "yes" "no" "what"
echohl ErrorMsg
echo "this message will be printed with error message highlighting"
echohl none "restore highting group
echomsg "this will be recorded in message history"
"commands to play with message history
"    :messages               show all
"    :3messages              show 3 recent
"    :messages clear         clear all
"    :3messages clear        clear all but 3 recent

" boolean option
set number      " number is on
set nonumber    " number is off
set number!     " number is on
set number?     " echo current state, number or nonumber

" option with value
set numberwidth=4
set numberwidth?
set number numberwidth=3   " set multiple options at once

" to get help of an option
"     :help 'number'
"     :help 'shiftwidth'
