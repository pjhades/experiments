#!/usr/bin/env ruby

def part1
    step = STDIN.readline.chomp.to_i
    l = [0]
    idx = 0
    (1..2017).each do |i|
        idx = (idx + step) % l.length + 1
        l.insert(idx, i)
    end
    puts l[(idx + 1) % l.length]
end

def part2
    step = STDIN.readline.chomp.to_i
    idx0 = 0
    after0 = nil
    idx = 0
    len = 1
    (1..50000000).each do |i|
        idx = (idx + step) % len
        if idx < idx0
            idx0 += 1
        elsif idx == idx0
            after0 = i
        end
        len += 1
        idx = (idx + 1) % len
    end
    puts after0
end

part1
part2
