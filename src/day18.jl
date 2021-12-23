
# Definition of tree and leaves 
mutable struct Leaf
  parent :: Union{Nothing,Leaf}
  depth  :: Int
  left   :: Union{Int,Leaf}
  right  :: Union{Int,Leaf}
end

Leaf() = Leaf(nothing, 0, 0, 0)

# Set depth of a leaf
function setDepth(l::Leaf,d::Int) 
  l.depth = d
  (typeof(l.left) !== Int) && setDepth(l.left,d+1)
  (typeof(l.right) !== Int) && setDepth(l.right,d+1) 
end

# Given a string, separate two leaves
function splitLeaves(s::String) :: Tuple{String,String}
  begin k = 0; i = 2; end
  while k != 0 || i == 2
    (s[i] == '[') && (k += 1)
    (s[i] == ']') && (k -= 1)
    i += 1
  end
  return s[2:i-1], s[i+1:end-1]
end

# Create a new leaf from a string
function newLeaf(parent::Union{Leaf,Nothing}, depth::Int, s::String) :: Union{Int,Leaf}
  (length(s) == 1) && return parse(Int,s) # Base case -> Integer

  # General case -> Leaf
  left, right = splitLeaves(s)
  res :: Leaf = Leaf(parent,depth,0,0)
  res.left    = newLeaf(res,depth+1,left)
  res.right   = newLeaf(res,depth+1,right)
  return res
end

newTree(s::String) = newLeaf(nothing,0,s)

# Magnitude of a leaf
magnitude(l::Leaf) :: Int = 3*magnitude(l.left) + 2*magnitude(l.right)
magnitude(n::Int)  :: Int = n

# Get left-most sub-leaf
function leftMost(l::Leaf) :: Leaf
  l2 = l
  while typeof(l2.left) == Leaf
    l2 = l2.left
  end
  return l2
end

# Get right-most sub-leaf
function rightMost(l::Leaf) :: Leaf 
  l2 = l
  while typeof(l2.right) === Leaf
    l2 = l2.right
  end
  return l2
end

# Get left neighbor of a leaf
function leftNbor(l::Leaf) :: Union{Leaf,Nothing} 
  l2 = l
  while l2.parent !== nothing && l2 === l2.parent.left 
    l2 = l2.parent
  end
  if (l2.parent === nothing) 
    return nothing
  else 
    (typeof(l2.parent.left) === Int) ? (return l2.parent) : (return rightMost(l2.parent.left))
  end
end

# Get right neighbor of a leaf
function rightNbor(l::Leaf) :: Union{Leaf,Nothing}
  l2 = l
  while l2.parent !== nothing && l2 === l2.parent.right
    l2 = l2.parent
  end
  if (l2.parent === nothing) 
    return nothing
  else
    (typeof(l2.parent.right) === Int) ? (return l2.parent) : (return leftMost(l2.parent.right))
  end
end


# Check if any leaf can be exploded recursively (left ones first). 
# Returns true if some leaf has been exploded.
function explode(l::Leaf) :: Bool
  if (typeof(l.left) !== Int) || (typeof(l.right) !== Int)
    return ((typeof(l.left) !== Int) &&  explode(l.left)) || ((typeof(l.right) !== Int) &&  explode(l.right))
  elseif l.depth >= 4
    left = leftNbor(l)
    right = rightNbor(l)

    if (left  !== nothing) 
      (typeof(left.right) === Int) ? (left.right += l.left) : (left.left += l.left)
    end
    if (right !== nothing) 
      (typeof(right.left) === Int) ?  (right.left += l.right) : (right.right += l.right)
    end
    
    (l.parent.left === l) ? (l.parent.left = 0) : (l.parent.right = 0)
    return true
  end
  return false
end

# Check if any leaf can be split recursively (left ones first). 
# Returns true if some leaf has been split.
function split(l::Leaf) :: Bool
  if (typeof(l.left) == Int) && (l.left > 9) 
    l.left = Leaf(l,l.depth+1,l.left÷2,l.left÷2+l.left%2)
    return true
  elseif (typeof(l.left) == Leaf) && split(l.left)
    return true
  elseif (typeof(l.right) == Int) && (l.right > 9) 
    l.right = Leaf(l,l.depth+1,l.right÷2,l.right÷2+l.right%2)
    return true
  elseif (typeof(l.right) == Leaf) && split(l.right)
    return true 
  end
  return false
end

# Reduce a leave until none of its sub-leaves can be exploded or split
function reduce(l::Leaf)
  keepGoing = true
  while keepGoing
    keepGoing = explode(l) || split(l)
  end
end

# Add two leaves together
function add(l::Leaf, r::Leaf) :: Leaf
  res = Leaf(nothing,0,l,r)
  l.parent = res
  r.parent = res
  setDepth(res,0)
  reduce(res)
  return res
end

# Display Leaves like in the inputs
printLeaf(l::Int) = print(l)

function printLeaf(l::Leaf)
  (l.parent === nothing) && println("")
  print("[")
  printLeaf(l.left)
  print(",")
  printLeaf(l.right)
  print("]")
  (l.parent === nothing) && println("")
end

function readInput() :: Array{String}
  f = open("./inputs/day18.txt")
  return map( x -> String(x), eachline(f))
end

function problem1(data::Array{String}) :: Int
  t = newTree(data[1])
  for line in data[2:end]
    printLeaf(t)
    tnew = newTree(line)
    t = add(t,tnew)
  end
  printLeaf(t)
  return magnitude(t)
end

function problem2(data::Array{String}) :: Int
  maxMag = 0
  for num1 in data
    for num2 in data
      if (num1 !== num2)
        t = add(newTree(num1),newTree(num2))
        m = magnitude(t)
        (m > maxMag) && (maxMag = m)
      end
    end
  end
  return maxMag
end


println("Reading Data... ")
data = readInput()

println("Problem 1: ")
res = problem1(data)
println(res)

println("Problem 2: ")
res = problem2(data)
println(res)
