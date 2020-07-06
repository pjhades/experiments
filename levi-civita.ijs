NB. https://en.wikipedia.org/wiki/Levi-Civita_symbol
NB. It's the parity of permutation used when computing determinants
NB.
NB. `ct` is the function to generate the matrices whose entries
NB. are all possible Levi-Civita values, in any given dimension
NB.
NB. In 2D, the matrix consists of
NB. [ ε11 ε12 ]   [  0 1 ]
NB. [ ε21 ε22 ] = [ -1 0 ]

ct=: C.!.2 @ (#:i.) @ $~

NB. Given argument n, $~ first computes n$n, determining the shape
NB. so if n=5 then the matrix shape will be 5 5 5 5 5, very full
NB.
NB. Then we apply fork (#: i.) on top, in case of n=3 we have
NB. 3 3 3 #: i. 3 3 3
NB.
NB. i. 3 3 3 generates a shape 3 3 3 matrix with values from 0 to (n^n)-1
NB.
NB. Then for each value, we convert it to base 3 3 3, which is basically
NB. the digits under base 3, so that values from the previous step
NB. 0 1 2 will become 0 0 0, 0 0 1, 0 0 2. Also because #: generates
NB. an array for each value so the output shape will become 3 3 3 3.
NB.
NB. Finally we apply permutation shape C.!.2 on top, computing the
NB. Levi-Civita symbol of each array from last step. Note that that step
NB. gives us a bunch of arrays consisting of 0 1 and 2, some of which
NB. can be regarded as a permutation while others can not.
NB. This step each array like 0 1 2 will be converted to a parity sign
NB. thus the output shape will go back to 3 3 3.
