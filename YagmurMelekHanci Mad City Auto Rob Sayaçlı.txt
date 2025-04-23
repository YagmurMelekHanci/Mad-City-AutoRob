--░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
--░   ░░░░░░   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   ░░░░░░░   ░░░░░░░░░░░░   ░░░░░░░░░░░░   ░░░░░░   ░░░░   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
--▒▒   ▒▒▒▒   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ▒   ▒▒▒    ▒▒▒▒▒▒▒▒▒▒▒▒   ▒▒▒▒▒▒▒▒▒▒▒▒   ▒▒▒▒▒▒   ▒▒▒▒   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  
--▒▒▒   ▒   ▒▒▒▒▒▒▒   ▒▒▒▒▒▒     ▒▒▒    ▒   ▒   ▒▒   ▒▒   ▒  ▒    ▒   ▒   ▒ ▒   ▒▒▒▒   ▒▒▒▒▒   ▒▒▒▒   ▒▒▒▒▒   ▒▒   ▒   ▒▒▒▒   ▒▒▒▒   ▒▒▒▒▒   ▒   ▒▒▒▒▒▒    ▒▒▒▒
--▓▓▓▓▓   ▓▓▓▓▓▓▓   ▓▓   ▓▓   ▓▓   ▓▓   ▓▓  ▓▓   ▓   ▓▓   ▓▓   ▓▓▓▓   ▓▓   ▓▓   ▓▓  ▓▓▓   ▓▓   ▓▓  ▓▓▓   ▓▓   ▓   ▓▓          ▓▓   ▓▓   ▓▓▓   ▓▓   ▓▓   ▓▓▓▓   
--▓▓▓▓▓   ▓▓▓▓▓▓   ▓▓▓   ▓▓  ▓▓▓   ▓▓   ▓▓  ▓▓   ▓   ▓▓   ▓▓   ▓▓▓▓   ▓▓▓  ▓▓   ▓         ▓▓   ▓         ▓▓     ▓▓▓▓   ▓▓▓▓   ▓   ▓▓▓   ▓▓▓   ▓▓   ▓   ▓▓▓▓▓   
--▓▓▓▓▓   ▓▓▓▓▓▓   ▓▓▓   ▓▓    ▓   ▓▓   ▓▓  ▓▓   ▓   ▓▓   ▓▓   ▓▓▓▓   ▓▓▓▓▓▓▓   ▓  ▓▓▓▓▓▓▓▓▓   ▓  ▓▓▓▓▓▓▓▓▓   ▓   ▓▓   ▓▓▓▓   ▓   ▓▓▓   ▓▓▓   ▓▓   ▓▓   ▓▓▓▓   
--█████   ████████   █    █████   ██    ██  ██   ███      █    ████   ███████   ███     ████   ███     ████   ██   █   ████   ███   █    █    ██   ████    █   
--███████████████████████████    ██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████




-- Sunucu değişiminde scripti yeniden başlatmak için:
queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/YagmurMelekHanci/Mad-City-AutoRob/refs/heads/main/Yagmur%20Melek%20Hanci%20Mad%20City%20Chapter%201'))()")

_G.AutoRob = true
_G.RobberyCount = 0

-- GUI oluşturma
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local counterLabel = Instance.new("TextLabel")
counterLabel.Parent = gui
counterLabel.Size = UDim2.new(0, 200, 0, 50)
counterLabel.Position = UDim2.new(0, 10, 0, 10)
counterLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
counterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
counterLabel.TextScaled = true
counterLabel.Text = "Soygun Sayısı: 0"

local function updateRobberyCount()
    _G.RobberyCount = _G.RobberyCount + 1
    counterLabel.Text = "Soygun Sayısı: " .. _G.RobberyCount
end

-- Sunucu değiştirme (shop) fonksiyonu
function shop()
    local a,b = pcall(function()
        local servers = {}
        local req = request({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"})
        local body = game:GetService("HttpService"):JSONDecode(req.Body)
    
        if body and body.data then
            for _, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, 1, v.id)
                end
            end
        end

        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
        else
            if #game.Players:GetPlayers() <= 1 then
                player:Kick("Rejoining...")
                wait()
                game:GetService("TeleportService"):Teleport(game.PlaceId, player)
            else
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
            end
        end
    end)

    if not a then
        shop()
    end

    task.spawn(function()
        while wait(5) do
            shop()
        end
    end)
end

-- Oyuncu ölürse yeniden bağlan
player.Character:WaitForChild("Humanoid").Died:Connect(function()
    shop()
end)

-- Hedefe ışınlama fonksiyonu
local function tp(x, y, z)
    local core = Game.Workspace.Pyramid.Tele.Core2
    core.CanCollide = false
    core.Transparency = 1
    core.CFrame = player.Character.HumanoidRootPart.CFrame
    task.wait()
    core.CFrame = CFrame.new(1231.14185, 51051.2344, 318.096191)
    core.Transparency = 0
    core.CanCollide = true
    task.wait()
    for _ = 1, 45 do
        player.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        task.wait()
    end
end

-- Soygun hedefleri
local MiniRobberies = {
    "Cash",
    "CashRegister",
    "DiamondBox",
    "Laptop",
    "Phone",
    "Luggage",
    "ATM",
    "TV",
    "Safe"
}

-- RemoteEvent bulma
local function getevent(v)
    for _, ev in next, v:GetDescendants() do
        if ev:IsA("RemoteEvent") then
            return ev
        end
    end
end

-- Soygun yapılabilir hedef bulma
local function getrobbery()
    for _, v in next, workspace.ObjectSelection:GetChildren() do
        if table.find(MiniRobberies, v.Name) and not v:FindFirstChild("Nope") and getevent(v) then
            return v
        end
    end
end

-- Takı kutuları soyuluyor
tp(-82, 86, 807)
task.wait(0.5)
for _, v in pairs(workspace.JewelryStore.JewelryBoxes:GetChildren()) do
    task.spawn(function()
        for _ = 1, 5 do
            workspace.JewelryStore.JewelryBoxes.JewelryManager.Event:FireServer(v)
        end
    end)
end

-- Mini soygunlara geçiş
task.wait(2)
tp(2115, 26, 420)
task.wait(1)

-- Soygun döngüsü
repeat
    local robbery = getrobbery()
    if robbery then
        for _ = 1, 20 do
            player.Character.HumanoidRootPart.CFrame = CFrame.new(robbery:GetPivot().Position + Vector3.new(0, 5, 0))
            getevent(robbery):FireServer()
            task.wait()
        end
        updateRobberyCount()
        print("Soygun sayısı: " .. _G.RobberyCount)
    end
until getrobbery() == nil

-- Sunucu değiştir
task.wait(1)
shop()
