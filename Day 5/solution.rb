def parse_input(file)
    rules_str, updates_str = File.read('input.txt').split(/^\n/)
    [rules_str, updates_str].map do |str|
        str.split(/\n/).map { |s| s.scan(/\d+/).map(&:to_i) }
    end
end

def is_correctly_ordered?(rules, update)
    rules.all? do |r|
        r.any? { |i| !update.include?(i) } || update.index(r[0]) < update.index(r[1])
    end
end

def correctly_ordered_updates(rules, updates)
    updates.filter { |u| is_correctly_ordered?(rules, u) }
end

def sum_update_middles(updates)
    updates.sum { |u| u[u.length / 2] }
end

def part_1
    rules, updates = parse_input('input.txt')
    sum_update_middles(correctly_ordered_updates(rules, updates))
end

def order_updates_correctly(rules, updates)
    updates.map do |u|
        new_update = u.clone
        relevant_rules = rules.filter { |r| r.all? { |i| u.include?(i) } }
        until is_correctly_ordered?(relevant_rules, new_update)
            relevant_rules.each do |r| 
                r0_i, r1_i = new_update.index(r[0]), new_update.index(r[1])
                next if r0_i < r1_i
                new_update = (new_update - [r[0], r[1]]).insert(r1_i, r[0], r[1])
            end
        end
        new_update
    end
end

def part_2
    rules, updates = parse_input('input.txt')
    incorrect_updates = updates - correctly_ordered_updates(rules, updates)
    sum_update_middles(order_updates_correctly(rules, incorrect_updates))

end