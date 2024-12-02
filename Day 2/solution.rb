def parse_input
    @reports = File.read('input.txt').split(/\n/).map do |raw_report| 
        raw_report.split(/\s+/).map(&:to_i)
    end
end

# Part 1 solution
def num_safe_reports
    @reports.reduce(0) do |count, report|
        sorted_report = report.sort
        next count if sorted_report != report && sorted_report != report.reverse
        
        next count unless report[1...].each_with_index.all? do |level, i|
            (1..3).cover? (level - report[i]).abs
        end

        count + 1
    end
end