local LK_Hub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftPanel = Instance.new("Frame")
local TabHolder = Instance.new("ScrollingFrame")
local ContentHolder = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local UICornerMain = Instance.new("UICorner")

LK_Hub.Name = "VercoPanielV12"
LK_Hub.Parent = game.CoreGui
LK_Hub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = LK_Hub
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -170)
MainFrame.Size = UDim2.new(0, 600, 0, 340) -- 16:9 Ratio Approx
MainFrame.Visible = true

UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

LeftPanel.Name = "LeftPanel"
LeftPanel.Parent = MainFrame
LeftPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LeftPanel.Size = UDim2.new(0, 160, 1, 0)

Title.Parent = LeftPanel
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Verco Paniel V.12"
Title.TextColor3 = Color3.fromRGB(0, 150, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

TabHolder.Parent = LeftPanel
TabHolder.BackgroundTransparency = 1
TabHolder.Position = UDim2.new(0, 0, 0, 50)
TabHolder.Size = UDim2.new(1, 0, 1, -50)
TabHolder.CanvasSize = UDim2.new(0, 0, 1.5, 0)
TabHolder.ScrollBarThickness = 0

ContentHolder.Name = "ContentHolder"
ContentHolder.Parent = MainFrame
ContentHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentHolder.Position = UDim2.new(0, 170, 0, 10)
ContentHolder.Size = UDim2.new(1, -180, 1, -20)

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = TabHolder
    TabBtn.Size = UDim2.new(1, -10, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 14
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = TabBtn
    
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Parent = ContentHolder
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Page
    Layout.Padding = UDim.new(0, 5)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(ContentHolder:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)
    
    return Page
end

local function CreateToggle(parent, text, callback)
    local Tgl = Instance.new("TextButton")
    Tgl.Size = UDim2.new(1, -10, 0, 30)
    Tgl.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Tgl.Text = "  " .. text
    Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tgl.TextXAlignment = Enum.TextXAlignment.Left
    Tgl.Parent = parent
    
    local Status = Instance.new("Frame")
    Status.Size = UDim2.new(0, 15, 0, 15)
    Status.Position = UDim2.new(1, -25, 0.5, -7)
    Status.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Status.Parent = Tgl
    
    local on = false
    Tgl.MouseButton1Click:Connect(function()
        on = not on
        Status.BackgroundColor3 = on and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 0, 0)
        callback(on)
    end)
end

local function CreateSlider(parent, text, min, max, callback)
    local Sld = Instance.new("Frame")
    Sld.Size = UDim2.new(1, -10, 0, 45)
    Sld.BackgroundTransparency = 1
    Sld.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Parent = Sld
    
    local Bar = Instance.new("TextButton")
    Bar.Size = UDim2.new(1, 0, 0, 10)
    Bar.Position = UDim2.new(0, 0, 0, 25)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Bar.Text = ""
    Bar.Parent = Sld
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0.5, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Fill.Parent = Bar
    
    Bar.MouseButton1Click:Connect(function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local percent = math.clamp((mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.floor(min + (max - min) * percent)
        callback(val)
    end)
end

local AimPage = CreateTab("Menu Aim")
local VisualPage = CreateTab("Menu Visual")
local MovePage = CreateTab("Menu Movement")

CreateToggle(AimPage, "AimBot (Lock Head)", function(v) end)
CreateToggle(AimPage, "AimSilent", function(v) end)

CreateToggle(VisualPage, "Enable Esp", function(v) end)
CreateToggle(VisualPage, "Line (Blue)", function(v) end)
CreateToggle(VisualPage, "Box (Blue)", function(v) end)
CreateToggle(VisualPage, "Health", function(v) end)
CreateToggle(VisualPage, "Name", function(v) end)
CreateToggle(VisualPage, "Dist&stance", function(v) end)

CreateToggle(MovePage, "Wallhack (NoJatuhMap)", function(v) end)
CreateSlider(MovePage, "Speed (Running)", 16, 500, function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end)
CreateToggle(MovePage, "FlyKill (Teleport Musuh)", function(v) end)
CreateToggle(MovePage, "Fly", function(v) end)
CreateToggle(MovePage, "Ms100 (Detect)", function(v) end)
CreateSlider(MovePage, "SkinPlayer (Geser)", 1, 100, function(v) end)

local IconLK = Instance.new("TextButton")
IconLK.Size = UDim2.new(0, 50, 0, 50)
IconLK.Position = UDim2.new(0, 20, 0, 20)
IconLK.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
IconLK.Text = "LK"
IconLK.TextColor3 = Color3.fromRGB(255, 255, 255)
IconLK.Visible = false
IconLK.Parent = LK_Hub
local CornerIcon = Instance.new("UICorner")
CornerIcon.CornerRadius = UDim.new(1, 0)
CornerIcon.Parent = IconLK

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.Text = "_"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IconLK.Visible = true
end)

IconLK.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    IconLK.Visible = false
end)

AimPage.Visible = true
