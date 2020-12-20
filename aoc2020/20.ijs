#!/usr/bin/env jconsole

parse=: 3 : 0
  row=. <;._1 LF,>y
  idx=. 0".5}.}:0{::row
  mat=. ]S:0 }.row
  idx ; mat
)

in=: parse S:0 (LF,LF) splitstring }:stdin''

N=: #in           NB. # of tiles
M=: %:N           NB. size of image
use=: N$0         NB. if a tile is used
img=: (M,M) $ a:  NB. image
mat=: (M,M) $ 0   NB. matrix of tile ids
rot=: |.@|:
flip=: |."1

set=: 4 : 0       NB. (row;col) set (idx;tid;t) set tile
  'idx tid t'=. y
  mat=: tid (<x) } mat
  img=: (<t) (<x) } img
  use=: 1 idx } use
)

unset=: 4 : 0     NB. (row;col) unset idx
  mat=: 0 (<x) } mat
  img=: a: (<x) } img
  use=: 0 y } use
)

NB. check above and left tile
above=: ({:@[)-:({.@])
left=: ({:"1@[)-:({."1@])
check=: 4 : 0
  'r c'=. x
  ok1=. 1
  if. r>0 do. ok1=. ((<(r-1);c) {:: img) above y end.
  ok2=. 1
  if. c>0 do. ok2=. ((<r;c-1) {:: img) left y end.
  ok1 *. ok2
)

NB. find all variants
trans=: 3 : '((<@rot@>)^:(0 1 2 3) <y) , (<@rot@>)^:(0 1 2 3) <flip y'

dfs=: 3 : 0       NB. dfs (row;col) tries that cell
  'r c'=. y
  if. N= +/use do.
    1 return.
  end.

  for_i. I. -. use do.
    'tid t0'=. i { in
    for_j. trans t0 do.
      if. -. y check >j do.
        continue.
      end.
      y set i;tid;>j
      if. dfs (r+c=M-1);(M|c+1) do.
        1 return.
      end.
      y unset i
    end.
  end.

  0
)

dfs 0;0

NB. part 1
smoutput */ ((<0;0),(<0;M-1),(<(M-1);0),(<(M-1);M-1)) { mat

remove=: }:"1@}."1@}:@}.
img=: ,/ (-M) ,./\ remove S:0 img
pat=: 0 : 0
..................#.
#....##....##....###
.#..#..#..#..#..#...
)
pat=: '#'= ];._1 LF,}:pat
count=: ] -: ] * '#'=[
find=: 3 : '+/ , ((1 1),:$>y) (count&(>y));._3 img'
NB. part 2
smoutput (+/,'#'=img) - (+/,pat) * +/ find"0 trans pat

exit''
