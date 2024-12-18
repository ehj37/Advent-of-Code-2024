def parse_input(path)
  File.read(path).lines.map { |l| l.scan(/\d+/).map(&:to_i) }
end

def grid_after_n_bytes_fall(grid_size, byte_coords, n)
  grid = (0...grid_size).map { (0...grid_size).map { '.' }  }
  byte_coords[0...n].each_with_object(grid) { |(x, y), g| g[y][x] = '#' }
end

def shortest_path_length(grid_size, byte_coords, n_fallen_bytes)
  grid = grid_after_n_bytes_fall(grid_size, byte_coords, n_fallen_bytes)

  unvisited = grid.flat_map.with_index { |l, y| l.filter_map.with_index { |s, x| [x, y] if s == '.' } }
  distance_from_start = unvisited.map { |(x, y)| [[x, y], [x, y] == [0, 0] ? 0 : Float::INFINITY] }.to_h
  while (current = unvisited.filter { |c| distance_from_start[c].finite? }.min_by { |c| distance_from_start[c] }) do
    unvisited.delete(current)
    cx, cy = current
    current_distance = distance_from_start[current]

    [[cx + 1, cy], [cx - 1, cy], [cx, cy + 1], [cx, cy - 1]].each do |(x, y)|
      next unless (0...grid_size).include?(x) && (0...grid_size).include?(y)

      next unless grid[y][x] != '#' && unvisited.include?([x, y])

      distance_from_start[[x, y]] = [distance_from_start[[x, y]], current_distance + 1].min
    end
  end

  distance_from_start[[grid_size - 1, grid_size - 1]]
end

def part_1
  shortest_path_length(71, parse_input('./input.txt'), 1024)
end