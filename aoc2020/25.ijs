#!/usr/bin/env jconsole

'pkc pkd'=: ;/ 0&".;._1 LF,}:stdin''
f=: (1+0{]) , 20201227|[*1{]
szc=: {. 7 f^:(pkc~:1{])^:(_) 0 1
szd=: {. 7 f^:(pkd~:1{])^:(_) 0 1
smoutput }. pkd f^:szc 0 1
smoutput }. pkc f^:szd 0 1

exit''
