local Aceternity = loadstring(game:HttpGet("https://raw.githubusercontent.com/vercoPapi/MyVerco/main/vipe.lua"))()
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")

-- Pengecekan Game ID agar berjalan lancar
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

-- Variabel Fitur
local AimbotEnabled = false
local TornadoEnabled = false
local WallhackEnabled = false
local ESPEnabled = false

-- Membuat Window Utama
local Window = Aceternity:CreateWindow({
    Title = "DELTA MOD MENU | " .. GameName,
    Subtitle = "Aceternity UI Style",
    Logo = "rbxassetid://123456789"
})

local MainTab = Window:CreateTab("Menu All", "home")

-- [[ FITUR AIMBOT LOCK HEAD ]]
MainTab:CreateToggle({
    Name = "Aimbot Lock Head",
    Description = "Lock Head player visible (Tidak Tembus Dinding)",
    Callback = function(state)
        AimbotEnabled = state
        task.spawn(function()
            while AimbotEnabled do
                local closestTarget = nil
                local shortestDist = math.huge
                
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        local head = v.Character.Head
                        local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        
                        if onScreen then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            rayParams.FilterDescendantsInstances = {Player.Character, v.Character}
                            local result = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, rayParams)
                            
                            if not result then 
                                local mouseDist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                                if mouseDist < shortestDist then
                                    closestTarget = v
                                    shortestDist = mouseDist
                                end
                            end
                        end
                    end
                end
                
                if closestTarget then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Character.Head.Position)
                end
                task.wait()
            end
        end)
    end
})

-- [[ FITUR MS100 ]]
MainTab:CreateButton({
    Name = "Execute MS100",
    Description = "Bawa musuh jarak < 100m ke depan layar",
    Callback = function()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if distance <= 100 then
                    v.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                end
            end
        end
    end
})

-- [[ FITUR TORNADO ]]
MainTab:CreateToggle({
    Name = "Tornado Mode",
    Description = "Karakter berputar-putar sendiri",
    Callback = function(state)
        TornadoEnabled = state
        task.spawn(function()
            while TornadoEnabled do
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(60), 0)
                end
                task.wait()
            end
        end)
    end
})

-- [[ FITUR WALLHACK (NOCLIP) ]]
MainTab:CreateToggle({
    Name = "Wallhack All Wall",
    Description = "Tembus dinding tanpa jatuh kebawah",
    Callback = function(state)
        WallhackEnabled = state
        local connection
        connection = RunService.Stepped:Connect(function()
            if not WallhackEnabled then connection:Disconnect() return end
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
})

-- [[ FITUR DRONE CAMERA 0-20 ]]
MainTab:CreateSlider({
    Name = "Drone Camera",
    Min = 0,
    Max = 20,
    Default = 0,
    Callback = function(val)
        Camera.FieldOfView = 70 + (val * 2)
        Player.CameraMaxZoomDistance = 12.8 + (val * 15)
    end
})

-- [[ FITUR ANTI LAG ]]
MainTab:CreateButton({
    Name = "Anti Lag All Game",
    Description = "Optimasi Anti Crash & FPS Patah-patah",
    Callback = function()
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
    end
})

-- [[ FITUR ESP LINE & BOX 3D WHITE ]]
MainTab:CreateToggle({
    Name = "ESP Line & Box 3D White",
    Description = "Mulus Putih, Deteksi Tim & Musuh",
    Callback = function(state)
        ESPEnabled = state
        task.spawn(function()
            while ESPEnabled do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        if not v.Character:FindFirstChild("ESP_Holder") then
                            local holder = Instance.new("Folder", v.Character)
                            holder.Name = "ESP_Holder"
                            
                            local box = Instance.new("BoxHandleAdornment", holder)
                            box.Size = v.Character:GetExtentsSize()
                            box.Adornee = v.Character
                            box.AlwaysOnTop = true
                            box.ZIndex = 5
                            box.Transparency = 0.5
                            box.Color3 = Color3.new(1, 1, 1)

                            local line = Instance.new("LineHandleAdornment", holder)
                            line.Thickness = 2
                            line.Adornee = v.Character.HumanoidRootPart
                            line.AlwaysOnTop = true
                            line.Color3 = Color3.new(1, 1, 1)

                            task.spawn(function()
                                while ESPEnabled and v.Character and v.Character:FindFirstChild("ESP_Holder") do
                                    local targetPos = v.Character.HumanoidRootPart.Position
                                    local selfPos = Player.Character.HumanoidRootPart.Position
                                    line.CFrame = CFrame.new(Vector3.new(), (selfPos - targetPos))
                                    line.Length = (selfPos - targetPos).Magnitude
                                    task.wait()
                                end
                                if holder then holder:Destroy() end
                            end)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
})

-- [[ SETTINGS: HIDE & EXIT ]]
local SettingsTab = Window:CreateTab("Settings", "settings")

SettingsTab:CreateKeybind({
    Name = "Hide Menu",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        Aceternity:ToggleUI()
    end
})

SettingsTab:CreateButton({
    Name = "Exit Mod Menu",
    Callback = function()
        Aceternity:Destroy()
    end
})

-- Notification Loader
Aceternity:Notify({
    Title = "System",
    Content = "Mod Menu Loaded for: " .. GameName,
    Duration = 5
})
