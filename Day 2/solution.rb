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

# Part 2 solution
def num_safe_reports_with_dampener
    @reports.reduce(0) do |count, report|
        next count + 1 if is_safe(report)

        has_safe_dampened_report = (0..report.length - 1).any? do |i|
            is_safe(report[0...i] + report[i + 1...])
        end
        has_safe_dampened_report ? count + 1 : count
    end
end

def is_safe(report)
    sorted_report = report.sort
    return false if sorted_report != report && sorted_report != report.reverse
    
    return false unless report[1...].each_with_index.all? do |level, i|
        (1..3).cover? (level - report[i]).abs
    end

    true
end