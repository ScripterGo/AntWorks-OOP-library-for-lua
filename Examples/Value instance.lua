
local AntClass = require("AntClass")
local ValueInstanceClass = AntClass("ValueInstance")

ValueInstanceClass:SetConstruct(function(self, ValueType)
	assert(script[ValueType], "Incompatible datatype")
	
	local SpecificClass = require(script[ValueType])
	self = SpecificClass.new()
	
	self.Value = nil 
	
	self:SuperLock() ---Locking everything
	self:Unlock("Value") ---Unlocking "Value" making "Value" then only non locked index
	self:LimitDataType("Value", ValueType) ----Limiting the datatype of the value at index to ValueType
	self:Inherit(ValueInstanceClass) --Yep the instantiated object is inheriting
	
	return self
end)

function ValueInstanceClass:Idk()
	print(self.Value)
end

local numberValue = ValueInstanceClass.new("number")
numberValue:Idk()
