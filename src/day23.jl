using DataStructures

############################################################################################
# Definition of the map
const Graph = Dict{String,Vector{Tuple{String,Int}}}(
  "A1" => [("A2",1),("E1",2),("F",2)],
  "A2" => [("A1",1)],
  "B1" => [("B2",1),("F",2),("G",2)],
  "B2" => [("B1",1)],
  "C1" => [("C2",1),("G",2),("H",2)],
  "C2" => [("C1",1)],
  "D1" => [("D2",1),("H",2),("I1",2)],
  "D2" => [("D1",1)],
  "E1" => [("E2",1),("F",2),("A1",2)],
  "E2" => [("E1",1)],
  "F"  => [("E1",2),("A1",2),("G",2),("B1",2)],
  "G"  => [("F",2),("B1",2),("H",2),("C1",2)],
  "H"  => [("G",2),("C1",2),("I1",2),("D1",2)],
  "I1" => [("I2",1),("H",2),("D1",2)],
  "I2" => [("I1",1)]
)

const Rooms = Set(["A1","A2","B1","B2","C1","C2","D1","D2"])
const Hall  = Set(["E1","E2","F","G","H","I1","I2"])

isRoom(pos::String) :: Bool = in(pos,Rooms)
isHall(pos::String) :: Bool = in(pos,Hall)
getPair(pos::String) :: String = (isRoom(pos)) ? (return string(pos[1],(pos[2] == '1' ? '2' : '1'))) : (return "")

newVisited() = Dict{String,Bool}(
  "A1" => false,
  "A2" => false,
  "B1" => false,
  "B2" => false,
  "C1" => false,
  "C2" => false,
  "D1" => false,
  "D2" => false,
  "E1" => false,
  "E2" => false,
  "F"  => false,
  "G"  => false,
  "H"  => false,
  "I1" => false,
  "I2" => false
)

############################################################################################
# Definition of the different classes
abstract type Amphipod end
struct Amber  <: Amphipod end
struct Bronze <: Amphipod end
struct Copper <: Amphipod end
struct Desert <: Amphipod end

const amphType         = [Amber,Amber,Bronze,Bronze,Copper,Copper,Desert,Desert]
const initialPositions = ["A1" ,"B2" ,"C1"  ,"D2"  ,"B1"  ,"D1"  ,"A2"  ,"C2"]

isHappy(pos::String, ::Type{Amber})  = (pos == "A1") || (pos == "A2")
isHappy(pos::String, ::Type{Bronze}) = (pos == "B1") || (pos == "B2")
isHappy(pos::String, ::Type{Copper}) = (pos == "C1") || (pos == "C2")
isHappy(pos::String, ::Type{Desert}) = (pos == "D1") || (pos == "D2")
isHappy(pos::String, ::Type{T}) where {T<:Amphipod} = isHappy(pos,T)
isHappy(pos::String, id::Int) = isHappy(pos,amphType[id])

mvCost(::Type{Amber }) = 1
mvCost(::Type{Bronze}) = 10
mvCost(::Type{Copper}) = 100
mvCost(::Type{Desert}) = 1000
mvCost(id::Int) = mvCost(amphType[id])

############################################################################################
# Definition of a certain graph configuration
mutable struct State
  score  :: Int
  energy :: Int
  pos    :: Vector{String}
end

function score(s::State) :: Int
  res = s.energy # Base score

  for id in 1:length(s.pos)
    if isHappy(s.pos[id],id)
      # Bonus for amphs in the correct room, with correct nbors
      nbor = findfirst(x->x==getPair(s.pos[id]),s.pos)
      if (nbor === nothing)
        (s.pos[id][2] == '2') ? (res -=10000) : res += 100000
      else
        (isHappy(getPair(s.pos[id]),nbor)) && (res -= 10000)
      end
    end
  end
  return res
end

function isLegal(id::Int, origin::String, dest::String, occupied::Vector{String})
  # Room -> Hall :: Always allowed
  (isRoom(origin) && isHall(dest)) && (return true) 
  
  # Hall/Room -> Room :: Only allowed if it is destination room && contains same type
  if isRoom(dest) && isHappy(dest,id) 
    nbor = findfirst(x->x==getPair(dest),occupied)
    ((nbor === nothing) || (isHappy(getPair(dest),nbor))) && (return true)
  end

  # All other cases forbidden
  return false
end

function exploreGraph(pos::String, occupied::Vector{String})
  moves :: Vector{Tuple{String,Int}} = []
  visited = newVisited()
  q = Queue{Tuple{String,Int}}()
  enqueue!(q,(pos,0))

  while !isempty(q)
    p = dequeue!(q)
    if !visited[p[1]]
      visited[p[1]] = true
      (p[1] !== pos) && push!(moves,p)
        
      map(x -> (!visited[x[1]] && !in(x[1],occupied)) && enqueue!(q,(x[1],x[2]+p[2])), Graph[p[1]])
    end
  end

  return moves
end

function getMoves(s::State) :: Array{Tuple{Int,String,Int}}
  moves :: Array{Tuple{Int,String,Int}} = []
  for id in 1:length(s.pos)
    idMoves = exploreGraph(s.pos[id],s.pos)

    map(move -> isLegal(id,s.pos[id],move[1],s.pos) && push!(moves,(id,move[1],move[2])), idMoves)
  end
  return moves
end

function applyMove(s::State, move::Tuple{Int,String,Int}) :: State 
  res = deepcopy(s)
  res.pos[move[1]] = move[2]
  res.energy += move[3]*mvCost(move[1])
  res.score = score(res)
  return res
end

function getStates(s::State) :: Array{State}
  return map(move -> applyMove(s,move), getMoves(s))
end

function isSolution(s::State) :: Bool
  return all(map(id -> isHappy(s.pos[id],id), 1:length(s.pos)))
end

function minimalMoves()
  states = PriorityQueue{State,Int}(State(0,0,initialPositions)=>0)
  visited :: Vector{Vector{String}} = []
  n = 0
  while !isempty(states) && n < 100
    state, score =  dequeue_pair!(states)
    display(state)
    n += 1
    if in(state.pos, visited) 
      push!(visited,state.pos)
    else
      isSolution(state) && (return state)
      map(s -> enqueue!(states,s=>s.score), getStates(state))
    end
  end
end

state = minimalMoves()
display(state)


