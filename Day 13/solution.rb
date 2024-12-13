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

def parse_input_corrected_coordinates(path)
  File.read(path).split(/\n\n/).map do |c|
    c.split(/\n/).map.with_index do |l, i|
      l.scan(/\d+/).map { |s| i < 2 ? s.to_i : 10000000000000 + s.to_i }
    end
  end
end

def winning_combos_for_redux(claw)
  (ax, ay), (bx, by), (px, py) = claw
  (i, j) = [(px * by - bx * py) / (ax * by - ay * bx), (ax * py - ay * px) / (ax * by - ay * bx)]
  ax * i + bx * j == px && ay * i + by * j == py ? [[i, j]] : []
end

def fewest_tokens_for_all_prizes_redux(claws)
  claws.sum do |c|
    wcs = winning_combos_for_redux(c)
    next 0 unless wcs.any?
    wc = wcs.min { |(x, y)| 3 * x + y }
    3 * wc[0] + wc[1]
  end
end

def part_2
  fewest_tokens_for_all_prizes_redux(parse_input_corrected_coordinates('./input.txt'))
end