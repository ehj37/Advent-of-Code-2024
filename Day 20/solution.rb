def parse_input(path)
    File.read(path).split(/\n/).map { |l| l.split('') }
end

def coord_to_distance_from_start(course)
    unvisited = course.flat_map.with_index { |l, y| l.filter_map.with_index { |s, x| [x, y] if s != '#' } }
    distance_from_start = unvisited.map { |(x, y)| [[x, y], course[y][x] == 'S' ? 0 : Float::INFINITY] }.to_h

    while (current = unvisited.filter { |c| distance_from_start[c].finite? }.min_by { |c| distance_from_start[c] }) do
      unvisited.delete(current)
      cx, cy = current
      current_distance = distance_from_start[current]
  
      [[cx + 1, cy], [cx - 1, cy], [cx, cy + 1], [cx, cy - 1]].each do |(x, y)|
        next unless (0...course[0].length).include?(x) && (0...course.length).include?(y)
  
        next unless course[y][x] != '#' && unvisited.include?([x, y])
  
        distance_from_start[[x, y]] = [distance_from_start[[x, y]], current_distance + 1].min
      end
    end
  
    distance_from_start
end

def num_cheats_saving_n(course, n)
    track_coords = course.flat_map.with_index { |l, y| l.filter_map.with_index { |s, x| [x, y] if s != '#' } }
    distance_mapping = coord_to_distance_from_start(course)
    cheatless_distance = distance_mapping[track_coords.find { |(x, y)| course[y][x] == 'E' }]

    track_coords.sum do |(x, y)|
        possible_ends = (x - 2..x + 2).to_a.product((y - 2..y + 2).to_a).filter { |(a, b)| (a - x).abs + (b - y).abs <= 2 }
        possible_ends.count do |(a, b)|
            next if distance_mapping[[a, b]].nil?

            distance_mapping[[a, b]] - distance_mapping[[x, y]] >= n + (a - x).abs + (b - y).abs
        end
    end
end

def example_part_1
    course = parse_input(File.join(File.dirname(__FILE__), '/example.txt'))
    num_cheats_saving_n(course, 64)
end

def part_1
    course = parse_input(File.join(File.dirname(__FILE__), '/input.txt'))
    num_cheats_saving_n(course, 100)
end