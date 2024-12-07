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
  distinct_positions(map).length
end

def distinct_positions(map)
  distinct_positions_helper(map, [])
end

def distinct_positions_helper(map, visited_positions)
  dir, pos = get_guard_info(map)
  new_visited_positions = visited_positions.include?(pos) ? visited_positions : visited_positions + [pos]
  pos_in_front = pos.each_with_index.map { |n, i| n + DIRECTION_TO_POSITION_CHANGE[dir][i] }

  is_off_map = !(0...map[0].length).include?(pos_in_front[0]) || !(0...map.length).include?(pos_in_front[1])
  return new_visited_positions if is_off_map

  new_dir = map[pos_in_front[1]][pos_in_front[0]] == '#' ? DIRECTION[(DIRECTION.index(dir) + 1) % 4] : dir
  new_pos = pos.each_with_index.map { |n, i| n + DIRECTION_TO_POSITION_CHANGE[new_dir][i] }

  new_map = map.each_with_index.map do |l, y|
    l.each_with_index.map do |c, x|
      DIRECTION.include?(c) ? '.' : ([x, y] == new_pos ? new_dir : c)
    end
  end

  distinct_positions_helper(new_map, new_visited_positions)
end

def part_1
  num_distinct_positions(parse_input('input.txt'))
end

def is_looping?(map)
  blockades = map.each_with_index.flat_map { |l, y| l.each_with_index.filter_map { |c, x| c == '#' ? [x, y] : nil } }
  initial_dir, initial_pos = get_guard_info(map)
  is_looping_helper(blockades, initial_pos, initial_dir, [])
end

def is_looping_helper(blockades, pos, dir, turns)
  blockades_in_path = blockades.filter do |b|
    case dir
    when UP
      pos[0] == b[0] && pos[1] > b[1]
    when RIGHT
      pos[1] == b[1] && pos[0] < b[0]
    when DOWN
      pos[0] == b[0] && pos[1] < b[1]
    when LEFT 
      pos[1] == b[1] && pos[0] > b[0]
    end
  end

  return false if blockades_in_path.blank?

  next_blockade = blockades_in_path.min_by { |b| (Vector[*pos] - Vector[*b]).magnitude }

  return true if turns.include?([dir, next_blockade])

  is_looping_helper(
    blockades,
    (Vector[*next_blockade] - Vector[*DIRECTION_TO_POSITION_CHANGE[dir]]).to_a,
    DIRECTION[(DIRECTION.index(dir) + 1) % 4],
    turns + [[dir, next_blockade]]
  )
end

def num_looping(map)
  _dir, initial_guard_pos = get_guard_info(map)
  possible_blockade_positions = distinct_positions(map) - [initial_guard_pos]
  possible_blockade_positions.count do |pos|
    altered_map = map.each_with_index.map do |l, y|
      l.each_with_index.map  { |c, x| ([x, y] == pos ? '#' : c) }
    end
    is_looping?(altered_map)
  end
end

def part_2
  num_looping(parse_input('input.txt'))
end