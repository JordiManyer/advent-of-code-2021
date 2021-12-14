using DelimitedFiles


additiveFactorial(n::Int) :: Int = sum(1:n)

distance(pos1::Int, pos2::Int) :: Int = abs(pos1-pos2)

# Cost of a distance for problem 1
cost(t::Int,positions::Vector{Int}) :: Int = sum(map(p -> distance(t,p), positions))

# Cost of a distance for problem 2
function cost2(t::Int,positions::Vector{Int}) :: Int 
  distances = map(p -> distance(t,p), positions)
  return sum( map( d -> additiveFactorial(d) , distances))
end

# Calculates least-cost alignment for problem 1.
function minimalAlignment(positions::Vector{Int}) :: Tuple{Int,Int}
  targets = Vector(0:maximum(positions))
  costs = map(t -> cost(t,positions), targets)
  i_best = argmin(costs)
  return (i_best, costs[i_best])
end

# Calculates least-cost alignment for problem 2
function minimalAlignment2(positions::Vector{Int}) :: Tuple{Int,Int}
  targets = Vector(0:maximum(positions))
  costs = map(t -> cost2(t,positions), targets)
  i_best = argmin(costs)
  return (i_best, costs[i_best])
end

# Read input
function readInput() :: Vector{Int}
  data = readdlm("./inputs/day7.txt", ',', Int)
  return reshape(data,length(data))
end

println("Problem 1: ")
positions = readInput()
res = minimalAlignment(positions)
display(res)


println("Problem 2: ")
positions = readInput()
res = minimalAlignment2(positions)
display(res)