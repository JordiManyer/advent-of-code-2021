
abstract type AbstractDie end

# Deterministic die
mutable struct DDie <: AbstractDie
  next :: Int
end

DDie() = DDie(0)

function next(d::DDie) :: Int 
  d.next = d.next%100+1
  return d.next
end

############################################################################################
abstract type AbstractPlayer end 

# Deterministic Player 
mutable struct Player <: AbstractPlayer
  pos   :: Int
  score :: Int
end

Player(pos::Int) = Player(pos,0)
score(p::Player) = p.score

function play(p::Player,d::AbstractDie)
  step :: Int = next(d) + next(d) + next(d)
  p.pos = (p.pos + step - 1) % 10 + 1
  p.score += p.pos
end


############################################################################################

function game(p1::Player,p2::Player,d::AbstractDie) :: Int
  turn = 1
  rolls = 0
  while true
    play(p1,d)
    rolls += 3
    (p1.score >= 1000) && (return p2.score * rolls)

    play(p2,d)
    rolls += 3
    (p2.score >= 1000) && (return p1.score * rolls)
    println("Turn ", turn, ": P1 -> (", p1.pos, ",", p1.score,")    P2 -> (", p2.pos, ",", p2.score,")")
    turn += 1
  end
end

############################################################################################

# (Possible results => Probability) for 3 throws of a 3-face dice.
df = Dict{Int,Int}(
  3 => 1,
  4 => 3,
  5 => 6,
  6 => 7,
  7 => 6,
  8 => 3,
  9 => 1
)

# Play a turn for player 'pid' from position 'pos'.
function play(M:: Array{Int,4}, pos::CartesianIndex{4}, Mnew:: Array{Int,4}, pid::Int)
  (M[pos] == 0) && return
  if pid == 1 # Player 1
    for roll in 3:9 # For every possible result
      pnew = (pos[1] + roll -1) % 10 + 1
      Mnew[CartesianIndex(pnew, min(pos[2]+pnew,22), pos[3], pos[4])] += df[roll] * M[pos]
    end
  else # Player 2
    for roll in 3:9 # For every possible result
      pnew = (pos[3] + roll -1) % 10 + 1
      Mnew[CartesianIndex(pos[1], pos[2], pnew, min(pos[4]+pnew,22))] += df[roll] * M[pos]
    end
  end
end

function quantumGame(pos1::Int, pos2::Int) :: Int
  # All possible universes: 10 positions for each player, 21 possible scores 
  universes :: Array{Int,4} = zeros(10,22,10,22)
  newuniverses :: Array{Int,4} = zeros(10,22,10,22)
  universes[pos1,1,pos2,1] = 1
  # Continue until all possible universes have reached the end of the game
  while any(map(x -> (x != 0) ? true : false, universes[:,1:21,:,1:21]))
    for pid in 1:2
      newuniverses[:,:,:,:] .= 0
      map(pos -> play(universes,pos,newuniverses,pid), CartesianIndices(universes[:,1:21,:,1:21]))
      universes[:,1:21,:,1:21] = newuniverses[:,1:21,:,1:21]
      universes[:,22,:,:] += newuniverses[:,22,:,:]
      universes[:,:,:,22] += newuniverses[:,:,:,22]
    end
  end

  return max(sum(universes[:,22,:,:]),sum(universes[:,:,:,22]))
end

############################################################################################

println("Problem 1:")
d   = DDie()
res = game(Player(7),Player(10),d)
println(res)


println("Problem 2:")
res = quantumGame(7,10)
println(res)
