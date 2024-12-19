def parse_input(path)
  available_patterns_input, desired_designs_input = File.read(path).split(/\n\n/)
  [available_patterns_input.scan(/[a-z]+/), desired_designs_input.split(/\n/)]
end

def is_possible?(design, available_patterns)
  num_ways_to_make(design, available_patterns).nonzero?
end

def num_ways_to_make(design, available_patterns)
  num_ways_to_make_helper(design, available_patterns, {})
end

def num_ways_to_make_helper(design, available_patterns, cache)
  return cache[design] if !cache[design].nil?

  return 1 if design == ''

  next_patterns = available_patterns.filter { |p| design.start_with?(p) }
  next_patterns.each do |p|
    next if !cache[design[p.length...]].nil?

    cache[design[p.length...]] = num_ways_to_make_helper(design[p.length...], available_patterns, cache)
  end

  cache[design] = next_patterns.sum { |p| cache[design[p.length...]]}
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

def example_part_2
  available_patterns, designs = parse_input(File.join(File.dirname(__FILE__), '/example.txt'))
  designs.sum { |d| num_ways_to_make(d, available_patterns) }
end

def part_2
  available_patterns, designs = parse_input(File.join(File.dirname(__FILE__), '/input.txt'))
  designs.sum { |d| num_ways_to_make(d, available_patterns) }
end