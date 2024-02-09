local Bullet = {}
Bullet.__index = Bullet

-- // Types
export type WallbangConfig = {
	Base: number,
	Materials: {number},
}

export type Config = {
	Velocity: number,
	Gravity: number,
	MaximumRicochets: number,
	RicochetThreshold: number, -- // 0 - 1, higher makes it easier to ricochet
	Wallbang: WallbangConfig,
	MaximumDistance: number,
	
	IgnoreList: {any}?,
	IgnoreType: string?,
}

-- // Modules
local Raycasting = shared.require('Libraries', 'Raycasting', true)
local Signal = shared.require('Classes', 'FastSignal', true)
local Cleaner = shared.require('Classes', 'Cleaner', true)

-- // Private functions & variables
local defaultWallbangConfig: WallbangConfig = { Base = 0, Materials = {} }
local defaultConfig: Config = { Velocity = 100, Gravity = 10, MaximumRicochets = 0, RicochetThreshold = 0, MaximumDistance = 3000, Wallbang = defaultWallbangConfig }
defaultConfig.__index = defaultConfig

local function reflect(direction: Vector3, normal: Vector3): Vector3
	return -2 * direction:Dot(normal) * normal + direction
end

-- // Constructor Methods
function Bullet.new(origin: Vector3, direction: Vector3, config: Config)
	local self = setmetatable({}, Bullet)
	
	-- // Properties
	self.Config = setmetatable(config or {}, defaultConfig) :: Config
	
	self.Origin = origin
	self.Direction = (direction.Unit * self.Config.Velocity)
	self.Gravity = (self.Config.Gravity * Vector3.yAxis)
	self.IgnoreList = table.clone(self.Config.IgnoreList or {})
	self.IgnoreType = self.Config.IgnoreType
	
	self.Penetration = self.Config.Wallbang.Base
	self.Ricochets = 0
	self.Distance = 0
	
	self.Active = true
	
	-- // Signals
	self.Cleaner = Cleaner.new()
	self.Collided = self.Cleaner:AddSignal(Signal.new()) -- // Fires with (rayResult: Instance, penetrated: boolean, ricochet: boolean)
	
	return self
end

function Bullet:Destroy()
	self.Cleaner:Destroy()
	
	table.clear(self)	
end

-- // Methods
function Bullet:Step(deltaTime: number)
	if (not self.Active) then
		return error('Bullet is not alive')
	end
	
	local origin: Vector3 = self.Origin
	local direction: Vector3 = (self.Direction * deltaTime)
	
	local rayResult: Instance?, rayHitPosition: Vector3, rayNormal: Vector3? = Raycasting:Raycast(
		origin, direction,
		self.IgnoreList, self.IgnoreType
	)
	
	if (rayResult) then
		local wallThickness: number = (Raycasting:CalculateWallThickness(rayHitPosition, self.Direction, rayResult) / (self.Config.Wallbang.Materials[rayResult.Material] or 1))
		local canPenetrate: boolean = (wallThickness <= self.Penetration)
		
		if (canPenetrate) then
			table.insert(self.IgnoreList, rayResult)
			
			self.Penetration -= wallThickness
			self.Collided:Fire(rayResult, true, false)
			
			return self:Step(deltaTime)
		elseif (self.Ricochets < self.Config.MaximumRicochets) and (direction.Unit:Dot(-rayNormal) >= self.Config.RicochetThreshold) then
			self.Ricochets += 1
			self.Direction = reflect(self.Direction, rayNormal)
			self.Collided:Fire(rayResult, false, true)
		else
			self.Collided:Fire(rayResult, false, false)
			self.Active = false
		end
	end
	
	-- // Write New Data
	self.Distance += (origin - rayHitPosition).Magnitude
	self.Origin = rayHitPosition
	self.Direction -= (self.Gravity * deltaTime)
	
	-- // Distance Check
	if (self.Distance >= self.Config.MaximumDistance) then
		self.Active = false
	end
end

-- // Internal Methods

return Bullet
