-- config
local modem = nil -- side of modem
if modem == nil then
  print("please set modem in config")
  return
end

-- check arguments
local args = { ... }
if #args < 1 then
  print("usage:\n\tstereo2-cli list\n\tstereo2-cli switch <track_id>")
  return
end

-- format a time into MM:SS
function format(now)
  local time = math.floor(now / 60) .. ":"
  if now % 60 < 10 then
    time = time .. "0"
  end
  time = time .. now % 60
  return time
end

-- hit server
rednet.open(modem)
rednet.broadcast(textutils.serialize({"list"}))
rednet.receive() -- dummy, skip our own broadcast
local server, message = rednet.receive(2)
if server == nil then
  print("no server responded")
  rednet.close(modem)
  return
end

if args[1] == "list" then
  local library = textutils.unserialize(message)
  -- get now playing
  rednet.send(server, textutils.serialize({"now"}))
  _, message = rednet.receive()
  local now = textutils.unserialize(message)

  -- print library
  for k, item in pairs(library) do
    if k == now[1] then
      local time = format(now[2])
      print(k .. ":*'" .. item[2] .. "' - " .. item[1] .. " [" .. time .. "/" .. item[4] .. "]")
    else
      print(k .. ": '" .. item[2] .. "' - " .. item[1] .. " [" .. item[4] .. "]")
    end
  end
elseif args[1] == "switch" then
  -- change track
  if #args < 2 then
    print("missing track_id")
    return
  end
  rednet.send(server, textutils.serialize({"switch", tonumber(args[2])}))
end

-- cleanup
rednet.close(modem)
