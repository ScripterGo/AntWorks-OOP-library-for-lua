
local Replicated = game:GetService("ReplicatedStorage")
local Utility = Replicated.Utility
local TableLibrary = require(Utility.TableLibrary)

local Multimethod = {}
Multimethod.__index = Multimethod

function Multimethod.new()
	local Method = setmetatable({}, Multimethod)
	Method.Dispatch = type
	Method.Methods = {}
	
	local proxy = {}
	proxy.__index = Method
	proxy.__newindex = function(tab, index, value)
		if Method[index] == nil then
			error("Cannot set a new index!")
		end
	end
	proxy.__call = function(tab, self, ...)
		assert(typeof(self) == "table" and self.AntObject == true, "You need to call the multimethod with the : syntax")
		
		
		local String = Method:GetString({...}, true)
		local Methods = tab.Methods
		
		return Methods[String](self, ...)
	end
	
	return setmetatable({}, proxy)
end

function Multimethod:Register(func, ...)
	local DataTypes = {...}
	if #DataTypes <= 0 then
		error("You need to provide datatypes for the multimethod")
	end
	
	local String = self:GetString(DataTypes, false)
	local Methods = self.Methods
	
	if self.Methods[String] ~= nil then
		error("You already have a function registered with that set of argument types")
	else
		self.Methods[String] = func
	end
end

function Multimethod:UnRegister(func, ...)
	local String = self:GetString({...}, false)
	local Methods = self.Methods
	
	if self.Methods[String] then
		self.Methods[String] = nil
	else 
		local found, key = TableLibrary.Find(Methods, func)
		if found then
			self.Methods[key] = nil
		end
	end
end

function Multimethod:GetString(tab, Flatout ,Current)
	local Dispatch = self.Dispatch
	if #tab == 0 then
		return Current
	end
	local ToAdd = (Flatout == true and Dispatch(tab[1])) or tab[1]
	
	if Current == nil then
		Current = ToAdd
	else
		Current = Current..", "..ToAdd
	end
	
	table.remove(tab, 1)
	return self:GetString(tab, Flatout, Current)
end






return Multimethod