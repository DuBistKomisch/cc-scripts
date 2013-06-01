function print(mon, str)
  w, h = mon.getSize()
  x, y = mon.getCursorPos()
  len = string.len(str)
  fit = w - x + 1
  
  mon.write(str)
  if len > fit then
    mon.setCursorPos(1, y + 1)
    mon.write(string.sub(str, fit + 1))
  end
end

function println(mon, str)
  print(mon, str)
  
  x, y = mon.getCursorPos()
  mon.setCursorPos(1, y + 1)
end
