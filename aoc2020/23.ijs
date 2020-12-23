#!/usr/bin/env jconsole

in=: 0"."0 }:stdin''
picked=: 4 : '(x=y) +. (x=y{next) +. x=(y{next){next'

iter=: 4 : 0
  rep=. 0
  cur=. {.next
  dec=: 1+x"_|]-2:
  while. rep<y do.
    p3=. cur { next
    next=: (((p3 { next) { next) { next) cur } next
    mx=. x
    while. mx picked p3 do. mx=. <:mx end.
    dst=. dec cur
    while. dst picked p3 do. dst=. dec dst end.
    next=: (dst { next) ((p3 { next) { next) } next
    next=: p3 dst } next
    rep=. >:rep
    cur=. cur { next
  end.
)

mklist=: 4 : 0
  pre=. 0
  for_i. x do.
    next=: i pre } next
    pre=. pre { next
  end.
  for_i. (>./x) + >:i.y-#x do.
    next=: i pre } next
    pre=. pre { next
  end.
  next=: ({.next) pre } next
)

scan=: 3 : 0
  i=. 1 { next
  s=. ''
  while. i~:1 do.
    s=. s,i
    i=. i { next
  end.
  ,/ ":"0 s
)

next=: 10$0
in mklist 9
9 iter 100
smoutput scan''

next=: 1000001$0
in mklist 1000000
1000000 iter 10000000
smoutput (1{next) * (1{next){next

exit''
