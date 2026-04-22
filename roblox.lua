local Library = {}
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VercoToHack"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local ParticleFrame = Instance.new("Frame")
ParticleFrame.Size = UDim2.new(1, 0, 1, 0)
ParticleFrame.BackgroundTransparency = 1
ParticleFrame.ClipsDescendants = true
ParticleFrame.Parent = MainFrame

task.spawn(function()
    while task.wait(0.1) do
        local p = Instance.new("Frame")
        p.Size = UDim2.new(0, math.random(1,3), 0, math.random(1,3))
        p.Position = UDim2.new(math.random(), 0, 1.1, 0)
        p.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        p.BorderSizePixel = 0
        p.Parent = ParticleFrame
        local speed = math.random(2, 5)
        TweenService:Create(p, TweenInfo.new(speed), {Position = UDim2.new(math.random(), 0, -0.1, 0), BackgroundTransparency = 1}):Play()
        game:GetService("Debris"):AddItem(p, speed)
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "VERCO TO HACK"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextSize = 28
Title.Font = Enum.Font.LuckiestGuy
Title.Parent = MainFrame

local SideMenu = Instance.new("ScrollingFrame")
SideMenu.Size = UDim2.new(0, 160, 0, 260)
SideMenu.Position = UDim2.new(0, 10, 0, 60)
SideMenu.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
SideMenu.BorderSizePixel = 0
SideMenu.ScrollBarThickness = 2
SideMenu.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
SideMenu.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = SideMenu
UIList.Padding = UDim.new(0, 5)

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(0, 360, 0, 260)
ContentFrame.Position = UDim2.new(0, 180, 0, 60)
ContentFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 2
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
ContentFrame.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Parent = ContentFrame
ContentList.Padding = UDim.new(0, 5)

local function ClearContent()
    for _, v in pairs(ContentFrame:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
end

local function AddFeature(name, desc, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = ContentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

local Tabs = {
    ["Menu Aim"] = function()
        ClearContent()
        AddFeature("Aim Silent", "360m Field Hit", function() print("Silent Aim Active") end)
        AddFeature("AimBot", "Lock when visible", function() print("Aimbot Active") end)
    end,
    ["Menu Esp"] = function()
        ClearContent()
        AddFeature("Esp Line", "Tracer Lines", function() print("ESP Line Active") end)
        AddFeature("Esp Box", "Player Box", function() print("ESP Box Active") end)
    end,
    ["Menu Config"] = function()
        ClearContent()
        AddFeature("Wallhack", "No Clip / No Fall", function() print("Wallhack Active") end)
        AddFeature("Fly Kill", "TP & Kill", function() print("Fly Kill Active") end)
        AddFeature("Anti lag", "HDR 3D Boost", function() print("Anti Lag Active") end)
    end
}

for tabName, openFunc in pairs(Tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 45)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
    tabBtn.Font = Enum.Font.GothamBlack
    tabBtn.TextSize = 16
    tabBtn.Parent = SideMenu
    
    tabBtn.MouseButton1Click:Connect(openFunc)
end

local Hide = Instance.new("TextButton")
Hide.Size = UDim2.new(0, 100, 0, 30)
Hide.Position = UDim2.new(0, 10, 0, 315)
Hide.BackgroundTransparency = 1
Hide.Text = "HIDE"
Hide.TextColor3 = Color3.fromRGB(255, 0, 0)
Hide.Font = Enum.Font.GothamBold
Hide.TextSize = 18
Hide.Parent = MainFrame

local Exit = Instance.new("TextButton")
Exit.Size = UDim2.new(0, 100, 0, 30)
Exit.Position = UDim2.new(1, -110, 0, 315)
Exit.BackgroundTransparency = 1
Exit.Text = "EXIT"
Exit.TextColor3 = Color3.fromRGB(255, 0, 0)
Exit.Font = Enum.Font.GothamBold
Exit.TextSize = 18
Exit.Parent = MainFrame

Hide.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
Exit.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
