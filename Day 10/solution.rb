def parse_input(path)
  File.read(path).split(/\n/).map { _1.split('').map(&:to_i) }
end

def overall_trailhead_score(top_map)
  trailheads = top_map.flat_map.with_index do |l, y|
    l.filter_map.with_index { |h, x| [y, x] if h == 0 }
  end

  trailheads.sum do |(y, x)|
    visited = []
    stack = [[y, x]]
    acc = 0
    while !(pos = stack.shift).nil? do
      next if visited.include? pos
      
      visited << pos
      b, a = pos
      next acc += 1 if top_map[b][a] == 9

      next_spots = [[b + 1, a], [b - 1, a], [b, a + 1], [b, a - 1]].filter do |(d, c)|
        is_on_map = (0...top_map.length).include?(d) && (0...top_map[0].length).include?(c)
        is_on_map && !visited.include?([d, c]) && top_map[d][c] == top_map[b][a] + 1
      end

      stack.concat(next_spots)
    end
    acc
  end
end

def part_1
  overall_trailhead_score(parse_input('./input.txt'))
end

def overall_trailhead_rating(top_map)
  trailheads = top_map.flat_map.with_index do |l, y|
    l.filter_map.with_index { |h, x| [y, x] if h == 0 }
  end

  trailheads.sum do |(y, x)|
    stack = [[y, x]]
    acc = 0
    while !(pos = stack.shift).nil? do
      b, a = pos
      next acc += 1 if top_map[b][a] == 9

      next_spots = [[b + 1, a], [b - 1, a], [b, a + 1], [b, a - 1]].filter do |(d, c)|
        is_on_map = (0...top_map.length).include?(d) && (0...top_map[0].length).include?(c)
        is_on_map && top_map[d][c] == top_map[b][a] + 1
      end

      stack.concat(next_spots)
    end
    acc
  end
end


def part_2
  overall_trailhead_rating(parse_input('./input.txt'))
end