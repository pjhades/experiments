#!/usr/bin/env jconsole

load 'regex'

r1=: '([[:print:]]+) bags? contain ([[:print:]]+).'
r2=: '([[:digit:]]+) ([[:print:]]+) bags?'
match=: (,:/"1 @ }. @ rxmatch) <;.0 ]
input=: r1&match;._1 LF,}:stdin''

id=: {."1@input"_ i. ]
count=: 0". 0{:: ]
dst=: id@(1&{)
parse=: ((dst , count) @ (r2&match) @ }.;._1 @ (', ', ])) @ >

no=: ('no'-: 2{. ]) @ >
zero=: #@input"_ $ 0:
v=: i.#input
edge=: +/ @: ((] * v"_ = [)/"1 @: parse)
row=: 3 : 'edge`zero @.(no y) y'

graph=: row"(0) 1{"1 input
start=: id <'shiny gold'

NB. state 0: unvisited, 1: next, >1: visited
loop=: 1 e. ]
bfs=: 3 : '(+:y) + +./ %~ (I. 1=y) { |:graph'
echo <: +/ 0~: bfs^:loop^:_ start=i.#graph

adj=: ] { graph"_
val=: (#~ 0&~:) @ adj
idx=: I. @ (0 ~: ]) @ adj
dfs=: ([: +/  val + val * dfs"0 @ idx) ` 0: @. ('' -: idx)
echo dfs start

exit''
