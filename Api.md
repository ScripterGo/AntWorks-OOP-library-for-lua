
# Ant Class

### Constructor
*(ClassName)* 
[Calls the constructor function with a newly constructed AntObject 
as one of the arguments. The return is dependant on what the set constructor function returns]

### Properties
**table** *InheritFrom*

[Is a table containing the classes currently inheriting from]
	
**string** *ClassName*

[Is a string storing the ClassName]
	
**func** *Constructor*

[Stores the constructor function for the class]

### Functions

**AntObject** *:Clone()*

[Returns a clone of the Object]

**dictionary** *:GetClassesInheritingFrom()*

[Returns a dictionary of ClassNames which is inherited from]

**bool** *:InheritsFrom(ClassName)*

[Returns true or false accordingly if inherits from a class with the given ClassName]

*:Inherit(AntClass,...)* 

[Takes any number of Ant Classes to inherit from]

*:DeInherit(AntClass, ...)*

[Takes any number of Ant Classes to DeInherit]

**bool** *:Is(ClassName)*
[Returns true if inheriting from a class with the given ClassName or if Objects Classname == ClassName]

*:SetConstruct(func)*
[Sets the constructor function to the given func]


