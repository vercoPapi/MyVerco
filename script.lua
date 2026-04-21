local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Pembersihan GUI Lama
if CoreGui:FindFirstChild("VercoFinal") then CoreGui.VercoFinal:Destroy() end
if CoreGui:FindFirstChild("CT_Icon") then CoreGui.CT_Icon:Destroy() end

-- Variabel Global
_G.Aimlock = false
_G.FovSize = 100
_G.EspEnabled = false
_G.FlyKill = false
_G.MS10 = false

-- Drawing FOV (Kunci di Tengah)
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1.5
FovCircle.NumSides = 360
FovCircle.Radius = _G.FovSize
FovCircle.Filled = false
FovCircle.Color = Color3.fromRGB(255, 0, 0) -- Merah sesuai permintaan

-- ================= LOGIC RENDER & FITUR =================
RunService.RenderStepped:Connect(function()
    -- Update FOV posisi Tengah
    FovCircle.Visible = true
    FovCircle.Radius = _G.FovSize
    FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local Target = nil
    local Dist = _G.FovSize
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
            local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if OnScreen then
                local Mag = (Vector2.new(Pos.X, Pos.Y) - FovCircle.Position).Magnitude
                if Mag < Dist then
                    Dist = Mag
                    Target = v
                end
            end
            
            -- Logic MS10 (Musuh 10m didepan mata)
            if _G.MS10 then
                local Distance = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if Distance < 30 then -- Radius sekitar 10-15 meter
                    v.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                end
            end
        end
    end

    -- Logic Aimlock
    if _G.Aimlock and Target then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
    end

    -- Logic FlyKill (Auto Rush Musuh)
    if _G.FlyKill and Target then
        Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

-- ================= GUI DESIGN (TAB SAMPING) =================
local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "VercoFinal"

local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 500, 0, 350)
Frame.Position = UDim2.new(0.5, -250, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Frame.Active = true
Frame.Draggable = true
Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 0)

local Sidebar = Instance.new("Frame", Frame)
Sidebar.Size = UDim2.new(0, 120, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
Title.Text = " VERCO X NUGI "
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local Content = Instance.new("ScrollingFrame", Frame)
Content.Size = UDim2.new(1, -130, 1, -50)
Content.Position = UDim2.new(0, 125, 0, 45)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 2, 0)
Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)

-- Fungsi Helper
local function AddToggle(name, callback)
    local b = Instance.new("TextButton", Content)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = name .. " : OFF"
    b.TextColor3 = Color3.fromRGB(0, 255, 0)
    b.Font = Enum.Font.GothamBold
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s
        b.Text = name .. (s and " : ON" or " : OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 30)
        callback(s)
    end)
end

-- TABS
local function ShowAim()
    Content:ClearAllChildren()
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
    AddToggle("Aimlock Head", function(v) _G.Aimlock = v end)
    AddToggle("FlyKill (Auto Rush)", function(v) _G.FlyKill = v end)
    AddToggle("MS10 (TP Near Enemy)", function(v) _G.MS10 = v end)
end

local function ShowVisual()
    Content:ClearAllChildren()
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
    AddToggle("ESP Green Box", function(v) _G.EspEnabled = v end)
    AddToggle("ESP Green Line", function(v) _G.EspEnabled = v end)
end

local function ShowConfig()
    Content:ClearAllChildren()
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
    AddToggle("Anti Lag", function(v)
        if v then
            settings().Rendering.QualityLevel = 1
            for _, x in pairs(game:GetDescendants()) do
                if x:IsA("PostProcessEffect") then x.Enabled = false end
            end
        end
    end)
    AddToggle("HDR Grafik 3D", function(v)
        if v then
            local b = Instance.new("BloomEffect", game.Lighting)
            b.Intensity = 1 b.Size = 24
        end
    end)
end

-- Sidebar Navigation
local function CreateTab(name, func)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.BackgroundTransparency = 0.5
    b.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.Position = UDim2.new(0,0,0, (#Sidebar:GetChildren()-1)*45)
    b.MouseButton1Click:Connect(func)
end

CreateTab("AIM", ShowAim)
CreateTab("VISUAL", ShowVisual)
CreateTab("CONFIG", ShowConfig)
ShowAim()

-- ICON CT
local CTGui = Instance.new("ScreenGui", CoreGui)
local CTBtn = Instance.new("Frame", CTGui)
CTBtn.Size = UDim2.new(0, 60, 0, 60)
CTBtn.Position = UDim2.new(0, 10, 0.5, 0)
CTBtn.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
CTBtn.Active = true CTBtn.Draggable = true
Instance.new("UICorner", CTBtn).CornerRadius = UDim.new(1, 0)
local CL = Instance.new("TextButton", CTBtn)
CL.Size = UDim2.new(1,0,1,0) CL.BackgroundTransparency = 1
CL.Text = "CT" CL.TextColor3 = Color3.new(0,1,0)
CL.TextSize = 24 CL.Font = Enum.Font.GothamBold
CL.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
