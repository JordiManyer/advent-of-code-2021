

const Instruction = Tuple{Char,Int}


function vfold(M::Matrix{Bool}, x::Int) :: Matrix{Bool}
  sY = size(M)[2]
  for i in 1:min(x-1,sY-x)
    M[:,x-i] = M[:,x-i] .| M[:,x+i] 
  end
  return deepcopy(M[:,1:x-1])
end

function hfold(M::Matrix{Bool}, y::Int) :: Matrix{Bool}
  sX = size(M)[1]
  for i in 1:min(y-1,sX-y)
    M[y-i,:] = M[y-i,:] .| M[y+i,:]
  end 
  return deepcopy(M[1:y-1,:])
end

fold(M::Matrix{Bool}, I::Instruction) = (I[1]=='x') ? vfold(M,I[2]) : hfold(M,I[2])


parseDot(line::String) = CartesianIndex(map(s->parse(Int,s),split(line,','))...)

function parseInstruction(line::String) :: Instruction
  s = split(line,' ')[3]
  return (first(s), parse(Int,s[3:end]))
end

function parseLine(line::String) 
  if isempty(line)
    return 
  elseif first(line) == 'f'
    parseInstruction(line) 
  else
    parseDot(line)
  end
end

function matrix(dots::Vector{CartesianIndex{2}}) :: Matrix{Bool}
  sX = maximum(map(x->x[1],dots))+1
  sY = maximum(map(x->x[2],dots))+1
  M :: Matrix{Bool} = zeros(sX,sY)
  map(x->M[x] = true, dots)
  return deepcopy(M)
end


function readInput()
  f = open("./inputs/day13.txt")

  data = map( line -> parseLine(line), eachline(f))
  dots::Vector{CartesianIndex{2}} = filter(x->typeof(x) == CartesianIndex{2}, data)
  instructions::Vector{Instruction} = filter(x->typeof(x) == Instruction, data)
  return dots, instructions
end


function test()
  M :: Matrix{Bool} = zeros(5,5)
  M[1,5] = true
  M[2,4] = true
  M[3,2] = true
  M[4,1] = true
  M[5,1] = true
  M[5,4] = true
  M[5,5] = true
  display(M)
  M2 = hfold(M,2)
  display(M2)
  vfold(M2,3)
end

test()


dots, instructions = readInput()
dots = map(p -> p + CartesianIndex(1,1), dots)
instructions = map(x -> (x[1],x[2]+1), instructions)
M = matrix(dots)

M1 = deepcopy(M)

MA = [M1]
for f in instructions
  push!(MA,fold(deepcopy(MA[end]),f))
end

display(MA[end])