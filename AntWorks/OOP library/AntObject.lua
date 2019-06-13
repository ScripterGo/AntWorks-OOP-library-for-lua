
local Replicated = game:GetService("ReplicatedStorage")
local Utility = Replicated.Utility

local AntObject = {}
AntObject.__index = AntObject

local function Constructor(InstantietedBy)
	local Object = setmetatable({}, AntObject)
	Object.Locked = {}
	Object.Unlocked = {}
	Object.DataTypeLimitations = {}
	Object.InheritFrom = {}
	
	Object.AntObject = true
	Object.SuperLocked = false
	Object.InstantiatedFrom = InstantietedBy
	
	Object.Changed = Object.CreateEvent()
	Object:LockProperty("Locked", "Unlocked", "DataTypeLimitations", "SuperLocked", "InheritFrom", "InstantiatedFrom", "Changed")
	
	local proxy = {}
	proxy.__index = function(tab, index)
		local Value = Object[index]
		Value = Value or AntObject[index]
		if Value ~= nil then return Value end
		
		local InheritingFrom = Object.InheritFrom
		for i = 1, #InheritingFrom do
			local Current = InheritingFrom[i][index] 
			if Current then
				return Current
			end
		end
	
		return Object.InstantiatedFrom[index]
	end
	
	proxy.__newindex = function(tab, index, value)
		if rawget(Object,index) == value then return end 
		
		local Limitation = Object.DataTypeLimitations[index]
		if (Object.SuperLocked == false and Object.Locked[index] ~= nil) or (Object.SuperLocked == true and Object.Unlocked[index] == nil) then
			error("The property: "..index.." is read only or just locked!")
		
		elseif Limitation == typeof(value) or Limitation == nil or value == nil then
			rawset(Object, index, value or Object.DefaultValue)
			Object.Changed:Fire(index, value)
		else
			error(string.upper(Limitation).." expected, got: "..string.upper(typeof(value)))
		end	
	end

	return setmetatable({}, proxy)	
end

function AntObject:LockProperty(...)
	if self.SuperLocked == true then
		warn("The object is already Super Locked, theres no point in locking any properties")
		return
	end
	
	local ToLock = {...}
	for i,v in pairs(ToLock) do
		self.Locked[v] = true ---Will work as a new index for the table Locked is just made
		self.Unlocked[v] = nil
	end
end

function AntObject:UnlockProperty(...)
	local ToUnlock = {...}
	for i,v in pairs(ToUnlock) do
		self.Locked[v] = nil 
		self.Unlocked[v] = true 
	end
end

function AntObject:SuperLock()
	rawset(self, "SuperLocked", true)
end

function AntObject:SuperUnlock()
	rawset(self, "SuperLocked", false)
end

function AntObject:LimitDataType(Index, DataType)
	DataType = string.lower(DataType)
	self.DataTypeLimitations[Index] = DataType
end

function AntObject:BreakDataTypeLimit(Index)
	self.DataTypeLimitations[Index] = nil
end

function AntObject:GetClassesInheritingFrom(Current)
	local TableLibrary = require(Utility.TableLibrary)
	Current = Current or {[self.InstantiatedFrom.ClassName] = true}
	
	for i,v in pairs(self.InheritFrom) do
		Current[v.ClassName] = true
		if #v.InheritFrom > 0 then
			TableLibrary.Paste(Current, v:GetClassesInheritingFrom(Current), true)
		end
	end
	for i,v in pairs(self.InstantiatedFrom.InheritFrom) do
		Current[v.ClassName] = true
		if #v.InheritFrom > 0 then
			TableLibrary.Paste(Current, v:GetClassesInheritingFrom(Current), true)
		end
	end
	
	return Current
end

function AntObject:ClearConnections(tab)
	tab = tab or self
	for i,v in pairs(tab) do
		if v.Event == true then
			v:ClearConnections()
		elseif typeof(v) == "table" then
			self:ClearConnections(v)
		end
	end	
end

function AntObject.CreateEvent()
	local EventClass = require(script.Parent.AntEvent)
	local NewEvent = EventClass()
	--self[index] = NewEvent
	
	return NewEvent
end

return Constructor
