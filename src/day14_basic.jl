
using DataStructures

mutable struct Compound
  word  :: String
  rules :: Dict{String,String}
end

function step!(c::Compound)
  pieces = map(i -> c.rules[c.word[i:i+1]], 1:length(c.word)-1)
  c.word = string(pieces...,c.word[end])
end

function parseLine(line::String) :: Pair{String,String}
  s = split(line," -> ")
  return Pair(string(s[1]), string(s[1][1],s[2]))
end

function readInput()
  lines = readlines("./inputs/day14.txt")

  word = lines[1]
  rules :: Dict{String,String} = Dict{String,String}()
  for line in lines[3:end]
    rule = parseLine(line)
    rules[rule.first] = rule.second
  end

  return Compound(word,rules)
end

myCompound = readInput()

nSteps = 40
for i in 1:nSteps
  println(i)
  step!(myCompound)
end

cnt = counter(myCompound.word)

display(maximum(x->x.second,cnt)-minimum(x->x.second,cnt)) 
