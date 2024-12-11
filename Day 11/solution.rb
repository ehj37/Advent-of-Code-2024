def parse_input(path)
    File.read(path).split(/ /).map(&:to_i)
end

def blink(stones, n)
    return stones if n == 0
    stones.flat_map do |s|
        if s == 0
            blink([1], n - 1)
        elsif (s_str = s.to_s; s_str.length % 2 == 0)
            s_l = s_str[0...s_str.length / 2].to_i
            s_r = s_str[s_str.length / 2..].to_i
            blink([s_l, s_r], n - 1)
        else
            blink([s * 2024], n - 1)
        end
    end
end

def part_1
    blink(parse_input('input.txt'), 25).length
end