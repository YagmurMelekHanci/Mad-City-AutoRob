_G.AutoRob = true
_G.RobberyCount = 0

-- Sayaç GUI
local function setupGui()
	local player = game.Players.LocalPlayer
	if player:FindFirstChild("PlayerGui") then
		local gui = Instance.new("ScreenGui", player.PlayerGui)
		gui.Name = "RobberyCounter"
		gui.ResetOnSpawn = false

		local counterLabel = Instance.new("TextLabel", gui)
		counterLabel.Size = UDim2.new(0, 200, 0, 50)
		counterLabel.Position = UDim2.new(0, 10, 0, 10)
		counterLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		counterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		counterLabel.TextScaled = true
		counterLabel.Text = "Soygun Sayısı: 0"

		game:GetService("RunService").RenderStepped:Connect(function()
			counterLabel.Text = "Soygun Sayısı: " .. tostring(_G.RobberyCount)
		end)
	end
end

-- Robbery sistemi
local function autorob()
	local MiniRobberies = {
		"Cash", "CashRegister", "DiamondBox", "Laptop", "Phone",
		"Luggage", "ATM", "TV", "Safe"
	}

	local function getevent(v)
		for _, d in pairs(v:GetDescendants()) do
			if d:IsA("RemoteEvent") then return d end
		end
	end

	local function getrobbery()
		for _, v in pairs(workspace.ObjectSelection:GetChildren()) do
			if table.find(MiniRobberies, v.Name) and not v:FindFirstChild("Nope") and getevent(v) then
				return v
			end
		end
	end

	local function tp(x, y, z)
		local root = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		for _ = 1, 30 do
			root.CFrame = CFrame.new(x, y, z)
			task.wait()
		end
	end

	-- Jewelry Store
	tp(-82, 86, 807)
	task.wait(1)
	for _, box in pairs(workspace.JewelryStore.JewelryBoxes:GetChildren()) do
		task.spawn(function()
			for _ = 1, 5 do
				workspace.JewelryStore.JewelryBoxes.JewelryManager.Event:FireServer(box)
			end
		end)
	end
	task.wait(2)

	-- Diğer soygunlar
	tp(2115, 26, 420)
	task.wait(1)
	repeat
		local robbery = getrobbery()
		if robbery then
			for _ = 1, 20 do
				local root = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
				root.CFrame = robbery:GetPivot() + Vector3.new(0, 5, 0)
				getevent(robbery):FireServer()
				task.wait()
			end
			_G.RobberyCount += 1
		end
		task.wait()
	until getrobbery() == nil
end

-- Server Hop Sistemi
local function serverHop()
	local HttpService = game:GetService("HttpService")
	local TeleportService = game:GetService("TeleportService")
	local servers = {}
	local success, result = pcall(function()
		local req = request({
			Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"
		})
		local body = HttpService:JSONDecode(req.Body)
		for _, v in pairs(body.data) do
			if v.id ~= game.JobId and v.playing < v.maxPlayers then
				table.insert(servers, v.id)
			end
		end
	end)
	if #servers > 0 then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
	else
		TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
	end
end

-- Ölünce tekrar bağlan
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
	serverHop()
end)

-- Sunucu Değişimi sonrası tekrar script başlasın
queue_on_teleport([[
	loadstring(game:HttpGet("https://raw.githubusercontent.com/YagmurMelekHanci/Mad-City-AutoRob/main/finalautrob.lua"))()
]])

-- Başlat!
setupGui()
autorob()
task.wait(2)
serverHop()
