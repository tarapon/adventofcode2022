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

puts [3] == 3

pairs = File.read('day13/input.txt').split("\n\n").map do |pair|
  a, b = pair.split("\n")
  [eval(a), eval(b)]
end

puts "a=", pairs.each_with_index.map { |(a, b), i| i + 1 if a <= b }.compact.sum
