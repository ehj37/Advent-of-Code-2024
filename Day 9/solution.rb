class EmptyBlock
    def empty?
        true
    end
end

class FileBlock
    attr_accessor :id

    def initialize(id)
        @id = id
    end

    def empty?
        false
    end
end

def parse_input(path)
    File.read(path).split('').map(&:to_i).flat_map.with_index do |n, i|
        n.times.map { i % 2 == 0 ? FileBlock.new(i / 2) : EmptyBlock.new } 
    end
end

def checksum(file)
    file.each_with_index.reduce(0) { |acc, (b, i)| acc + (b.empty? ? 0 : i * b.id) }
end

def compacted_file(file)
    move_i = file.length
    file.map.with_index do |block, i|
        next EmptyBlock.new if i >= move_i
        next block if !block.empty?
        move_i_candidate = file[0...move_i].rindex { |b| !b.empty? }
        if move_i_candidate >= i
            move_i = move_i_candidate
            file[move_i]
        else
            EmptyBlock.new
        end
    end
end

def part_1
    checksum(compacted_file(parse_input('./input.txt')))
end

def grouped_file(file)
    groups = [[]]
    file.each do |b|
        if groups.last.all? { |gb| b.empty? ? gb.empty? : gb.is_a?(FileBlock) && gb.id == b.id }
            groups.last.append(b)
        else
            groups.append([b])
        end
    end 
    groups
end

def pick_group(candidate_groups, used_groups, space)
    candidate_groups
        .filter { |g| (g.all? { |b| !b.empty? }) && !used_groups.include?(g) && g.length <= space }
        .max { |g| g.first.id }
end

def squash_empty_spaces(compacted_file)
    acc = []
    compacted_file.each { || }
end

def compacted_file_but_this_time_with_full_files(file)
    block_groups = grouped_file(file)
    moved = []
    acc = []

    block_groups.each_with_index do |bg, i|
        puts i
        next acc << (0...bg.length).map { EmptyBlock.new } if moved.include?(bg)
        next acc << bg if !bg.any?(&:empty?)
        space = bg.length
        while !(moveable_i = block_groups[i..].rindex { |cg| !cg.any?(&:empty?) && !moved.include?(cg) && cg.length <= space }).nil? do
            moveable_block = block_groups[i + moveable_i]
            acc << moveable_block
            moved << moveable_block
            space -= moveable_block.length
        end
        acc << (0...space).map { EmptyBlock.new }
    end

    acc.flatten
end

def part_2
    checksum compacted_file_but_this_time_with_full_files(parse_input('./input.txt'))
end