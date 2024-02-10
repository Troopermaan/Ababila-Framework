local Weld = {}

function Weld:Motor6DTo(Part0: BasePart, Part1: BasePart, NoAutoOffset: boolean?) -- // Motor6D 2 parts together
	do -- // type checking
		assert(typeof(Part0) == 'Instance', 'Part0 must be an instance')
		assert(typeof(Part1) == 'Instance', 'Part1 must be an instance')

		assert(Part0:IsA('BasePart'), 'Part0 must be a BasePart')
		assert(Part1:IsA('BasePart'), 'Part1 must be a BasePart')
	end
	
	local Motor6D = Instance.new('Motor6D')
	
	Motor6D.Name = Part1.Name..' -> '..Part0.Name
	
	Motor6D.Part0 = Part0
	Motor6D.Part1 = Part1
	
	if not NoAutoOffset then
		Motor6D.C0 = Part0.CFrame:ToObjectSpace(Part1.CFrame) -- // ToObjectSpace is just getting the offset between 2 cframes
	end
	
	Motor6D.Parent = Part0
end

function Weld:WeldTo(Part0: BasePart, Part1: BasePart)
	do -- // type checking
		assert(typeof(Part0) == 'Instance', 'Part0 must be an instance')
		assert(typeof(Part1) == 'Instance', 'Part1 must be an instance')

		assert(Part0:IsA('BasePart'), 'Part0 must be a BasePart')
		assert(Part1:IsA('BasePart'), 'Part1 must be a BasePart')
	end

	local WeldInstance = Instance.new('Weld')

	WeldInstance.Name = Part1.Name..' -> '..Part0.Name

	WeldInstance.Part0 = Part0
	WeldInstance.Part1 = Part1

	WeldInstance.C0 = Part0.CFrame:ToObjectSpace(Part1.CFrame) -- // ToObjectSpace is just getting the offset between 2 cframes
	WeldInstance.Parent = Part0
end

function Weld:WeldModel(PrimaryPart: BasePart, Model: any, IgnoreList: table)
	do -- // type checking
		assert(typeof(PrimaryPart) == 'Instance', 'PrimaryPart must be an instance')
		assert(typeof(Model) == 'Instance', 'Model must be an instance')

		assert(PrimaryPart:IsA('BasePart'), 'PrimaryPart must be a BasePart')
	end

	for i,v in next, Model:GetChildren() do
		if v == PrimaryPart or (table.find(IgnoreList, v) or table.find(IgnoreList, v.Name)) then continue end
		if not v:IsA('BasePart') then continue end

		Weld:WeldTo(PrimaryPart, v)
	end
end

function Weld:Motor6DModel(PrimaryPart: BasePart, Model: any, IgnoreList: table)
	do -- // type checking
		assert(typeof(PrimaryPart) == 'Instance', 'PrimaryPart must be an instance')
		assert(typeof(Model) == 'Instance', 'Model must be an instance')

		assert(PrimaryPart:IsA('BasePart'), 'PrimaryPart must be a BasePart')
	end
	
	for i,v in next, Model:GetChildren() do
		if v == PrimaryPart or (table.find(IgnoreList, v) or table.find(IgnoreList, v.Name)) then continue end
		if not v:IsA('BasePart') then continue end
		
		Weld:Motor6DTo(PrimaryPart, v)
	end
end

function Weld:SetModelCollision(parentInstance: any, collisionValue: boolean, recursive: boolean?) -- // Recursive is basically if it does descendants or not
	for i,v in next, parentInstance:GetChildren() do
		if not v:IsA('BasePart') then continue end

		v.CanCollide = collisionValue

		if recursive then
			Weld:SetModelCollision(v, collisionValue, true)
		end
	end
end

function Weld:DestroyInstancesWithName(parentInstance: Instance, blacklistedNames: any)
	for i,v in next, parentInstance:GetChildren() do
		if not table.find(blacklistedNames, v.Name) then continue end
		
		v:Destroy()
	end
end

return Weld
