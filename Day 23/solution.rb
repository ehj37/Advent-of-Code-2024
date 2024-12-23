def parse_input(path)
    File.read(path).split(/\n/).map { |l| l.split('-') }
end

def connected_triplets_for(connected_pairs)
    computer_to_direct_connections = {}
    connected_pairs.each do |(a, b)|
        computer_to_direct_connections[a] ||= []
        computer_to_direct_connections[a] << b
        computer_to_direct_connections[b] ||= []
        computer_to_direct_connections[b] << a
    end

    connected_triplets = []
    connected_pairs.each do |(a, b)|
        connected_to_both = (computer_to_direct_connections[a] & computer_to_direct_connections[b]).uniq
        connected_to_both.each { |c| connected_triplets << [a, b, c] }
    end
    connected_triplets.uniq(&:sort)
end

def connected_triplets_starting_with_t_for(connected_pairs)
    connected_triplets_for(connected_pairs).count { |t| t.any? { _1.start_with? 't' } }
end

def example_part_1
    connected_pairs = parse_input(File.join(File.dirname(__FILE__), '/example.txt')) 
    connected_triplets_starting_with_t_for(connected_pairs)
end

def part_1
    connected_pairs = parse_input(File.join(File.dirname(__FILE__), '/input.txt'))
    connected_triplets_starting_with_t_for(connected_pairs)
end