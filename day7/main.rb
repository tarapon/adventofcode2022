class ElfFile
  attr_reader :name, :size

  def initialize(name, size = 0)
    @name = name
    @size = size
  end

  def dir?
    false
  end
end

class ElfDir < ElfFile
  include Enumerable

  attr_reader :children

  def initialize(name)
    super(name)
    @children = []
  end

  def add_child(child)
    @children << child
  end

  def get_child(name)
    children.find { |child| child.name == name } || raise("No such file: #{name}")
  end

  def size
    @children.map(&:size).sum
  end

  def dir?
    true
  end

  def each(&block)
    block.call(self)
    children.each do |child|
      if child.dir?
        child.each(&block)
      else
        block.call(child)
      end
    end
  end
end

stack = [ElfDir.new('/')]

File.readlines('day7/input.txt')[1..].each do |line|
  next if line.match(%r{^\$ ls})

  if line.match(%r{^\$ cd \.\.})
    puts "cd .."
    stack.pop
    next
  end

  if (m = line.match(%r{^\$ cd (.+)}))
    puts "cd #{m[1]}"
    stack.push(stack.last.get_child(m[1]))
    next
  end

  if (m = line.match(%r{^dir (.+)}))
    puts "add dir #{m[1]} to #{stack.last.name}"

    stack.last.add_child(ElfDir.new(m[1]))
    next
  end

  if (m = line.match(%r{(\d+) (.+)}))
    puts "add file #{m[2]} to #{stack.last.name}"

    stack.last.add_child(ElfFile.new(m[2], m[1].to_i))
    next
  end
end

root = stack.first

puts "a: ", root.filter(&:dir?).map(&:size).filter { |size| size <= 100_000 }.sum
