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

  visited.reject! { |k, v| v == 0 || GRAPH[k].rate == 0 }
  visited
end

def generate_permutations(set)
  ((set.size / 2.0).ceil...set.size).inject([]) do |acc, i|
    acc + set.permutation(i).to_a
  end
end

def visit_score(passes, idx, time_left, visited = {})
  scores = passes[idx].map do |ss, length|
    t = length + 1

    if visited[ss] || t >= time_left
      0
    else
      visit_score(passes, ss, time_left - t, visited.dup.merge(ss => true))
    end
  end

  scores.max + time_left * GRAPH[idx].rate
end

all_passes = GRAPH.keys.map { |k| [k, compute_passes(k)] }.to_h

puts "a=", visit_score(all_passes, 'AA', 30)

valuable_vx = all_passes['AA'].keys

scores = generate_permutations(valuable_vx).map do |a|
  work_a = (valuable_vx - a).map { |k| [k, true] }.to_h
  work_b = (a).map { |k| [k, true] }.to_h

  visit_score(all_passes, 'AA', 26, work_b) + visit_score(all_passes, 'AA', 26, work_a)
end

puts "b=", scores.max


