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
  for iR in 1:length(rules) # The rule AB -> C will create two new patterns (AC,CB)
    pattern1 = string(patterns[iR][1],letters[rules[iR]])
    pattern2 = string(letters[rules[iR]], patterns[iR][2])
    push!(chains,(findfirst(isequal(pattern1),patterns), findfirst(isequal(pattern2),patterns)))
  end
  return Compound(word, rules, patterns, letters, chains)
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

############################################################################################
# Non-optimised way of solving the problem. 

function steps!(nSteps::Int, pattern::Int16, c::Compound, cnter::Array{Int})
  (nSteps == 0) && return

  cnter[c.rules[pattern]] += 1
  steps!(nSteps-1,c.chains[pattern][1],c,cnter)
  steps!(nSteps-1,c.chains[pattern][2],c,cnter)
end


function solve(nSteps::Int, c::Compound)
  cnter :: Array{Int} = map(l -> count(x->x==l,c.word), c.letters)
  for i in 1:length(c.word)-1
    pattern :: Int16 = findfirst(isequal(c.word[i:i+1]), c.patterns)
    steps!(nSteps, pattern, c, cnter)
  end
  return maximum(cnter) - minimum(cnter)
end

############################################################################################
# Optimised procedure: Just count the total number of each pattern and update at each step. 

function dostep(c::Compound, cnter::Array{Int}) :: Array{Int}
  newCnter :: Array{Int} = fill(0,length(cnter))
  for i in 1:length(c.patterns)
    newCnter[c.chains[i][1]] += cnter[i]
    newCnter[c.chains[i][2]] += cnter[i]
  end
  return newCnter
end

function solve2(nSteps::Int, c::Compound)
  cnter :: Array{Int} = fill(0,length(c.patterns))
  for i in 1:length(c.word)-1
    pattern :: Int16 = findfirst(isequal(c.word[i:i+1]), c.patterns)
    cnter[pattern] += 1
  end
  for i in 1:nSteps
    cnter = dostep(c,cnter)
  end
  res :: Array{Int} = fill(0,length(c.letters))
  for i in 1:length(cnter)
    letter = first(c.patterns[i])
    res[findfirst(isequal(letter),c.letters)] += cnter[i]
  end
  res[findfirst(isequal(c.word[end]),c.letters)] += 1
  return maximum(res) - minimum(res)
end


############################################################################################
myCompound = readInput()

nSteps = 40
res = solve2(nSteps,myCompound)
# res = solve(nSteps,myCompound)
println(res)
