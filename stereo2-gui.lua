-- config
local modem = nil -- side of modem
local monitor = nil -- side of monitor (optional)
local interval = 1 -- how long between updates
if modem == nil then
  print("please set modem in config")
  return
end

-- ### functions

-- format a time into MM:SS
-- returns the formatted string
function formatTime(now)
  local time = math.floor(now / 60) .. ":"
  if now % 60 < 10 then
    time = time .. "0"
  end
  time = time .. now % 60
  return time
end

-- pads a string to the specified length
-- returns the string of the specified length
-- credit to dissy at http://www.computercraft.info/forums2/index.php?/topic/6965-
function padString (sText, iLen)
  local iTextLen = string.len(sText)
  -- Too short, pad
  if iTextLen < iLen then
    local iDiff = iLen - iTextLen
    return(sText..string.rep(" ",iDiff))
  end
  -- Too long, trim
  if iTextLen > iLen then
    return(string.sub(sText,1,iLen))
  end
  -- Exact length
  return(sText)
end

-- format an item
-- returns the formatted string
function formatItem(id, item)
  return string.format("%2d %s %s %s", id, padString(item[2], 13), padString(item[1], 6), item[4])
end

-- switch track
-- returns nil
function switch(server, n)
  rednet.send(server, textutils.serialize({"switch", n}))
end

-- ### interface

function drawInterface()
  term.setCursorPos(1, 3)
  if term.isColor() then
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
  end
  term.clearLine()
  term.write("ID Track         Artist Length")
end

function drawItem(id, item, now)
  term.setCursorPos(1, 3 + id)
  if term.isColor() then
    term.setBackgroundColor(colors.black)
    if now then
      term.setTextColor(colors.yellow)
    else
      term.setTextColor(colors.lightGray)
    end
    term.clearLine()
    term.write(formatItem(id, item))
  else
    term.clearLine()
    if now then
      term.write(formatItem(id, item) .. " *")
    else
      term.write(formatItem(id, item))
    end
  end
end

function drawNow(now, item)
  term.setCursorPos(1, 1)
  if term.isColor() then
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.lightBlue)
  end
  term.clearLine()
  term.write("Playing ")
  if term.isColor() then
    term.setTextColor(colors.orange)
  end
  term.write(formatTime(now[2]))
  if term.isColor() then
    term.setTextColor(colors.lightBlue)
  end
  term.write(" / " .. item[4])
end

-- ### main

-- init
rednet.open(modem)
if monitor ~= nil then
  term.redirect(peripheral.wrap(monitor))
end
term.setCursorBlink(false)

-- ping until server found
local kill= false
while true do
  rednet.broadcast(textutils.serialize({"list"}))
  rednet.receive() -- skip our own broadcast
  -- wait for reply
  local timer = os.startTimer(interval)
  local dc = false
  while true do
    local event, server, message = os.pullEventRaw()
    if event == "terminate" then
      -- terminate
      kill = true
      break
    elseif event == "timer" and server == timer then
      -- try again
      break
    elseif event == "rednet_message" then
      -- draw static content
      local library = textutils.unserialize(message)
      drawInterface()
      -- continually check status
      while true do
        rednet.send(server, textutils.serialize({"now"}))
        local timer2 = os.startTimer(interval)
        -- wait and check mouse
        dc = true
        while true do
          local event2, param1, param2, param3 = os.pullEventRaw()
          if event2 == "terminate" then
            -- terminate
            kill = true
            break
          elseif event2 == "timer" and param1 == timer2 then
            -- go again
            break
          elseif event2 == "rednet_message" and param1 == server then
            -- now playing
            local now = textutils.unserialize(param2)
            for i=1,#library do
              drawItem(i, library[i], i == now[1])
            end
            drawNow(now, library[now[1]])
            dc = false
          elseif event2 == "mouse_click" or event2 == "monitor_touch" then
            if param3 >= 4 and param3 <= 3 + #library then
              switch(server, param3 - 3)
            end
          end
        end
        -- terminate
        if dc or kill then
          break
        end
      end
      -- terminate
      if dc or kill then
        break
      end
    end
  end
  -- terminate
  if kill then
    break
  end
end

-- cleanup
rednet.close(modem)
term.setCursorBlink(true)
term.restore()
