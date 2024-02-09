local Framework = {}
Framework.moduleRoot = game:GetService('ReplicatedStorage'):WaitForChild('Modules')

-- // Private function & variables
local function createTree(moduleRoot: Instance): {any}
	local moduleTree = {}

	for i,v in next, moduleRoot:GetChildren() do
		if (not v:IsA('Folder')) then
			continue
		end

		moduleTree[v.Name] = {}
	end

	return moduleTree
end

-- // Methods
function Framework.require(folderName: string, moduleName: string): any?
	if (not Framework.tree[folderName]) then
		return warn(string.format('Folder "%s" does not exist', folderName))
	end

	if (not Framework.tree[folderName][moduleName]) then
		local realFolder: Folder = Framework.moduleRoot:FindFirstChild(folderName)
		local realModule: ModuleScript = realFolder:FindFirstChild(moduleName)

		if (not realModule) then
			return warn(string.format('%s/%s does not exist', folderName, moduleName))
		end

		Framework.tree[folderName][moduleName] = require(realModule)
	end

	return Framework.tree[folderName][moduleName]
end

-- // Setup
Framework.tree = createTree(Framework.moduleRoot)
shared.require = Framework.require

return Framework
