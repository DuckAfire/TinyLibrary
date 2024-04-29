-- NAME:    Magic Pallete
-- AUTHOR:  DuckAfire
-- VERSION: 1.2

----- FOLLOW_ME -----
-- Itch:     http://duckafire.itch.io
-- GitHub:   http://github.com/duckafire
-- Tic80:    http://tic80.com/dev?id=8700
-- Facebook: http://facebook.com/duckafire

----- LICENSE -----

-- Zlib License

-- Copyright (C) 2024 DuckAfire <facebook.com/duckafire>
  
-- This software is provided 'as-is', without any express or implied
-- warranty. In no event will the authors be held liable for any damages
-- arising from the use of this software.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it
-- freely, subject to the following restrictions:
  
-- 1. The origin of this software must not be misrepresented; you must not
--    claim that you wrote the original software. If you use this software
--    in a product, an acknowledgment in the product documentation would be
--    appreciated but is not required. 
-- 2. Altered source versions must be plainly marked as such, and must not be
--    misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.



----- ABOUT PALETTE CODE -----

local function sortCode(code, order, low)
	local ord, _code, c = order or 0, {}, nil-- type of return; colors; to return
	
	-- HEXADECIMAL CODE
	if type(_code) == "string" then
		local temp = _code
		for i = #temp + 1, 6 do temp = temp.."0" end-- fill void spaces
		
		local id    = {1, 3, 5}
		local _font = low and string.lower or string.upper
		for i = 1, 3 do _code[i] = _font(string.sub(temp, id[i], id[i] + 1)) end
	
	-- DECIMAL CODE
	else
		_code = code
	end
	
	for i = 1, 3 do if not _code[i] then _code[i] = 0 end end-- fill void spaces
	
	-- RETURN TYPES
	if ord == 0 then-- 3 arg to 3 var
		return _code[1], _code[2], _code[3]
	
	elseif ord == 1 then-- a array (table)
		c = _code
	
	elseif ord == 2 then-- a table with "structure"
		c = {red = _code[1], green = _code[2], blue = _code[3]}
	
	elseif ord == 3 then-- string
		if hex then
			c = "#".._code[1].._code[2].._code[3]-- hexadecimal
		else
			c = _code[1]..", ".._code[2]..", ".._code[3]-- decimal
		end
	else
		error('[Magic_Palette] The parameter "order" is invalid, try values between 0-3. In function "pale.sortCode", argument #2.')
	end
	
	return c
end

local function save(hex)
	local var
	
	if hex then   var = ""   else   var = {}   end
	
	for i = 0, 15 do	
		if not hex then var[i] = {} end
		
		for j = 0, 2 do
			if hex then
				var = var..string.format("%x", peek(0x03FC0 + i * 3 + j))-- hexadecimal
			else
				var[i][j] = peek(0x03FC0 + i * 3 + j)-- decimal (in sub-tables)
			end
		end
	
	end

	return var
end



----- CONVERSION -----

local function toDec(_code, order)
	local inDeci = {}
	
	local code
	code = type(_code) == "table" and _code[1] or _code
	code = string.sub(code, 1, 1) == "#" and string.sub(code, 2) or code-- remove "#"
	
	for i = 0, 2 do
		local lcl = i + 1 + (i * 1)-- LoCaLe
		inDeci[i + 1] = tonumber(string.sub(code, lcl, lcl + 1), 16)
	end
	
	return sortCode(inDeci, order)
end

local function toHex(_code, order, low)
	local inHexa = ""
	
	for i = 1, 3 do
		if     _code[i] < 0   then _code[i] = 0 
		elseif _code[i] > 255 then _code[i] = 255
		end
		
		inHexa = inHexa..string.format("%x", math.floor(_code[i]))
	end
	
	return sortCode(inHexa, order, low)
end



-- CHANGE TINT (RGB)

local function swap(_code, id)
	local code = _code-- remove trash
	if  string.sub(_code, 1, 4) == "000:" then code = string.sub(_code, 5)
	elseif string.sub(_code, 1, 1) == "#" then code = string.sub(_code, 2)
	end
	
	-- function core
	local function rgb(v, ifPalette)
		local add = ifPalette or 0
		for i = 0, 2 do
			local lcl = i + 1 + (i * 1)-- LoCaLe
			local color = tonumber(string.sub(code, lcl + add, lcl + 1 + add), 16)
			poke(0x03fc0 + v * 3 + i, color)-- apply the edition in ram
		end
	end
	
	if id == "palette" then
		for id = 0, 15 do rgb(id, 6 * id) end-- swap palette
		
	elseif id == "equal" then
		for id = 0, 15 do rgb(id) end-- edit all colors (all are equal)
	
	else
		rgb(tonumber(id))-- edit one color
	
	end
	
end

local function shine(speed, tbl)
	local spd, qtt = speed and math.floor(speed) or 1, 0-- update speed; quantity of color in min/max
	
	for i = 0, 15 do-- index
		for j = 0, 2 do-- rgb
		
			local cur = peek(0x03FC0 + i * 3 + j)
			
			local min = type(tbl) == "table" and tbl[i][j] or 0
			local max = type(tbl) == "table" and tbl[i][j] or 255
			
			local value = (cur + spd >= min) and cur + spd or min-- less
			if spd > 0 then value = (cur + spd <= max) and cur + spd or max end-- more
			
			poke(0x03FC0 + i * 3 + j, value)
			
			if value == min or value == max then qtt = qtt + 1 end
			
		end
	end
	
	return qtt == 48
end



----- ADD TO TABLE -----

local magicPalette = {}

magicPalette.sortCode = sortCode
magicPalette.save     = save
magicPalette.toDec    = toDec
magicPalette.toHex    = toHex
magicPalette.swap     = swap
magicPalette.shine    = shine

return magicPalette
