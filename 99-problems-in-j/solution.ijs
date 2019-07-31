NB. problem 1
NB. take length, minus 1, then index
last_element =: 3 : 0
if. 0 = #y
then. ''
else. ((0&{)@:(,~/)) y
end.
)

NB. problem 2
last_but_one_element =: 3 : 0
if. 2 > #y
then. ''
else. ((1&{)@:(,~/)) y
end.
)

NB. problem 3
kth_element =: {

NB. problem 4
number_of_elements =: #

NB. problem 5
reverse =: ,~/

NB. problem 6
NB. match with reversed list
is_palindrome =: -: ,~/
