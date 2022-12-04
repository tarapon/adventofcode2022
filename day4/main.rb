def include?(r1, r2)
  (r1.include?(r2.min) && r1.include?(r2.max)) || (r2.include?(r1.min) && r2.include?(r1.max))
end

def overlaps?(r1, r2)
  r1.include?(r2.min) || r2.include?(r1.min)
end

def to_ranges(line)
  line.strip
    .split(',')
    .map { |r| r.split('-') }
    .map { |r| (r[0].to_i..r[1].to_i) }
end

ranges = File.readlines('day4/input.txt').map { |line| to_ranges(line) }

puts "a: ", ranges.map { |a, b| include?(a, b)  }.count(true)
puts "b: ", ranges.map { |a, b| overlaps?(a, b)  }.count(true)
