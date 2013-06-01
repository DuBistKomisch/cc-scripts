mon = peripheral.wrap("right")
lever = "left"
button = "top"

os.loadAPI("printutil")

function redstate(side)
  return redstone.getInput(side)
end

mon.clear()

low = 1
guess = 50
high = 100
printutil.println(mon, "Pick a no. "..low.."-"..high)

while not (guess == low and guess == high) do
  printutil.println(mon, "I guess "..guess..",")
  printutil.println(mon, "higher or lower?")
  
  while not redstate(button) do
    sleep(0.5)
  end
  
  if redstate(lever) then
    high = guess
  else
    low = guess
  end
  guess = math.floor(low + (high - low) / 2)
end

printutil.println(mon, "Your no. is "..guess.."!")
printutil.println(mon, "I win ;D")

unloadAPI("printutil")
