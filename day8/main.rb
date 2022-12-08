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

def hidden(row)
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

forest = Matrix.new(forest)

a = Matrix.new( forest.rows.map { |r| hidden(r) } )
b = Matrix.new( forest.rows.map { |r| hidden(r.reverse).reverse } )
c = Matrix.new( forest.columns.map { |r| hidden(r) } ).transpose
d = Matrix.new( forest.columns.map { |r| hidden(r.reverse).reverse } ).transpose

puts "a=", (a + b + c + d).rows.map { |r| r.count { |e| e.positive? } }.sum
