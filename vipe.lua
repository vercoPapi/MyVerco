local Aceternity = loadstring(game:HttpGet("https://raw.githubusercontent.com/skid123skid/Aceternity/main/Source.lua"))()
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")

local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local AimbotEnabled = false
local TornadoEnabled = false
local WallhackEnabled = false
local ESPEnabled = false

local Window = Aceternity:CreateWindow({
    Title = "DELTA MOD MENU | " .. GameName,
    Subtitle = "Aceternity UI Style",
    Logo = "rbxassetid://123456789"
})

local MainTab = Window:CreateTab("Menu All", "home")

MainTab:CreateToggle({
    Name = "Aimbot (Lock Head)",
    Description = "Lock Head, Tidak Tembus Dinding, Bisa Geser Target",
    Callback = function(state)
        AimbotEnabled = state
        task.spawn(function()
            while AimbotEnabled do
                local Target = nil
                local Dist = math.huge
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        local Pos, Visible = Camera:WorldToViewportPoint(v.Character.Head.Position)
                        if Visible then
                            local RaycastParam = RaycastParams.new()
                            RaycastParam.FilterType = Enum.RaycastFilterType.Exclude
                            RaycastParam.FilterDescendantsInstances = {Player.Character, v.Character}
                            local RaycastResult = workspace:Raycast(Camera.CFrame.Position, (v.Character.Head.Position - Camera.CFrame.Position).Unit * 1000, RaycastParam)
                            
                            if not RaycastResult then
                                local MousePos = Vector2.new(Mouse.X, Mouse.Y)
                                local ScreenPos = Vector2.new(Pos.X, Pos.Y)
                                local Magnitude = (MousePos - ScreenPos).Magnitude
                                if Magnitude < Dist then
                                    Target = v
                                    Dist = Magnitude
                                end
                            end
                        end
                    end
                end
                if Target then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
                end
                task.wait()
            end
        end)
    end
})

MainTab:CreateButton({
    Name = "Execute MS100",
    Description = "Bawa Musuh < 100m ke depan layar",
    Callback = function()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local Distance = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if Distance <= 100 then
                    v.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                end
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Tornado Mode",
    Description = "Karakter Berputar Sendiri",
    Callback = function(state)
        TornadoEnabled = state
        task.spawn(function()
            while TornadoEnabled do
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
                end
                task.wait()
            end
        end)
    end
})

MainTab:CreateToggle({
    Name = "Wallhack (Noclip)",
    Description = "Tembus Dinding, Tidak Jatuh",
    Callback = function(state)
        WallhackEnabled = state
        local Connection
        Connection = RunService.Stepped:Connect(function()
            if not WallhackEnabled then Connection:Disconnect() return end
            if Player.Character then
                for _, v in pairs(Player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
})

MainTab:CreateSlider({
    Name = "Drone Camera",
    Min = 0,
    Max = 20,
    Default = 0,
    Callback = function(val)
        Camera.FieldOfView = 70 + (val * 2)
        Player.CameraMaxZoomDistance = 12.8 + (val * 10)
    end
})

MainTab:CreateButton({
    Name = "Anti Lag & Anti Crash",
    Description = "Optimasi Grafis & FPS",
    Callback = function()
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "ESP Line & Box (3D White)",
    Description = "Deteksi Tim & Musuh Mulus",
    Callback = function(state)
        ESPEnabled = state
        task.spawn(function()
            while ESPEnabled do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        if not v.Character:FindFirstChild("ESP_3D") then
                            local Folder = Instance.new("Folder", v.Character)
                            Folder.Name = "ESP_3D"
                            
                            local Box = Instance.new("BoxHandleAdornment", Folder)
                            Box.Size = v.Character:GetExtentsSize()
                            Box.Adornee = v.Character
                            Box.AlwaysOnTop = true
                            Box.ZIndex = 5
                            Box.Transparency = 0.6
                            Box.Color3 = Color3.new(1, 1, 1)

                            local Line = Instance.new("LineHandleAdornment", Folder)
                            Line.Length = 0
                            Line.Thickness = 2
                            Line.Adornee = v.Character.HumanoidRootPart
                            Line.AlwaysOnTop = true
                            Line.Color3 = Color3.new(1, 1, 1)

                            task.spawn(function()
                                while ESPEnabled and v.Character and v.Character:FindFirstChild("ESP_3D") do
                                    local TargetPos = v.Character.HumanoidRootPart.Position
                                    local SelfPos = Player.Character.HumanoidRootPart.Position
                                    Line.CFrame = CFrame.new(Vector3.new(), (SelfPos - TargetPos))
                                    Line.Length = (SelfPos - TargetPos).Magnitude
                                    task.wait()
                                end
                                Folder:Destroy()
                            end)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
})

local SettingsTab = Window:CreateTab("Settings", "settings")

SettingsTab:CreateKeybind({
    Name = "Hide / Show Menu",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        Aceternity:ToggleUI()
    end
})

SettingsTab:CreateButton({
    Name = "Exit Script",
    Callback = function()
        Aceternity:Destroy()
    end
})

Aceternity:Notify({
    Title = "System",
    Content = "Mod Menu Berhasil Dimuat untuk " .. GameName,
    Duration = 5
})
