
mutable struct Cuboid
  x :: Tuple{Int,Int}
  y :: Tuple{Int,Int}
  z :: Tuple{Int,Int}
end

mutable struct Instruction
  state  :: Bool
  cuboid :: Cuboid
end

function apply(I::Instruction, M::Array{Bool,3})
  M[I.x[1]:I.x[2],I.y[1]:I.y[2],I.z[1]:I.z[2]] = I.state
end

function parseCuboid(s::String) :: Cuboid
  return Cuboid(map(y -> (parse(Int,y[1]),parse(Int,y[2])), map(x->split(x[3:end],".."),split(s,',')))...)
end

function parseLine(line::String) :: Instruction
  parts = split(line, ' ')
  state  :: Bool    = (parts[1] == "on" ? true : false)
  cuboid :: Cuboid = parseCuboid(String(parts[2]))
  return Instruction(state,cuboid)
end

function readInput() :: Vector{Instruction}
  f = open("inputs/day22.txt")
  data = map(line -> parseLine(line), eachline(f))
  return data
end


data = readInput()

