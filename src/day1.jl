
"""
Problem 1: 

Given an input array of integers, count the number of values which increase relatively 
to their precedent. 

Problem 2: 
Same, but using the convolution of the signal with a 3-position rectangular window.

"""

using DSP


# Read input
f = open("./inputs/day1.txt", "r")
data = map( x -> parse(Int,x), eachline(f))

# Problem
function countIncreasing(v::Vector{Int}) :: Int
  counter = 0
  for i in 2:length(v)
    if v[i] > v[i-1]
      counter += 1
    end
  end
  return counter
end

countIncreasingSums(v) = countIncreasing(conv(v,[1,1,1])[3:end-2])

println("Problem 1: ")
println(countIncreasing(data))
println("Problem 2: ")
println(countIncreasingSums(data))