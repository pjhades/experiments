#!/usr/bin/env ruby

def reset
    $N = 256
    $lst = (0...$N).to_a
    $current = 0
    $skip = 0
end

def round(lengths)
    lengths.each do |len|
        idx = $current
        $lst.cycle(2).to_a.slice($current, len).reverse.each do |x|
            $lst[idx] = x
            idx = (idx + 1) % $N
        end
        $current = ($current + len + $skip) % $N
        $skip += 1
    end
end

def part1
    reset
    lengths = STDIN.readline.chomp.split(',').map{|x| x.to_i}
    round(lengths)
    puts $lst[0] * $lst[1]
end

def knot(key)
    reset
    lengths = key.split('').map{|x| x.ord} + [17, 31, 73, 47, 23]
    64.times { round(lengths) }
    dense = $lst.each_slice(16).map do |s|
        s.reduce(0, :^).to_s(16).rjust(2, '0')
    end
    dense.join
end

def part2
    puts knot(STDIN.readline.chomp)
end

#part1
#part2
