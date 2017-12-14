#!/usr/bin/env ruby

$t = {
    'n'  => {'sw' => 'nw', 's'  => 0, 'se' => 'ne'},
    'ne' => {'nw' => 'n',  'sw' => 0, 's'  => 'se'},
    'se' => {'n'  => 'ne', 'nw' => 0, 'sw' => 's' },
    's'  => {'ne' => 'se', 'n'  => 0, 'nw' => 'sw'},
    'sw' => {'se' => 's',  'ne' => 0, 'n'  => 'nw'},
    'nw' => {'ne' => 'n',  'se' => 0, 's'  => 'sw'},
}

def simplest?(step)
    step.each_key.select{|x| step[x] > 0}
        .all?{|x| $t[x].each_key.all?{|y| step[y] == 0}}
end

def simplify!(step)
    step.each_key.to_a.combination(2).each do |k1, k2|
        next if step[k1] == 0 || step[k2] == 0
        if $t[k1][k2]
            step[k1] -= 1
            step[k2] -= 1
            if $t[k2][k1] != 0
                step[$t[k2][k1]] += 1
            end
        end
    end
end

def solve
    STDIN.each_line do |l|
        step = { 'n' => 0, 'ne' => 0, 'se' => 0, 's' => 0, 'sw' => 0, 'nw' => 0 }
        max = 0
        l.chomp.split(',').each do |x|
            step[x] += 1
            while !simplest?(step) do
                simplify!(step)
            end
            if step.values.sum > max
                max = step.values.sum
            end
        end
        puts step.values.sum
        puts max
    end
end

solve
