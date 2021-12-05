in=: (".S:0)"1 ' -> '&splitstring;._2 stdin''
r=: <.+[:i.@>:>.-<.
rg=: r`({.@r)`(|.@r)@.(>:@*@-)
range=: <@(rg/@{. ,. rg/@{:)@|:
echo +/ 1< #/.~ ; range"2 (#~ (+./@:=/)"2) in
echo +/ 1< #/.~ ; range"2 in
