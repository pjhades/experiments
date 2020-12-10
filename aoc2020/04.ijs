#!/usr/bin/env jconsole

clean=: 3 : 0
  /:~ y #~ (0{"1 y)~:<'cid'
)

record=: 3 : 0
  clean _2]\ <;._1 ':', ':' (I.' '= >y) } >y
)

parse=: 3 : 0
  y=. }: ' ' (I. LF=y)} y
  y=. ('  ';LF) stringreplace y
  y=. <;._1 LF,y
  record"0 y
)

input=: parse stdin''
keys=: /:~ 'byr';'iyr';'eyr';'hgt';'hcl';'ecl';'pid'
have_all=: (I. */"1 keys ="(1 1) 0{"1 input) { input

NB. part 1
echo #have_all

byr=: 1= (1919 2002)"_ I. 0". 1{:: (keys i. <'byr') { ]
iyr=: 1= (2009 2020)"_ I. 0". 1{:: (keys i. <'iyr') { ]
eyr=: 1= (2019 2030)"_ I. 0". 1{:: (keys i. <'eyr') { ]
cm=: 3 : 0
  0: ` (1= (149 193)"_ I. 0". _2}. ]) @. (('cm'-:_2&{.) y) y
)
in=: 3 : 0
  0: ` (1= (58 76)"_ I. 0". _2}. ]) @. (('in'-:_2&{.) y) y
)
hgt=: [: (cm +. in) 1{:: (keys i. <'hgt') { ]
hcl=: [: ((1= [: *./ 'abcdef0123456789'"_ e.~ }.) *. (7=#) *. ('#'"_ ={.)) 1{:: (keys i. <'hcl') { ]
ecl=: [: (1= [: *./ 'ambblubrngrygrnhzloth'"_ e.~ ]) 1{:: (keys i. <'ecl') { ]
pid=: [: ((1= [: *./ '0123456789'"_ e.~ ]) *. (9=#)) 1{:: (keys i. <'pid') { ]

check=: byr`iyr`eyr`hgt`hcl`ecl`pid
NB. part 2
echo +/ *./"1 check`:0"2 have_all

exit ''
