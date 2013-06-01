local fuel, seed, fert = 1, 2, 3

function checkFuel(low)
  while turtle.getFuelLevel() <= low do
    turtle.select(fuel)
    turtle.refuel(1)
  end
end

checkFuel(5)
turtle.select(seed)
turtle.forward()
turtle.place()
turtle.back()
turtle.place()
turtle.turnRight()
turtle.forward()
turtle.turnLeft()
turtle.forward()
turtle.place()
turtle.back()
turtle.place()

turtle.select(fert)
turtle.place()

local height = 0
turtle.dig()
checkFuel(1)
turtle.forward()
while turtle.detect() do
  height = height + 1
  turtle.dig()
  turtle.digUp()
  checkFuel(1)
  turtle.up()
end
turtle.turnLeft()
checkFuel(1)
turtle.forward()
turtle.turnRight()
turtle.digDown()
checkFuel(1)
turtle.down()
while height > 1 do
  height = height - 1
  turtle.dig()
  turtle.digDown()
  checkFuel(1)
  turtle.down()
end
turtle.dig()
checkFuel(1)
turtle.back()
