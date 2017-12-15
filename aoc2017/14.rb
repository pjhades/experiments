#!/usr/bin/env ruby

require_relative '10.rb'

$p = {
    '0' => '....', '1' => '...x', '2' => '..x.', '3' => '..xx',
    '4' => '.x..', '5' => '.x.x', '6' => '.xx.', '7' => '.xxx',
    '8' => 'x...', '9' => 'x..x', 'a' => 'x.x.', 'b' => 'x.xx',
    'c' => 'xx..', 'd' => 'xx.x', 'e' => 'xxx.', 'f' => 'xxxx',
}

def bfs(h, p)
    q = [p]
    seen = [p]
    while !q.empty?
        i, j = q.delete_at(0)
        h[i][j] = '*'
        [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |di, dj|
            np = [i + di, j + dj]
            if np[0] >= 0 && np[0] <= 127 && np[1] >= 0 && np[1] <= 127 &&
               h[np[0]][np[1]] == 'x' && !seen.member?(np)
                q.push(np)
                seen.push(np)
            end
        end
    end
end

def solve
    key = STDIN.readline.chomp
    hashes = (0..127).map{|x| knot(key + '-' + x.to_s)}
                     .map{|h| h.each_char.map{|y| $p[y]}.join}
    puts hashes.map{|h| h.count('x')}.sum
    
    count = 0
    (0..127).each do |i|
        (0..127).each do |j|
            next if hashes[i][j] != 'x'
            bfs(hashes, [i, j])
            count += 1
        end
    end
    puts count
end

solve
