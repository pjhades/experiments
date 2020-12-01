splitstring=. #@[ }.&.> [ (E. <;.1 ]) ,

NB. Now let's dismantle it.
NB. It's actually a long train:
NB.
NB.      }.&.>
NB.     /     \
NB. #@[        (E. <;.1 ])
NB.           /           \
NB.          [            ,
NB.
NB. The bottom-right part uses cut conjunction
NB.
NB.   x <;.1 y
NB.
NB. where x is a boolean array indicating the items in y
NB. that should be used as frets. Then each piece is boxed.
NB.
NB. The bottom-left part computes the length of the delimiter.
NB.
NB. The top part uses the under conjunction
NB.
NB. }.&.>
NB.
NB. where the split string is unboxed first and then }. is applied
NB. on each of the pieces, dropping from the beginning a number of
NB. characters equal to the delimiter length, thus no delimiter remains
NB. in the result.
NB.
NB. Enjoy.
