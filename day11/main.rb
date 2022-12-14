class Expr
  attr_reader :old

  def initialize(expr)
    @expr = expr
  end

  def call(val, relief, cap)
    @old = val
    (instance_eval(@expr) / relief.to_f).floor % cap
  end
end

class Monkey
  attr_reader :items, :inspected_count, :divider

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

  def play(monkeys, relief:)
    cap = monkeys.map(&:divider).reduce(:*)

    until @items.empty?
      item = @expr.call(@items.shift, relief, cap)
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

def simulate(n, relief:)
  input = File.read('day11/input.txt').split("\n\n")
  monkeys = input.map { |i| parse(i) }

  n.times do
    monkeys.each { |m| m.play(monkeys, relief: relief) }
  end

  monkeys
end

monkeys = simulate(20, relief: 3)
puts "a=", monkeys.map(&:inspected_count).max(2).reduce(:*)

monkeys = simulate(10000, relief: 1)
puts "b=", monkeys.map(&:inspected_count).max(2).reduce(:*)
