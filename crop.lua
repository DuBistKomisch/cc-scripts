local args = { ... }
if #args < 1 then
  print("specify crop size")
end

local fuel, seed = 1, 2

function checkFuel(low)
  turtle.select(fuel)
  while turtle.getFuelLevel() <= low do
    turtle.refuel(1)
  end
end

local size = tonumber(args[1])
checkFuel(size*size)
turtle.select(seed)
for row=1,size do
  for i=1,size do
    turtle.placeDown()
    turtle.forward()
    if i == size - 1 or i == size then
      if row % 2 == 0 then
        turtle.turnLeft()
      else
        turtle.turnRight()
      end
    end
  end
end
