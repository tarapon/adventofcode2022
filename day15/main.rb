require 'set'

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def +(other)
    ([first, other.first].min..[last, other.last].max)
  end

  def split(x)
    return [(x+1..last)] if x == first
    return [(first..x-1)] if x == last
    [(first..x - 1), (x + 1..last)]
  end
end

class Space
  def initialize
    @ranges = []
  end

  def add(range)
    overlaps = @ranges.filter { |r| r.overlaps?(range) }
    @ranges.reject! { |r| r.overlaps?(range) }

    overlaps = overlaps.reduce(range) { |r, o| r + o }
    @ranges += [overlaps]
  end

  def include?(x)
    @ranges.any? { |r| r.include?(x.first) && r.include?(x.last) }
  end

  def exclude(x)
    @ranges.each_with_index do |r, i|
      if r.include?(x)
        @ranges.delete_at(i)
        @ranges += r.split(x)
        break
      end
    end
  end

  def invert
    Space.new.tap do |s|
      @ranges.sort { |a, b| a.last <=> b.first }.each_cons(2) do |a, b|
        s.add((a.last + 1)..(b.first - 1))
      end
    end
  end

  def min
    @ranges.map(&:first).min
  end

  def max
    @ranges.map(&:last).max
  end

  def size
    @ranges.sum(&:size)
  end
end

sensors = File.readlines('day15/input.txt').map do |line|
  matches = line.match(/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/)
  matches[1..4].map(&:to_i)
end

def coverage(sensors, row_y)
  space = Space.new

  sensors.each do |x, y, bx, by|
    r = (bx - x).abs + (by - y).abs
    dx = r - (y - row_y).abs
    space.add((x - dx)..(x + dx)) if dx >= 0
  end

  space
end

def positions_without_sensors(sensors, row_y)
  space = coverage(sensors, row_y)
  known_x = sensors.map { |x, y, bx, by| bx if by == row_y }.compact.uniq
  known_x.each { |x| space.exclude(x) }
  space.size
end

def find_distract_beacon(sensors, min, max)
  range = (min..max)

  (min..max).each do |row_y|
    s = coverage(sensors, row_y)
    unless s.include?(range)
      return [s.invert.min, row_y]
    end
  end

  nil
end

def frequency(x, y)
  x * 4_000_000 + y
end



puts "a=", positions_without_sensors(sensors, 2000000)

s = find_distract_beacon(sensors, 0, 4000000)
puts "b=", frequency(*s)
