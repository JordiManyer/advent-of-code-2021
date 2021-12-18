

############################################################################################
#     a
#    ___
# b |   | c
#   |_d_|
#   |   |
# e |___| f
#     g
############################################################################################
const zero = Set("abcefg")
const one = Set("cf")
const two = Set("acdeg")
const three = Set("acdfg")
const four = Set("bcdf")
const five = Set("abdfg")
const six = Set("abdefg")
const seven = Set("acf")
const eight = Set("abcdefg")
const nine = Set("abcdfg")
const numbers = Dict(zero => '0', one => '1', two => '2', three => '3', four => '4', 
                     five => '5', six => '6', seven => '7', eight => '8', nine => '9')

isOne(s::String) :: Bool = (length(s) == 2)
isFour(s::String) :: Bool = (length(s) == 4)
isSeven(s::String) :: Bool = (length(s) == 3)
isEight(s::String) :: Bool = (length(s) == 7)
haslengthsix(s::String) :: Bool = (length(s) == 6)
haslengthfive(s::String) :: Bool = (length(s) == 5)

struct Combination
  digits :: Vector{String}
  message :: Vector{String}
end

function getInitialMap()
  return Dict('a' => Set("abcdefg"), 'b' => Set("abcdefg"), 
              'c' => Set("abcdefg"), 'd' => Set("abcdefg"), 
              'e' => Set("abcdefg"), 'f' => Set("abcdefg"), 
              'g' => Set("abcdefg"))
end

# Chacks if map is fully solved
function solved(d::Dict{Char,Set{Char}}) :: Bool
  for entry in d
    if length(entry.second) != 1
      return false
    end
  end
  return true
end

# Eliminates the letters we know from other lists. 
function clean!(d::Dict{Char,Set{Char}}) 
  for key in d
    if length(key.second) == 1
      clean!(d,first(key.second))
    end
  end
end

# Remove a letter from all except the ones which have been found.
function clean!(d::Dict{Char,Set{Char}}, c::Char)
  for key in d
    if length(key.second) > 1
      delete!(key.second, c)
    end
  end
end

# Adds known combination to the map 
function add!(d::Dict{Char,Set{Char}},key::Char,vals::Set{Char})
  d[key] = intersect(d[key],vals)
end

function add!(d::Dict{Char,Set{Char}},keys::Set{Char},vals::Set{Char})
  for key in keys
    add!(d,key,vals)
  end
end

# Find the map that decifers the combination
function findMap(comb::Combination) :: Dict{Char,Char}
  digits  = comb.digits
  posible = getInitialMap()

  # Initial knowledge: 
  add!(posible, one  , Set(digits[findfirst(isOne, digits)]))   # One 
  add!(posible, four , Set(digits[findfirst(isFour, digits)]))  # Four
  add!(posible, seven, Set(digits[findfirst(isSeven, digits)])) # Seven 
  add!(posible, eight, Set(digits[findfirst(isEight, digits)])) # Eight
  add!(posible, intersect(two,three,five), Set(intersect(digits[findall(haslengthfive, digits)]...)))
  add!(posible, intersect(zero,six,nine), Set(intersect(digits[findall(haslengthsix, digits)]...)))

  # Iterate until we decifer all: 
  it = 0
  while !solved(posible) && it < 10
    clean!(posible)
    it += 1
  end

  # Create output (inverse map)
  res :: Dict{Char,Char} = Dict()
  for key in posible
    res[first(key.second)] = key.first
  end

  return res
end

# Takes a coded digit and decifers it (returns digit as char)
function decifer(d::Dict{Char,Char}, s::String) :: Char
  res = Set(map(c -> d[c], collect(s)))
  return numbers[res]
end

############################################################################################

function parseWords(s::String) :: Vector{String}
  return split(s, " ", keepempty=false)
end

function parseCombination(s::String) :: Combination
  parts = split(s, "|", keepempty=false)
  digits = parseWords(String(parts[1]))
  message = parseWords(String(parts[2]))
  return Combination(digits,message)
end

function readInput() :: Vector{Combination}
  f = open("./inputs/day8.txt")

  combinations :: Vector{Combination} = []
  for comb in eachline(f)
    push!(combinations, parseCombination(comb))
  end
  return combinations
end

############################################################################################


function problem1(combs::Vector{Combination}) :: Int
  n = 0
  for comb in combs
    for word in comb.message
      if (isOne(word) || isFour(word) || isSeven(word) || isEight(word))
        n += 1
      end
    end
  end
  return n
end


function problem2(combs::Vector{Combination}) :: Int
  n = 0
  for comb in combs
    solvemap = findMap(comb)
    n += parse(Int,join(map(word -> decifer(solvemap,word), comb.message)))
  end
  return n
end


combinations = readInput()
println("Problem 1: ", problem1(combinations))
println("Problem 1: ", problem2(combinations))
