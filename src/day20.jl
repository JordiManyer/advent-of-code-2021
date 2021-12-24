

infPixel(step::Int) = (iseven(step)) ? true : false

function getPixelIndex(M::Matrix{Bool}, pos::CartesianIndex{2}, step::Int) :: Int
  s = size(M)
  num :: Vector{Bool} = []
  (pos[1] != 1   ) && (pos[2] != 1   ) ? push!(num, M[pos + CartesianIndex(-1,-1)]) : push!(num,infPixel(step))
  (pos[1] != 1   ) ? push!(num, M[pos + CartesianIndex(-1,0)]) : push!(num,infPixel(step))
  (pos[1] != 1   ) && (pos[2] != s[2]) ? push!(num, M[pos + CartesianIndex(-1, 1)]) : push!(num,infPixel(step))

  (pos[2] != 1   ) ? push!(num, M[pos + CartesianIndex(0,-1)]) : push!(num,infPixel(step))
  push!(num, M[pos + CartesianIndex(0,0)])
  (pos[2] != s[2]) ? push!(num, M[pos + CartesianIndex(0,1)]) : push!(num,infPixel(step))

  (pos[1] != s[1]) && (pos[2] != 1   ) ? push!(num, M[pos + CartesianIndex( 1,-1)]) : push!(num,infPixel(step))
  (pos[1] != s[1]) ? push!(num, M[pos + CartesianIndex(1,0)]) : push!(num,infPixel(step))
  (pos[1] != s[1]) && (pos[2] != s[2]) ? push!(num, M[pos + CartesianIndex( 1, 1)]) : push!(num,infPixel(step))
  return toInt(num)
end

# Converts from binary to decimal (binary given as array of bools). 
function toInt(v :: Array{Bool,1}) 
  num = 0
  for i in 1:length(v)
    num += (v[i] ? 1 : 0) * 2^(length(v)-i)
  end
  return num
end

getOutputPixel(algo::Vector{Bool}, M::Matrix{Bool}, pos::CartesianIndex{2}, step::Int) :: Bool = algo[getPixelIndex(M,pos,step)+1]

function getOutputImage(algo::Vector{Bool}, M::Matrix{Bool}, step::Int)
  return map(p -> getOutputPixel(algo,M,p,step), CartesianIndices(M))
end

function addPadding(M::Matrix{Bool}, n::Int) M::Matrix{Bool}
  s = size(M)
  res :: Matrix{Bool} = zeros(s[1] + 2*n, s[2] + 2*n)
  res[n+1:s[1]+n,n+1:s[2]+n] = M[:,:]
  return res 
end

function parseLine(s::String) :: Union{Nothing,Vector{Bool}}
  (s == "") && (return nothing)
  return map(c -> (c == '#') ? true : false , collect(s))
end

function readInput()
  data = map(line -> parseLine(line), eachline("inputs/day20.txt"))

  algo  :: Vector{Bool} = data[1]
  image :: Matrix{Bool} = transpose(hcat(data[3:end]...))
  return (algo, image)
end

function problem1(algo::Vector{Bool}, image::Matrix{Bool})::Int
  ims = []
  im = addPadding(image,10)
  push!(ims, im)

  for i in 1:2
    push!(ims, getOutputImage(algo,ims[i],i))
  end
  return count(ims[3])
end


function problem2(algo::Vector{Bool}, image::Matrix{Bool})::Int
  ims = []
  im = addPadding(image,70)
  push!(ims, im)

  for i in 1:50
    push!(ims, getOutputImage(algo,ims[i],i))
  end
  return count(ims[51])
end


algo, image = readInput()

println("Problem 1:")
res = problem1(algo,image)
display(res)

println("Problem 2:")
res = problem2(algo,image)
display(res)