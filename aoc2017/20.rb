#!/usr/bin/env ruby

def point(s)
    m = s.match(/[pva]=<([-0-9]+),([-0-9]+),([-0-9]+)>/)
    m[1..3].map{|k| k.to_i}.to_a
end

def part1
    t = 10000000
    puts STDIN.each_with_index.map {|l, idx|
        p, v, a = l.chomp.split(', ').map{|k| point(k)}.to_a
        distance = p.zip(v, a).map{|pi, vi, ai| (pi + t*vi + ai*t*(t+1)/2).abs}.to_a.sum
        [distance, idx]
    }.min_by{|distance, idx| distance}[1]
end

# This is dirty. I never expected that only 1000 steps would be enough
# to find out all intersections. Learn some graphics man!
def part2
    t = 1000
    traj= STDIN.each_line.map do |l|
        p, v, a = l.chomp.split(', ').map{|k| point(k)}.to_a
        (0..t).map do |ti|
            p.zip(v, a).map{|pi, vi, ai| pi + ti*vi + ai*ti*(ti+1)/2}
        end
    end
    puts traj.select{|t1| (0..t).all?{|i| traj.map{|t2| t2[i]}.count(t1[i]) == 1}}.length
end

part2
