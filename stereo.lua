local remove = "left"
local insert = "top"
local player = "back"

local artist = {}
artist["C418 - 13"] = "C418"
artist["C418 - cat"] = "C418"
artist["C418 - blocks"] = "C418"
artist["C418 - chirp"] = "C418"
artist["C418 - far"] = "C418"
artist["C418 - mall"] = "C418"
artist["C418 - mellohi"] = "C418"
artist["C418 - stal"] = "C418"
artist["C418 - strad"] = "C418"
artist["C418 - ward"] = "C418"
artist["C418 - 11"] = "C418"
artist["wait"] = "C418"
artist["pg.stillalive"] = "Valve"
artist["pg.wantyougone"] = "Valve"

local track = {}
track["C418 - 13"] = "13"
track["C418 - cat"] = "cat"
track["C418 - blocks"] = "blocks"
track["C418 - chirp"] = "chirp"
track["C418 - far"] = "far"
track["C418 - mall"] = "mall"
track["C418 - mellohi"] = "mellohi"
track["C418 - stal"] = "stal"
track["C418 - strad"] = "strad"
track["C418 - ward"] = "ward"
track["C418 - 11"] = "11"
track["wait"] = "wait"
track["pg.stillalive"] = "Still Alive"
track["pg.wantyougone"] = "Want You Gone"

local duration = {}
duration["C418 - 13"] = 178
duration["C418 - cat"] = 185
duration["C418 - blocks"] = 345
duration["C418 - chirp"] = 185
duration["C418 - far"] = 174
duration["C418 - mall"] = 197
duration["C418 - mellohi"] = 96
duration["C418 - stal"] = 150
duration["C418 - strad"] = 188
duration["C418 - ward"] = 251
duration["C418 - 11"] = 71
duration["wait"] = 238
duration["pg.stillalive"] = 176
duration["pg.wantyougone"] = 140

function switch()
  redstone.setOutput(remove, true)
  os.sleep(3)
  redstone.setOutput(insert, false)
  redstone.setOutput(remove, false)
  os.sleep(1)
  redstone.setOutput(insert, true)
  os.sleep(5)
end

redstone.setOutput(insert, true)
while true do
  switch()
  disk.playAudio(player)
  
  local label = disk.getLabel(player)
  local len = duration[label]
  local time = math.floor(len / 60) .. ":"
  if len % 60 < 10 then
    time = time .. "0"
  end
  time = time .. len % 60
  
  peripheral.call("right", "say", "Now playing '" .. track[label] .. "' by " .. artist[label] .. " [" .. time .. "]")
  os.sleep(len)
end
