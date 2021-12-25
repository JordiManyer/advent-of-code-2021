
hexDic = Dict{Char,String}(
  '0' => "0000",
  '1' => "0001",
  '2' => "0010",
  '3' => "0011",
  '4' => "0100",
  '5' => "0101",
  '6' => "0110",
  '7' => "0111",
  '8' => "1000",
  '9' => "1001",
  'A' => "1010",
  'B' => "1011",
  'C' => "1100",
  'D' => "1101",
  'E' => "1110",
  'F' => "1111",
)

hex2bin(s::String) = string(map(x -> hexDic[x], collect(s))...)

# Converts from binary to decimal (binary given as array of bools). 
function toInt(v :: Array{Bool,1}) :: Int
  num = 0
  for i in 1:length(v)
    num += (v[i] ? 1 : 0) * 2^(length(v)-i)
  end
  return num
end

toInt(s::String) :: Int = toInt(map(c -> (c == '0') ? false : true, collect(s)))

############################################################################################

abstract type Packet end

struct NumberPacket <: Packet
  version :: Int
  type    :: Int
  value   :: Int
end

struct OperatorPacket <: Packet
  version  :: Int
  type     :: Int
  nPackets :: Int
  packets  :: Vector{Packet}
end


function parsePacket(s::String) :: Tuple{Packet,Int} 
  println(" > Parsing Packet")
  (toInt(s[4:6]) == 4) ? (return parseNumber(s)) : (return parseOperator(s))
end

function parseNumber(s::String) :: Tuple{NumberPacket,Int}
  println("   > Parsing Number")
  version :: Int = toInt(s[1:3])
  type    :: Int = toInt(s[4:6])
  
  lastPack :: Bool = false
  pos :: Int = 7
  packs :: Vector{String} = []
  while !lastPack
    lastPack = (s[pos] == '0')
    push!(packs,s[pos+1:pos+4])
    pos += 5
  end
  value :: Int = toInt(string(packs...))
  return NumberPacket(version,type,value), pos
end

function parseOperator(s::String) :: Tuple{OperatorPacket,Int}
  println("   > Parsing Operator")
  version :: Int = toInt(s[1:3])
  type    :: Int = toInt(s[4:6])

  pos :: Int = 7
  packets :: Vector{Packet} = []
  if s[7] == '0'
    lenPackets :: Int = toInt(s[8:22])
    pos = 23
    while pos-23 < lenPackets 
      packet, step = parsePacket(s[pos:end])
      pos += step-1
      push!(packets,packet)
    end
  else
    numPackets :: Int = toInt(s[8:18])
    pos = 20
    for i in 1:numPackets
      println(pos, " - ", s[pos:end])
      packet, step = parsePacket(s[pos:end])
      pos += step-1
      push!(packets,packet)
    end
  end

  return OperatorPacket(version, type, length(packets), packets), pos  
end

function readInput()
  s = readline("inputs/day16.txt")
  data = parsePacket(s)
end




parseNumber("110100101111111000101000")
