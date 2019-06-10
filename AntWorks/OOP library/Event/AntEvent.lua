
local ConnectionClass = require(script.AntConnection)

local AntEvent = {}
AntEvent.__index = AntEvent
AntEvent.Event = true -----Just to indentify that its an event

local function Constructor()
	local Event = setmetatable({}, AntEvent)
	Event.Bindable = Instance.new("BindableEvent")
	Event.Connections = {}
	
	return Event
end

function AntEvent:Connect(func)
	local Bindable = self.Bindable
	local Signal = Bindable.Event:Connect(func)
	
	local Connection = ConnectionClass.new(func, Signal)
	table.insert(self.Connections, Connection)	
	return Connection
end

function AntEvent:Fire(...)
	local Bindable = self.Bindable
	Bindable:Fire(...)
end

function AntEvent:Wait()
	local Bindable = self.Bindable
	Bindable.Event:Wait()
end

function AntEvent:ClearConnections()
	for i,v in pairs(self.Connections) do
		v:Disconnect()
	end
end

return Constructor