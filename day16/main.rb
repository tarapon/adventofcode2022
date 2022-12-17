require 'set'

class Vertex
  attr_reader :rate, :siblings

  def initialize(weight, siblings)
    @rate = weight
    @siblings = siblings
  end
end

GRAPH = File.readlines('day16/input.txt').map do |line|
  matches = line.match(/Valve (.*) has flow rate=(\d+); tunnels? leads? to valves? (.*)/)
  [matches[1], Vertex.new(matches[2].to_i, matches[3].split(', '))]
end.to_h

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

  visited.reject! { |_, v| v == 0 }
  visited
end

def score(vertexes)
  vertexes.values.sum(&:rate)
end

def visit_score(passes, idx, time_left, visited = {})
  scores = passes[idx].map do |ss, length|
    if visited[ss] || length > time_left
      time_left * score(visited)
    else
      t = length + 1
      t * score(visited) + visit_score(passes, ss, time_left - t, visited.dup.merge(ss => GRAPH[ss]))
    end
  end

  scores.max
end

all_passes = GRAPH.keys.map { |k| [k, compute_passes(k)] }.to_h

visited = GRAPH.filter { |_, v| v.rate == 0 }
puts "a=", visit_score(all_passes, 'AA', 30, visited)
