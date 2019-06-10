
# How to use?
Download the AntWorks.rbxm or AntWorks folder from the repository. Unpack it and specify the desired file paths within the "requires". Then just require the AntClass module whenever you wish you create a new class. The only aspect which take use of the roblox api, is the event system. A pure lua solution is possible to create, although i didnt include it.

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
