#!/usr/bin/env jconsole

parse=: 3 : 0
  <;._1 ':', ':' (I.' '=>y) } >y
)
input=: parse"0 <;._1 LF,('  ';LF) stringreplace (LF;' ') stringreplace stdin''

keys=: 'byr';'iyr';'eyr';'hgt';'hcl';'ecl';'pid'
have_all=: *./ keys e."0 1/ input

NB. part 1
echo +/ have_all

byr=: (1= (1919 2002)&I.) @ (0&". @ > @ ({~ (>:@i.&(<'byr'))))
iyr=: (1= (2009 2020)&I.) @ (0&". @ > @ ({~ (>:@i.&(<'iyr'))))
eyr=: (1= (2019 2030)&I.) @ (0&". @ > @ ({~ (>:@i.&(<'eyr'))))
cm=: 3 : 0
  (0: ` ((1= (149 193)&I.) @ (0&".) @ (_2&}.))) @. (('cm' -: _2&{.) y) y
)
in=: 3 : 0
  (0: ` ((1= (58 76)&I.)  @ (0&".) @ (_2&}.))) @. (('in' -: _2&{.) y) y
)
hgt=: (cm +. in) @ > @ ({~ (>:@i.&(<'hgt')))
hcl=: ((1 = *./ @: e.&'abcdef0123456789' @ }.) *. (7=#) *. ('#'"_ = {.)) @ > @ ({~ (>:@i.&(<'hcl')))
ecl=: (1 = *./ @: e.&'amb blu brn gry grn hzl oth') @ > @ ({~ (>:@i.&(<'ecl')))
pid=: ((1 = *./ @: e.&'0123456789') *. (9=#)) @ > @ ({~ (>:@i.&(<'pid')))

NB. part 2
echo +/ *./"1 (byr`iyr`eyr`hgt`hcl`ecl`pid)`:0"(1) (I. have_all) { input

exit''
