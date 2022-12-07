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

stack = File.readlines('day7/input.txt').inject([]) do |stack, line|
  case line.strip.split(' ')
  in ['$', 'ls']
    stack
  in ['$', 'cd', '/']
    stack << ElfDir.new('/')
  in ['$', 'cd', '..']
    stack.pop
  in ['$', 'cd', dir]
    stack << stack.last.get_child(dir)
  in ['dir', name]
    stack.last.add_child(ElfDir.new(name))
  in [size, name]
    stack.last.add_child(ElfFile.new(name, size.to_i))
  end

  stack
end

root = stack.first

puts "a: ", root.filter(&:dir?).map(&:size).filter { |size| size <= 100_000 }.sum

space_needed = 30_000_000 - 70_000_000 + root.size

puts "b: ", root.filter { |f| f.dir? && f.size >= space_needed }.min_by(&:size)&.size
