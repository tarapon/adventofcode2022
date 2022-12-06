msg = File.readlines('day6/input.txt').join.strip

M_SIZE = 4

start_index = (M_SIZE..msg.size).find do |i|
  msg[i - M_SIZE..i - 1].split('').uniq.size == M_SIZE
end

puts "a: ", start_index
