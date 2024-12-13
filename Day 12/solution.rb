def parse_input(path)
  File.read(path).split(/\n/).map { |l| l.split('') }
end

def total_fencing_cost(garden_map)
  garden_width = garden_map[0].length
  garden_height = garden_map.length

  visited = []
  garden_map.flat_map.with_index do |l, y|
    l.each_with_index.reduce(0) do |acc, (plot, x)|
      next acc if visited.include?([x, y])

      area = 0
      perimeter = 0
      stack = [[x, y]]
      while loop_plot = stack.shift do
        visited << loop_plot
        area += 1
        loop_x, loop_y = loop_plot
        loop_plant = garden_map[loop_y][loop_x]
        adjacent_plot_coords = [
          [loop_x + 1, loop_y],
          [loop_x - 1, loop_y],
          [loop_x, loop_y + 1],
          [loop_x, loop_y - 1],
        ].filter do |(c_x, c_y)|
           (0...garden_width).include?(c_x) && (0...garden_height).include?(c_y) && garden_map[c_y][c_x] == loop_plant
        end
        perimeter += 4 - adjacent_plot_coords.length
        stack.concat(adjacent_plot_coords.filter { |p| !visited.include?(p) && !stack.include?(p) })
      end
      acc + area * perimeter
    end
  end.sum
end

def part_1
  total_fencing_cost(parse_input('input.txt'))
end