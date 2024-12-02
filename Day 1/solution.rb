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

# Part 2 solution
def calculate_similarity_score
    right_value_to_count = @right_list.uniq.each_with_object({}) do |i, hash| 
        hash[i] = @right_list.count(i)
    end

    @left_list.reduce(0) { |sum, i| sum + i * right_value_to_count[i].to_i }
end
