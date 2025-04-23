-- Ayarlar
_G.AutoRob = true
_G.RobberyCount = 0

-- Sunucu değişiminde otomatik yeniden başlatma
queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/YagmurMelekHanci/Mad-City-AutoRob/refs/heads/main/Yagmur%20Melek%20Hanci%20Mad%20City%20Chapter%201'))()")

for i = 1, 100 do
    print("Made by YagmurMelekHanci / YagmurMelek (on dc)")
end

-- Sunucu değiştirme (server hop)
function shop()
    local success, result = pcall(function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local servers = {}
        local response = request({
            Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"
        })

        local data = HttpService:JSONDecode(response.Body)
        for _, server in ipairs(data.data) do
            if tonumber(server.playing) < tonumber(server.maxPlayers) and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end

        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
        else
            TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    end)

    if not success then
        warn("Sunucu değiştirilemedi, tekrar deneniyor...")
        shop()
    end
end

-- Died Event
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
    shop()
end)

-- Teleport efekti kaldır
local gui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MainGUI")
if gui and gui:FindFirstChild("TeleportEffect") then
    gui.TeleportEffect:Destroy()
end

-- Teleport sistemi
local function tp(x, y, z)
    local Core = workspace.Pyramid.Tele.Core2
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart

    Core.CanCollide = false
    Core.Transparency = 1
    Core.CFrame = hrp.CFrame
    task.wait()
    Core.CFrame = CFrame.new(1231.14185, 51051.2344, 318.096191)
    Core.Transparency = 0
    Core.CanCollide = true

    for i = 1, 25 do  -- daha hızlı
        hrp.CFrame = CFrame.new(x, y, z)
        task.wait(0.01)
    end
end

-- GUI Sayaç
local function setupGui()
    local player = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "RobberyCounter"
    gui.ResetOnSpawn = false

    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(0, 200, 0, 50)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Text = "Soygun Sayısı: 0"

    game:GetService("RunService").RenderStepped:Connect(function()
        label.Text = "Soygun Sayısı: " .. tostring(_G.RobberyCount)
    end)
end
setupGui()

-- Soygun tanımı
local MiniRobberies = {
    "Cash", "CashRegister", "DiamondBox", "Laptop", "Phone",
    "Luggage", "ATM", "TV", "Safe"
}

local function getevent(v)
    for _, d in ipairs(v:GetDescendants()) do
        if d:IsA("RemoteEvent") then
            return d
        end
    end
end

local function getrobbery()
    for _, v in ipairs(workspace.ObjectSelection:GetChildren()) do
        if table.find(MiniRobberies, v.Name) and not v:FindFirstChild("Nope") and getevent(v) then
            return v
        end
    end
end

-- Jewelry soy
tp(-82, 86, 807)
task.wait(0.25)
for _, v in ipairs(workspace.JewelryStore.JewelryBoxes:GetChildren()) do
    task.spawn(function()
        for i = 1, 5 do
            workspace.JewelryStore.JewelryBoxes.JewelryManager.Event:FireServer(v)
        end
    end)
end
task.wait(1)

-- Mini soygun
tp(2115, 26, 420)
task.wait(0.5)
repeat
    local robbery = getrobbery()
    if robbery then
        local pivot = robbery:GetPivot().Position
        for i = 1, 10 do -- hızlandı
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pivot.X, pivot.Y + 5, pivot.Z)
            getevent(robbery):FireServer()
            task.wait(0.01) -- hızlandı
        end
        _G.RobberyCount += 1
        print("Soygun sayısı: " .. _G.RobberyCount)
    end
until getrobbery() == nil

task.wait(0.5)

-- Sürekli server hop başlat
task.spawn(function()
    while task.wait(3) do -- daha sık kontrol
        shop()
    end
end)
