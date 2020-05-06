load 'viewmat'
load '~addons/graphics/fvj4/dwin.ijs'

NB. from section 1.7
rpoly =: 3 : 0
1 rpoly y
:
x * |: 2 1 o./ (2p1%y) * i.y
)

NB. x star y draws a star with y angles and step length x
star =: 4 : '|: 2 1 o./ ((2p1%y) * x) * i.y'

NB. Exercise 1
NB. (a)    3-(4+5)
NB. (b)    3*(4-5)
NB. (c)    3^(4-5)
NB. (d)    1^(e^(1+1))
NB. (e)    1-(-2-3)
NB. (f)    1/(5/5)
NB. (g)    9+1/(-9)
NB. (h)    -1/(-(1/5))
NB. (i)    1/e^(1-(4-3))
NB. (j)    sqrt(1/4)
NB. (k)    sqrt(1+1)
NB. (l)    sqrt(7+1/(-(1*(2-3))))

NB. Exercise 2
NB. (a) - + both dyadic
NB. (b) * - both dyadic
NB. (c) ^ - both dyadic
NB. (d) first ^ dyadic, second ^ monadic, + dyadic
NB. (e) - - both dyadic
NB. (f) + dyadic, % monadic, - monadic
NB. (h) - % - % all monadic
NB. (i) % dyadic, ^ monadic, - - both dyadic
NB. (j) %: % both monadic
NB. (k) *: monadic, + dyadic
NB. (l) %: monadic, + dyadic, % monadic, first - monadic, * - both dyadic

NB. Exercise 3
3^4r7                 NB. (a)
^.3                   NB. (b)
1 o. 1r4p1            NB. (c)
% %:1+^1              NB. (d)
((%:8)-4) % (3*%:5)+1 NB. (e)

NB. Exercise 4
NB. (a)    sin(0)
NB. (b)    sin(pi/3)
NB. (c)    2^(3+4)
NB. (d)    1+2*5
NB. (e)    e^(2*5)
NB. (f)    1/(ln(sqrt(3)))
NB. (g)    -(2+2^5)
NB. (h)    -2+2^5
NB. (i)    2+(-(2^5))
NB. (j)    2+(-2)^5
NB. (k)    -(2+2^5)
NB. (l)    -2+2^5

NB. Exercise 5
2*i.5   NB. (a)
*:i.5   NB. (b)
%:i.5   NB. (c)
%1+i.5  NB. (d)
2^2+i.5 NB. (e)

NB. Exercise 6
2 3 4 +/ i.5      NB. (a)
1 2 3 */ %1+i.5   NB. (b)
,.~ ,~ 0 1 */ 0 1 NB. (c)

NB. Exercise 7
NB. (a)
0 : 0
dclear ''
0 0 255 dpoly rpoly 11
)

NB. (b)
0 : 0
dclear ''
0 255 0 dpoly 1 star 11
)

NB. (c)
0 : 0
dclear ''
0 0 255 dpoly rpoly 11
0 255 0 dpoly 1 star 11
)

NB. Exercise 8
NB. ... T_T

NB. Exercise 9
NB. like a bownot: (0,0) -> (0,1) -> (1,0) -> (1,1)
NB. monadic #: returns the binary representation 

NB. Exercise 10
NB. (a) black
NB. (b) blue
NB. (c) green
NB. (d) cyan
NB. (e) red
NB. (f) purple
NB. (g) yellow
NB. (h) white
NB. (i) grey
NB. (j) orange

NB. Exercise 11
NB. (a)
0 : 0
dclear ''
0 255 255 dpoly 4 star 11
)
NB. (b)
0 : 0
dclear ''
0 0 255 dpoly rpoly 12
0 255 0 dpoly 1r2 rpoly 12
)
NB. (c)
NB. remove last 3 sets of values of a regular 11-side polygon
0 : 0
dclear ''
remaining_points =: (}:^:3) rpoly 12
255 0 0 dpoly remaining_points
255 255 255 dpoly 0.5 * remaining_points
)
NB. (d)
0 : 0
dclear ''
0 0 255 dpoly rpoly 7
0 255 255 dpoly 2 star 7
255 0 255 dpoly 3 star 7
)

NB. Exercise 12
NB. ?4 5$10 generates a random 4x5 matrix with atoms less than 10

NB. Exercise 13
0 : 0
0 0 100 100 dwin 'test'
dclear ''
(?100 3$256) dpoly ?100 5 2$100
)

NB. Exercise 14
p =: 1 2 3
q =: 40 50 60
|:q,:p        NB. (a)
p,:q          NB. (b)
p (,"0 1 /) q NB. (c) append rank-0 of p to rank-1 of q

NB. Exercise 15
3 4 $ 1 7 4 5 2 0 6 6 9 3 5 8                 NB. (a)
(4$1 7 4 5),(4$2 0 6 6),:(4$9 3 5 8)          NB. (b)
(,.1 2 9),.(,.7 0 3),.(,.4 6 5),.(,.5 6 8)    NB. (c)

NB. Exercise 16
NB. (a) shape 3 4, tally 3
NB. (b) shape 3 5, tally 3
NB. (c) shape 6 5, tally 6
NB. (d) shape 3 9, tally 3
NB. (e) shape 4 3, tally 4
NB. (f) shape 4 4, tally 4
NB. (g) shape 6 8, tally 6
NB. (h) shape 3 5, tally 3

NB. Exercise 17
NB. Repeat only 10 times will be VERY SLOW. There must be a smarter way.
sier_carpet =: 3 : 0
a =. y,.y,.y
b =. y,.(($y)$1),.y
a,b,a
)

NB. Exercise 18
NB. Note that the lower right piece is transposed, looking different from the other two.
sier_fractal =: 3 : 'y,y,.|:y'

NB. Exercise 19
NB. Thank you.

NB. Exercise 20
NB. Object-based graphics specifies only the geometric properties of shapes,
NB. therefore it's the low-level system's work to map the geometric description
NB. to what can be understood and rendered by the system itself. From this aspect,
NB. object-based graphics is not coupled with the details of the underlying system,
NB. thus it's more portable. However raster graphics can be viewed as an array of
NB. pixels that is what will actually be rendered on the screen, specifying the
NB. color, resolution etc. Thus it's more closly related to the underlying system,
NB. requires more memory to hold the information of a certain frame. But it also leaves
NB. much room for compression.

NB. Exercise 21
10&*  NB. (a)
10&+  NB. (b)
10&-  NB. (c)
-&10  NB. (d)
10&%  NB. (e)
10&^  NB. (f)

NB. Exercise 22
3 : '10*y'         NB. (a)
3 : '10+y'         NB. (b)
3 : '10-y'         NB. (c)
3 : 'y-10'         NB. (d)
3 : '10%y'         NB. (e)
3 : '10^y'         NB. (f)
3 : '(10*y)+10%y'  NB. (g)
3 : '(1 o. %:y)+(2 o. 10*y)'  NB. (h)

NB. Exercise 23
4 : 'x++:y'     NB. (a)
4 : 'x+y+^x*y'  NB. (b)
4 : '(*:x)-*:y' NB. (c)
4 : '(1+^x*y)%:x+y+1p1'  NB. (d)

NB. Exercise 24
NB. (a)
NB. 3 noun
NB. + dyad
NB. % monad
NB. * dyad
NB. / adverb
NB. 1 noun
NB. + dyad
NB. i. monad
NB. 5 noun
NB.
NB. (b)
NB. ( punctuation
NB. i. monad
NB. 2 noun
NB. ) punctuation
NB. * dyad
NB. + dyad
NB. / adverb
NB. ^: conjunction
NB. 2 noun
NB. i. monad
NB. 2 3 noun

NB. Exercise 25
NB. (a) array 3x4 assigned to a, printed
NB. (b) array 2x3x4 assigned to b, not printed
NB. (c) inserted between rows, get 1x4
NB. (d) inserted between planes, get 3x4
NB. (e) inserted into each row, get 1x3
NB. (f) inserted into each row, get 2x3
NB. (g) same as default +/, get 1x4
NB. (h) inserted between items in each plane, get 2x4
NB. (i) concatenate rows, get 1x12
NB. (j) concatenate planes, get 6x4
NB. (k) equally transpose a, get 4x3
NB. (l) stitch planes, get 3x8
NB. (m) link rows, get 1x3
NB. (n) link planes, get 1x2

NB. Exercise 26
NB. (a) a list linked with an 2x2 array of 'a'
NB. (b) 0 1 2 3 4 linked together
NB. (c) 2
NB. (d) 5
NB. (e) 2
NB. (f) 5
NB. (g) array of boxes initialized with items from a
NB. (h) array of boxes initialized with items from b
NB. (i) domain error, atoms are of different shapes
NB. (j) unboxed array of 2x2
NB. (k) a boxed again, linked with items from a
NB. (l) boxed b linked with boxed b, then the whole is boxed