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

res = File.readlines('day4/input.txt').map do |line|
  a, b = to_ranges(line)
  include?(a, b)
end

puts "a: ", res.count(true)

res = File.readlines('day4/input.txt').map do |line|
  a, b = to_ranges(line)
  overlaps?(a, b)
end

puts "b: ", res.count(true)
