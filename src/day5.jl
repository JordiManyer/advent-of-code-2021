

struct Board
  n :: Int
  lines :: Vector{Line}
  cells :: Matrix{Int}
end

function Board(lines::Vector{Line})
  n = maximum(map(l -> max(l.startPt[1],l.startPt[2],l.endPt[1],l.endPt[2]),lines))
  return Board(n,lines,zeros(Int,(n,n)))
end 

############################################################################################

struct Line
  startPt :: CartesianIndex{2}
  endPt   :: CartesianIndex{2}
  points  :: Vector{CartesianIndex{2}}
end

function Line(p1::CartesianIndex{2}, p2::CartesianIndex{2})
  slope = (p2-p1)
  npts = max(abs(slope[1]), abs(slope[2]))
  slope = CartesianIndex(slope[1] ÷ npts,slope[2] ÷ npts)
  pts = [p1 + i*slope for i = 0:npts]
  return Line(p1, p2, pts)
end

isHorizontal(l::Line) :: Bool = (l.startPt[1] == l.endPt[1])
isVertical(l::Line)   :: Bool = (l.startPt[2] == l.endPt[2])
isFlat(l::Line)       :: Bool = isHorizontal(l) || isVertical(l)

############################################################################################

function parsePoint(s::String) :: CartesianIndex{2}
  coords = map(x -> parse(Int,x),split(s, ',', keepempty=false))
  return CartesianIndex(coords[1], coords[2])
end

function parseLine(s::String) :: Line
  pts = split(s, "->", keepempty=false)
  p1 = parsePoint(String(pts[1]))
  p2 = parsePoint(String(pts[2]))
  return Line(p1,p2)
end

function readInput() :: Vector{Line}
  f = open("./inputs/day5.txt")

  lines :: Vector{Line} = []
  for line in eachline(f)
    push!(lines, parseLine(line))
  end
  return lines
end

############################################################################################

function add!(line::Line, M::Matrix{Int})
  for p in line.points
    M[p] += 1
  end
end

function drawLines!(b::Board)
  map(l -> add!(l,b.cells), b.lines)
end

############################################################################################

lines = readInput()

# Problem 1
lines1 = deepcopy(filter(isFlat, lines))
board1 = Board(lines1)
drawLines!(board1)
res = count( map( x -> (x > 1) ? true : false, board1.cells))

# Problem 2
lines2 = deepcopy(lines)
board2 = Board(lines2)
drawLines!(board2)
res = count( map( x -> (x > 1) ? true : false, board2.cells))