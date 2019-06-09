
# How to use?
Download the AntWorks.rbxm from the repository. Unpack it inside Roblox Studio and place the content folders inside ReplicatedStorage. Then just require the AntClass module whenever you wish you create a new class.

# Creating your first class
```lua
local AntClass = require("AntClass")
local NewClass = AntClass("ClassName")

--setting a constructor function
NewClass:SetConstructor(function(self)
  self.test = "Hello World!"
  return self
end)

--Adding a method to the class
function NewClass:Print(...)
  print(...)
end

--Creating a new object
local NewObject = NewClass.new()
NewObject:Print(NewObject.test) --->> "Hello World!"
```
Theres alot more to it, so make sure you check out the api documentation.
