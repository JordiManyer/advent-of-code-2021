

# Graph 
mutable struct Graph
  nN     :: Int
  edges  :: Vector{Vector{Int}}
  big    :: Vector{Bool}
  visits :: Vector{Int}
  tags   :: Dict{String,Int}
  paths  :: Vector{Vector{Int}}
  hasVisitedSmallTwice :: Bool
end

Graph() = Graph(0, [], [], [], Dict{String,Int}(), [], false)

# Adds a new node to the Graph
function addNode!(G::Graph, n::String) :: Int
  haskey(G.tags,n) && return G.tags[n]
  G.nN += 1
  push!(G.edges,[])
  islowercase(n[1]) ? push!(G.big,false) : push!(G.big,true)
  push!(G.visits,0)
  G.tags[n] = G.nN
  return G.tags[n]
end

# Adds a new edge to the Graph
function addEdge!(G::Graph, v::Tuple{String,String})
  idx1 = haskey(G.tags,v[1]) ? G.tags[v[1]] : addNode!(G,v[1])
  idx2 = haskey(G.tags,v[2]) ? G.tags[v[2]] : addNode!(G,v[2])
  push!(G.edges[idx1],idx2)
  push!(G.edges[idx2],idx1)
end

# Recursive function that computes the number of paths that go from 'istart' to 'iend'.
function paths!(G::Graph, istart::Int, iend::Int) :: Int
  (istart == iend) && return 1
  G.visits[istart] += 1
  res = 0
  for e in G.edges[istart]
    if G.visits[e] == 0 || G.big[e]
      res += paths!(G,e,iend)
    end
  end
  G.visits[istart] -= 1
  return res
end

paths!(G::Graph, istart::String, iend::String) = paths!(G,G.tags[istart],G.tags[iend])

# Same as paths, modified for problem 2.
function paths2!(G::Graph, istart::Int, iend::Int) :: Int
  (istart == iend) && return 1
  G.visits[istart] += 1
  res = 0
  for e in G.edges[istart]
    if G.visits[e] == 0 || G.big[e]
      res += paths2!(G,e,iend)
    elseif (G.tags["start"] !== e) && (G.visits[e] == 1) && !(G.hasVisitedSmallTwice)
      G.hasVisitedSmallTwice = true
      res += paths2!(G,e,iend)
      G.hasVisitedSmallTwice = false
    end
  end
  G.visits[istart] -= 1
  return res
end

paths2!(G::Graph, istart::String, iend::String) = paths2!(G,G.tags[istart],G.tags[iend])

# Same as paths, but also saves the actual paths in G.paths
function paths_visual!(G::Graph, istart::Int, iend::Int, p::Vector{Int}) :: Int
  if istart == iend
    push!(G.paths,deepcopy(p))
    return 1
  end

  G.visits[istart] += 1
  res = 0
  for e in G.edges[istart]
    if G.visits[e] == 0 || G.big[e]
      res += paths_visual!(G,e,iend,vcat(p,e))
    end
  end
  G.visits[istart] -= 1
  return res
end

paths_visual!(G::Graph, istart::String, iend::String) = paths_visual!(G,G.tags[istart],G.tags[iend],[G.tags[istart]])

# Prints the paths saved in G.paths
function printPaths(G)
  invMap = Dict(value => key for (key, value) in G.tags)
  for p in G.paths
    println(map(x -> invMap[x], p))
  end
end

parseLine(line::String) = tuple(map(s -> String(s),split(line,'-'))...)

function readInput()
  f = open("./inputs/day12.txt")
  G = Graph()

  edges = map( line -> parseLine(line), eachline(f))
  map(e -> addEdge!(G,e), edges)
  return G
end


println("Problem 1: ")
G = readInput()
res = paths!(G,"start","end")
printPaths(G)
println(res)


println("Problem 2: ")
G = readInput()
res = paths2!(G,"start","end")
println(res)
