local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- Pembersihan GUI
if CoreGui:FindFirstChild("VercoUltimate") then CoreGui.VercoUltimate:Destroy() end
if CoreGui:FindFirstChild("CT_Icon") then CoreGui.CT_Icon:Destroy() end

-- Variabel Global (Pengaturan)
_G.Aimlock = false
_G.FovSize = 100
_G.FovVisible = true
_G.Esp3D = false
_G.EspLine = false
_G.EspColor = Color3.fromRGB(255, 0, 0)
_G.FovColor = Color3.fromRGB(255, 0, 0)

-- Drawing FOV
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1
FovCircle.NumSides = 360
FovCircle.Filled = false

-- ================= LOGIC RENDER =================
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    FovCircle.Visible = _G.FovVisible
    FovCircle.Radius = _G.FovSize
    FovCircle.Color = _G.FovColor
    FovCircle.Position = UIS:GetMouseLocation()

    -- Logic Aimlock dengan Pembatasan FOV
    if _G.Aimlock then
        local target = nil
        local shortest = _G.FovSize
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mag < shortest then
                        shortest = mag
                        target = v
                    end
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- ================= GUI DESIGN =================
local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "VercoUltimate"

local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 550, 0, 380)
Frame.Position = UDim2.new(0.5, -275, 0.5, -190)
Frame.BackgroundColor3 = Color3.fromRGB(5, 10, 5)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Particle Green Effect
for i = 1, 15 do
    local p = Instance.new("Frame", Frame)
    p.Size = UDim2.new(0, 1, 0, 15)
    p.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    p.BackgroundTransparency = 0.5
end

local Sidebar = Instance.new("Frame", Frame)
Sidebar.Size = UDim2.new(0, 120, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 20, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
Title.Text = " VERCO X NUGI "
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

local Content = Instance.new("ScrollingFrame", Frame)
Content.Size = UDim2.new(1, -135, 1, -60)
Content.Position = UDim2.new(0, 130, 0, 55)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 2, 0)
local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0, 8)

-- Fungsi Helper
local function AddToggle(name, default, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
    btn.Text = name .. " : OFF"
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.Font = Enum.Font.GothamBold
    local s = default
    btn.MouseButton1Click:Connect(function()
        s = not s
        btn.Text = name .. (s and " : ON" or " : OFF")
        btn.BackgroundColor3 = s and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(20, 40, 20)
        callback(s)
    end)
end

local function AddSlider(name, min, max, callback)
    local txt = Instance.new("TextLabel", Content)
    txt.Size = UDim2.new(1, -10, 0, 20)
    txt.Text = name .. " [Geser]"
    txt.TextColor3 = Color3.fromRGB(0, 255, 0)
    txt.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
    btn.Text = tostring(min)
    btn.MouseButton1Click:Connect(function()
        local val = tonumber(btn.Text) + 20
        if val > max then val = min end
        btn.Text = tostring(val)
        callback(val)
    end)
end

-- TAB MENU
local function ShowAim()
    for _, v in pairs(Content:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") then v:Destroy() end end
    AddToggle("Aimlock Head", false, function(v) _G.Aimlock = v end)
    AddToggle("Show FOV Circle", true, function(v) _G.FovVisible = v end)
    AddSlider("FOV Size (0-360)", 100, 360, function(v) _G.FovSize = v end)
    
    AddToggle("Ubah FOV ke Merah", false, function(v) _G.FovColor = v and Color3.new(1,0,0) or Color3.new(0,1,0) end)
    AddToggle("Ubah ESP ke Kuning", false, function(v) _G.EspColor = v and Color3.new(1,1,0) or Color3.new(1,0,0) end)
end

local function ShowVisual()
    for _, v in pairs(Content:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") then v:Destroy() end end
    AddToggle("3D Box ESP", false, function(v) _G.Esp3D = v end)
    AddToggle("ESP Line", false, function(v) _G.EspLine = v end)
end

-- Sidebar Buttons
local function CreateTab(name, func)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.Position = UDim2.new(0, 0, 0, (#Sidebar:GetChildren()-1) * 45)
    b.MouseButton1Click:Connect(func)
end

CreateTab("AIMLOCK", ShowAim)
CreateTab("VISUAL", ShowVisual)
ShowAim()

-- ================= CT ICON =================
local CTGui = Instance.new("ScreenGui", CoreGui)
local CTBtn = Instance.new("Frame", CTGui)
CTBtn.Size = UDim2.new(0, 60, 0, 60)
CTBtn.Position = UDim2.new(0, 15, 0.5, 0)
CTBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
CTBtn.Active = true
CTBtn.Draggable = true
Instance.new("UICorner", CTBtn).CornerRadius = UDim.new(1, 0)
local CL = Instance.new("TextButton", CTBtn)
CL.Size = UDim2.new(1, 0, 1, 0)
CL.BackgroundTransparency = 1
CL.Text = "CT"
CL.TextColor3 = Color3.fromRGB(0, 255, 0)
CL.TextSize = 24
CL.Font = Enum.Font.GothamBold
CL.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
