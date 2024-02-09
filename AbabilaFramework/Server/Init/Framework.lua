local Framework = {}
Framework.moduleRoot = game:GetService('ServerStorage'):WaitForChild('Modules')
Framework.clientModuleRoot = game:GetService('ReplicatedStorage'):WaitForChild('Modules')

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
function Framework.require(folderName: string, moduleName: string, clientModule: boolean?): any?
	local moduleTree: {} = (clientModule and Framework.clientTree) or Framework.tree
	local moduleContainer: Folder = (clientModule and Framework.clientModuleRoot) or Framework.moduleRoot
	
	if (not moduleTree[folderName]) then
		return warn(string.format('Folder "%s" does not exist', folderName))
	end

	if (not moduleTree[folderName][moduleName]) then
		local realFolder: Folder = moduleContainer:FindFirstChild(folderName)
		local realModule: ModuleScript = realFolder:FindFirstChild(moduleName)

		if (not realModule) then
			return warn(string.format('%s/%s does not exist', folderName, moduleName))
		end

		moduleTree[folderName][moduleName] = require(realModule)
	end

	return moduleTree[folderName][moduleName]
end

-- // Setup
Framework.tree = createTree(Framework.moduleRoot)
Framework.clientTree = createTree(Framework.clientModuleRoot)
shared.require = Framework.require

return Framework
