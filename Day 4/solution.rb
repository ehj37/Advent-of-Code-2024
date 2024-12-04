def parse_input(file)
    File.read(file).split(/\n/).map(&:chars)
end

def num_xmas(word_search)
    word_search_w = word_search[0].length
    word_search_h = word_search.length
    
    horizontal_lines = word_search.map(&:join)
    vertical_lines = word_search.transpose.map(&:join)
    diagonal_lines = []
    (0...word_search_h).each do |i|
       diagonal_lines.append i.downto(0).map { |j| word_search[j][i - j] }.join
       diagonal_lines.append i.downto(0).map { |j| word_search[j][word_search_w - 1 - (i - j)] }.join
    end
    (1...word_search_w).each do |i|
        diagonal_lines.append (i..word_search_w).map { |j| word_search[word_search_h - 1 - (j - i)][j] }.join
        diagonal_lines.append (i..word_search_w - 1).map { |j| word_search[word_search_h - 1 - (j - i)][word_search_w - j - 1] }.join
    end

    [horizontal_lines, vertical_lines, diagonal_lines].sum do |lines|
        lines.sum { |l| l.scan(/XMAS/).count + l.reverse.scan(/XMAS/).count }
    end
end

def sample
    num_xmas(parse_input('sample.txt'))
end

def part_1
    num_xmas(parse_input('input.txt'))
end