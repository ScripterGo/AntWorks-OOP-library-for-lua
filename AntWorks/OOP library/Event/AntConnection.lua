
local AntConnection = {}
AntConnection.__index = AntConnection

local function Constructor(func, signal)
	local Connection = setmetatable({}, AntConnection)
	Connection.func = func
	Connection.Signal = signal
	return Connection
end

function AntConnection:Disconnect()
	local Signal = self.Signal
	if Signal ~= nil then
		Signal:Disconnect()
		Signal = nil
	end	
end

return Constructor