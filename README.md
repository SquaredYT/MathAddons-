![image](https://cdn.discordapp.com/attachments/734602322323439739/924354242360250408/InShot_20211225_123321486.jpg)
<div align="center">
  
 ## 🔴 [Documentation](https://devforum.roblox.com/t/introducing-mathaddons/1338754) || 🟢 [Model](https://www.roblox.com/library/7066695577/MathAddons)
  
</div>
  
**MathAddons** is a simple yet useful module with math functions that should've been incorporated into lua(u) and math functions that are just helpful 

MathAddons is an efficient module that returns functions as fast as regular math functions

Using any of the functions is as simple as:
```lua
-- Within a LocalScript or ServerScript and assuming MathAddons is placed in ReplicatedStorage

local Math = require(game.ReplicatedStorage.MathAddons)
local numbers = {1,2,3,4,5,6}
local average = Math.avg(numbers)
print(average) -- 3.5
```

but can get as complex as
```lua
local Math = require(game.ReplicatedStorage.MathAddons)
local complex = Math.Complex
local i = complex.i
local result = i^2
print(result) -- -1
print(Math.lambert_w0(i)) -- 0.37469902073711625+0.5764127230314329i
```

**Want to check it out?**  grab the **[model here](https://www.roblox.com/library/7066695577/MathAddons)**!

Need more help? Check out the **[Documentation here](https://devforum.roblox.com/t/introducing-mathaddons/1338754)** or contact me through devforum or discord (squared#7051)
