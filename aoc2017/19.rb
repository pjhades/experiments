#!/usr/bin/env ruby

$delta = [[-1, 0], [0, -1], [1, 0], [0, 1]]

def walk(board, row, col)
    x, y = 0, board[0].index('|')
    dir = 2
    letters = ''
    steps = 0
    while true
        dx, dy = $delta[dir]
        x, y = x + dx, y + dy
        steps += 1
        while board[x][y] != ' ' && board[x][y] != '+'
            letters += board[x][y] if board[x][y] =~ /[A-Z]/
            x, y = x + dx, y + dy
            steps += 1
        end
        break if board[x][y] == ' '
        [-1, 1].map{|i| (dir + i) % 4}.each do |new_dir|
            dx, dy = $delta[new_dir]
            if x + dx >= 0 && x + dx < row &&
               y + dy >= 0 && y + dy < col &&
               board[x + dx][y + dy] != ' '
                dir = new_dir
                break
            end
        end
    end
    puts letters
    puts steps
end

def solve
    board = STDIN.each_line.map{|l| l.chomp}
    board.each {|x| puts x}
    walk(board, board.length, board.map{|l| l.length}.max)
end

solve
