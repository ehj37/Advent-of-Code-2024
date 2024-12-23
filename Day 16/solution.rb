def parse_input(path)
    File.read(path).split(/\n/).map { |l| l.split('') }
end

def shortest_path(maze)
    maze_coords = [*0...maze.first.length].product([*0...maze.length])
    start = maze_coords.find { |x, y| maze[y][x] == 'S' }

    dist = [*0...maze.first.length].product([*0...maze.length])
        .filter { |x, y| maze[y][x] != '#' }
        .flat_map do |x, y|
            ['^', '>', 'v', '<'].map do |d|
                [[[x, y], d], [x, y] == start && d == '>' ? 0 : Float::INFINITY]
            end
        end.to_h

    unvisited = dist.keys
    while current = unvisited.filter { dist[_1].finite? }.min_by { dist[_1] } do
        unvisited.delete(current)

        current_dist = dist[current]
        (x, y), dir = current

        [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].each do|(a, b)|
            next unless (0...maze.first.length).include?(a) && (0...maze.length).include?(b)
            
            next if maze[b][a] == '#'

            new_dir = a == x ? (b > y ? 'v' : '^') : (a > x ? '>' : '<')

            # No reason to go backwards.
            next if [['^', 'v'], ['<', '>']].include?([dir, new_dir].sort)

            tile_data = [[a, b], new_dir]

            next unless unvisited.include?(tile_data)

            updated_cost = current_dist + (dir == new_dir ?  1 : 1001)
            dist[tile_data] = updated_cost if updated_cost < dist[tile_data]
        end
    end

    ending = maze_coords.find { |x, y| maze[y][x] == 'E' }
    ['^', '>', 'v', '<'].map { |d| dist[[ending, d]] }.min
end

def example_part_1
    maze = parse_input(File.join(File.dirname(__FILE__), '/example.txt'))
    shortest_path(maze)
end

def part_1
    maze = parse_input(File.join(File.dirname(__FILE__), '/input.txt'))
    shortest_path(maze)
end