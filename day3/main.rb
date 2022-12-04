def priority(char)
  char >= 'a' ? char.ord - 96 : char.ord - 38
end

input = File.readlines('day3/input.txt').map(&:strip)

res = input.map do |line|
  a, b = line.split('').each_slice(line.size / 2).to_a
  priority((a & b).first)
end

puts "a: ", res.sum

res = input.each_slice(3).map do |group|
  a, b, c = group.map { |l| l.split('') }
  priority((a & b & c).first)
end

puts "b: ", res.sum
