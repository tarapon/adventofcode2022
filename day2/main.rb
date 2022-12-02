class Game
  def initialize
    @player1 = 0
    @player2 = 0
  end

  def play(move_1, move_2)
    move_1 = to_move(move_1)
    move_2 = to_move(move_2)

    points = play_round(move_1, move_2)
    @player1 += move_score(move_1) + points[0]
    @player2 += move_score(move_2) + points[1]
  end

  def score
    [@player1, @player2]
  end

  private

  def to_move(code)
    case code
    when "A", "X" # rock
      'rock'
    when "B", "Y" # paper
      'paper'
    when "C", "Z" # scissors
      'scissors'
    else
      raise "Invalid move"
    end
  end

  def move_score(move)
    case move
    when "rock"
      1
    when "paper"
      2
    when "scissors"
      3
    end
  end

  def play_round(move_1, move_2)
    return [3, 3] if move_1 == move_2

    return [6, 0] if move_1 == "rock" && move_2 == "scissors"
    return [6, 0] if move_1 == "scissors" && move_2 == "paper"
    return [6, 0] if move_1 == "paper" && move_2 == "rock"

    [0, 6]
  end
end

g = Game.new

File.readlines('day2/input.txt').map do |line|
  move_a, move_b = line.split(' ')
  g.play(move_a, move_b)
end

puts g.score.inspect
