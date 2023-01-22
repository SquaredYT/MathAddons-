  --Hello, Im putting this here in case bots reupload this module with a virus in it. Im PerfectlySquared, the original creator of this module. If you find any module that has the same asset under a different creator that is not me.

-- Functions
local GSL_DBL_EPSILON = 1e-14
local one_over_E = 1 / math.exp(1)

function split(t)
	table.sort(t,function(a,b)
		return a < b
	end)
	local num = #t
	local t1, t2 = {},{}
	if (num/2)%1 ~= 0 then
		for i=1,math.floor(num/2) do
			t1[i]=t[i]
		end
		for i=math.ceil(num/2+1),#t do
			t2[i-math.ceil(num/2)]=t[i]
		end
	else
		for i=1,num/2 do
			t1[i] = t[i]
		end
		for i=num/2+1,#t do
			t2[i-num/2] = t[i]
		end
	end
	return t1, t2
end
function dupe(t)
	local newT = {}
	for i,v in ipairs(t) do
		if not table.find(newT,tonumber(v)) then
			table.insert(newT,tonumber(v))
		end
	end
	return newT
end
function add0(x)
	if x < 10 then return tostring('0'..x) else return x end
end

local function series_eval(r)
	local c = {
		[0]=-1.0,
		2.331643981597124203363536062168,
		-1.812187885639363490240191647568,
		1.936631114492359755363277457668,
		-2.353551201881614516821543561516,
		3.066858901050631912893148922704,
		-4.175335600258177138854984177460,
		5.858023729874774148815053846119,
		-8.401032217523977370984161688514,
		12.250753501314460424,
		-18.100697012472442755,
		27.029044799010561650
	}

	local t_8 = c[8] + r * (c[9] + r * (c[10] + r * c[11]))
	local t_5 = c[5] + r * (c[6] + r * (c[7] + r * t_8))
	local t_1 = c[1] + r * (c[2] + r * (c[3] + r * (c[4] + r * t_5)))
	return c[0] + r * t_1
end



local MathFunctions = {}

type val = 
	{
		x: number?,
		y: number?
	}
-- Statistics/Chance

function MathFunctions.flip(x)
	if x == nil then x = .5 end
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number from 0 to 1") end
	return Random.new():NextNumber() < x
end

function MathFunctions.sd(x,PopulationToggle)
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	if typeof(PopulationToggle) ~= 'boolean' and PopulationToggle ~= nil then return warn("Make sure parameter 2 is set to nil or a boolean") end
	if PopulationToggle == nil then PopulationToggle = false end
	local s = 0
	local ss = pcall(function()
		for i,v in ipairs(x) do s += v end
	end)
	if not s then return warn("Make sure all values in the table are numbers") end 
	local avg = s/#x
	local t = 0
	for i,v in ipairs(x) do t += (v - avg)^2 end
	if not PopulationToggle then
		return math.sqrt(t/(#x-1))
	else
		return math.sqrt(t/(#x))
	end
end



function MathFunctions.min(x) 
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	local s = pcall(function()
		table.sort(x,function(a,b)
			return a < b
		end)
	end)
	if not s then return warn("Make sure all values in the table are numbers") end
	return x[1]
end

function MathFunctions.median(x) 
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	local s = pcall(function()
		table.sort(x,function(a,b)
			return a < b
		end)
	end)
	if not s then return warn("Make sure all values in the table are numbers") end
	local index = #x/2+.5
	local median
	if index%1 ~= 0 then
		median = (x[index-.5]+x[index+.5])/2
	else
		median = x[index]
	end
	return median
end

function MathFunctions.q1(x)
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	local s = pcall(function()
		table.sort(x,function(a,b)
			return a < b
		end)
	end)
	if not s then return warn("Make sure all values in the table are numbers") end
	local t,_ = split(x)
	return MathFunctions.median(t)
end



function MathFunctions.q3(x)
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	local s = pcall(function()
		table.sort(x,function(a,b)
			return a < b
		end)
	end)
	if not s then return warn("Make sure all values in the table are numbers") end
	local _,t = split(x)
	
	return MathFunctions.median(t)
end
function MathFunctions.max(x) 
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	local s = pcall(function()
		table.sort(x,function(a,b)
			return a > b
		end)
	end)
	if not s then return warn("Make sure all values in the table are numbers") end
	return x[1]
end

function MathFunctions.iqr(x)
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	local s = pcall(function()
		table.sort(x,function(a,b)
			return a < b
		end)
	end)
	if not s then return warn("Make sure all values in the table are numbers") end
	return MathFunctions.q3(x)-MathFunctions.q1(x)
end

function MathFunctions.range(x)
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	local s = pcall(function()
		table.sort(x,function(a,b)
			return a < b
		end)
	end)
	if not s then return warn("Make sure all values in the table are numbers") end
	return MathFunctions.max(x)-MathFunctions.min(x)
end

function MathFunctions.mode(x)
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	local mostFrequent = {}
	local s = pcall(function()
		for i,v in ipairs(x) do
			if mostFrequent[tostring(v)] ~= nil then
				mostFrequent[tostring(v)] += 1
			else
				mostFrequent[tostring(v)] = 1
			end
		end
	end)
	if not s then return warn("Make sure all values in the table are numbers") end
	table.sort(mostFrequent,function(a,b)
		return a > b
	end)
	local greatest = {{nil},0}
	for i,v in ipairs(mostFrequent) do
		if v > greatest[2] then
			greatest = {{i},v}
		end
		if v == greatest[2] then
			table.insert(greatest[1],i)
		end
	end
	return dupe(greatest[1])
end

function MathFunctions.mad(x)
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	local avg = 0
	local s = pcall(function()
		for i,v in ipairs(x) do
			avg += v/#x
		end
	end)
	
	if not s then return warn("Make sure all values in the table are numbers") end
	local s = 0
	for i=1,#x do
		s += math.abs(x[i]-avg)
	end
	return s/#x
end

function MathFunctions.avg(x)
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	local avg = 0
	
	local s = pcall(function()
		for i,v in ipairs(x) do
			avg += v/#x
		end
	end)
	if not s then return warn("Make sure all values in the table are numbers") end
	return avg
end

function MathFunctions.zscore(x,PopulationToggle)
	if PopulationToggle == nil then PopulationToggle = false end
	if typeof(x) ~= 'table' then return warn("Make sure parameter 1 is a table") end
	if typeof(PopulationToggle) ~= 'boolean' and PopulationToggle ~= nil then return warn("Make sure parameter 2 is set to nil or a boolean") end
	
	local newt = {}
	local sd = MathFunctions.sd(x,PopulationToggle)
	local mean = MathFunctions.avg(x)
	for i,v in ipairs(x) do
		newt[tostring(v)] = (v-mean)/sd
	end
	return newt
end

function MathFunctions.linreg(...)
	local t = table.pack(...)
	local FunctionToggle = true
	if typeof(t[#t]) == 'boolean' then FunctionToggle = t[#t] table.remove(t,#t) end
	local x,y = {},{}
	for i,v in ipairs(t) do
		if tonumber(i) and i ~= 'n' then
			table.insert(x,v[1])
			table.insert(y,v[2])
		end
	end
	local xysum = 0
	for i=1,#x do
		xysum += (x[i]-MathFunctions.avg(x))*(y[i]-MathFunctions.avg(y))
	end
	local xsum,ysum = 0,0
	for i=1,#x do
		xsum += (x[i]-MathFunctions.avg(x))^2
	end
	for i=1,#x do
		ysum += (y[i]-MathFunctions.avg(y))^2
	end
	local r = xysum/math.sqrt(math.abs(xsum*ysum))
	local slope = r*(MathFunctions.sd(y)/MathFunctions.sd(x))
	local yint = MathFunctions.avg(y)-slope*MathFunctions.avg(x)
	if FunctionToggle then
		return function(x1) return slope*x1+yint end, r
	else
		return slope,yint , r
	end
	
end

function MathFunctions.nCr(n,r)
	local t = 1
	for i=n,r+1,-1 do
		t *= i
	end
	local d = 1
	for i=1,n-r do
		d *= i
	end
	return t/d
end

function MathFunctions.nPr(n,r)
	local t = 1
	for i=n,n-r+1,-1 do
		t *= i
	end
	return t
end

function MathFunctions.pascalstri(row)
	local t = {}
	for i=0,row do
		t[i] = MathFunctions.nCr(row,i)
	end
	return t
end


-- Miscellaneous

function MathFunctions.gcd(a,b)
	if typeof(a) ~= 'number' and typeof(b) ~= 'number' then return warn("Make sure parameter 1 and 2 are both numbers") end 
	if typeof(a) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(b) ~= 'number' then return warn("Make sure parameter 2 is a number") end 
	if b ~= 0 then
		return MathFunctions.gcd(b, a % b)
	else
		return math.abs(a)
	end
end

function MathFunctions.lcm(a,b)
	if typeof(a) ~= 'number' and typeof(b) ~= 'number' then return warn("Make sure parameter 1 and 2 are both numbers") end 
	if typeof(a) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(b) ~= 'number' then return warn("Make sure parameter 2 is a number") end 
	return math.abs(a*b)/MathFunctions.gcd(a,b)
end

function MathFunctions.floor(x,NearestDecimal)
	if NearestDecimal == nil then NearestDecimal = 0 end
	if typeof(x) ~= 'number' and typeof(NearestDecimal) ~= 'number' then return warn("Make sure parameter 1 and 2 are both numbers") end 
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(NearestDecimal) ~= 'number' then return warn("Make sure parameter 2 is a number") end 
	return math.floor(x*10^NearestDecimal)/10^NearestDecimal
end

function MathFunctions.round(x,NearestDecimal)
	if NearestDecimal == nil then NearestDecimal = 0 end
	if typeof(x) ~= 'number' and typeof(NearestDecimal) ~= 'number' then return warn("Make sure parameter 1 and 2 are both numbers") end 
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(NearestDecimal) ~= 'number' then return warn("Make sure parameter 2 is a number") end 
	return math.round(x*10^NearestDecimal)/10^NearestDecimal
end

function MathFunctions.ceil(x,NearestDecimal)
	if NearestDecimal == nil then NearestDecimal = 0 end
	if typeof(x) ~= 'number' and typeof(NearestDecimal) ~= 'number' then return warn("Make sure parameter 1 and 2 are both numbers") end 
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(NearestDecimal) ~= 'number' then return warn("Make sure parameter 2 is a number") end 
	return math.ceil(x*10^NearestDecimal)/10^NearestDecimal
end

function MathFunctions.factors(x)
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	local t = {}
	for i=1,x^.5 do
		if x%i == 0 then
			table.insert(t,i)
			table.insert(t,x/i)
		end
	end
	table.sort(t,function(a,b)
		return a < b
	end)
	return dupe(t)
end

function MathFunctions.iteration(Input,Iterations,Func)

	if typeof(Index) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(Iterations) ~= 'number' then return warn("Make sure parameter 2 is a number") end 
	if Iterations%1 ~= 0 then return warn("Make sure parameter 2 is an integer") end 
	if typeof(Func) ~= 'function' then return warn("Make sure parameter 3 is a function") end 

	local new = Input
	for i=1,Iterations do
		new = Func(new)
	end
	return math.round(new*10e11)/10e11
end

function MathFunctions.nthroot(x,Index)
	return x^(1/Index)
end



function MathFunctions.lucas(x)
	return (((1+math.sqrt(5))/2)^x-((1-math.sqrt(5))/2)^x)/math.sqrt(5)+(((1+math.sqrt(5))/2)^(x-2)-((1-math.sqrt(5))/2)^(x-2))/math.sqrt(5)
end


-- Useless

function MathFunctions.digitadd(x)
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if x%1 ~= 0 then return warn("Make sure parameter 1 is an integer") end 
	
	local t = string.split(x,'')
	local s = 0
	for i,v in ipairs(t) do
		s += v
	end
	return s
end

function MathFunctions.digitmul(x)
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if x%1 ~= 0 then return warn("Make sure parameter 1 is an integer") end 
	local t = string.split(x,'')
	local s = 1
	for i,v in ipairs(t) do
		s *= v
	end
	return s
end

function MathFunctions.digitrev(x)
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if x%1 ~= 0 then return warn("Make sure parameter 1 is an integer") end 
	local strin = string.split(tostring(x),'')
	local newt = {}
	for i,v in ipairs(strin) do
		newt[#strin-i+1] = v
	end
	return tonumber(table.concat(newt,''))
end

-- Formatting

function MathFunctions.primeFactor(x,t)
	local finalnums = {}
	local newNum = x
	while true do
		if #MathFunctions.factors(newNum) <= 2 then break end
		for i = 2,newNum^.5 do
			if newNum%i == 0 then
				if #MathFunctions.factors(i) == 2 then
					table.insert(finalnums,i)
					newNum = newNum/i
				end
			end
		end
	end
	if newNum ~= 1 then
		table.insert(finalnums,newNum)
	end
	if t then
		return finalnums
	end
	local newT = {}

	for i,v in pairs(finalnums) do
		if newT[v] ~= nil then
			newT[v] += 1
		else
			newT[v] = 1
		end
	end
	local newnewT = {}
	for i,v in pairs(newT) do
		table.insert(newnewT,{i,v})
	end
	return newnewT
end

function MathFunctions.toComma(x)
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	local neg = false
	if x < 1000 and x > -1000 then return tostring(x) end
	if x < 0 then x = math.abs(x) neg = true end
	local nums = string.split(x,'')
	local num = ''
	local digits = math.floor(math.log10(x))+1
	for i,v in ipairs(nums) do
		if (digits-i)%3 == 0 and digits-i ~= 0 then
			num ..= v..','
		else
			num ..= v
		end
	end
	if neg then return '-'..num end 
	return num
end

function MathFunctions.fromComma(x)
	if typeof(x) ~= 'string' then return warn("Make sure parameter 1 is a string") end 
	local a = string.gsub(x,',','')
	return a
end

function MathFunctions.toKMBT(x,NearestDecimal)
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if x < 1000 and x > -1000 then return tostring(x) end
	local neg = false
	if  x < 0 then
		neg = true
		x = math.abs(x)
	end
	if NearestDecimal == nil then NearestDecimal = 15 end 
	local list = {'','K','M','B','T','Qa','Qi','Sx','Sp','Oc','No','Dc','Udc','Ddc','Tdc'}
	local digits = math.floor(math.log10(x))+1
	local suffix = list[math.floor((digits-1)/3)+1]
	if neg then return '-'..math.floor((x/(10^(3*math.floor((digits-1)/3))))*10^NearestDecimal)/10^NearestDecimal .. suffix end
	return math.floor((x/(10^(3*math.floor((digits-1)/3))))*10^NearestDecimal)/10^NearestDecimal .. suffix
end

function MathFunctions.fromKMBT(x)
	if typeof(x) ~= 'string' then return warn("Make sure parameter 1 is a string") end 
	if tonumber(x) then return x end
	local list = {'','K','M','B','T','Qa','Qi','Sx','Sp','Oc','No','Dc','Udc','Ddc','Tdc'}
	local neg = string.find(x,'-') ~= nil
	local splits = string.split(x,'')
	local letter = splits[string.find(x,'%a')]
	local factor = 10^((table.find(list,letter)-1)*3)
	if neg then return tonumber('-'..string.split(x,letter)[1]*factor) end
	return string.split(x,letter)[1]*factor
end

function MathFunctions.toScientific(x,Base)
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(Base) ~= 'number' and Base ~= nil then return warn("Make sure parameter 2 is a number or nil") end 
	local neg = false
	if x < 0 then neg = true x = math.abs(x) end
	if Base == nil then Base = 10 end
	local power = math.floor(math.log(x,Base))
	local constant = x/Base^power
	if neg then return -constant..' * ' ..Base..'^'.. power end
	return constant..' * ' ..Base..'^'.. power
end

function MathFunctions.fromScientific(x)
	if typeof(x) ~= 'string' then return warn("Make sure parameter 1 is a string") end 
	local constant = tonumber(string.split(x,'*')[1])
	local base = tonumber(string.split(string.split(x,'*')[2],'^')[1])
	local power = tonumber(string.split(string.split(x,'*')[2],'^')[2])
	return constant*base^power
end
function MathFunctions.toNumeral(x)
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	local numberMap = {
		{1000, 'M'},
		{900, 'CM'},
		{500, 'D'},
		{400, 'CD'},
		{100, 'C'},
		{90, 'XC'},
		{50, 'L'},
		{40, 'XL'},
		{10, 'X'},
		{9, 'IX'},
		{5, 'V'},
		{4, 'IV'},
		{1, 'I'}

	}
		local roman = ""
		while x > 0 do
			for index,v in ipairs(numberMap)do 
				local romanChar = v[2]
				local int = v[1]
				while x >= int do
					roman = roman..romanChar
					x -= int
				end
			end
		end
		return roman
end

function MathFunctions.fromNumeral(x)
	if typeof(x) ~= 'string' then return warn("Make sure parameter 1 is a string") end 
	local decimal = 0
	local num = 1
	local numeralLength = string.len(x)
	local numberMap = {
		['M'] = 1000,
		['D'] = 500,
		['C'] = 100,
		['L'] = 50,
		['X'] = 10,
		['V'] = 5,
		['I'] = 1
	}
	for char in string.gmatch(tostring(x),'.') do
		local ifString = false
		for i, v in ipairs(numberMap) do
			if char == i then ifString = true end
		end
		if ifString == false then return warn("Check if you're only using characters (M,D,C,L,X,V,I)") end
	end
	while num < numeralLength do
		local Z1 = numberMap[string.sub(x, num, num)]
		local Z2 = numberMap[string.sub(x, num + 1, num + 1)]
		if Z1 < Z2 then
			decimal += (Z2 - Z1)
			num += 2
		else
			decimal += Z1
			num += 1
		end
	end
	if num <= numeralLength then decimal += numberMap[string.sub(x, num, num)] end
	return decimal
end

function MathFunctions.toPercent(x,NearestDecimal)
	if NearestDecimal == nil then NearestDecimal = 15 end
	if typeof(x) ~= 'number' and typeof(NearestDecimal) ~= 'number' then return warn("Make sure parameter 1 and 2 are both numbers") end 
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(NearestDecimal) ~= 'number' then return warn("Make sure parameter 2 is a number") end 
	return math.round(x*100*10^NearestDecimal)/10^NearestDecimal
end

function MathFunctions.fromPercent(x)
	if typeof(x) ~= 'string' then return warn("Make sure parameter 1 is a string") end 
	local n
	local s = pcall(function()
		n = string.split(x,'%')[1]
	end)
	if not s then return warn('Make sure parameter 1 is in the form "N%"') end
	return n/100
end

function MathFunctions.toFraction(x,MixedToggle)
	if MixedToggle == nil then MixedToggle = false end
	if typeof(x) ~= 'number' and typeof(MixedToggle) ~= 'boolean' then return warn("Make sure parameter 1 is a number and parameter 2 is a boolean") end 
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(MixedToggle) ~= 'boolean' then return warn("Make sure parameter 2 is a boolean") end 
	local neg = 1
	if x < 0 then
		x = math.abs(x)
		neg = -1
	end
	
	local whole,number = math.modf(x)
	if not string.find(tostring(number),'e') then
		number = math.round(number*1e13)/1e13
	end
	local factor = 1
	local function getNum(x)
		return string.split(tostring(x),'.')[2]
	end
	if number < 1/20001 and number ~= 0 then
		if string.find(tostring(number),'e') then
			number,factor = tonumber(string.split(tostring(number),'e')[1])/10,10^(-tonumber(string.split(tostring(number),'e')[2])-1)
		else
			factor =  10^(#getNum(number)-1)
			number = factor*number 
		end
	else
		number = math.round(number*1e13)/1e13
		
	end
	local a,b,c,d,e,f = 0,1,1,1,nil,nil
	for i=1,20000 do
		e = a+c
		f = b+d
		if e/f < number then
			a=e
			b=f
		elseif e/f > number then
			c=e
			d=f
		else
			break
		end
	end
	if x%1 == 0 then e -= 1 end
	local gcd = MathFunctions.gcd((e+(f*whole)),f)
	if string.find(factor,'e') then
		local pow = math.floor(math.log10(f))
		local newNum = f/10^pow
		local ePow = string.split(factor,'e')[2]
		local newString = newNum..'e'..ePow+pow
		if MixedToggle then
			return neg*whole.. ' '..e..'/'..newString
		else
			return (neg*((e)+(f*whole*factor)))/gcd..'/'..newString
		end
	end
	if MixedToggle then
		return neg*whole.. ' '..e..'/'..f*factor
	else
		return (neg*((e)+(f*whole*factor)))/gcd..'/'..f*factor/gcd
	end
end

function MathFunctions.fromFraction(x)
	if typeof(x) ~= 'string' then return warn("Make sure parameter 1 is a string") end 
	local mixed = false
	local whole
	local s = pcall(function()
		whole = string.split(x,' ')[1]
		mixed = whole ~= x
		if not mixed then whole = 0 end
	end)
	if not s then whole = 0 end
	local num,denom
	local s = pcall(function()
		num,denom = string.split(x,'/')[1],string.split(x,'/')[2]
		if mixed then num = string.split(string.split(x,'/')[1],' ')[2] end
	end)
	if not s then return warn('Make sure parameter 1 is a string in the form of "A B/C" or A/B') end 
	return whole + num/denom
end

function MathFunctions.toTime(x,AMPMToggle)
	if AMPMToggle == nil then AMPMToggle = false end
	if typeof(x) ~= 'number' and typeof(AMPMToggle) ~= 'boolean' then return warn("Make sure parameter 1 is a number from 0-24 and parameter 2 is a boolean") end 
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number from 0-24") end 
	if typeof(AMPMToggle) ~= 'boolean' then return warn("Make sure parameter 2 is a boolean") end 
	local hour = math.floor(x)
	local leftover = x-hour
	local minute = math.floor(leftover*60)
	local second = math.round((leftover*60-minute)*60)
	if not AMPMToggle then
		return add0(hour)..':'..add0(minute)..':'..add0(second)
	else
		if hour >= 13 then
			return add0(hour-12)..':'..add0(minute)..':'..add0(second).. ' PM'
		elseif hour == 0 then
			return 12 ..':'..add0(minute)..':'..add0(second).. ' AM'
		else
			
			return add0(hour)..':'..add0(minute)..':'..add0(second).. ' AM'
		end
	end
end

function MathFunctions.fromTime(x)
	if typeof(x) ~= 'string' then return warn("Make sure parameter 1 is a string") end 
	local am = string.find(x,'AM')
	local pm = string.find(x,'PM')
	local twoletter
	local ampm = false
	if am ~= nil then
		ampm = true
		twoletter = 'AM'
	elseif pm ~= nil then
		ampm = true
		twoletter = 'PM'
	end
	local hours, minutes, seconds = string.split(x,':')[1],string.split(x,':')[2],string.split(string.split(x,':')[3],' ')[1]
	
	
	if twoletter then
		if twoletter == 'AM' then
			if tonumber(hours) == 12 then
				return hours-12 + minutes/60 + seconds/3600
			end
			return hours + minutes/60 + seconds/3600
		else
			tonumber(hours)
			if tonumber(hours) < 12 then
				return hours+12 + minutes/60 + seconds/3600
			else
				return hours + minutes/60 + seconds/3600
			end
		end
	else
		return hours + minutes/60 + seconds/3600
	end
end

function MathFunctions.toBase(x,Base,CurrentBase)

	if typeof(Base) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(CurrentBase) ~= 'number' then return warn("Make sure parameter 1 is a number") end 

	x = string.upper(x)
	local digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local function baseToDecimal(n1,b1)
		local nums = string.split(tostring(n1),'')
		for i,v in ipairs(nums) do
			if tonumber(v) == nil then
				local digits2 = string.split(digits,'')
				nums[i] = table.find(digits2,v)-1
			else
				local digits2 = string.split(digits,'')
				nums[i] = table.find(digits2,v)-1
			end
		end
		local sum = 0
		for i,v in ipairs(nums) do
			sum += (v*(b1^(#nums-i)))
		end
		return sum
	end
	if CurrentBase ~= 10 then
		x = baseToDecimal(x,CurrentBase)
	end
	x = math.floor(x)
	if not Base or Base == 10 then return tostring(x) end
	
	local t = {}
	local sign = ""
	if x < 0 then
		sign = "-"
		x = -x
	end
	repeat
		local d = (x % Base) + 1
		x = math.floor(x / Base)
		table.insert(t, 1, digits:sub(d,d))
	until x == 0
	return sign .. table.concat(t,"")
end
function MathFunctions.toFahrenheit(x)
	return 9*x/5 + 32
end


function MathFunctions.toCelsius(x)
	return 5*(x-32)/9
end

-- Algebra


function MathFunctions.solver(f1,f2) 
	local iterations = 1e3
	local t: {number} = {}
	for i = -20, 20, .1 do
		table.insert(t, i)
	end
	if f2 == nil then f2 = 0 end
	if typeof(f2) ~= 'function' then local a = f2 f2 = function(x) return a end end
	if typeof(f1) ~= 'function' then local b = f1 f1 = function(x) return b end end
	local f = function(x)
		return f1(x)-f2(x)
	end
	for ii = 1, iterations do
		for i, a in ipairs(t) do
			local fa = f(a)
			local num = a - 1e-5*fa / (f(a + 1e-5) - fa)
			local num2 = math.round(num*1e14)/1e14
			t[i] = if string.lower(tostring(num2)) == 'nan' then math.huge else if ii == iterations then num2 else num
		end
	end
	local bl = {}
	local n = {}
	for _, v in ipairs(t) do
		local num: number = math.round(v*1e7)/1e7
		if not bl[num] then
			bl[num] = true
			if math.floor(v*1e7)/1e7 == 0 then
				table.insert(n, 0)
			else
				table.insert(n, math.round(v*1e13)/1e13)
			end
			
		end
	end
	table.sort(n)
	return n
end




-- Calculus

function MathFunctions.derivative(x,Function)
	if typeof(Function) ~= 'function' then return warn("Make sure parameter 2 is a function") end 
	return (Function(x+1e-12)-Function(x))/1e-12
end

function MathFunctions.integral(Lower,Upper,Function)
	if type(Lower) ~= 'number' then return warn("Make sure parameter 1 is a number") end
	if type(Upper) ~= 'number' then return warn("Make sure parameter 2 is a number") end
	if type(Function) ~= 'function' then return warn("Make sure parameter 3 is a function") end
	local sum = 0
	local h = (Upper - Lower) / 1e3
	for i = 0, 1e3-1 do
		local x = Lower + i * h + h / 2
		sum = sum + Function(x) * h
	end

	return sum
end

function MathFunctions.limit(x,Function)
	if typeof(x) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(Function) ~= 'function' then return warn("Make sure parameter 2 is a function") end 
	return math.floor(Function(x+1e-13)*10^12)/10^12
end

function MathFunctions.summation(Start,Finish,Function)
	if Function == nil then
		Function = function(x)
			return x
		end
	end
	if typeof(Start) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(Finish) ~= 'number' then return warn("Make sure parameter 2 is a number") end 
	if typeof(Function) ~= 'function' then return warn("Make sure parameter 3 is a function") end 
	local sum = 0
	for i=Start,Finish do
		sum += Function(i)
	end
	return sum
end

function MathFunctions.product(Start,Finish,Function)
	if typeof(Start) ~= 'number' then return warn("Make sure parameter 1 is a number") end 
	if typeof(Finish) ~= 'number' then return warn("Make sure parameter 2 is a number") end 
	if typeof(Function) ~= 'function' then return warn("Make sure parameter 3 is a function") end 
	local sum = 0
	for i=Start,Finish do
		sum *= Function(i)
	end
	return sum
end



--Consants
MathFunctions.e = math.exp(1)
MathFunctions.g = 9.807
MathFunctions.G = 6.674 * 10^-11
MathFunctions.phi = (1 + 5^.5)/2

--Physics

function MathFunctions.maxHeight(v,theta)
	return (v*math.sin(theta))^2/(2*MathFunctions.g)
end

function MathFunctions.travelTime(v,theta)
	return (2*v*math.sin(theta))/(MathFunctions.g)
end

function MathFunctions.travelDistance(v,theta)
	return (v^2*math.sin(2*theta))/(MathFunctions.g)
end

function MathFunctions.gravitationalForce(mass1,mass2,rad)
	return MathFunctions.G*mass1*mass2/rad^2
end

function MathFunctions.centripetalForce(mass,v,rad)
	return mass*v^2/rad
end

local mt = {}

MathFunctions.Complex = {}

local Complex = MathFunctions.Complex
local private = {}
Complex.i = setmetatable({0,1}, mt)
local i = Complex.i
function Complex.toString(c)

	if c[2] == 0 then
		return c[1]
	elseif c[1] == 0 then
		if c[2] == 1 then
			return 'i'
		elseif c[2] == -1 then
			return '-i'
		end
		return c[2]..'i'

	elseif c[2] < 0 then
		if c[2] == -1 then
			return c[1]..'-i'
		end
		return c[1] .. c[2] ..'i'
	else 
		if c[2] == 1 then
			return c[1]..'+i'
		end
		return c[1].. '+' .. c[2]..'i'
	end
end

function Complex.toArray(c)
	if tonumber(c) ~= nil then return {c,0} end
	local r,i
	local n = false
	if #string.split(c,'-') > 1 and string.split(c,'-')[1] ~= '' then 
		r = string.split(c,'-')[1]
		i = string.split(c,'-')[2]
		n = true 
	elseif string.split(c,'+')[1] == c and string.split(c,'-')[1] == c or string.split(c,'+')[1] == '' then
		r = 0
		if string.split(c,'+')[1] == c and string.split(c,'-')[1] ~= c then
			i = string.split(c,'-')[1]
			n = true
		elseif string.split(c,'-')[1] == c and string.split(c,'+')[1] ~= c then
			i = string.split(c,'+')[1]
		else
			i=1
		end
	
	elseif string.split(c,'+')[1] ~= c and string.split(c,'+')[2] ~= c then
		r = string.split(c,'+')[1]
		i = string.split(c,'+')[2]
	else 
		r = 0
		i = string.split(c,'-')[2]
		n = true 
	end
	local a,_ = string.gsub(i,'i','')
	a = a == '' and 1 or a
	local factor = n and -1 or 1
	return {tonumber(r),tonumber(a*factor)}
end

function private.add(...)

	local t = table.pack(...)
	
	local total = t[1]
	if typeof(total) == 'number' then total = {total,0} end

	local nex = t[2]
	for i,v in ipairs(t) do


		if typeof(nex) == 'number' then nex = {nex,0} end
		if i == #t then break end
		total = {total[1]+nex[1] , total[2]+nex[2]}
		
		pcall(function()
			nex = t[i+2]
		end)
	end
	return setmetatable(total,mt)
end

function private.mul(...)
	local t = table.pack(...)
	local total = t[1]

	if typeof(total) == 'number' then total = {total,0} end
	local nex = t[2]
	for i,v in ipairs(t) do

		if typeof(nex) == 'number' then nex = {nex,0} end
		if i == #t then break end
		total = {total[1]*nex[1]-total[2]*nex[2] , total[1]*nex[2]+nex[1]*total[2]}

		pcall(function()
			nex = t[i+2]
		end)
	end

		return setmetatable(total,mt)
end

function private.div(c1,c2)
	if typeof(c1) == 'number' then c1 = {c1,0} end
	if typeof(c2) == 'number' then c2 = {c2,0} end
	local a,b,c,d = c1[1],c1[2],c2[1],c2[2]

	return setmetatable({(a*c+b*d)/(c^2+d^2) , (b*c-a*d)/(c^2+d^2)},mt)
end
function Complex.pow(c1,c2)
	local function pow(c3,Power)
		local distance2 = math.sqrt(c3[1]^2+c3[2]^2)
		local add = c3[1] >= 0 and 0 or 1
		local theta2 = (math.atan(c3[2]/c3[1])+add*math.pi)

		local r = math.round((math.cos(theta2*Power)*distance2^Power)*10e13)/10e13
		local i = math.round((math.sin(theta2*Power)*distance2^Power)*10e13)/10e13
		return {r,i}
	end

	if typeof(c1) == 'number' then c1 = {c1,0} end
	if typeof(c2) == 'number' then c2 = {c2,0} end
	local a,b,c,d = c1[1],c1[2],c2[1],c2[2]
	local first = pow({a,b},c)
	local dist,theta = Complex.toPolar(c1)
	local toI = private.mul({math.cos(math.log(dist)),math.sin(math.log(dist))},{math.exp(1)^-theta,0})
	local second = pow(toI,d)
	local final = private.mul(first,second)
	return setmetatable(final,mt)
end
function Complex.exp(x)
	if tonumber(x) then return math.exp(x) end
	return setmetatable(Complex.pow(math.exp(1),x),mt) 
end
function Complex.max(x,y)
	local a = Complex.abs(x)
	local b = Complex.abs(y)
	if a > b then return x else return y end 
end

function Complex.min(x,y)
	local a = Complex.abs(x)
	local b = Complex.abs(y)
	if a < b then return x else return y end 
end

-- Complex
function Complex.cosh(x)

	return setmetatable(private.div(private.add(Complex.pow(math.exp(1),x),Complex.pow(math.exp(1),-x)),2),mt)
end

function Complex.sinh(x)

	return setmetatable(private.div(private.add(Complex.pow(math.exp(1),x),private.mul(-1,Complex.pow(math.exp(1),{-x[1],-x[2]}))),2),mt)
end

function Complex.tanh(x)

	return setmetatable(private.div(Complex.sinh(x),Complex.cosh(x)),mt)
end

function Complex.toPolar(c1,StringFormat)
	if StringFormat == nil then StringFormat = false end
	if typeof(c1) == 'number' then c1 = {c1,0} end

	if typeof(StringFormat) ~= 'boolean' then return warn("Make sure parameter 2 is a boolean or nil") end 
	local distance = math.sqrt(c1[1]^2+c1[2]^2)
	local theta = math.atan(c1[2]/c1[1])
	local add = c1[1] < 0 and math.pi or c1[2] < 0 and 2*math.pi or 0
	if theta+add > math.pi then
		add -= 2*math.pi
	end
	if StringFormat then
		return distance .. 'e^'..theta+add..'i'
	else
		return distance,theta+add
	end
end

function Complex.fromPolar(distance,theta)
	return setmetatable({math.cos(theta)*distance,math.sin(theta)*distance},mt)
end

function Complex.Re(x)

	return setmetatable({x[1],0},mt)
end

function Complex.Im(x)

	return setmetatable({0,x[2]},mt)
end

function Complex.log(arg,base)
	if base == nil then base = math.exp(1) end
	if tonumber(arg) and arg > 0 then return math.log(arg,base) end
	local function ln(c)
		return {math.log(math.sqrt(c[1]^2+c[2]^2)),math.atan(c[2]/c[1])}
	end
	local a
	if typeof(arg) == 'number' and typeof(base) == 'number' then
		if arg > 0 and base > 0 then
			
			a = {math.log(arg,base),0}
		elseif arg > 0 and base < 0 then
			a = private.div(math.log(arg),{math.log(-base),math.pi})
		elseif arg < 0 and base > 0 then
			a = private.div({math.log(-arg),math.pi},math.log(base))
		elseif arg < 0 and base < 0 then
			a = private.div({math.log(-arg),math.pi},{math.log(-base),math.pi})

		end
	else
		local num = typeof(arg) == 'number' and Complex.log(arg,math.exp(1)) or ln(arg)
		local denom = typeof(base) == 'number' and Complex.log(base,math.exp(1)) or ln(base)
		a = private.div(num,denom)
	end
	return setmetatable(a,mt)
end

function Complex.sin(x)

	if typeof(x) == 'number' then return setmetatable({math.sin(x),0},mt) end
	local a,b = x[1],x[2]
	local ans = {math.sin(a)*math.cosh(b),math.cos(a)*math.sinh(b)}
	return setmetatable(ans,mt)
end
function Complex.abs(x)
	if typeof(x) == 'number' then return math.abs(x) end
	return math.sqrt(x[1]^2+x[2]^2)
end
function Complex.sqrt(x)
	if tonumber(x) then return x^.5 end
	return setmetatable(Complex.pow(x,.5),mt)
end

function Complex.asin(x)
	if typeof(x) == 'number' then x = {x,0} end
	if x[1] > -1 and x[1] < 1 and x[2] == 0 then return {math.asin(x[1]),0} end
	local a,b = x[1],x[2]
	local z2 = private.mul(-1,Complex.pow(x,2))
	local sqrt = Complex.pow(private.add(1,z2),.5)
	local insideLn = private.add({-b,a},sqrt)
	local log = Complex.log(insideLn,math.exp(1))
	local ans = private.mul({0,-1},log)
	return setmetatable(ans,mt)
end

function Complex.cos(x)
	if typeof(x) == 'number' then return setmetatable({math.cos(x),0},mt) end
	local positiveTheta = Complex.pow(math.exp(1),private.mul(i,x))
	local negativeTheta = Complex.pow(math.exp(1),private.mul(i,{-x[1],-x[2]}))
	local sum = private.add(positiveTheta,negativeTheta)
	local ans = private.div(sum,2)
	return setmetatable(ans,mt)
end

function Complex.acos(x)
	if typeof(x) == 'number' then x = {x,0} end
	local a,b = x[1],x[2]
	local z2 = Complex.pow(x,2)
	local sqrt = Complex.pow(private.add(-1,z2),.5)
	local insideLn = private.add(x,sqrt)
	local log = Complex.log(insideLn,math.exp(1))
	local ans = private.mul({0,-1},log)
	return setmetatable(ans,mt)
end

function Complex.tan(x)
	
	local ans = private.div(Complex.sin(x),Complex.cos(x))
	return setmetatable(ans,mt)
end

function Complex.atan(x)
	if typeof(x) == 'number' then return {math.atan(x),0} end
	if x[2] == nil or x[2] == 0 then return {math.atan(x[1]),0} end
	local a,b = x[1],x[2]
	local ln1 = Complex.log({b+1,-a},math.exp(1))
	local ln2 = private.mul(-1,Complex.log({-b+1,a},math.exp(1)))
	local sum = private.add(ln1,ln2)
	local ans = private.mul({0,.5},sum)
	ans[1] += math.pi/2
	return setmetatable(ans,mt)
end

function Complex.mandelbrot(x,Power)
	if Power == nil then Power = 2 end
	if typeof(Power) ~= 'number' then return warn("Make sure parameter 2 is a number") end 
	local squ = {0,0}
	local function pow(t,p)
		local start1 = {1,0}
		for i=1,p do
			start1 = private.mul(start1,t)
		end
		return start1
	end

	for i=1,250 do
		squ = private.add(pow(squ,Power),x)
		if squ[1]^2+squ[2]^2 > 4 then return false end
	end
	return true
end

function it(x, w_initial, max_iters)
	local w = w_initial
	local i

	local result = {}
	local a
	for i = 0, max_iters - 1 do
		a = i
		local tol
		local e = Complex.exp(w)
		local p = w + 1.0
		local t = w * e - x

		if Complex.abs(w) > 0 then
			t = (t / p) / e
			-- Newton iteration
		else
			t = t / (e * p - 0.5 * (p + 1.0) * t / p)
			-- Halley iteration
		end

		w = w - t

		tol = GSL_DBL_EPSILON * Complex.max(Complex.abs(w), 1.0 / (Complex.abs(p) * e))
		if Complex.abs(t) < Complex.abs(tol) then
			return w
		end
	end
end
function MathFunctions.lambert_w0(x)
	local one_over_E = 1.0 / Complex.exp(1)
	local q = x + one_over_E

	local result

	if x == 0.0 then
		result = 0.0
		return result
	elseif Complex.abs(q) < 0.0 then
		result = -1.0
		return result
	elseif Complex.abs(q) == 0.0 then
		result = -1.0
		return result
	elseif Complex.abs(q) < 1.0e-03 then
		local r = Complex.sqrt(q)
		result = series_eval(r)
		return result
	else
		local maxit = 100
		local w

		if Complex.abs(x) < 1.0 and tonumber(x) > -one_over_E then
			local p = Complex.sqrt(2.0 * Complex.exp(1) * q)
			w = -1.0 + p * (1.0 + p * (-1.0 / 3.0 + p * 11.0 / 72.0))
		else
			w = Complex.log(x)
			if Complex.abs(x) > 3.0 then
				w = w - Complex.log(w)
			end
		end

		return it(x, w, maxit)
	end
end

function MathFunctions.lambert_wm1(x)
	local result

	if x > 0.0 then
		return math.log(-1)
	elseif x == 0.0 then
		result = 0.0
		return result
	else
		local maxit = 32
		local one_over_E = 1.0 / math.exp(1)
		local q = x + one_over_E
		local w

		if q < 0.0 then

			return math.log(-1)
		end

		if x < -1.0e-6 then
			local r = -math.sqrt(q)
			w = series_eval(r)
			if q < 3.0e-3 then
				result = w
				return result
			end
		else
			w = -1.0
		end

		return it(x, w, maxit)
	end
end

function MathFunctions.vertex(a,b,c)
	return -b/(2*a),-b^2/(4*a)+c
end


function MathFunctions.fibonacci(x)
	local term1 = private.add(Complex.pow((1+math.sqrt(5))/2,x),private.mul(-1,Complex.pow((1-math.sqrt(5))/2,x)))
	if x%1 == 0 then
		return setmetatable({math.floor(private.div(term1,math.sqrt(5))[1]),0},mt)
	else
		return setmetatable({math.round(private.div(term1,math.sqrt(5))[1]*1e10)/1e10,(private.div(term1,math.sqrt(5))[2]*1e10)/1e10},mt)

	end
end

function MathFunctions.tetration(x,Iteration)
	if Iteration == math.huge then
		local a = MathFunctions.solver(function(xx) return xx^(1/xx) end,x)
		local newt = {}
		for i,v in pairs(a) do
			if not tostring(v):find('inf') then
				table.insert(newt,v)
			end
		end
		return newt[1]
	end
	local div = false
	pcall(function()
		if x < 0 then x = math.abs(x) div = true end
	end)
	local n = x
	for i=1,Iteration-1 do
		n = x^n
	end
	if div then return 1/n end
	return n
end


function MathFunctions.gamma(x)
	if tonumber(x) then
		if x < 0 and math.floor(x) == x then
			return setmetatable({math.huge, 0}, mt)
		end
				x = {x,0}
		end
		local function t(x)
			local t1, t2
			if x[1] < 0.5 then
				t1, t2 = t({1 - x[1], -x[2]})
				if t2 == 0 then
				t1 = math.pi / (Complex.sin(math.rad(180 * x[1]))[1] * t1)
				else
				local t3, t4 = unpack(Complex.exp(setmetatable({math.pi * x[2], -math.pi * x[1]}, mt)))
					t3, t4 = t4 / -2, t3 / 2
					local t5, t6 = unpack(Complex.exp(setmetatable({-math.pi * x[2], math.pi * x[1]}, mt)))
					t3, t4 = t3 + t6 / 2, t4 + t5 / -2
					t1, t2 = t3 * t1 - t4 * t2, t3 * t2 + t4 * t1
					t1, t2 = math.pi * t1 / (t1 ^ 2 + t2 ^ 2), -math.pi * t2 / (t1 ^ 2 + t2 ^ 2)
				end
			else
				if x[2] == 0 then
					if x[1] > 142 then
						t1 = math.huge
				else
					t1 = 2.5066282746310002 * Complex.exp((x[1] - 0.5) * Complex.log(x[1] + 6.5)) * Complex.exp(-x[1] - 6.5) * (0.99999999999980993 + 676.5203681218851 / x[1] + -1259.1392167224028 / (x[1] + 1) + 771.32342877765313 / (x[1] + 2) + -176.61502916214059 / (x[1] + 3) + 12.507343278686905 / (x[1] + 4) + -0.13857109526572012 / (x[1] + 5) + 9.9843695780195716e-6 / (x[1] + 6) + 1.5056327351493116e-7 / (x[1] + 7))
						if x[1] % 1 == 0 then
							t1 = math.round(t1)
						end
					end
					t2 = 0
				else
					t1, t2 = 0.99999999999980993, 0
					t1, t2 = t1 + 676.5203681218851 * x[1] / (x[1] ^ 2 + x[2] ^ 2), t2 + -676.5203681218851 * x[2] / (x[1] ^ 2 + x[2] ^ 2)
					t1, t2 = t1 + -1259.1392167224028 * (x[1] + 1) / ((x[1] + 1) ^ 2 + x[2] ^ 2), t2 + 1259.1392167224028 * x[2] / ((x[1] + 1) ^ 2 + x[2] ^ 2)
					t1, t2 = t1 + 771.32342877765313 * (x[1] + 2) / ((x[1] + 2) ^ 2 + x[2] ^ 2), t2 + -771.32342877765313 * x[2] / ((x[1] + 2) ^ 2 + x[2] ^ 2)
					t1, t2 = t1 + -176.61502916214059 * (x[1] + 3) / ((x[1] + 3) ^ 2 + x[2] ^ 2), t2 + 176.61502916214059 * x[2] / ((x[1] + 3) ^ 2 + x[2] ^ 2)
					t1, t2 = t1 + 12.507343278686905 * (x[1] + 4) / ((x[1] + 4) ^ 2 + x[2] ^ 2), t2 + -12.507343278686905 * x[2] / ((x[1] + 4) ^ 2 + x[2] ^ 2)
					t1, t2 = t1 + -0.13857109526572012 * (x[1] + 5) / ((x[1] + 5) ^ 2 + x[2] ^ 2), t2 + 0.13857109526572012 * x[2] / ((x[1] + 5) ^ 2 + x[2] ^ 2)
					t1, t2 = t1 + 9.9843695780195716e-6 * (x[1] + 6) / ((x[1] + 6) ^ 2 + x[2] ^ 2), t2 + -9.9843695780195716e-6 * x[2] / ((x[1] + 6) ^ 2 + x[2] ^ 2)
					t1, t2 = t1 + 1.5056327351493116e-7 * (x[1] + 7) / ((x[1] + 7) ^ 2 + x[2] ^ 2), t2 + -1.5056327351493116e-7 * x[2] / ((x[1] + 7) ^ 2 + x[2] ^ 2)
					local t3, t4 = unpack(setmetatable({x[1] + 6.5, x[2]}, mt) ^ setmetatable({x[1] - 0.5, x[2]}, mt))
					t3, t4 = 2.5066282746310002 * t3, 2.5066282746310002 * t4
					local t5, t6 = unpack(Complex.exp(setmetatable({-x[1] - 6.5, -x[2]}, mt)))
					t3, t4 = t3 * t5 - t4 * t6, t3 * t6 + t4 * t5
					t1, t2 = t3 * t1 - t4 * t2, t3 * t2 + t4 * t1
				end
			end

			return t1, t2
		end

		local t1, t2 = t({x[1], x[2]})
		if string.find(tostring(t1), "nan") or string.find(tostring(t2), "nan") then
			t1, t2 = tonumber("-nan(ind)"), tonumber("-nan(ind)")
		end

		return setmetatable({t1, t2}, mt)
end

function MathFunctions.factorial(x)
	if tonumber(x) then
		x = setmetatable({x,0},mt)
	else
		x = setmetatable(x,mt)
	end
	return MathFunctions.gamma(x+1)
end

-- Solver

function mt:__add(other)
	return setmetatable(private.add(self,other), mt)
end

function mt:__sub(other)
	return setmetatable(private.add(self,-other), mt)
end

function mt:__unm()
	return setmetatable(private.mul(-1,self), mt)
end

function mt:__tostring() -- for printing
	return Complex.toString(self)
end

function mt:__mul(other)
	return setmetatable(private.mul(other,self), mt)
end

function mt:__div(other)
	return setmetatable(private.div(self,other), mt)
end

function mt:__pow(other)
	return setmetatable(Complex.pow(self,other), mt)
end
function mt:__eq(other)
	return self[1] == other[1] and self[2] == other[2]
end

return MathFunctions

-- made with love 💙
