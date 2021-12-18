

function getNbors(M::Matrix{Int}, pos::CartesianIndex{2}) :: Vector{CartesianIndex{2}}
  s = size(M)
  nbors :: Vector{CartesianIndex{2}} = []
  (pos[1] != 1   ) && push!(nbors, pos + CartesianIndex(-1,0)) 
  (pos[1] != s[1]) && push!(nbors, pos + CartesianIndex(1,0))  
  (pos[2] != 1   ) && push!(nbors, pos + CartesianIndex(0,-1)) 
  (pos[2] != s[2]) && push!(nbors, pos + CartesianIndex(0,1))  
  (pos[1] != 1   ) && (pos[2] != 1   ) && push!(nbors, pos + CartesianIndex(-1,-1)) 
  (pos[1] != 1   ) && (pos[2] != s[2]) && push!(nbors, pos + CartesianIndex(-1, 1)) 
  (pos[1] != s[1]) && (pos[2] != 1   ) && push!(nbors, pos + CartesianIndex( 1,-1)) 
  (pos[1] != s[1]) && (pos[2] != s[2]) && push!(nbors, pos + CartesianIndex( 1, 1)) 
  return nbors
end

# Performs a flash cycle, returns total number of flashes. 
function step!(M::Matrix{Int}) :: Int
  flashed :: Matrix{Bool} = zeros(size(M))

  # A) Everyone increases energy by 1
  M .+= 1

  # B) Octopuses flash
  charged = findall((M .> 9) .& .!flashed)
  while !isempty(charged)
    # Flash
    map(pos -> M[getNbors(M, pos)] .+= 1, charged)
    flashed[charged] .= true

    # Reset
    charged = findall((M .> 9) .& .!flashed)
  end

  # C) All octopuses that have flashed go back to 0
  M[flashed] .= 0
  return count(flashed)
end


function readInput() :: Matrix{Int}
  f = open("./inputs/day11.txt")
  data :: Matrix{Int} = zeros(10,10)

  i = 1
  for line in eachline(f)
    data[i,:] = map(x -> parse(Int,x), collect(line))
    i += 1
  end
  return data
end


problem1!(M::Matrix{Int}) = sum(map(i -> step!(M), 1:100))

function problem2!(M::Matrix{Int}) :: Int
  i :: Int = 1
  while step!(M) != 100
    i += 1
  end 
  return i
end

println("Problem 1:")
M = readInput()
println(problem1!(M))


println("Problem 2:")
M = readInput()
println(problem2!(M))

