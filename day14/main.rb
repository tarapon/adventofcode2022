class Cave
  attr_reader :units

  def initialize(min_x, max_x, min_y, max_y)
    @min_x = min_x
    @max_x = max_x
    @min_y = min_y
    @max_y = max_y
    @drop_x = 500
    @drop_y = 0

    @data = (0..(max_y - min_y)).map { ['.'] * (max_x - min_x + 1) }
    @units = 0
  end

  def add_wall(x1, y1, x2, y2)
    if x1 == x2
      Range.new(*[y1, y2].sort).each { |y| set(x1, y, '#') }
    else
      Range.new(*[x1, x2].sort).each { |x| set(x, y1, '#') }
    end
  end

  def print
    puts @data.map { |row| row.join }.join("\n")
  end

  def drop!
    @cx, @cy = [@drop_x, @drop_y]

    while true
      return false if full?

      moved = false
      moves = [[@cx, @cy + 1], [@cx - 1, @cy + 1], [@cx + 1, @cy + 1]]
      moves.each do |x, y|
        return false if out_of_bounds?(x, y)

        code = get(x, y)

        if code == '.'
          @cx, @cy = [x, y]
          moved = true
          break
        end
      end

      unless moved
        set(@cx, @cy, 'o')
        @units += 1
        return true
      end
    end
  end

  private

  def full?
    get(@drop_x, @drop_y) == 'o'
  end

  def out_of_bounds?(x, y)
    x < @min_x || x > @max_x || y < @min_y || y > @max_y
  end

  def set(x, y, value)
    @data[y - @min_y][x - @min_x] = value
  end

  def get(x, y)
    @data[y - @min_y][x - @min_x]
  end
end

input = File.readlines('day14/input.txt').map do |line|
  line.split(' -> ').map { |s| s.split(',').map(&:to_i) }
end

min_x = input.map { |row| row.min_by { |x, _| x }.first }.min
max_x = input.map { |row| row.max_by { |x, _| x }.first }.max
max_y = input.map { |row| row.max_by { |_, y| y }.last }.max

# ===== part a =====
m = Cave.new(min_x, max_x, 0, max_y)

input.each do |row|
  row.each_cons(2) do |(x1, y1), (x2, y2)|
    m.add_wall(x1, y1, x2, y2)
  end
end

while m.drop!; end

puts "a=", m.units

# ===== part b =====
m = Cave.new(min_x - max_y, max_x + max_y, 0, max_y + 2)
m.add_wall(min_x - max_y, max_y + 2, max_x + max_y, max_y + 2)

input.each do |row|
  row.each_cons(2) do |(x1, y1), (x2, y2)|
    m.add_wall(x1, y1, x2, y2)
  end
end

while m.drop!; end

puts "b=", m.units
