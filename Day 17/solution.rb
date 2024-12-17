def parse_input(path)
    register_input, program_input = File.read(path).split(/\n\n/)
    [program_input.scan(/\d+/).map(&:to_i), register_input.split(/\n/).flat_map { |r| r.scan(/\d+/) }.map(&:to_i)]
end

def combo_operand_val(operand, registers)
    register_a, register_b, register_c = registers
    case operand
    when 0, 1, 2, 3
        operand
    when 4
        register_a
    when 5
        register_b
    when 6
        register_c
    when 7
        puts '(╯°□°)╯︵ ┻━┻'
    end
end

def output_str(program, initial_registers)
    output = []
    register_a, register_b, register_c = initial_registers
    instruction_pointer = 0
    while instruction_pointer < program.length - 1 do
        instruction, operand = program[instruction_pointer..instruction_pointer + 1]
        registers = [register_a, register_b, register_c]
        case instruction
        when 0
            register_a = (register_a.to_f / (2 ** combo_operand_val(operand, registers))).to_i
        when 1
            register_b = register_b ^ operand
        when 2
            register_b = combo_operand_val(operand, registers) % 8
        when 3
            (instruction_pointer = operand; next) if register_a != 0
        when 4
            register_b = register_b ^ register_c
        when 5
            output << combo_operand_val(operand, registers) % 8
        when 6
            register_b = (register_a.to_f / (2 ** combo_operand_val(operand, registers))).to_i
        when 7
            register_c = (register_a.to_f / (2 ** combo_operand_val(operand, registers))).to_i
        end
        instruction_pointer += 2
    end
    output.join(',')
end

def example_part_1
    output_str(*parse_input('./example.txt'))
end

def part_1
    output_str(*parse_input('./input.txt'))
end

def part_2
end