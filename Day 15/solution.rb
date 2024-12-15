class Wall
    @@all ||= []
    attr_reader :x, :y

    def initialize(x, y)
        @x, @y = x, y
        @@all << self
    end

    def attempt_push!(_dir)
        false
    end

    def self.all
        @@all
    end

    def self.reset!
        @@all = []
    end
end

class Moveable
    attr_reader :x, :y
    
    def attempt_push!(dir)
        target_coords = case dir
        when '^'
            [x, y - 1]
        when '>'
            [x + 1, y]
        when 'v'
            [x, y + 1]
        when '<'
            [x - 1, y]
        end
        impediment = (Wall.all + Box.all).find { |w_or_b| [w_or_b.x, w_or_b.y] == target_coords }
        return false if impediment && !impediment.attempt_push!(dir)

        @x, @y =  target_coords
        true
    end
end

class Box < Moveable
    @@all ||= []

    def initialize(x, y)
        super
        @@all << self
    end

    def self.all
        @@all
    end

    def self.reset!
        @@all = []
    end
end

class Robot < Moveable; end

def parse_input(path)
    Wall.reset!; Box.reset!
    warehouse_map_input, moves_input = File.read(path).split(/\n\n/)
    warehouse_contents = warehouse_map_input.split(/\n/).flat_map.with_index do |l, y|
        l.chars.filter_map.with_index do |c, x|
            case c
            when 'O'
                Box.new(x, y)
            when '#'
                Wall.new(x, y)
            when '@'
                Robot.new(x, y)
            end
        end
    end
    moves = moves_input.delete("\n").split('')
    [warehouse_contents, moves]
end

def apply_moves(warehouse_contents, moves)
    robot = warehouse_contents.find { |c| c.is_a? Robot }
    moves.each { |m| robot.attempt_push!(m) }
end

def gps_sum(warehouse_contents)
    warehouse_contents.filter { |c| c.is_a? Box }.sum { |b| b.x + 100 * b.y }
end

def example_small_part_1
    warehouse_contents, moves = parse_input('./example_small.txt')
    apply_moves(warehouse_contents, moves)
    gps_sum(warehouse_contents)
end

def example_large_part_1
    warehouse_contents, moves = parse_input('./example_large.txt')
    apply_moves(warehouse_contents, moves)
    gps_sum(warehouse_contents)
end

def part_1
    warehouse_contents, moves = parse_input('./input.txt')
    apply_moves(warehouse_contents, moves)
    gps_sum(warehouse_contents)
end

