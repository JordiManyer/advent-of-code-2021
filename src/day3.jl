
"""
Problem 1: 

Given an array of 12-digit binary numbers, find a) the most repeated digit in each position
and b) the least repeated digit in each position. Then convert both numbers to decimal and 
multiply.

Problem 2: 
Given an array of 12-digit binary numbers, repeatedly filter them out given a digit criteria. 

"""


# Read input
function readInput() :: Array{Array{Bool,1},1}
  f = open("./inputs/day3.txt", "r")
  return map( y -> map(x -> parse(Bool,x), collect(y)), eachline(f))
end

function toInt(v :: Array{Bool,1}) 
  num = 0
  for i in 1:length(v)
    num += (v[i] ? 1 : 0) * 2^(length(v)-i)
  end
  return num
end

function rates(data :: Array{Array{Bool,1},1}) 
  counts = zeros(length(data[1]))
  for dd in data
    counts += map(x-> x ? 1 : -1, dd)
  end
  println(counts)
  return map(x -> x >= 0 ? true : false, counts), map(x -> x >= 0 ? false : true, counts)
end



function nextBit(dd, i :: Int) :: Bool
  counts = sum(map(x -> x[i] ? 1 : -1, dd))
  return (counts >= 0 ? true : false)
end

function rates2(data :: Array{Array{Bool,1},1}) 
  
  gamma = deepcopy(data)
  i = 1
  while size(gamma)[1] > 1 && i <= size(data[1])[1]
    bit = nextBit(gamma,i)
    println(i, "    ", bit)
    gamma = filter(x -> x !== nothing , map( x -> x[i] == bit ? x : nothing, gamma))
    i += 1
  end
  println(gamma)
  @assert size(gamma)[1] == 1 "Gamma is not well defined"

  epsilon = deepcopy(data)
  i = 1
  while size(epsilon)[1] > 1 && i <= size(data[1])[1]
    bit = !nextBit(epsilon,i)
    println(i, "    ", bit)
    epsilon = filter(x -> x !== nothing , map( x -> x[i] == bit ? x : nothing, epsilon))
    i += 1
  end
  println(epsilon)
  @assert size(epsilon)[1] == 1 "Epsilon is not well defined"

  return gamma[1], epsilon[1]
end


data = readInput()

display("Problem 1: ")
gamma, epsilon = rates(data)
display(toInt(gamma))
display(toInt(epsilon))
display(toInt(gamma) * toInt(epsilon))

display("Problem 2: ")
gamma, epsilon = rates2(data)
display(toInt(gamma))
display(toInt(epsilon))
display(toInt(gamma) * toInt(epsilon))