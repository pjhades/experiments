NB. problem 1
NB. XXX error should be handled in some way but i don't know right now
NB. take length, minus 1, then index
last_element1 =: {~ (-&1)@:#
NB. reverse, take first
last_element2 =:(0&{)@:(,~/)

NB. problem 2
NB. XXX same, handle error here
last_but_one_element =: (1&{)@:(,~/)

NB. problem 3
kth_element =: {

NB. problem 4
number_of_elements =: #

NB. problem 5
reverse =: ,~/

NB. problem 6
NB. match with reversed list
is_palindrome =: -: ,~/
