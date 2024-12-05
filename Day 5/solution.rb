def parse_input(file)
    rules_str, updates_str = File.read('input.txt').split(/^\n/)
    [rules_str, updates_str].map do |str|
        str.split(/\n/).map { |s| s.scan(/\d+/).map(&:to_i) }
    end
end

def correctly_ordered_updates(rules, updates)
    updates.filter do |u|
        rules.all? { |r| r.any? { |i| !u.include?(i) } || u.index(r[0]) < u.index(r[1]) }
    end
end

def sum_update_middles(updates)
    updates.sum { |u| u[u.length / 2] }
end

def part_1
    rules, updates = parse_input('input.txt')
    sum_update_middles(correctly_ordered_updates(rules, updates))
end