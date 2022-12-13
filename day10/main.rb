cpu = Enumerator.new do |out|
  x = 1
  out << x

  File.readlines('day10/input.txt').each do |line|
    case line.strip.split(' ')
      in ['noop']
        out << x
      in ['addx', num]
        out << x
        x += num.to_i
        out << x
    end
  end
end


result = cpu.each_with_index.map do |x, i|
  idx = i + 1

  if idx == 20
    x * idx
  elsif idx > 20 && (idx - 20) % 40 == 0
    x * idx
  else
    0
  end
end

puts "a: #{result.sum}"

puts "b:"

cpu.each_with_index.map do |x, i|
  puts if i % 40 == 0

  if (x-1..x+1).include?(i % 40)
    print "\u001B[41m"
    print '#'
  else
    print "\u001B[40m"
    print '.'
  end
end

