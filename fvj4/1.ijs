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
