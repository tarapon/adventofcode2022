msg = File.readlines('day6/input.txt').join.strip

def find_packet_start(msg, n)
  (n..msg.size).find do |i|
    msg[i - n..i - 1].split('').uniq.size == n
  end
end

puts "a: ", find_packet_start(msg, 4)
puts "b: ", find_packet_start(msg, 14)
