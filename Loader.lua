-- // AbabileFramework Loader - Put this in ServerScriptService
local AbabilaFramework = game:GetService('ServerStorage'):WaitForChild('AbabilaFramework')
local Client = AbabilaFramework.Client
local Server = AbabilaFramework.Server

-- // Setup Server
Server.Modules.Parent = game:GetService('ServerStorage')
Server.Init.Enabled = true
Server.Init.Parent = game:GetService('ServerScriptService')

-- // Setup Client
Client.Modules.Parent = game:GetService('ReplicatedStorage')
Client.Init.Enabled = true
Client.Init.Parent = game:GetService('ReplicatedFirst')

-- // Cleanup
AbabilaFramework:Destroy()
script:Destroy()
