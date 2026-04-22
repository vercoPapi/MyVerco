local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local VercoGui = Instance.new("ScreenGui")
VercoGui.Name = "VercoToHack"
VercoGui.Parent = CoreGui
VercoGui.ResetOnSpawn = false

-- Icon LK saat Hide
local IconLK = Instance.new("TextButton")
IconLK.Name = "LK_Icon"
IconLK.Parent = VercoGui
IconLK.Size = UDim2.new(0, 40, 0, 40)
IconLK.Position = UDim2.new(0, 10, 0.5, 0)
IconLK.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
IconLK.BorderSizePixel = 2
IconLK.BorderColor3 = Color3.fromRGB(255, 0, 0)
IconLK.Text = "LK"
IconLK.TextColor3 = Color3.fromRGB(255, 0, 0)
IconLK.Font = Enum.Font.GothamBlack
IconLK.TextSize = 20
IconLK.Visible = false
local IconCorner = Instance.new("UICorner", IconLK)
IconCorner.CornerRadius = UDim.new(0, 8)

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = VercoGui
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
Main.Active = true
Main.Draggable = true

local BgEffect = Instance.new("Frame", Main)
BgEffect.Size = UDim2.new(1, 0, 1, 0)
BgEffect.BackgroundTransparency = 1
BgEffect.ClipsDescendants = true

task.spawn(function()
    while task.wait(0.1) do
        local p = Instance.new("Frame", BgEffect)
        p.Size = UDim2.new(0, 2, 0, 2)
        p.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        p.Position = UDim2.new(math.random(), 0, 1, 0)
        p.BorderSizePixel = 0
        TS:Create(p, TweenInfo.new(3), {Position = UDim2.new(math.random(), 0, -0.1, 0), BackgroundTransparency = 1}):Play()
        game:GetService("Debris"):AddItem(p, 3)
    end
end)

local Title = Instance.new("TextLabel", Main)
Title.Text = "VERCO TO HACK"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.BackgroundTransparency = 1

local SideBar = Instance.new("ScrollingFrame", Main)
SideBar.Size = UDim2.new(0, 150, 0, 250)
SideBar.Position = UDim2.new(0, 10, 0, 60)
SideBar.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
SideBar.BorderSizePixel = 0
SideBar.ScrollBarThickness = 2
SideBar.ScrollBarImageColor3 = Color3.fromRGB(255,0,0)

local FeaturePanel = Instance.new("ScrollingFrame", Main)
FeaturePanel.Size = UDim2.new(0, 360, 0, 250)
FeaturePanel.Position = UDim2.new(0, 170, 0, 60)
FeaturePanel.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
FeaturePanel.BorderSizePixel = 0
FeaturePanel.ScrollBarThickness = 2
FeaturePanel.ScrollBarImageColor3 = Color3.fromRGB(255,0,0)

Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 5)
Instance.new("UIListLayout", FeaturePanel).Padding = UDim.new(0, 5)

-- Fungsi Checkbox Merah Gahar
local function CreateCheckbox(name, parent, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(0.95, 0, 0, 40)
    Frame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local Box = Instance.new("TextButton", Frame)
    Box.Size = UDim2.new(0, 25, 0, 25)
    Box.Position = UDim2.new(0.85, 0, 0.2, 0)
    Box.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    Box.BorderColor3 = Color3.fromRGB(255, 0, 0)
    Box.Text = ""
    
    local Checked = false
    Box.MouseButton1Click:Connect(function()
        Checked = not Checked
        Box.Text = Checked and "X" or ""
        Box.TextColor3 = Color3.fromRGB(255, 0, 0)
        Box.Font = Enum.Font.GothamBlack
        callback(Checked)
    end)
end

local function ClearFeatures()
    for _, v in pairs(FeaturePanel:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
end

-- LOGIKA FITUR (WORK)
local Features = {
    Aimbot = false,
    SilentAim = false,
    Wallhack = false,
    FlyKill = false,
    AntiLag = false
}

local function GetClosestPlayer()
    local target = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
            local mag = (v.Character.Head.Position - LP.Character.Head.Position).Magnitude
            if mag < dist then
                dist = mag
                target = v
            end
        end
    end
    return target
end

-- Tab Logic
local Tabs = {
    ["Menu Aim"] = function()
        ClearFeatures()
        CreateCheckbox("Aim Silent (360m)", FeaturePanel, function(v) 
            Features.SilentAim = v 
        end)
        CreateCheckbox("AimBot (Lock)", FeaturePanel, function(v) 
            Features.Aimbot = v 
        end)
    end,
    ["Menu Esp"] = function()
        ClearFeatures()
        CreateCheckbox("Esp Line", FeaturePanel, function(v) print("ESP Line: "..tostring(v)) end)
        CreateCheckbox("Esp Box", FeaturePanel, function(v) print("ESP Box: "..tostring(v)) end)
    end,
    ["Menu Config"] = function()
        ClearFeatures()
        CreateCheckbox("Wallhack", FeaturePanel, function(v) 
            Features.Wallhack = v
            LP.Character.HumanoidRootPart.CanCollide = not v
        end)
        CreateCheckbox("Fly Kill", FeaturePanel, function(v) 
            Features.FlyKill = v 
        end)
        CreateCheckbox("Anti lag (HDR)", FeaturePanel, function(v)
            if v then
                game.Lighting.Brightness = 2
                game.Lighting.GlobalShadows = true
            end
        end)
    end
}

-- Side Buttons
for tabName, func in pairs(Tabs) do
    local b = Instance.new("TextButton", SideBar)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    b.Text = tabName
    b.TextColor3 = Color3.fromRGB(255, 0, 0)
    b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(func)
end

-- Loop Fungsi
RS.RenderStepped:Connect(function()
    local target = GetClosestPlayer()
    if target and target.Character then
        if Features.Aimbot then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
        end
        if Features.FlyKill then
            LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            -- Auto Shoot Logic here
        end
    end
end)

-- Footer Controls
local Hide = Instance.new("TextButton", Main)
Hide.Text = "Hide"
Hide.Size = UDim2.new(0, 80, 0, 30)
Hide.Position = UDim2.new(0, 10, 1, -35)
Hide.BackgroundTransparency = 1
Hide.TextColor3 = Color3.fromRGB(255, 0, 0)
Hide.Font = Enum.Font.GothamBold
Hide.MouseButton1Click:Connect(function()
    Main.Visible = false
    IconLK.Visible = true
end)

local Exit = Instance.new("TextButton", Main)
Exit.Text = "Exit"
Exit.Size = UDim2.new(0, 80, 0, 30)
Exit.Position = UDim2.new(1, -90, 1, -35)
Exit.BackgroundTransparency = 1
Exit.TextColor3 = Color3.fromRGB(255, 0, 0)
Exit.Font = Enum.Font.GothamBold
Exit.MouseButton1Click:Connect(function() VercoGui:Destroy() end)

IconLK.MouseButton1Click:Connect(function()
    Main.Visible = true
    IconLK.Visible = false
end)
