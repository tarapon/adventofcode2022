input = File.read('day11/input.txt').split("\n\n")

class Expr
  attr_reader :old

  def initialize(expr)
    @expr = expr
  end

  def call(val)
    @old = val
    (instance_eval(@expr) / 3.0).floor
  end
end

class Monkey
  attr_reader :items, :inspected_count

  def initialize(expr, divider, if_true, if_false)
    @items = []
    @expr = Expr.new(expr)
    @divider = divider
    @if_true = if_true
    @if_false = if_false
    @inspected_count = 0
  end

  def add_item(*items)
    @items.concat(items)
  end

  def play(monkeys)
    until @items.empty?
      item = @expr.call(@items.shift)
      if item % @divider == 0
        monkeys[@if_true].add_item(item)
      else
        monkeys[@if_false].add_item(item)
      end
      @inspected_count += 1
    end
  end

  def to_s
    "<Monkey: #{items.join(', ')}>"
  end
end

def parse(input)
  res = input.match(%r{Monkey (\d+):\n\s+Starting items: (.*)\n\s+Operation: (.*)\n\s+Test: divisible by (\d+)\n\s+If true: throw to monkey (\d+)\n\s+If false: throw to monkey (\d+)}).captures
  _, items, expr, divider, if_true, if_false = res

  Monkey.new(expr, divider.to_i, if_true.to_i, if_false.to_i).tap do |monkey|
    monkey.add_item(*items.split(', ').map(&:to_i))
  end
end

monkeys = input.map { |i| parse(i) }

20.times do
  monkeys.each { |m| m.play(monkeys) }
end

puts "a=", monkeys.map(&:inspected_count).max(2).reduce(:*)
