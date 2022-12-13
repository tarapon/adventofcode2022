class Snake
  attr_reader :trail

  def initialize(size)
    @snake = (size + 1).times.map { [0, 0] }
    @trail = [tail.dup]
  end

  def head
    @snake.first
  end

  def tail
    @snake.last
  end

  def move(dir, steps)
    steps.times do
      case dir
      when 'U'
        head[1] += 1
      when 'D'
        head[1] -= 1
      when 'L'
        head[0] -= 1
      when 'R'
        head[0] += 1
      end

      pull_up_all
    end
  end

  private

  def pull_up_all
    @snake.each_cons(2) do |a, b|
      break if touching?(b, a)
      pull_up(b, a)
    end

    trail << tail.dup unless tail == trail.last
  end

  def touching?(a, b)
    (b[0] - a[0]).abs <= 1 && (b[1] - a[1]).abs <= 1
  end

  def pull_up(a, b)
    a[0] += (b[0] <=> a[0])
    a[1] += (b[1] <=> a[1])
  end
end

def simulate(n)
  s = Snake.new(n)

  File.readlines('day9/input.txt').each do |line|
    dir, steps = line.split(' ')
    s.move(dir, steps.to_i)
  end

  s.trail
end

puts "a: ", simulate(1).uniq.size
puts "b: ", simulate(9).uniq.size

