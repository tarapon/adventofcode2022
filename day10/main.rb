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
