
local Replicated = game:GetService("ReplicatedStorage")
local Utility = Replicated.Utility
--[[
	How does the class become cyclic?
	*A class inherits from itself
	*A class inherits from a class that indirectly inherits from the A class
	
--]] 

local function MakesCyclic(Class, ToInherit) ----Checks if an inherit will make the class inheritation cyclic
	local InheritingFrom = ToInherit:GetClassesInheritingFrom()
	for i,v in pairs(InheritingFrom) do
		if i == Class.ClassName then
			return true
		end
	end
	return false
end


local AntClass = {}
AntClass.__index = function(tab, index) --Will run whenever a class object(tab) is indexed with an index which-s value is nil
	local Value = rawget(tab, index)
	Value = Value or rawget(AntClass, index)
	if Value ~= nil then print("returning", Value) return Value end
	
	local InheritingFrom = tab.InheritFrom
	for i = 1,#InheritingFrom do
		local Current = InheritingFrom[i][index]
		if Current then
			print("returning", Current)
			return Current
		end
	end
end

AntClass.__newindex = function(tab, index, value) -----Will run whenever you try to set a new index of the Class object(tab)
	----Isnt bullet proof, since im not using a proxy newindex wont fire if the key wasnt nil.
	if typeof(value) == "table" then
		if value.Event == true then
			warn("You cannot add an event to a class, you need to add the event to the created object!")
			return
		end
	end
	
	rawset(tab, index, value)
end

local function Constructor(ClassName)---Creating a new AntClass
	local ObjectClass = require(script.AntObject)
	
	local Class = {}
	Class.InheritFrom = {} ----Table containing every class to inherit from
	Class.ClassName = ClassName
	Class.Constructor = nil -----the constructor function
	setmetatable(Class, AntClass) 
	
	function Class:SetConstruct(func)
		rawset(self, "Constructor", func)
	end
	
	function Class.new(...)
		if Class.Constructor == nil then
			warn("You need to set a constructor function first!")
		end
	
		local Object = ObjectClass(Class)
		return Class.Constructor(Object, ...)
	end
	
	return Class
end

function AntClass:Clone() -----Clones the class object
	local TableLibrary = require(Utility.TableLibrary)
	return TableLibrary.Clone(self)
end

function AntClass:GetClassesInheritingFrom(Current) -----Only for class objects, returns a list of every class that the class 												
	local TableLibrary = require(Utility.TableLibrary)
	
	Current = Current or {}							-----is inheriting from
	for i,v in pairs(self.InheritFrom) do
		Current[v.ClassName] = true
		if #v.InheritFrom > 0 then
			TableLibrary.Paste(Current, v:GetClassesInheritingFrom(Current), true)
		end
	end
	
	return Current
end

function AntClass:InheritsFrom(ClassName)			----Returns true or false accordingly if the class inherits from a class with
	local InheritingFrom = self:GetClassesInheritingFrom() --classname [ClassName]
	for i,v in pairs(InheritingFrom) do
		if i == ClassName then
			return true
		end	
	end
	return false
end

function AntClass:Inherit(...) ----Takes Class objects to inherit from
	local InheritFrom = self.InheritFrom
	local ToInherit = {...}
	
	for i,v in pairs(ToInherit) do
		if self:InheritsFrom(v.ClassName) then
			warn("The class already inherits from: "..v.ClassName)
		elseif MakesCyclic(self, v) == false then
			table.insert(InheritFrom, v)
		else
			warn("Oh nooo! You cannot create a chain of an endless inheritation!")
			return
		end
	end	
end

function AntClass:DeInherit(...) ---Takes class objects to deinherit from
	local TableLibrary = require(Utility.TableLibrary)
	local InheritFrom = self.InheritFrom
	local ToDeInherit = {...}
	
	for i,v in pairs(ToDeInherit) do
		local IsInherit = self:InheritsFrom(v.ClassName)
		if not IsInherit then
			warn("The class didnt even inherit from: "..v.ClassName.." in the first place")
		else
			local Found, index = TableLibrary.Find(InheritFrom, v.ClassName)
			table.remove(InheritFrom, index)
		end
	end
end

function AntClass:Is(ClassName) ---Checks if the class object is a certain type
	local Bool = self.ClassName == ClassName or self:InheritsFrom(ClassName)
	return Bool
end

function AntClass:CreateMultimethod(index)
	local Multimethod = require(script.Parent.Multimethod)
	local NewMultimethod = Multimethod.new()
	self[index] = NewMultimethod
	
	return NewMultimethod
end



return Constructor