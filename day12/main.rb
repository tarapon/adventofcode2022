class Vertex
  attr_reader :code, :weight, :pos

  def initialize(code, pos)
    @code = code
    @weight = Float::INFINITY
    @visited = false
    @src = false
    @dst = false
    @pos = pos

    if code == 'S'
      @weight = 0
      @code = 'a'
      @src = true
    elsif code == 'E'
      @code = 'z'
      @dst = true
    else
      @code = code
    end
  end

  def src?
    @src
  end

  def dst?
    @dst
  end

  def visit!
    @visited = true
  end

  def visited?
    @visited
  end

  def update_weight(weight)
    @weight = weight if weight < @weight
  end

  def neighbor?(v)
    (pos[0] - v.pos[0]).abs + (pos[1] - v.pos[1]).abs == 1 && v.code.ord <= code.ord + 1
  end

  def to_s
    "#{code}:#{weight}"
  end

  def inspect
    to_s
  end
end

data = File.readlines('day12/input.txt').each_with_index.map do |line, i|
  line.strip.chars.each_with_index.map { |c, j| Vertex.new(c, [i, j]) }
end

until data.flatten.all?(&:visited?)
  cur = data.flatten.filter { |v| !v.visited? }.min_by(&:weight)
  cur.visit!
  neighbors = data.flatten.filter { |v| cur.neighbor?(v) }
  neighbors.each do |v|
    v.update_weight(cur.weight + 1)
  end
end

puts "a=", data.flatten.find(&:dst?).weight
