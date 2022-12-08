class Matrix
  include Enumerable
  attr_reader :n, :m

  def initialize(src)
    @matrix = src
    @n = src[0].size
    @m = src.size
  end

  def each(&block)
    @matrix.each(&block)
  end

  def rows
    @matrix
  end

  def columns
    @matrix.transpose
  end

  def row(i)
    @matrix[i]
  end

  def column(j)
    @matrix.map { |row| row[j] }
  end

  def transpose
    Matrix.new(@matrix.transpose)
  end

  def + (m)
    Matrix.new((0...n).map { |i| row(i).zip(m.row(i)).map { |a,b| a + b } })
  end

  def * (m)
    Matrix.new((0...n).map { |i| row(i).zip(m.row(i)).map { |a,b| a * b } })
  end

  def to_s
    @matrix.inspect
  end

  def inspect
    to_s
  end
end

forest = File.readlines('day8/input.txt').map do |line|
  line.strip.chars.map(&:to_i)
end

def weights_a(row)
  max = -1
  row.map do |x|
    if x > max
      max = x
      1
    else
      0
    end
  end
end

def weights_b(row)
  row.each_with_index.map do |x, i|
    i - (row[...i].rindex { |y| y >= x } || 0)
  end
end

m = Matrix.new(forest)

def compute(m, row_fn, agg_fn)
  a = Matrix.new( m.rows.map { |r| row_fn.call(r) } )
  b = Matrix.new( m.rows.map { |r| row_fn.call(r.reverse).reverse } )
  c = Matrix.new( m.columns.map { |r| row_fn.call(r) } ).transpose
  d = Matrix.new( m.columns.map { |r| row_fn.call(r.reverse).reverse } ).transpose

  [a, b, c, d].reduce(&agg_fn)
end

puts "a=", compute(m, method(:weights_a), :+).rows.map { |r| r.count { |e| e > 0 } }.sum

puts "b=", compute(m, method(:weights_b), :*).rows.map { |r| r.max }.max
