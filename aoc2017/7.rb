#!/usr/bin/env ruby

$weight = {}
$children = {}

def bottom
    $weight.keys.select {|v| !$children.values.flatten.member?(v)}.first
end

$memo = {}

def calc(v)
    return $weight[v] if $children[v].empty?
    return $memo[v] if $memo.keys.member?(v)
    s = $weight[v]
    s += $children[v].map {|x| calc(x)}.sum
    $memo[v] = s
    return s
end

def part1
    puts bottom
end

def part2
    node = bottom
    diff = 0
    while true do
        a = $children[node].map {|x| calc(x)}
        b = a.select {|x| a.count(x) == 1}.first
        c = a.select {|x| a.count(x) > 1 }.first
        if b
            diff = c - b
            node = $children[node].at(a.index(b))
        else
            puts $weight[node] + diff
            break
        end
    end
end

STDIN.each do |l|
    m = /^([a-z]+) \(([0-9]+)\)( -> ([a-z]+(, [a-z]+)*?))?$/.match(l.chomp)
    n = m[1]
    w = m[2]
    c = m[4] ? m[4].split(', ') : []
    $weight[n] = w.to_i
    $children[n] = c
end

part1
part2
