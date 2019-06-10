
local RectangleClass = AntClass("Rectangle")
RectangleClass:SetConstruct(function(self, Width, Height)
	self.Width = Width
	self.Height = Height
	
	self:LockProperty("Width", "Height")
	return self
end)

function RectangleClass:GetArea()
	return self.Width * self.Height
end

local SquareClass = AntClass("Square")
SquareClass:Inherit(RectangleClass)

SquareClass:SetConstruct(function(self, Length)
	self = RectangleClass.new(Length, Length)
	return self
end)

local Square = SquareClass.new(4)
print(Square:GetArea())
print(Square:Is("Rectangle"))
