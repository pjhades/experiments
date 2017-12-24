#!/usr/bin/env ruby

$node = STDIN.map{|l| l.chomp.split('/').map{|x| x.to_i}}
$seen = [false] * $node.length
$max = 0
$longest = 0
$longest_max = 0

def dfs(input, sum, len)
    $node.each_with_index.select{|x, idx| !$seen[idx] && x.member?(input)}.each do |x, idx|
        a, b = x
        $seen[idx] = true
        if input == a
            dfs(b, sum + input + b, len + 1)
        else
            dfs(a, sum + input + a, len + 1)
        end
        $seen[idx] = false
    end
    $max = sum if sum > $max
    if len >= $longest
        $longest = len
        $longest_max = sum if sum > $longest_max
    end
end

dfs(0, 0, 0)
puts $max
puts $longest_max
