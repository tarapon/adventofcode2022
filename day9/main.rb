class Snake
  attr_reader :head, :tail
  attr_reader :trail

  def initialize
    @head = [0, 0]
    @tail = [0, 0]
    @trail = [@tail.dup]
  end

  def move(dir, steps)
    case dir
    when 'U'
      head[1] += steps
    when 'D'
      head[1] -= steps
    when 'L'
      head[0] -= steps
    when 'R'
      head[0] += steps
    end

    pull_up until touching?
  end

  private

  def touching?
    (head[0] - tail[0]).abs <= 1 && (head[1] - tail[1]).abs <= 1
  end

  def pull_up
    tail[0] += (head[0] <=> tail[0])
    tail[1] += (head[1] <=> tail[1])

    trail << tail.dup
  end
end

s = Snake.new

File.readlines('day9/input.txt').each do |line|
  dir, steps = line.split(' ')
  s.move(dir, steps.to_i)
end

puts "a: ", s.trail.uniq.size

