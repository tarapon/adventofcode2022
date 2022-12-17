require 'set'

beacons = File.readlines('day15/input.txt').map do |line|
  matches = line.match(/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/)
  matches[1..4].map(&:to_i)
end

def coverage(beacons, row_y)
  ranges = beacons.map do |x, y, bx, by|
    r = (bx - x).abs + (by - y).abs
    dx = r - (y - row_y).abs
    Set.new((x - dx)..(x + dx)) - [row_y == by ? bx : nil] if dx >= 0
  end

  ranges.compact.inject(&:+).size
end

puts coverage(beacons, 2000000).inspect
