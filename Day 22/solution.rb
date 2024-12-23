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