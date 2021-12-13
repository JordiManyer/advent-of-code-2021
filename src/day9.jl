using DataStructures


function getNbors(M::Matrix{Int}, pos::CartesianIndex{2}) :: Vector{CartesianIndex{2}}
  s = size(M)
  nbors :: Vector{CartesianIndex{2}} = []
  (pos[1] != 1   ) && push!(nbors, pos + CartesianIndex(-1,0)) 
  (pos[1] != s[1]) && push!(nbors, pos + CartesianIndex(1,0))  
  (pos[2] != 1   ) && push!(nbors, pos + CartesianIndex(0,-1)) 
  (pos[2] != s[2]) && push!(nbors, pos + CartesianIndex(0,1))  
  return nbors
end


function lowPts(M::Matrix{Int}) :: Vector{CartesianIndex{2}}
  s = size(M)
  lpts :: Vector{CartesianIndex{2}} = []
  for i in 1:s[1]
    for j in 1:s[2]
      pos = CartesianIndex(i,j)
      nbors = getNbors(M,pos)
      (all(map( n -> M[n] > M[pos], nbors))) && push!(lpts,pos)
    end
  end
  return lpts
end

riskLevel(M::Matrix{Int}, pos::CartesianIndex{2}) :: Int = M[pos] + 1

riskLevel(M::Matrix{Int}, pos::Vector{CartesianIndex{2}}) :: Int = sum(map(p -> riskLevel(M,p), pos))


function basins(M::Matrix{Int}, lpts::Vector{CartesianIndex{2}}) :: Vector{Int}
  visited :: Matrix{Int} = -ones(size(M))

  nBasin = 1
  sizes :: Vector{Int} = []
  for p in lpts
    if visited[p] == -1 # If new bassin
      append!(sizes,0)
      q :: Queue{CartesianIndex{2}} = Queue{CartesianIndex{2}}()
      enqueue!(q,p)
      while !isempty(q)
        next = dequeue!(q)
        if visited[next] == -1 && M[next] != 9
          visited[next] = nBasin
          sizes[nBasin] += 1
          map(n -> enqueue!(q,n), getNbors(M,next))
        end
      end
      nBasin += 1
    end
  end

  return sort(sizes,rev=true)
end


function readInput() :: Matrix{Int}
  f = open("./inputs/day9.txt")
  data :: Matrix{Int} = zeros(100,100)

  i = 1
  for line in eachline(f)
    data[i,:] = map(x -> parse(Int,x), collect(line))
    i += 1
  end
  return data
end



M = readInput()

println("Problem 1: ")
lpts = lowPts(M)
res = riskLevel(M,lpts)
println(res)

sizes = basins(M,lpts)
println("Problem 2: ")
println(sizes)
println(sizes[1]*sizes[2]*sizes[3])