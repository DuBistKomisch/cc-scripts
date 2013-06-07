local remove = "left"
local insert = "top"
local player = "back"

local duration = {}
duration["13"] = 178
duration["C418 - cat"] = 185
duration["blocks"] = 345
duration["C418 - chirp"] = 185
duration["far"] = 174
duration["C418 - mall"] = 197
duration["mellohi"] = 96
duration["stal"] = 150
duration["strad"] = 188
duration["ward"] = 251
duration["11"] = 71
duration["wait"] = 238
duration["pg.stillalive"] = 176
duration["pg.wantyougone"] = 140

function switch()
  redstone.setOutput(remove, true)
  os.sleep(3)
  redstone.setOutput(insert, false)
  redstone.setOutput(remove, false)
  os.sleep(3)
  redstone.setOutput(insert, true)
end

redstone.setOutput(insert, true)
while true do
  switch()
  disk.playAudio(player)
  os.sleep(duration[disk.getAudioTitle(player)])
end
