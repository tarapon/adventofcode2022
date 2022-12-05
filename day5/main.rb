stacks = []
commands = []

File.readlines('day5/input.txt').each do |line|
  if line.include?('[')
    line.scan(/.{3,4}/).map(&:strip).each_with_index do |item, index|
      stacks[index] ||= []
      stacks[index].unshift(item.gsub(/[\[\]]/, '')) unless item.empty?
    end
  end

  if line.include?('move')
    line.match(/move (\d+) from (\d+) to (\d+)/) do |match|
      commands << [match[1].to_i, match[2].to_i, match[3].to_i]
    end
  end
end

stacks_a = stacks.map(&:dup)
stacks_b = stacks.map(&:dup)

commands.each do |command|
  n, from, to = command
  n.times { stacks_a[to - 1].push(stacks_a[from - 1].pop) }
end

commands.each do |command|
  n, from, to = command
  stacks_b[to - 1].push(*stacks_b[from - 1].pop(n))
end

puts "a: ", stacks_a.map { |s| s.last }.compact.join
puts "b: ", stacks_b.map { |s| s.last }.compact.join

