local Raycasting = {}

function Raycasting:Raycast(Origin: Vector3, Direction: Vector3, IgnoreList: any, RayType: string?)
	assert(typeof(Origin) == 'Vector3', 'Invalid argument #1: Vector3 expected, got '..typeof(Origin))
	assert(typeof(Direction) == 'Vector3', 'Invalid argument #2: Vector3 expected, got '..typeof(Direction))
	assert(typeof(IgnoreList) == 'table', 'Invalid argument #3: table expected, got '..typeof(IgnoreList))
	
	local RayParams = RaycastParams.new()
	
	RayParams.FilterDescendantsInstances = IgnoreList
	RayParams.FilterType = Enum.RaycastFilterType[RayType or 'Exclude']
	RayParams.IgnoreWater = true
	
	local raycastResult = workspace:Raycast(Origin, Direction, RayParams)
	
	if raycastResult then
		return raycastResult.Instance, raycastResult.Position, raycastResult.Normal, raycastResult.Distance, raycastResult.Material
	end
	
	return nil, Origin + Direction
end

function Raycasting:Blockcast(Origin: CFrame, Size: Vector3, Direction: Vector3, IgnoreList: any, RayType: string?)
	assert(typeof(Origin) == 'CFrame', 'Invalid argument #1: Vector3 expected, got '..typeof(Origin))
	assert(typeof(Size) == 'Vector3', 'Invalid argument #2: Vector3 expected, got '..typeof(Size))
	assert(typeof(Direction) == 'Vector3', 'Invalid argument #3: Vector3 expected, got '..typeof(Direction))
	assert(typeof(IgnoreList) == 'table', 'Invalid argument #4: table expected, got '..typeof(IgnoreList))

	local RayParams = RaycastParams.new()

	RayParams.FilterDescendantsInstances = IgnoreList
	RayParams.FilterType = Enum.RaycastFilterType[RayType or 'Exclude']
	RayParams.IgnoreWater = true

	local raycastResult = workspace:Blockcast(Origin, Size, Direction, RayParams)

	if raycastResult then
		return raycastResult.Instance, raycastResult.Position, raycastResult.Normal, raycastResult.Distance, raycastResult.Material
	end

	return nil, Origin.Position + Direction, nil, Direction.Magnitude
end

function Raycasting:Spherecast(Origin: Vector3, Size: number, Direction: Vector3, IgnoreList: any, RayType: string?)
	assert(typeof(Origin) == 'Vector3', 'Invalid argument #1: Vector3 expected, got '..typeof(Origin))
	assert(typeof(Size) == 'number', 'Invalid argument #2: Vector3 expected, got '..typeof(Size))
	assert(typeof(Direction) == 'Vector3', 'Invalid argument #3: Vector3 expected, got '..typeof(Direction))
	assert(typeof(IgnoreList) == 'table', 'Invalid argument #4: table expected, got '..typeof(IgnoreList))

	local RayParams = RaycastParams.new()

	RayParams.FilterDescendantsInstances = IgnoreList
	RayParams.FilterType = Enum.RaycastFilterType[RayType or 'Exclude']
	RayParams.IgnoreWater = true

	local raycastResult = workspace:Spherecast(Origin, Size, Direction, RayParams)

	if raycastResult then
		return raycastResult.Instance, raycastResult.Position, raycastResult.Normal, raycastResult.Distance, raycastResult.Material
	end

	return nil, Origin + Direction
end

function Raycasting:RaycastToPosition(Origin: Vector3, TargetPosition: Vector3, ...)
	assert(typeof(Origin) == 'Vector3', 'Invalid argument #1: Vector3 expected, got '..typeof(Origin))
	assert(typeof(TargetPosition) == 'Vector3', 'Invalid argument #2: Vector3 expected, got '..typeof(TargetPosition))

	return Raycasting:Raycast(Origin, CFrame.lookAt(Origin, TargetPosition).LookVector * (Origin - TargetPosition).Magnitude, ...)
end

function Raycasting:BlockcastToPosition(Origin: CFrame, Size: Vector3, TargetPosition: Vector3, ...)
	assert(typeof(Origin) == 'CFrame', 'Invalid argument #1: CFrame expected, got '..typeof(Origin))
	assert(typeof(TargetPosition) == 'Vector3', 'Invalid argument #2: Vector3 expected, got '..typeof(TargetPosition))
	
	return Raycasting:Blockcast(Origin, CFrame.lookAt(Origin.Position, TargetPosition).LookVector * (Origin.Position - TargetPosition).Magnitude, ...)
end

function Raycasting:CalculateWallThickness(Origin: Vector3, Direction: Vector3, TargetPart: BasePart)
	assert(typeof(Origin) == 'Vector3', 'Invalid argument #1: Vector3 expected, got '..typeof(Origin))
	assert(typeof(Direction) == 'Vector3', 'Invalid argument #2: Vector3 expected, got '..typeof(Direction))
	assert(typeof(TargetPart) == 'Instance', 'Invalid argument #3: Instance expected, got '..typeof(TargetPart))
	
	local partSizeMag: number = TargetPart.Size.Magnitude
	local newDirection: Vector3 = Direction * partSizeMag
	
	local rayResult: Instance?, rayHitPosition: Vector3 = Raycasting:Raycast(Origin + newDirection, -newDirection, {TargetPart}, 'Include')
	
	if rayResult then
		return (rayHitPosition - Origin).Magnitude
	end
	
	return math.huge
end

return Raycasting
