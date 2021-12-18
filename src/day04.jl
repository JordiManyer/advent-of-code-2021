using DelimitedFiles
import Base.size 

# Bingo struct
mutable struct Bingo
  n ::Int
  nums :: Matrix{Int}
  mask :: Matrix{Bool}
end

Bingo(n::Int) = Bingo(n,zeros(n,n),zeros(n,n))
Bingo(n::Int, nums::Matrix{Int}) = Bingo(n,nums,zeros(n,n))
Bingo(nums::Matrix{Int}) = Bingo(size(nums)[1], nums)

size(b::Bingo) :: Int = b.n
row(b::Bingo, i::Int) :: Vector{Bool} = b.mask[i,:]
col(b::Bingo,i::Int) :: Vector{Bool} = b.mask[:,i]

# Returns true if the bingo is complete. 
function bingo(b::Bingo) :: Bool
  res = false
  for i in 1:size(b)
    res = res || all(row(b,i)) || all(col(b,i))
  end
  return res
end

# Adds number appearance to bingo. 
function newNum!(num::Int, b::Bingo)
  ind = findall(x -> x == num, b.nums)
  if length(ind) > 0
    b.mask[ind] .= true
  end
end

# Returns the score of a bingo board. 
function score(b::Bingo)
  return sum(b.nums[map(x->!x,b.mask)])
end

# Returns the score of the first bingo to be complete. 
function playBingo!(nums::Vector{Int}, bingos::Vector{Bingo}) :: Int
  for num in nums
    println("New num: ", num)
    map(x -> newNum!(num, x), bingos)
    complete = map(x -> bingo(x), bingos)
    if (any(complete))
      ind = findfirst(complete)
      println("BINGO!!!")
      println("Bingo sheet nº", ind, " has been completed: ")
      display(bingos[ind].mask)
      return score(bingos[ind]) * num
    end
  end
  return -1 
end

# Returns the score of the last bingo to be complete. 
function lastBingo!(nums::Vector{Int}, bingos::Vector{Bingo}) :: Int
  lastRound :: Vector{Bool} = zeros(length(bingos))
  for num in nums
    println("New num: ", num)
    map(x -> newNum!(num, x), bingos)
    complete = map(x -> bingo(x), bingos)
    if (all(complete))
      ind = findfirst(map(x -> !x, lastRound))
      println("BINGO!!!")
      println("Bingo sheet nº", ind, " has been completed: ")
      display(bingos[ind].mask)
      return score(bingos[ind]) * num
    end
    lastRound = deepcopy(complete)
  end
  return -1 
end


function readInput()
  # Read numbers
  f = readdlm("./inputs/day4.txt", ',')
  nums :: Vector{Int} = f[1,:]
  
  # Read bingo sheets
  f = readdlm("./inputs/day4.txt", Int, skipstart=1, skipblanks=true)
  sBingos = size(f)[2]
  nBingos = size(f)[1] ÷ sBingos
  f = reshape(transpose(f),(sBingos,sBingos,nBingos))

  bingos :: Vector{Bingo} = []
  for i in 1:nBingos
    push!(bingos, Bingo(permutedims(f[:,:,i],(2,1))))
  end
  return nums, bingos
end


nums, bingos = readInput()

res =  playBingo!(nums,deepcopy(bingos))
println("Final score: ", res)

res = lastBingo!(nums,deepcopy(bingos))
println("Final score: ", res)
