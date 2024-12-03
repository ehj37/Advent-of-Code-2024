def parse_input(path)
    File.read(path).lines
end

def mul_instructions_sum(memory)
    memory.reduce(0) do |acc, line|
        valid_instructions = line.scan(/mul\([0-9]+,[0-9]+\)/)
        acc + valid_instructions.reduce(0) do |inner_sum, i| 
            inner_sum + i.scan(/[0-9]+/).map(&:to_i).reduce(:*)
        end
    end
end

def part_1
    mul_instructions_sum(parse_input('input.txt'))
end