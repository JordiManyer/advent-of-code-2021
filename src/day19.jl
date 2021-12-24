

allPerms = Set(([1,2,3], [2,3,1], [3,1,2], [2,1,3], [1,3,2], [3,2,1]))
allSigns = Set(([1,1,1], [-1,1,1], [-1,-1,1], [-1,-1,-1]))

mutable struct Transformation
  offset :: Vector{Int}
  perm   :: Vector{Int}
  sign   :: Vector{Int}
end

# Compose two coordinate transformations such that: 
#   1->3 = 2->3 ◌ 1->2 
function compose(o12::Transformation, o23::Transformation) :: Transformation
  return Transformation(
    o23.offset .+ transform(o12.offset,o23),
    o12.perm[o23.perm],
    o23.sign .* o12.sign[o23.perm]
  )
end

# Apply transformation to coordinate vector
transform(x::Vector{Int},o::Transformation) :: Vector{Int} = o.offset .+ o.sign .* x[o.perm]

# Get relative transformation between two sets of points
function relativeTransformation(sc1::Vector{Vector{Int}}, sc2::Vector{Vector{Int}}) :: Transformation
  for perm in allPerms
    for sign in allSigns
      
    end
  end
end

function parseLine(s::String)
  (s == "") && (return nothing)
  (s[1:3] == "---") && (return "new")
  return map(x -> parse(Int,x), split(s,','))
end

function readInput()
  data = map(line -> parseLine(line), eachline("inputs/day19.txt"))

  i = 0
  scanners :: Vector{Vector{Vector{Int}}} = []
  for dd in data
    if dd == "new"
      i += 1
      push!(scanners,[])
    elseif typeof(dd) === Vector{Int}
      push!(scanners[i],dd)
    end
  end
  return scanners
end

scanners = readInput()