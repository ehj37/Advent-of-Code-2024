def parse_input(path)
  File.read(path).split(/\n/).map { |l| l.split '' }
end

DIRECTION = [
  UP = '^',
  RIGHT = '>',
  DOWN = 'v',
  LEFT = '<',
]

DIRECTION_TO_POSITION_CHANGE = {
  UP => [0, -1],
  RIGHT => [1, 0],
  DOWN => [0, 1],
  LEFT => [-1, 0],
}

def get_guard_info(map)
  map.each_with_index do |l, y|
    x = l.index { |i| ['^', '>', 'v', '<'].include? i }
    return [map[y][x], [x, y]] unless x.blank?
  end
end

def num_distinct_positions(map)
  num_distinct_positions_helper(map, [])
end

def num_distinct_positions_helper(map, visited_positions)
  dir, pos = get_guard_info(map)
  new_visited_positions = visited_positions.include?(pos) ? visited_positions : visited_positions + [pos]
  pos_in_front = pos.each_with_index.map { |n, i| n + DIRECTION_TO_POSITION_CHANGE[dir][i] }
  new_dir = map[pos_in_front[1]][pos_in_front[0]] == '#' ? DIRECTION[(DIRECTION.index(dir) + 1) % 4] : dir
  new_pos = pos.each_with_index.map { |n, i| n + DIRECTION_TO_POSITION_CHANGE[new_dir][i] }

  is_off_map = !(0...map[0].length).include?(new_pos[0]) || !(0...map.length).include?(new_pos[1])
  return new_visited_positions.length if is_off_map

  new_map = map.each_with_index.map do |l, y|
    l.each_with_index.map do |c, x|
      DIRECTION.include?(c) ? '.' : ([x, y] == new_pos ? new_dir : c)
    end
  end

  num_distinct_positions_helper(new_map, new_visited_positions)
end

def part_1
  num_distinct_positions(parse_input('input.txt'))
end