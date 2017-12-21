#!/usr/bin/env ruby

def flip(pattern)
    pattern.map{|row| row.reverse}
end

def rotate(pattern)
    flip(pattern).map{|row| row.split('')}.transpose.map{|row| row.join}
end

def add_rule(rules, from, to)
    4.times do
        from = rotate(from)
        rules[from] = to
    end
    rules[flip(from)] = to
end

def find_match(pattern, rules)
    p = pattern
    4.times do
        p = rotate(p)
        return rules[p] if rules.key?(p)
        f = flip(p)
        return rules[f] if rules.key?(f)
    end
end

def expand(pattern, len, rules)
    pattern.each_slice(len).map do |slice|
        slice.map{|row| row.split('')}
             .reduce(:zip)
             .map{|row| row.flatten}
             .each_slice(len)
             .map{|grid| find_match(grid.transpose.map{|row| row.join}, rules)}
             .reduce{|memo, obj| memo.zip(obj).map{|x, y| x + y}}
    end.reduce(:+)
end

def solve
    rules = {}
    STDIN.each_line do |l|
        from, to = l.chomp.split(' => ').map{|s| s.split('/')}
        rules[from] = to
    end

    pattern = ['.#.', '..#', '###']
    18.times do |i|
        puts pattern.map{|row| row.count('#')}.sum if i == 5
        pattern = expand(pattern, pattern.length % 2 == 0 ? 2 : 3, rules)
    end
    puts pattern.map{|row| row.count('#')}.sum
end

solve
