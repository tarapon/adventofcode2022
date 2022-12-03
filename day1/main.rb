calories = []
current = 0

File.readlines('day1/input.txt').each do |line|
  if line.strip.empty?
    calories << current
    current = 0
  else
    current += line.to_i
  end
end

calories << current

puts "a: ", calories.max
puts "b: ", calories.max(3).sum
