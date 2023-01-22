![image](https://user-images.githubusercontent.com/85357169/213919990-946a9970-7545-4176-a484-16b1f5ea6626.png)

<div align="center">
  
 ## 🔴 [Documentation](https://devforum.roblox.com/t/introducing-mathaddons/1338754) || 🟢 [Model](https://www.roblox.com/library/7066695577/MathAddons)
  
</div>
  
***MathAddons+** is a simple yet large module for all your mathematical needs*
*With over 85 functions, such as calculating the mean, scientific notation, fraction conversion, complex number support, and much more!*

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

Need more help? Check out the **[documentation here](https://devforum.roblox.com/t/mathaddons-useful-functions-all-in-one-place/1836343)** or contact me through devforum or discord (squared#7051)
