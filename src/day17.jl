
struct SquareRange
  xRange :: Tuple{Int,Int}
  yRange :: Tuple{Int,Int}
end

mutable struct Probe 
  pos :: Tuple{Int,Int}
  vel :: Tuple{Int,Int}
end

Probe(v::Tuple{Int,Int}) = Probe((0,0),v)

function step!(p::Probe)
  p.pos = p.pos .+ p.vel
  p.vel = p.vel .+ (-sign(p.vel[1]),-1)
end

function inRange(p::Probe, r::SquareRange) :: Bool
  return (p.pos[1] >= r.xRange[1] && p.pos[1] <= r.xRange[2] && p.pos[2] >= r.yRange[1] && p.pos[2] <= r.yRange[2])
end

function checkTrajectory(p::Probe, r::SquareRange) :: Int
  yMax :: Int = 0
  while(p.pos[2] > r.yRange[1]) 
    step!(p)
    yMax = max(yMax,p.pos[2])
    inRange(p,r) && return yMax
  end
  return -1
end

function readInput()
  xRange = (135,155)
  yRange = (-102,-78)
  return SquareRange(xRange, yRange)
end

# For the first problem, the 'x' does not matter (since it does not affect y or vy in any way). 
# This means we can set vx = 16 or 17 (velocities for which we will drop straight down inside the range)
# and just maximize for vy. 
function problem1(r::SquareRange) :: Tuple{Int,Int}
  vmax :: Int = -1
  ymax :: Int = 0
  for v in 0:1000
    y = checkTrajectory(Probe((17,v)),r)
    y > ymax && begin vmax = v; ymax = y; end
  end
  return (vmax,ymax)
end

# For the second problem, we need to consider the velocity range that is possibe. In order
# to do so, we can try to set some approppriate ranges for both directions: 
#  - If vx < 16, the probe stops before reaching the range. 
#  - If vx > 156, the probe will pass right through. 
# For vy, we have that vy = -|vy_0| at y=0 (either at the start of when it crosses over) so 
# we have that 
#  - If vy > 103, the probe goes through the range without stoping in it. 
#  - If vy < -103, same thing happens
function problem2(r::SquareRange) :: Int
  cnter :: Int = 0
  for vx in 16:156
    for vy in -103:103
      (checkTrajectory(Probe((vx,vy)),r) != -1) && (cnter += 1) 
    end
  end
  return cnter 
end

range = readInput()
res = problem1(range)
println(res)
res = problem2(range)
println(res)