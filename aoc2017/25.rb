#!/usr/bin/env ruby

def read
    fsa = {}
    m = STDIN.readline.chomp.match(/^Begin in state ([A-Z]).$/)
    state = m[1]
    m = STDIN.readline.chomp.match(/^Perform a diagnostic checksum after (\d+) steps.$/)
    step = m[1].to_i
    while !STDIN.eof?
        STDIN.readline
        m = STDIN.readline.chomp.match(/^In state ([A-Z]):$/)
        from = m[1]
        fsa[from] = {}
        (0..1).each do |bit|
            STDIN.readline
            m = STDIN.readline.chomp.match(/Write the value (0|1)/)
            output = m[1].to_i
            m = STDIN.readline.chomp.match(/Move one slot to the (right|left)/)
            direction = m[1] == 'right' ? 1 : -1
            m = STDIN.readline.chomp.match(/Continue with state ([A-Z])/)
            to = m[1]
            fsa[from][bit] = [output, direction, to]
        end
    end

    [state, step, fsa]
end

def part1
    state, step, fsa = read
    tape = [0] * (step * 2 + 1)
    idx = step
    step.times do
        output, direction, to = fsa[state][tape[idx]]
        tape[idx] = output
        idx += direction
        state = to
    end
    puts tape.sum
end

part1
