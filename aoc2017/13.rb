#!/usr/bin/env ruby

$fw = {}
STDIN.each_line do |l|
    depth, range = l.chomp.split(': ').map{|x| x.to_i}
    $fw[depth] = range
end

def pos(time, range)
    if (time / (range - 1)) % 2 == 0
        p = time % (range - 1)
    else
        p = (range - 1) - (time % (range - 1))
    end
    return p
end

def caught_at(time)
    layers = []
    $fw.each_pair do |depth, range|
        layers.push(depth) if pos(time + depth, range) == 0
    end
    layers
end

def part1
    puts caught_at(0).map{|x| x * $fw[x]}.sum
end

def part2
    delay = 0
    while !caught_at(delay).empty? do
        delay += 1
    end
    puts delay
end

part1
part2
