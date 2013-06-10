-- config
local player = nil -- side of disk drive
local chat = nil -- side of chat box (optional)
local modem = nil -- side of moden (optional)
if player == nil then
  print("please set player side in config")
  return
end
if turtle == nil then
  print("you must run this on a turtle")
  return
end

-- hardcoded data on records
local data = {}
data["C418 - 13"] = {"C418", "13", 178, nil}
data["C418 - cat"] = {"C418", "cat", 185, nil}
data["C418 - blocks"] = {"C418", "blocks", 345, nil}
data["C418 - chirp"] = {"C418", "chirp", 185, nil}
data["C418 - far"] = {"C418", "far", 174, nil}
data["C418 - mall"] = {"C418", "mall", 197, nil}
data["C418 - mellohi"] = {"C418", "mellohi", 96, nil}
data["C418 - stal"] = {"C418", "stal", 150, nil}
data["C418 - strad"] = {"C418", "strad", 188, nil}
data["C418 - ward"] = {"C418", "ward", 251, nil}
data["C418 - 11"] = {"C418", "11", 71, nil}
data["wait"] = {"C418", "wait", 238, nil}
data["pg.stillalive"] = {"Valve", "Still Alive", 176, nil}
data["pg.wantyougone"] = {"Valve", "Want You Gone", 140, nil}

-- convert durations into strings like MM:SS
for k, v in pairs(data) do
  local len = v[3]
  local time = math.floor(len / 60) .. ":"
  if len % 60 < 10 then
    time = time .. "0"
  end
  time = time .. len % 60
  data[k][4] = time
end

-- build library
library = {}
turtle.suck()
for i = 1,16 do
  turtle.select(i)
  turtle.drop()
  if not disk.hasAudio(player) then
    break
  end
  table.insert(library, disk.getLabel(player))
  print("added " .. disk.getLabel(player) .. " to library")
  turtle.suck()
end

-- prepare selection
math.randomseed(os.time())
next = 0

-- prepare rednet
if modem ~= nil then
  rednet.open(modem)
end

while true do
  -- switch out disc
  if next == 0 then
    next = math.random(table.getn(library))
  end
  turtle.suck()
  turtle.select(next)
  turtle.drop()
  
  -- track info
  local label = disk.getLabel(player)
  local len = data[label][3]
  if chat ~= nil then
    peripheral.call(chat, "say", "Now playing '" .. data[label][2] .. "' - " .. data[label][1] .. " [" .. data[label][4] .. "]")
  end

  -- play track
  disk.playAudio(player)
  local timer = os.startTimer(len)
  local start = os.clock()

  -- wait for events
  while true do
    event, param1, param2 = os.pullEventRaw()
    if event == "terminate" then
      -- cleanup and quit
      if modem ~= nil then
        rednet.close(modem)
      end
      disk.stopAudio(player)
      turtle.suck()
      return
    elseif event == "timer" and param1 == timer then
      -- track is finished
      next = 0
      break
    elseif event == "rednet_message" then
      local command = textutils.unserialize(param2)
      if command[1] == "list" then
        -- list library
        local items = {}
        for k, v in pairs(library) do
          table.insert(items, data[v])
        end
        rednet.send(param1, textutils.serialize(items))
      elseif command[1] == "now" then
        -- get information about currently playing track
        rednet.send(param1, textutils.serialize({next, math.floor(os.clock() - start)}))
      elseif command[1] == "switch" then
        -- validate switch, then switch or cancel
        if command[2] >= 1 and command[2] <= table.getn(library) then
          next = command[2]
          break
        end
      end
    end
  end
end
