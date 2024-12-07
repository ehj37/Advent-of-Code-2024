def parse_input(path)
    File.read(path).split(/\n/)
        .map { |eq| eq.scan(/\d+/).map(&:to_i) }
        .map { |ns| [ns[0], ns[1..]] }
end


def filter_possibly_true(eqs)
    eqs.filter do |(test_val, ns)|
        ['*', '+'].repeated_permutation(ns.length - 1).find do |p|
            test_val == ns[1..].each_with_index.reduce(ns.first) do |acc, (n, i)|
                [acc, n].reduce(p[i].to_sym)
            end
        end
    end
end

def part_1
    filter_possibly_true(parse_input('input.txt')).map(&:first).sum
end