in=: ".;._2 ',',~}:stdin''
cost1=: [:+/|@-
cost2=: [:+/(-:@(* >:))@|@-
range=: <./+[: i.@>: >./-<./
echo <./ (cost1"1 0 range) in
echo x: <./ (cost2"1 0 range) in
