require 'matrix'

class Antenna
    attr_accessor :freq, :coords

    def initialize(freq, x, y)
        @freq = freq
        @coords = Vector[x, y]
    end

    def antinodes_with(other, x_limit, y_limit)
        v = other.coords - @coords
        [@coords - v, other.coords + v].filter do |loc|
            (0...x_limit).include?(loc[0]) && (0...y_limit).include?(loc[1])
        end
    end
end

def parse_input(path)
    lines = File.read(path).split(/\n/)
    antennae = lines.flat_map.with_index do |l, i|
        l.split('').filter_map.with_index { |c, j| Antenna.new(c, j, i) if c != '.' }
    end
    [antennae, lines[0].length, lines.length]
end

def num_antinode_locs(antennae, city_width, city_height)
    antennae.group_by(&:freq).flat_map do |_f, group|
        group.combination(2).flat_map do |(a1, a2)|
            a1.antinodes_with(a2, city_width, city_height)
        end
    end.uniq.length
end

def part_1
    num_antinode_locs(*parse_input('./input.txt'))
end

def num_antinode_locs_but_for_real(antennae, city_width, city_height)
    antenna_groups = antennae.group_by(&:freq).values
    (0...city_height).flat_map do |y|
        (0...city_width).filter_map do |x|
            v = Vector[x, y]
            v if antenna_groups.any? do |group|
                group.combination(2).any? do |(a1, a2)|
                    break true if v == a1.coords || v == a2.coords
                    to_a1 = (a1.coords - v).normalize.round(6)
                    to_a2 = (a2.coords - v).normalize.round(6)
                    to_a1 == to_a2 || to_a1 == -to_a2
                end
            end
        end
    end.uniq.length
end

def part_2
    num_antinode_locs_but_for_real(*parse_input('./input.txt'))
end