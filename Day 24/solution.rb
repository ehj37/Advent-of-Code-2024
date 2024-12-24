def parse_input(path)
    initial_values_input, gates_and_wires_input = File.read(path).split(/\n\n/)
    initial_values = initial_values_input
        .split(/\n/)
        .map { w, b = _1.split(': '); [w, b.to_i] }
    gates_and_wires = gates_and_wires_input
        .split(/\n/)
        .map { _1.scan(/\w+/) }
    [initial_values, gates_and_wires]
end

def wire_values_for(initial_values, gates_and_wires)
    wire_values = initial_values.to_h

    unresolved = gates_and_wires
    while unresolved.any? do
        resolvable = unresolved.find { |(w1, gate, w2, w3)| wire_values[w1] && wire_values[w2] }
        unresolved.delete(resolvable)
        w1, gate, w2, w3 = resolvable
        case gate
        when 'XOR'
            wire_values[w3] = wire_values[w1] ^ wire_values[w2]
        when 'AND'
            wire_values[w3] = wire_values[w1] & wire_values[w2]
        when 'OR'
            wire_values[w3] = wire_values[w1] | wire_values[w2]
        end
    end

    wire_values
end

def z_bit_number(initial_values, gates_and_wires)
    wire_values = wire_values_for(initial_values, gates_and_wires)
    z_values = wire_values.filter_map { |k, v| [k, v] if k.start_with?('z') }.sort_by(&:first)
    z_values.map.with_index { |(_w, v), i| v * 2 ** i }.sum
end

def example_part_1
    initial_values, gates_and_wires = parse_input(File.join(File.dirname(__FILE__), '/example.txt'))
    z_bit_number(initial_values, gates_and_wires)
end

def part_1
    initial_values, gates_and_wires = parse_input(File.join(File.dirname(__FILE__), '/input.txt'))
    z_bit_number(initial_values, gates_and_wires)
end