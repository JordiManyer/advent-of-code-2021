
# Definition of tree and leaves 
mutable struct Leaf
  parent :: Union{Nothing,Leaf}
  depth  :: Int
  left   :: Union{Int,Leaf}
  right  :: Union{Int,Leaf}
end

mutable struct Tree
  top   :: Leaf
  depth :: Int
end

Leaf() = Leaf(nothing, 0, 0, 0)
Tree() = Tree(Leaf(),0)

function splitLeaves(s::String) :: Tuple{String,String}
  begin k = 0; i = 2; end
  while k != 0 || i == 2
    (s[i] == '[') && (k += 1)
    (s[i] == ']') && (k -= 1)
    i += 1
  end
  return s[2:i-1], s[i+1:end-1]
end

function Leaf(parent :: Leaf, depth::Int, s::String) :: Union{Int,Leaf}
  (length(s) == 1) && return parse(Int,s)
  left, right = splitLeaves(s)
  return Leaf(parent, depth, Leaf(parent, ), Leaf(parent, ))
end

# Building the tree 
function addLeft(parent::Leaf, left::Leaf) 
  parent.left = left
  left.parent = parent
end

function addRight(parent::Leaf, right::Leaf) 
  parent.right = right
  right.parent = parent
end

function addLeaves(parent::Leaf, left:: Leaf, right:: Leaf)
  addLeft(parent, left)
  addRight(parent, right)
end

# Magnitude of a tree
magnitude(t::Tree) :: Int = magnitude(t.top)
magnitude(l::Leaf) :: Int = 3*magnitude(l.left) + 2*magnitude(l.right)
magnitude(n::Int)  :: Int = n

# Accessing neighboring leaves
function leftMost(l::Leaf) :: Leaf
  l2 = l
  while typeof(l2.left) == Leaf
    l2 = l2.left
  end
  return l2
end

function rightMost(l::Leaf) :: Leaf 
  l2 = l
  while typeof(l2.right) === Leaf
    l2 = l2.right
  end
  return l2
end

function leftNbor(l::Leaf) :: Union{Leaf,Nothing} 
  l2 = l
  while l2.parent !== nothing && l2 === l2.parent.left 
    l2 = l2.parent
  end
  (l2.parent === nothing) ? (return nothing) : (return rightMost(l2.parent.left))
end

function rightNbor(l::Leaf) :: Union{Leaf,Nothing}
  l2 = l
  while l2.parent !== nothing && l2 === l2.parent.right
    l2 = l2.parent
  end
  (l2.parent === nothing) ? (return nothing) : (return leftMost(l2.parent.right))
end


# Leaf refactoring
function explode(l::Leaf) 
  if l.depth >= 4
    left = leftNbor(l)
    right = rightNbor(l)

    (left  !== nothing) && (left.right += l.left)
    (right !== nothing) && (right.left += l.right) 
    
    (l.parent.left === l) ? (l.parent.left = 0) : (l.parent.right = 0)
  end
end

function split(l::Leaf)
  (typeof(l.left) == Int && l.left > 9) && (l.left = Leaf(l,l.depth+1,l.left÷2,l.left÷2+l.left%2))
  (typeof(l.right) == Int && l.right > 9) && (l.right = Leaf(l,l.depth+1,l.right÷2,l.right÷2+l.right%2))
end


function readInput() :: Array{String}
  f = open("./inputs/day18.txt")
  return map( x -> String(x), eachline(f))
end

function problem1(data::Array{String})
  for line in data
    t = Tree(line)
  end
end

data = readInput()