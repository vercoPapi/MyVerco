local Aceternity = loadstring(game:HttpGet("https://raw.githubusercontent.com/skid123skid/Aceternity/main/Source.lua"))()
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")

-- Mendapatkan info game untuk optimasi kelancaran
local gameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local gameName = gameInfo.Name

-- State Variables
local AimbotEnabled = false
local TornadoEnabled = false
local WallhackEnabled = false
local ESPEnabled = false

local Window = Aceternity:CreateWindow({
    Title = "DELTA MOD MENU | " .. gameName,
    Subtitle = "Aceternity UI Style",
    Logo = "rbxassetid://123456789"
})

local MainTab = Window:CreateTab("Menu All", "home")

-- [[ FUNGSI AIMBOT ]]
MainTab:CreateToggle({
    Name = "Aimbot Lock Head",
    Description = "Lock Head, Tidak Tembus Dinding, Smooth Target",
    Callback = function(state)
        AimbotEnabled = state
        task.spawn(function()
            while AimbotEnabled do
                local closestTarget = nil
                local shortestDist = math.huge
                
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                        local head = v.Character.Head
                        local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        
                        if onScreen then
                            -- Raycast check agar tidak lock tembus dinding
                            local params = RaycastParams.new()
                            params.FilterType = Enum.RaycastFilterType.Exclude
                            params.FilterDescendantsInstances = {Player.Character, v.Character}
                            local result = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, params)
                            
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

-- [[ FUNGSI MS100 ]]
MainTab:CreateButton({
    Name = "Execute MS100",
    Description = "Deteksi musuh 100m dan pindahkan ke depan layar",
    Callback = function()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if dist <= 100 then
                    v.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                end
            end
        end
    end
})

-- [[ FUNGSI TORNADO ]]
MainTab:CreateToggle({
    Name = "Tornado Mode",
    Description = "Karakter berputar secara otomatis",
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

-- [[ FUNGSI WALLHACK ]]
MainTab:CreateToggle({
    Name = "Wallhack (Noclip)",
    Description = "Tembus dinding tanpa jatuh ke bawah",
    Callback = function(state)
        WallhackEnabled = state
        local nc
        nc = RunService.Stepped:Connect(function()
            if not WallhackEnabled then nc:Disconnect() return end
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

-- [[ FUNGSI DRONE CAMERA ]]
MainTab:CreateSlider({
    Name = "Drone Camera",
    Min = 0,
    Max = 20,
    Default = 0,
    Callback = function(v)
        Player.CameraMaxZoomDistance = 12.8 + (v * 10)
        Camera.FieldOfView = 70 + (v * 2)
    end
})

-- [[ FUNGSI ANTI LAG ]]
MainTab:CreateButton({
    Name = "Anti Lag All Game",
    Description = "Anti crash, anti patah-patah, optimasi total",
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

-- [[ FUNGSI ESP LINE & BOX ]]
MainTab:CreateToggle({
    Name = "ESP Line & Box 3D White",
    Description = "Deteksi semua target Tim & Musuh (Mulus)",
    Callback = function(state)
        ESPEnabled = state
        task.spawn(function()
            while ESPEnabled do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        if not v.Character:FindFirstChild("ESP_Holder") then
                            local h = Instance.new("Folder", v.Character)
                            h.Name = "ESP_Holder"
                            
                            -- 3D Box White
                            local box = Instance.new("BoxHandleAdornment", h)
                            box.Adornee = v.Character
                            box.Size = v.Character:GetExtentsSize()
                            box.AlwaysOnTop = true
                            box.Transparency = 0.5
                            box.Color3 = Color3.new(1, 1, 1)
                            box.ZIndex = 10

                            -- 3D Line White
                            local line = Instance.new("LineHandleAdornment", h)
                            line.Adornee = v.Character.HumanoidRootPart
                            line.AlwaysOnTop = true
                            line.Color3 = Color3.new(1, 1, 1)
                            line.Thickness = 2
                            
                            task.spawn(function()
                                while ESPEnabled and v.Character and v.Character:FindFirstChild("ESP_Holder") do
                                    local root = v.Character.HumanoidRootPart
                                    line.CFrame = CFrame.new(Vector3.new(), (Player.Character.HumanoidRootPart.Position - root.Position))
                                    line.Length = (Player.Character.HumanoidRootPart.Position - root.Position).Magnitude
                                    task.wait()
                                end
                                if h then h:Destroy() end
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
local ConfigTab = Window:CreateTab("Settings", "settings")

ConfigTab:CreateKeybind({
    Name = "Hide Menu",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        Aceternity:ToggleUI()
    end
})

ConfigTab:CreateButton({
    Name = "Exit / Destroy Script",
    Callback = function()
        Aceternity:Destroy()
    end
})

-- Game Checker Notification
Aceternity:Notify({
    Title = "System Check",
    Content = "Mod Menu siap digunakan untuk: " .. gameName,
    Duration = 5
})
