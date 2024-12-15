require 'matrix'

class Robot
    attr_accessor :position, :velocity

    def initialize(p, v)
        @position = Vector[*p]
        @velocity = Vector[*v]
    end

    def update!(space_w, space_h)
        @position = Vector[(position[0] + velocity[0]) % space_w, (position[1] + velocity[1]) % space_h]
    end

    def x
        position[0]
    end

    def y
        position[1]
    end
end

def parse_input(path)
    File.read(path).split(/\n/).flat_map do |l|
        p, v = l.split(' ').map { |r| r.scan(/[\d|-]+/).flatten.map(&:to_i) }
        Robot.new(p, v)
    end
end

def update_robots!(n, robots, space_w, space_h)
    n.times { robots.map { |r| r.update!(space_w, space_h) } }
end

def safety_factor(robots, space_w, space_h)
    q1_ct = robots.count { |r| (space_w / 2 + 1..).include?(r.x) && (0...space_h / 2).include?(r.y) }
    q2_ct = robots.count { |r| (0...space_w / 2).include?(r.x) && (0...space_h / 2).include?(r.y) }
    q3_ct = robots.count { |r| (0...space_w / 2).include?(r.x) && (space_h / 2 + 1..).include?(r.y) }
    q4_ct = robots.count { |r| (space_w / 2 + 1..).include?(r.x) && (space_h / 2 + 1..).include?(r.y) }
    q1_ct * q2_ct * q3_ct * q4_ct
end

def example_part_1
    robots = parse_input('./example.txt')
    robots = robots.filter { |r| r.position == Vector[2, 4] }
    space_w, space_h = 11, 7
    update_robots!(1, robots, space_w, space_h)
    safety_factor(robots, space_w, space_h)
end

def part_1
    robots = parse_input('./input.txt')
    space_w, space_h = 101, 103
    update_robots!(100, robots, space_w, space_h)
    safety_factor(robots, space_w, space_h)
end