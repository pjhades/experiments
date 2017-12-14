#!/usr/bin/env ruby

def root(uf, x)
    while uf[x] > 0 do
        x = uf[x]
    end
    x
end

def merge(uf, x, y)
    rx, ry = root(uf, x), root(uf, y)
    return if rx == ry
    if uf[rx] < uf[ry]
        uf[rx] += uf[ry]
        uf[ry] = rx
    else
        uf[ry] += uf[rx]
        uf[rx] = ry
    end
end

def solve
    t = {}
    STDIN.each_line do |l|
        a, b = l.chomp.split(' <-> ')
        a = a.to_i
        b = b.split(', ').map{|x| x.to_i}
        t[a] = b
    end
    uf = [-1] * t.length
    t.each {|a, b| b.each{|x| merge(uf, a, x)}}
    puts -uf[root(uf, 0)]
    puts uf.select{|x| x < 0}.length
end

solve
