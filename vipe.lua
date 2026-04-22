local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local Content = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local IconLK = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "Aceternity_Delta_LK"
ScreenGui.ResetOnSpawn = false

-- [[ ICON LK SAAT HIDE ]]
IconLK.Name = "LK_Icon"
IconLK.Parent = ScreenGui
IconLK.Size = UDim2.new(0, 50, 0, 50)
IconLK.Position = UDim2.new(0, 20, 0.5, -25)
IconLK.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconLK.Text = "LK"
IconLK.TextColor3 = Color3.fromRGB(0, 255, 150)
IconLK.Font = Enum.Font.GothamBold
IconLK.TextSize = 20
IconLK.Visible = false
IconLK.Draggable = true
Instance.new("UICorner", IconLK).CornerRadius = UDim.new(0, 10)
local IconStroke = Instance.new("UIStroke", IconLK)
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Thickness = 2

-- [[ MENU FRAME ]]
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -210)
MainFrame.Size = UDim2.new(0, 330, 0, 420)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(40, 40, 45)
UIStroke.Thickness = 2

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "DELTA MOD MENU | " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

Content.Parent = MainFrame
Content.Position = UDim2.new(0, 10, 0, 60)
Content.Size = UDim2.new(1, -20, 1, -70)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 0
Content.CanvasSize = UDim2.new(0, 0, 2, 0)

UIListLayout.Parent = Content
UIListLayout.Padding = UDim.new(0, 10)

-- [[ UI FUNCTIONS ]]
local function CreateToggle(name, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    Button.Text = "  " .. name
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 13
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Content
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    
    local active = false
    Button.MouseButton1Click:Connect(function()
        active = not active
        Button.TextColor3 = active and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(200, 200, 200)
        callback(active)
    end)
end

local function CreateSlider(name, min, max, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    SliderFrame.Parent = Content
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = name .. ": " .. min
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBar = Instance.new("TextButton", SliderFrame)
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 40)
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    SliderBar.Text = ""
    Instance.new("UICorner", SliderBar)

    local Fill = Instance.new("Frame", SliderBar)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    Instance.new("UICorner", Fill)

    local dragging = false
    local function Update()
        local pos = math.clamp((game.Players.LocalPlayer:GetMouse().X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = name .. ": " .. val
        callback(val)
    end
    SliderBar.MouseButton1Down:Connect(function() dragging = true end)
    game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    game:GetService("RunService").RenderStepped:Connect(function() if dragging then Update() end end)
end

local function CreateButton(name, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Button.Text = name
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.GothamBold
    Button.Parent = Content
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    Button.MouseButton1Click:Connect(callback)
end

-- [[ GAME LOGIC ]]
local LP = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local AimActive, TornadoActive, WallActive, EspActive = false, false, false, false

CreateToggle("Aimbot Lock Head", function(s)
    AimActive = s
    task.spawn(function()
        while AimActive do
            local target, dist = nil, math.huge
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
                    local p, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
                    if vis then
                        local r = RaycastParams.new()
                        r.FilterType = Enum.RaycastFilterType.Exclude
                        r.FilterDescendantsInstances = {LP.Character, v.Character}
                        if not workspace:Raycast(Camera.CFrame.Position, (v.Character.Head.Position - Camera.CFrame.Position).Unit * 1000, r) then
                            local mag = (Vector2.new(LP:GetMouse().X, LP:GetMouse().Y) - Vector2.new(p.X, p.Y)).Magnitude
                            if mag < dist then target = v dist = mag end
                        end
                    end
                end
            end
            if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
            task.wait()
        end
    end)
end)

CreateButton("Execute MS100", function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if (v.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude <= 100 then
                v.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            end
        end
    end
end)

CreateToggle("Tornado Mode", function(s)
    TornadoActive = s
    task.spawn(function()
        while TornadoActive do
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(50), 0)
            end
            task.wait()
        end
    end)
end)

CreateToggle("Wallhack (Noclip)", function(s)
    WallActive = s
    local c; c = game:GetService("RunService").Stepped:Connect(function()
        if not WallActive then c:Disconnect() return end
        if LP.Character then for _, v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end)
end)

CreateSlider("Drone Camera", 0, 20, function(v)
    Camera.FieldOfView = 70 + (v * 2)
    LP.CameraMaxZoomDistance = 12.8 + (v * 15)
end)

CreateButton("Anti Lag System", function()
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") then v:Destroy() end
    end
end)

CreateToggle("ESP Line & Box 3D", function(s)
    EspActive = s
    task.spawn(function()
        while EspActive do
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if not v.Character:FindFirstChild("ESP_3D") then
                        local h = Instance.new("Folder", v.Character); h.Name = "ESP_3D"
                        local b = Instance.new("BoxHandleAdornment", h)
                        b.Size = v.Character:GetExtentsSize(); b.Adornee = v.Character; b.AlwaysOnTop = true; b.Color3 = Color3.new(1,1,1); b.Transparency = 0.6
                        local l = Instance.new("LineHandleAdornment", h)
                        l.Thickness = 2; l.Adornee = v.Character.HumanoidRootPart; l.AlwaysOnTop = true; l.Color3 = Color3.new(1,1,1)
                        task.spawn(function()
                            while EspActive and v.Character and h do
                                l.CFrame = CFrame.new(Vector3.new(), (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position))
                                l.Length = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
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
end)

-- [[ HIDE & EXIT LOGIC ]]
local function ToggleUI()
    MainFrame.Visible = not MainFrame.Visible
    IconLK.Visible = not MainFrame.Visible
end

IconLK.MouseButton1Click:Connect(ToggleUI)
CreateButton("Hide Menu (RightCtrl)", ToggleUI)
CreateButton("Exit Mod Menu", function() ScreenGui:Destroy() end)

game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightControl then ToggleUI() end
end)
