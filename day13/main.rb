class Array
  include Comparable

  def ==(other)
    (self <=> other) == 0
  end

  def <=>(other)
    return self <=> [other] if other.is_a?(Numeric)

    (0...[self.size, other.size].min).each do |i|
      return self[i] <=> other[i] if self[i] != other[i]
    end

    self.size <=> other.size
  end
end

class Integer
  [:<=>, :<, :<=, :>, :>=, :==].each do |method|
    alias_method "orig_#{method}".to_sym, method

    define_method(method) do |other|
      return [self].send(method, other) if other.is_a?(Array)
      send("orig_#{method}".to_sym, other)
    end
  end
end

packets = File.read('day13/input.txt').split(/\n+/).map { |exp| eval(exp) }

pairs = packets.each_slice(2).to_a
puts "a=", pairs.each_with_index.map { |(a, b), i| i + 1 if a <= b }.compact.sum

DIVIDER_1 = [[2]]
DIVIDER_2 = [[6]]

packets << DIVIDER_1
packets << DIVIDER_2
packets.sort!

puts "b=", (packets.index(DIVIDER_1) + 1) * (packets.index(DIVIDER_2) + 1)
