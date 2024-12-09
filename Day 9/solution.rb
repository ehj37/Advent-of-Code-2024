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
        puts move_i_candidate
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