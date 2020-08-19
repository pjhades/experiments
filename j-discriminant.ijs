#!/usr/bin/env jconsole

NB. This monadic verb computes the discriminant
NB. of a quadratic function, with arguments being
NB. coefficients:
NB.
NB.   discriminant 1 2 3
NB.
NB. computes discriminant for equation
NB. x^2 + 2x + 3 or 1 + 2x + 3x^2
discriminant=: 1 2 1 (_4 1 +/ . * [ *//. ^~) ]

NB. To anatomize it:
NB.
NB. 1) _4 1       gives hint to dot product of vectors [-4, 1] and [ac, bb]
NB. 2) +/ . *     computes the dot product
NB. 3) [ *//. ^~  computes ac and bb
NB.               where x is 1 2 1 and y is the given argument.
NB.               *//. first partitions coefficients according to 1 2 1
NB.               so a and c will be grouped together and */ is applied
NB.               so we get [ac, bb] as a vector.

exit 0
