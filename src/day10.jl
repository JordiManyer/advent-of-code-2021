
using DataStructures

const score = Dict(
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
)

const score2 = Dict(
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
)

const closing = Dict(
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
)

const openChar  = Set(['(', '[', '{', '<'])
const closeChar = Set([')', ']', '}', '>'])

# Calculates the score for problem 2
function calcScore(s::Array{Char}) :: Int
  res = 0
  map( x -> res = 5*res + score2[x], s)
  return res
end

# Evaluates expression, and returns the following code: 
#   1  -> Expression is valid and complete
#   0  -> Expression is valid but incomplete
#   -1 -> Expression is invalid
# If invalid, returns invalid character.
# If incomplete, returns array of missing characters.
function eval(expr::String) :: Tuple{Int,Vector{Char}}
  s = Stack{Char}()
  for c in expr 
    in(c,closeChar) && ( isempty(s) || (c != closing[pop!(s)])) && return (-1,[c]) # Closing char
    in(c, openChar) && push!(s,c) # Opening char, put in stack
  end
  !isempty(s) && return (0,map(c -> closing[c], s))
  return (1,[])
end


function readInput() :: Vector{String}
  f = open("./inputs/day10.txt")
  data :: Vector{String} = []

  for line in eachline(f)
    push!(data, line)
  end
  return data
end


function problem1(lines::Vector{String}) :: Int
  return sum(map(x -> score[x[2][1]] , filter(x -> x[1] == -1,map(line -> eval(line), lines))))
end

function problem2(lines::Vector{String}) :: Int
  scores = sort(map(x -> calcScore(x[2]) , filter(x -> x[1] == 0,map(line -> eval(line), lines))))
  return scores[length(scores) ÷ 2 + 1]
end

lines = readInput()

println("Problem 1:")
res = problem1(lines)
println(res)

println("Problem 2:")
res = problem2(lines)
println(res)

