def parse_input(path)
    File.read(path).split(/\n/).map(&:to_i)
end

def nth_secret_number(initial, n)
    return initial if n == 0

    r1 = (initial ^ (initial * 64)) % 16777216
    r2 = (r1 ^ (r1 / 32)) % 16777216
    nth_secret_number((r2 ^ (2048 * r2)) % 16777216, n - 1)
end

def nth_secret_number_sum(initial_secret_numbers, n)
    initial_secret_numbers.sum { |i| nth_secret_number(i, n) }
end

def part_1
    initial_secret_numbers = parse_input(File.join(File.dirname(__FILE__), '/input.txt'))
    nth_secret_number_sum(initial_secret_numbers, 2000)
end

def n_secret_numbers(initial, n)
    return [] if n == 0

    secret_numbers = [initial]

    current = initial
    for i in (1...n) do
        r1 = (current ^ (current * 64)) % 16777216
        r2 = (r1 ^ (r1 / 32)) % 16777216
        r3 = (r2 ^ (2048 * r2)) % 16777216

        secret_numbers << r3
        current = r3
    end

    secret_numbers
end

def price(secret_number)
    secret_number.to_s.chars.last.to_i
end

def price_change_sequence_info_for(secret_numbers)
    sequences = []
    (4...secret_numbers.length).each do |i|
        seq = []
        secret_numbers[i - 4..i].each_cons(2) do |(a, b)|
            seq << price(b) - price(a)
        end
        next if sequences.any? { |s| s.first == seq }

        sequences << [seq, price(secret_numbers[i])]
    end
    sequences
end

def most_bananas_for(initial_secret_numbers, n)
    price_change_sequence_info = initial_secret_numbers.flat_map do |secret_number|
        generated_secret_numbers = n_secret_numbers(secret_number, n + 1)
        price_change_sequence_info_for(generated_secret_numbers)
    end

    price_change_sequence_info
        .group_by(&:first)
        .transform_values { |is| is.sum { |i| i[1] } }
        .max_by { |(k, v)| v }[1]
end

def example_part_2
    initial_secret_numbers = parse_input(File.join(File.dirname(__FILE__), '/example.txt'))
    most_bananas_for(initial_secret_numbers, 2000)
end

def part_2
    initial_secret_numbers = parse_input(File.join(File.dirname(__FILE__), '/input.txt'))
    most_bananas_for(initial_secret_numbers, 2000)
end