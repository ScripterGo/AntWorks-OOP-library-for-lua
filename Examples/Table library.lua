
local AntClass = require(OOPLibrary.AntClass)
local Repr = require("Repr")
local TableLibrary = AntClass("TableLibrary")
function TableLibrary.Clone(ToClone)
	local NewTab = {}
	for i,v in pairs(ToClone) do
		if typeof(v) == "table" then
			NewTab[i] = TableLibrary.Clone(v)
		else
			NewTab[i] = v
		end
	end
	setmetatable(NewTab, getmetatable(ToClone))
	
	return NewTab
end

function TableLibrary.GetElementCount(tab)
	local count = 0
	for i,v in pairs(tab) do
		count = count + 1
	end
	return count
end

function TableLibrary.Paste(ToPasteInto, ToPaste, Dictionary)
	for i,v in pairs(ToPaste) do
		if Dictionary then
			ToPasteInto[i] = v
		else
			table.insert(ToPasteInto, v)
		end
	end
end

function TableLibrary.Find(Tab, Value)
	for i,v in pairs(Tab) do
		if v == Value then
			return true, i
		end
	end
end

function TableLibrary.PrintOut(Tab)
	print(Repr(Tab))
end

--[[
As this library is a class we can not only use it standardly, but also have classes or objects inherit these methods for quick access.
Constructor functions arent a must as shown by the example.
--]]
