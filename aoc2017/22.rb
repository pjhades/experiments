#!/usr/bin/env ruby

$dir = [[0, 1], [1, 0], [0, -1], [-1, 0]]

def read
    pos = {}
    center_map = STDIN.map{|l| l.chomp}
    len = (center_map.length - 1) / 2
    len.downto(-len).each do |y|
        (-len..len).each{|x| pos[[x, y]] = center_map[len-y][x+len]}
    end
    pos
end

def part1
    pos = read
    x, y = 0, 0
    d = 0
    infection = 0
    10000.times do
        if pos[[x, y]] == '#'
            d = (d + 1) % 4
            pos[[x, y]] = '.'
        else
            d = (d - 1) % 4
            pos[[x, y]] = '#'
            infection += 1
        end
        dx, dy = $dir[d]
        x, y = x + dx, y + dy
    end
    puts infection
end

def part2
    pos = read
    state = {nil => 'w', '.' => 'w', 'w' => '#', '#' => 'f', 'f' => '.'}
    x, y = 0, 0
    d = 0
    infection = 0
    10000000.times do
        delta = {nil => -1, '.' => -1, '#' => 1, 'f' => 2, 'w' => 0}
        d = (d + delta[pos[[x, y]]]) % 4
        pos[[x, y]] = state[pos[[x, y]]]
        infection += 1 if pos[[x, y]] == '#'
        dx, dy = $dir[d]
        x, y = x + dx, y + dy
    end
    puts infection
end

#part1
part2
