NB. problem 1
last_element =: {:

NB. problem 2
NB. check length first
last_but_one_element =: (''&[) ` ({: @ }:) @. (>:&2 @ #)

NB. problem 3
kth_element =: {

NB. problem 4
number_of_elements =: #

NB. problem 5
reverse =: |.

NB. problem 6
NB. match with reversed list
is_palindrome =: -: |.

NB. problem 7
NB. unboxing all nested boxes
NB. we recurse based on the length, call unbox on
NB. every element
unbox =: >^:_
flatten_list =: ((unbox @ {.) , ($: @ }.)) ` unbox @. (# <: 1:)

NB. problem 8
NB. let s be 'aabbbccd', we compare each element with
NB. its predecessor, so:
NB. a abbbccd     => behead
NB.   aabbbcc d   => curtail
NB.   1011010     => starting from the second element,
NB.                  whether it equals its predecessor
NB. we inverse it so we can get the indices of all elements
NB. that are not equal to its predecessor, starting from the
NB. second one. Finally we prepend the first element.
NB. We make use of }. and }: so that we don't have to worry
NB. about empty lists.
remove_consecutive_duplicate =: {. , ({~ (>: @ I. @ (-. @ (}. = }:))))
