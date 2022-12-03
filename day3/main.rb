def priority(char)
  if char >= 'a'
    char.codepoints.first - 96
  else
    char.codepoints.first - 38
  end
end

res = File.readlines('day3/input.txt').map do |line|
  a, b = line.split('').each_slice(line.size / 2).to_a
  priority(a.intersection(b).first)
end

puts "a: ", res.inspect, res.sum

res = File.readlines('day3/input.txt').map(&:strip).each_slice(3).map do |group|
  a, b, c = group.map { |l| l.split('') }
  priority(a.intersection(b).intersection(c).first)
end

puts "b: ", res.inspect, res.sum
