
"""
Problem 1: 

Given a path given by an input array of commands (direction + integer), 
compute the final position relative to the start.

Problem 2: 
Same, but changing slightly the rules.

"""

using DelimitedFiles

# Read input
function readInput() :: Array{Tuple{String,Int}}
  data = readdlm("./inputs/day2.txt", ' ', String)
  data = map(x -> (x[1],parse(Int,x[2])), data[i,:] for i in 1:size(data)[1] )
  return data
end


function toIndex(s::String)
  if s == "up"
    return CartesianIndex(0,-1)
  elseif s == "down"
    return CartesianIndex(0,1)
  elseif s == "forward"
    return CartesianIndex(1,0)
  else 
    return CartesianIndex(-1,0)
  end
end

function followPath(path:: Array{Tuple{String,Int}}) :: CartesianIndex{2}
  pos = CartesianIndex(0,0)
  for step in path
    pos += step[2] * toIndex(step[1])
  end
  return pos
end

function followPath2(path:: Array{Tuple{String,Int}}) :: CartesianIndex{2}
  aim = 0
  pos = CartesianIndex(0,0)
  for step in path
    dir = toIndex(step[1])
    aim += step[2] * dir[2]
    pos += CartesianIndex(step[2] * dir[1] ,aim * step[2] * dir[1])
  end
  return pos
end


path = readInput()

pos = followPath(path)
println("Problem 1:")
println(pos[1]*pos[2])

pos = followPath2(path)
println("Problem 2:")
println(pos[1]*pos[2])
