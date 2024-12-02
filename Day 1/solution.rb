def parse_input(path)
    lines = File.read(path).split("\n")
    pairs = lines.map { |left_right_str| left_right_str.split(/\s+/).map(&:to_i) }
    @left_list = pairs.map { |pair| pair[0] }
    @right_list = pairs.map { |pair| pair[1] }
end

# Part 1 solution
def pair_and_measure
    sorted_left = @left_list.sort
    sorted_right = @right_list.sort
    zipped_lists = sorted_left.zip sorted_right
    distances = zipped_lists.map { |pair| (pair[0] - pair[1]).abs }
    distances.sum
end