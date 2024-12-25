def parse_input(path)
    locks_and_keys_input = File.read(path)
        .split(/\n\n/)
        .map { _1.split.join.split('')}
        .partition { |lock_or_key| (0..4).all? { |i| lock_or_key[i] == '#' } }

    locks_and_keys_input.map do |input|
        input.map do |lock_or_key|
            lock_or_key.each_with_object([0, 0, 0, 0, 0]).with_index do |(c, acc), i|
                acc[i % 5] += 1 if c == '#'
            end
        end
    end
end

def num_non_overlapping_pairs(locks, keys)
    locks.product(keys).count do |(lock, key)|
        (0..4).all? { |i| lock[i] + key[i] <= 7 }
    end
end

def part_1
    locks, keys = parse_input(File.join(File.dirname(__FILE__), '/input.txt'))
    num_non_overlapping_pairs(locks, keys)
end