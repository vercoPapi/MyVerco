local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local VercoGui = Instance.new("ScreenGui")
VercoGui.Name = "VercoToHack"
VercoGui.ResetOnSpawn = false
VercoGui.Parent = game.CoreGui

-- Main Menu Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
Main.Active = true
Main.Draggable = true
Main.Parent = VercoGui

-- Icon LK (Muncul saat Hide)
local LK_Icon = Instance.new("TextButton")
LK_Icon.Name = "LK_Icon"
LK_Icon.Size = UDim2.new(0, 40, 0, 40)
LK_Icon.Position = UDim2.new(0, 10, 0.5, -20)
LK_Icon.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
LK_Icon.Text = "LK"
LK_Icon.TextColor3 = Color3.new(1, 1, 1)
LK_Icon.Font = Enum.Font.GothamBlack
LK_Icon.TextSize = 18
LK_Icon.Visible = false
LK_Icon.Parent = VercoGui
local CornerIcon = Instance.new("UICorner", LK_Icon)
CornerIcon.CornerRadius = UDim.new(1, 0)

-- Particle Background
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
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.BackgroundTransparency = 1

local SideBar = Instance.new("ScrollingFrame", Main)
SideBar.Size = UDim2.new(0, 150, 0, 260)
SideBar.Position = UDim2.new(0, 10, 0, 50)
SideBar.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
SideBar.BorderSizePixel = 0
SideBar.ScrollBarThickness = 2

local FeaturePanel = Instance.new("ScrollingFrame", Main)
FeaturePanel.Size = UDim2.new(0, 370, 0, 260)
FeaturePanel.Position = UDim2.new(0, 170, 0, 50)
FeaturePanel.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
FeaturePanel.BorderSizePixel = 0
FeaturePanel.ScrollBarThickness = 2

Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 5)
Instance.new("UIListLayout", FeaturePanel).Padding = UDim.new(0, 5)

-- System Checkbox (Centang)
local function AddToggle(name, callback)
    local Frame = Instance.new("Frame", FeaturePanel)
    Frame.Size = UDim2.new(0.95, 0, 0, 40)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Text = " " .. name
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.GothamBold
    Label.BackgroundTransparency = 1

    local Box = Instance.new("TextButton", Frame)
    Box.Size = UDim2.new(0, 25, 0, 25)
    Box.Position = UDim2.new(1, -35, 0.5, -12)
    Box.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    Box.BorderColor3 = Color3.fromRGB(255, 0, 0)
    Box.Text = ""
    
    local enabled = false
    Box.MouseButton1Click:Connect(function()
        enabled = not enabled
        Box.Text = enabled and "✓" or ""
        Box.TextColor3 = Color3.fromRGB(255, 0, 0)
        callback(enabled)
    end)
end

local function ClearFeatures()
    for _, v in pairs(FeaturePanel:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
end

-- TAB LOGIC
local Tabs = {
    ["Menu Aim"] = function()
        ClearFeatures()
        AddToggle("Aim Silent (360m)", function(val) _G.SilentAim = val end)
        AddToggle("AimBot (Lock)", function(val) _G.Aimbot = val end)
    end,
    ["Menu Esp"] = function()
        ClearFeatures()
        AddToggle("Esp Line", function(val) _G.EspLine = val end)
        AddToggle("Esp Box", function(val) _G.EspBox = val end)
    end,
    ["Menu Config"] = function()
        ClearFeatures()
        AddToggle("Wallhack (NoFall)", function(val) _G.Wallhack = val end)
        AddToggle("Fly Kill (TP Shoot)", function(val) _G.FlyKill = val end)
        AddToggle("Anti Lag (HDR 3D)", function(val) _G.AntiLag = val end)
    end
}

for tabName, func in pairs(Tabs) do
    local b = Instance.new("TextButton", SideBar)
    b.Size = UDim2.new(0.9, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    b.Text = tabName
    b.TextColor3 = Color3.new(1, 0, 0)
    b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(func)
end

-- Navigation
local HideBtn = Instance.new("TextButton", Main)
HideBtn.Text = "Hide"
HideBtn.Position = UDim2.new(0, 10, 1, -30)
HideBtn.Size = UDim2.new(0, 60, 0, 20)
HideBtn.BackgroundTransparency = 1
HideBtn.TextColor3 = Color3.new(1, 0, 0)

local ExitBtn = Instance.new("TextButton", Main)
ExitBtn.Text = "Exit"
ExitBtn.Position = UDim2.new(1, -70, 1, -30)
ExitBtn.Size = UDim2.new(0, 60, 0, 20)
ExitBtn.BackgroundTransparency = 1
ExitBtn.TextColor3 = Color3.new(1, 0, 0)

HideBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    LK_Icon.Visible = true
end)

LK_Icon.MouseButton1Click:Connect(function()
    Main.Visible = true
    LK_Icon.Visible = false
end)

ExitBtn.MouseButton1Click:Connect(function()
    VercoGui:Destroy()
end)
