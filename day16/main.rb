require 'set'

class Vertex
  attr_reader :rate, :siblings

  def initialize(weight, siblings)
    @rate = weight
    @siblings = siblings
  end
end

class Solution
  attr_reader :score, :path
  def initialize(score, path)
    @score = score
    @path = path
  end

  def +(other)
    Solution.new(@score + other.score, path | other.path)
  end
end

GRAPH = File.readlines('day16/input.txt').map do |line|
  matches = line.match(/Valve (.*) has flow rate=(\d+); tunnels? leads? to valves? (.*)/)
  [matches[1], Vertex.new(matches[2].to_i, matches[3].split(', '))]
end.to_h

BIT_MASK = GRAPH.select { |_, v| v.rate > 0 }.keys.sort.each_with_index.map { |key, i| [key, 1 << i] }.to_h

def compute_passes(idx)
  visited = { idx => 0 }
  stack = [idx]

  until stack.empty?
    idx = stack.shift

    GRAPH[idx].siblings.each do |ss|
      if visited[ss].nil?
        visited[ss] = visited[idx] + 1
        stack << ss
      end
    end
  end

  visited.reject! { |k, v| v == 0 || GRAPH[k].rate == 0 }
  visited
end

def visit_score(passes, idx, time_left, visited = {})
  solutions = passes[idx].map do |ss, length|
    t = length + 1

    if visited[ss] || t >= time_left
      Solution.new(0, 0)
    else
      visit_score(passes, ss, time_left - t, visited.dup.merge(ss => true))
    end
  end

  solutions.flatten.map { |s| s + Solution.new(time_left * GRAPH[idx].rate, BIT_MASK[idx] || 0) }
end

def best_score(solutions)
  solutions.max_by(&:score).score
end

all_passes = GRAPH.keys.map { |k| [k, compute_passes(k)] }.to_h

solutions = visit_score(all_passes, 'AA', 30)

puts "a=", best_score(solutions)

solutions = visit_score(all_passes, 'AA', 26).sort {|a, b| b.score <=> a.score }

puts solutions.size

scores = solutions.each_with_index.map do |sa, i|
  sa.score + (solutions.find { |sb| sa.path & sb.path == 0 }&.score || 0)
end

puts "b=", scores.max


