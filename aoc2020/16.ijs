#!/usr/bin/env jconsole

load 'regex'

'rule my nearby'=: (LF,LF)splitstring }:stdin''

rerule      =: '([[:print:]]+): ([[:digit:]]+)-([[:digit:]]+) or ([[:digit:]]+)-([[:digit:]]+)'
parserule   =: 0&{:: ; 0&".@>@}.
match       =: (,:/"1 @ }. @ rxmatch) <;.0 ]
rule        =: parserule @ (rerule&match) ;._1 LF,rule
my          =: 0&".;._1 ',',13}.my
parsenearby =: 0&".;._1 @ (',',])
nearby      =: parsenearby;._1 LF,16}.nearby
key         =: {."1 rule
range       =: > {:"1 rule
within      =: ([>:0{])*.([<:1{])
checkone    =: ([ within 2{.])+.([ within 2}.])
checkall    =: +./ @ (] checkone"0 1 range"_)

validity    =: checkall"0 nearby
NB. part 1
echo +/ , nearby * -. validity

nearby =: (*./"1 validity) # nearby
N      =: #rule
perm   =: N $ _
used   =: N $ 0
done   =: 0
memo   =: (N,N) $ _
compat =: 4 : 0
  idx =. < x;y
  c   =. idx { memo
  if. _ = c do.
    c    =. *./ (y {"1 nearby) checkone"0 1 (x { range)
    memo =: c idx } memo
  end.
  c
)

dfs =: 3 : 0
  if. y=N do.
    done =: 1
    1 return.
  end.

  avail =. I. -.used
  for_ijk. avail do.
    NB. if rule ijk does not work with column y
    if. 0= ijk compat y do.
      continue.
    end.

    NB. if some remaining rule does not work with some remaining column
    rrules =. (ijk ~: avail) # avail
    rcols  =. (y+1) }. i.N
    rc     =. rrules compat"0 0/ rcols
    if. 0= (*./ +./ rc) *. (*./ +./"1 rc) do.
      continue.
    end.

    used =: 1 ijk } used
    perm =: ijk y } perm

    dfs y+1

    if. done do.
      1 return.
    end.

    used =: 0 ijk } used
    perm =: _ y } perm
  end.
)

dfs 0 NB. still need more pruning
f=: +./ @ ('departure' E. ])
i=: +/ (I. f S: 0 key) ="0 1 perm
echo */ i#my

exit''
