using DelimitedFiles

# Lanternfish pack structure
mutable struct Lanternfish
  days:: Int
  n :: Int
  groups :: Vector{Int}
end

function Lanternfish(fish::Vector{Int})
  n = 0
  groups = zeros(Int, 9)
  map(x -> groups[x+1] += 1 , fish)
  n = sum(groups)
  return Lanternfish(0,n,groups)
end

# One-day reproduction cycle. 
function nextDay!(lf::Lanternfish)
  permute!(lf.groups,[2,3,4,5,6,7,8,9,1])
  lf.groups[7] += lf.groups[9]
  lf.n += lf.groups[9]
  lf.days += 1
end

# Advance reproduction cycle several days.
function nextDays!(lf::Lanternfish,nDays::Int) 
  for i in 1:nDays
    nextDay!(lf)
  end
end

# Read input
function readInput() :: Vector{Int}
  data = readdlm("./inputs/day6.txt", ',', Int)
  return reshape(data,length(data))
end

println("Problem 1: ")
fish = readInput()
lf = Lanternfish(fish)
nextDays!(lf,80)
println("Number of days: ", lf.days)
println("Number of fish: ", lf.n)
println("Final state: ", lf.groups)


println("Problem 2: ")
fish = readInput()
lf = Lanternfish(fish)
nextDays!(lf,256)
println("Number of days: ", lf.days)
println("Number of fish: ", lf.n)
println("Final state: ", lf.groups)