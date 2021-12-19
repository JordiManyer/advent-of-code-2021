using DataStructures

function getNbors(M::Matrix{Int}, pos::CartesianIndex{2}, expand::Int) :: Vector{CartesianIndex{2}}
  s = size(M) .* expand
  nbors :: Vector{CartesianIndex{2}} = []
  (pos[1] != 1   ) && push!(nbors, pos + CartesianIndex(-1,0)) 
  (pos[1] != s[1]) && push!(nbors, pos + CartesianIndex(1,0))  
  (pos[2] != 1   ) && push!(nbors, pos + CartesianIndex(0,-1)) 
  (pos[2] != s[2]) && push!(nbors, pos + CartesianIndex(0,1))  
  return nbors
end

getNbors(M::Matrix{Int}, pos::CartesianIndex{2}) = getNbors(M,pos,1)

function getWeights(M::Matrix{Int}, pos::CartesianIndex{2}) :: Int
  s = size(M)
  return ((M[(pos[1]-1)%s[1]+1, (pos[2]-1)%s[2]+1] 
          + ((pos[1]-1)÷s[1]) + ((pos[2]-1)÷s[2])) - 1) % 9 +1
end

# Checks if neighbor belongs in the queue: 
#  - If neighbor has not been visited, adds it to the queue
#  - If neighbor has been visited but with bigger weight, checks if it is still in the queue
#    and either adds it (if not present) or updates weight (if present). 
function addNbor!(q::PriorityQueue{CartesianIndex{2},Int}, n::CartesianIndex{2}, w::Int, W::Matrix{Int})
  (W[n] > w) && begin (W[n] = w) ; (in(n,keys(q)) ? q[n] = w : enqueue!(q,n,w)) end
end

# Dijkstra-based algorithm to find the path with less risk.
function bestPath(M::Matrix{Int}, pstart::CartesianIndex, pend::CartesianIndex, expand::Int) :: Int
  W :: Matrix{Int} = 5*sum(M)*ones(size(M) .* expand) # Weight matrix
  q = PriorityQueue{CartesianIndex{2}, Int}()
  enqueue!(q, pstart, 0)
  W[pstart] = 0
  
  while !isempty(q) 
    # Retrieve next position
    pos, weight = dequeue_pair!(q)

    # Have we arrived? 
    pos == pend && return weight

    # Otherwise, enqueue new path options
    nbors = getNbors(M,pos,expand)
    map(n -> addNbor!(q,n,weight+getWeights(M,n),W), nbors)
  end
  return -1
end

function readInput() :: Matrix{Int}
  f = open("./inputs/day15.txt")
  data :: Matrix{Int} = zeros(100,100)

  i = 1
  for line in eachline(f)
    data[i,:] = map(x -> parse(Int,x), collect(line))
    i += 1
  end
  return data
end


M = readInput()

expand = 5
res = bestPath(M, CartesianIndex(1,1), CartesianIndex(100*expand,100*expand), expand)
println(res)
