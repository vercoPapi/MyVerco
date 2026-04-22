local LK_Hub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICornerMain = Instance.new("UICorner")
local LeftPanel = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local TabHolder = Instance.new("ScrollingFrame")
local UIListLayoutTabs = Instance.new("UIListLayout")
local Container = Instance.new("Frame")
local CloseBtn = Instance.new("TextButton")

LK_Hub.Name = "VercoPanielV12"
LK_Hub.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = LK_Hub
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -160)
MainFrame.Size = UDim2.new(0, 560, 0, 320)
MainFrame.ClipsDescendants = true

UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

UIStroke.Thickness = 1.2
UIStroke.Color = Color3.fromRGB(45, 45, 45)
UIStroke.Parent = MainFrame

LeftPanel.Name = "LeftPanel"
LeftPanel.Parent = MainFrame
LeftPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LeftPanel.Size = UDim2.new(0, 150, 1, 0)

Title.Parent = LeftPanel
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Verco Paniel V.12"
Title.TextColor3 = Color3.fromRGB(0, 150, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

TabHolder.Parent = LeftPanel
TabHolder.BackgroundTransparency = 1
TabHolder.Position = UDim2.new(0, 5, 0, 50)
TabHolder.Size = UDim2.new(1, -10, 1, -60)
TabHolder.ScrollBarThickness = 0

UIListLayoutTabs.Parent = TabHolder
UIListLayoutTabs.Padding = UDim.new(0, 4)

Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Container.Position = UDim2.new(0, 160, 0, 10)
Container.Size = UDim2.new(1, -170, 1, -20)

local IconLK = Instance.new("TextButton")
IconLK.Size = UDim2.new(0, 50, 0, 50)
IconLK.Position = UDim2.new(0.05, 0, 0.05, 0)
IconLK.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
IconLK.Text = "LK"
IconLK.TextColor3 = Color3.fromRGB(255, 255, 255)
IconLK.Font = Enum.Font.GothamBold
IconLK.Visible = false
IconLK.Parent = LK_Hub
local CornerIcon = Instance.new("UICorner")
CornerIcon.CornerRadius = UDim.new(1, 0)
CornerIcon.Parent = IconLK

CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.BackgroundTransparency = 1
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IconLK.Visible = true
end)

IconLK.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    IconLK.Visible = false
end)

local Pages = {}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 12
    TabBtn.Parent = TabHolder
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.Parent = Container
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Page
    Layout.Padding = UDim.new(0, 6)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        Page.Visible = true
    end)
    
    return Page
end

local function CreateToggle(page, text, callback)
    local TglBtn = Instance.new("TextButton")
    TglBtn.Size = UDim2.new(1, -5, 0, 38)
    TglBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TglBtn.Text = "   " .. text
    TglBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    TglBtn.TextXAlignment = Enum.TextXAlignment.Left
    TglBtn.Font = Enum.Font.Gotham
    TglBtn.Parent = page
    Instance.new("UICorner", TglBtn).CornerRadius = UDim.new(0, 6)

    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 18, 0, 18)
    Box.Position = UDim2.new(1, -28, 0.5, -9)
    Box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Box.Parent = TglBtn
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

    local state = false
    TglBtn.MouseButton1Click:Connect(function()
        state = not state
        Box.BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
        callback(state)
    end)
end

local function CreateSlider(page, text, min, max, def, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.Parent = page
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.Text = "   " .. text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Bar = Instance.new("TextButton")
    Bar.Size = UDim2.new(0.9, 0, 0, 6)
    Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Bar.Text = ""
    Bar.Parent = Frame
    Instance.new("UICorner", Bar)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Fill.Parent = Bar
    Instance.new("UICorner", Fill)

    Bar.MouseButton1Click:Connect(function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local percent = math.clamp((mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.floor(min + (max - min) * percent)
        callback(val)
    end)
end

local function CreateButton(page, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = page
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

local AimPage = CreateTab("Menu Aim")
local VisualPage = CreateTab("Menu Visual")
local MovePage = CreateTab("Menu Movement")

CreateToggle(AimPage, "AimBot (Lock Head)", function(t) end)
CreateToggle(AimPage, "AimSilent", function(t) end)

CreateToggle(VisualPage, "Enable Esp", function(t) end)
CreateToggle(VisualPage, "Line", function(t) end)
CreateToggle(VisualPage, "Box", function(t) end)
CreateToggle(VisualPage, "Health", function(t) end)
CreateToggle(VisualPage, "Name", function(t) end)
CreateToggle(VisualPage, "Dist&stance", function(t) end)

CreateToggle(MovePage, "Wallhack (NoJatuhMap)", function(t) end)
CreateSlider(MovePage, "Speed (running)", 16, 500, 16, function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end)
CreateButton(MovePage, "FlyKill (TeleportKeMusuh)", function() end)
CreateToggle(MovePage, "Fly (diam di atas map)", function(t) end)
CreateToggle(MovePage, "Ms100 (dekat musuh 100M)", function(t) end)
CreateSlider(MovePage, "SkinPlayer (Geser)", 1, 50, 1, function(v) end)

AimPage.Visible = true
