class Vertex
  attr_reader :code, :weight, :pos

  def initialize(code, pos)
    @code = code
    @weight = Float::INFINITY
    @src = false
    @dst = false
    @pos = pos

    if code == 'S'
      @code = 'a'
      @src = true
    elsif code == 'E'
      @weight = 0
      @code = 'z'
      @dst = true
    end
  end

  def src?
    @src
  end

  def bottom?
    code == 'a'
  end

  def dst?
    @dst
  end

  def update_weight(weight)
    @weight = weight if weight < @weight
  end

  def neighbor?(v)
    (pos[0] - v.pos[0]).abs + (pos[1] - v.pos[1]).abs == 1 && (v.code.ord >= code.ord - 1)
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

vertexes = data.flatten
unvisited = vertexes.dup

until unvisited.empty?
  cur = unvisited.min_by(&:weight)
  unvisited.delete(cur)

  neighbors = vertexes.filter { |v| cur.neighbor?(v) }
  neighbors.each do |v|
    v.update_weight(cur.weight + 1)
  end
end

puts "a=", vertexes.find(&:src?).weight
puts "b=", vertexes.filter(&:bottom?).min_by(&:weight).weight
