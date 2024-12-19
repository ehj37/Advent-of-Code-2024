def parse_input(path)
  available_patterns_input, desired_designs_input = File.read(path).split(/\n\n/)
  [available_patterns_input.scan(/[a-z]+/), desired_designs_input.split(/\n/)]
end

def is_possible?(design, available_patterns)
  is_possible_helper(design, available_patterns, {})
end

def is_possible_helper(remaining_design, available_patterns, cache)
  return cache[remaining_design] if !cache[remaining_design].nil?

  return true if remaining_design == ''

  next_patterns = available_patterns.filter { |p| remaining_design.start_with?(p) }
  next_patterns.each do |p|
    next if !cache[remaining_design[p.length...]].nil?

    cache[remaining_design[p.length...]] = is_possible_helper(remaining_design[p.length...], available_patterns, cache)
  end

  next_patterns.any? { |p| cache[remaining_design[p.length...]]}
end

def num_possible(designs, available_patterns)
  designs.count { |d| is_possible?(d, available_patterns) }
end

def example_part_1
  available_patterns, designs = parse_input(File.join(File.dirname(__FILE__), '/example.txt'))
  num_possible(designs, available_patterns)
end

def part_1
  available_patterns, designs = parse_input(File.join(File.dirname(__FILE__), '/input.txt'))
  num_possible(designs, available_patterns)
end