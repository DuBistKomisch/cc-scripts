local fuel, seed, fert = 1, 2, 6

function checkFuel(low)
  if turtle.getFuelLevel() <= low
  then
    turtle.select(fuel)
    turtle.refuel(1)
  end
end

-- check supplies
if turtle.getItemCount(fuel) <= 4
then
  print("out of fuel")
  return 1
end
if turtle.getItemCount(fert) <= 4
then
  print("out of fert")
  return 3
end
while turtle.getItemCount(seed) <= 4 and seed < fert
do
  seed = seed + 1
end
if seed == fert
then
  print("out of seed")
  return 2
end

-- plant saplings
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

-- grow tree
turtle.select(fert)
turtle.place()

-- cut it down
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

-- drop load
turtle.turnRight()
turtle.turnRight()
local slot = 7
for slot=7,16 do
  turtle.select(slot)
  turtle.drop()
end
turtle.turnRight()
turtle.turnRight()
