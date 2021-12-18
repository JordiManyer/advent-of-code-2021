using DataStructures

mutable struct Compound
  word     :: String
  rules    :: Array{Int16}              # List of rules (pattern => letter) by index
  patterns :: Array{String}             # List of two-letter patterns
  letters  :: Array{Char}               # List of intercalation letters
  chains   :: Array{Tuple{Int16,Int16}} # Tree of rule relations
end

function Compound(word::String,rules::Array{Int16},patterns::Array{String},letters::Array{Char})
  chains :: Array{Tuple{Int16,Int16}} = []
  for iR in 1:length(rules)
    
  end
  return Compound(word, rules, patterns, letters, chains)
end

function step!(c::Compound)
  pieces = map(i -> c.rules[c.word[i:i+1]], 1:length(c.word)-1)
  c.word = string(pieces...,c.word[end])
end

function parseLine(line::String) :: Pair{String,String}
  return Pair(map(s -> string(s), split(line," -> "))...)
end

function readInput()
  lines = readlines("./inputs/day14.txt")

  word = lines[1]

  nPattern :: Int16 = 0
  nLetter  :: Int16 = 0
  iLetter  :: Int16 = 0
  rules    :: Array{Int16} = []
  patterns :: Array{String} = []
  letters  :: Array{Char} = []
  for line in lines[3:end]
    rule = parseLine(line)

    push!(patterns,rule.first)
    nPattern += 1

    if in(first(rule.second),letters)
      iLetter = findfirst(c->c==first(rule.second),letters)
    else
      nLetter += 1
      iLetter = nLetter
      push!(letters,first(rule.second))
    end

    push!(rules,iLetter)
  end

  return Compound(word,rules,patterns,letters)
end

myCompound = readInput()

nSteps = 40
for i in 1:nSteps
  println(i)
  step!(myCompound)
end

cnt = counter(myCompound.word)

display(maximum(x->x.second,cnt)-minimum(x->x.second,cnt)) 
