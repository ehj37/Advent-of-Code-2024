def parse_input(path)
  File.read(path).split(/\n\n/).map { |c| c.split(/\n/).map { _1.scan(/\d+/).map(&:to_i) } }
end

def winning_combos_for(claw)
  (ax, ay), (bx, by), (px, py) = claw
  (0..100).to_a.product((0..100).to_a).filter { |(i, j)| i * ax + j * bx == px && i * ay + j * by == py }
end

def fewest_tokens_for_all_prizes(claws)
  claws.sum do |c|
    wcs = winning_combos_for(c)
    next 0 unless wcs.any?
    wc = wcs.min { |(x, y)| 3 * x + y }
    3 * wc[0] + wc[1]
  end
end

def part_1
  fewest_tokens_for_all_prizes(parse_input('./input.txt'))
end