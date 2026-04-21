local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("VercoFinal") then CoreGui.VercoFinal:Destroy() end
if CoreGui:FindFirstChild("CT_Icon") then CoreGui.CT_Icon:Destroy() end

-- Variabel Global (Resetable)
_G.Aimlock = false
_G.FovSize = 100
_G.EspEnabled = false
_G.FlyKill = false
_G.MS10 = false
_G.Noclip = false

-- FOV Circle
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1.5
FovCircle.NumSides = 360
FovCircle.Radius = _G.FovSize
FovCircle.Filled = false
FovCircle.Color = Color3.fromRGB(255, 0, 0)
FovCircle.Visible = true

-- ================= LOOP UTAMA (DENGAN SISTEM MATI TOTAL) =================
RunService.RenderStepped:Connect(function()
    FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FovCircle.Radius = _G.FovSize
    
    -- Reset Noclip jika OFF
    if not _G.Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    elseif _G.Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    local Target = nil
    local Dist = _G.FovSize
    
    -- Mencari Target
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

            -- Logic MS10 (Hanya aktif jika ON)
            if _G.MS10 and (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude < 30 then
                v.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            end
        end
    end

    -- Aimlock & FlyKill (Hanya Jalan jika ON)
    if Target and Target.Character then
        if _G.Aimlock then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
        if _G.FlyKill then
            Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)

-- ================= GUI DESIGN =================
local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "VercoFinal"

local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 480, 0, 330)
Frame.Position = UDim2.new(0.5, -240, 0.5, -165)
Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Frame.Active = true
Frame.Draggable = true
local Border = Instance.new("UIStroke", Frame)
Border.Color = Color3.fromRGB(0, 255, 0)
Border.Thickness = 2

local Sidebar = Instance.new("Frame", Frame)
Sidebar.Size = UDim2.new(0, 110, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
Title.Text = " VERCO X NUGI "
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local Content = Instance.new("ScrollingFrame", Frame)
Content.Size = UDim2.new(1, -120, 1, -50)
Content.Position = UDim2.new(0, 115, 0, 45)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 2, 0)
local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0, 5)

-- Fungsi Toggle yang Diperbaiki (Bisa Reset)
local function AddToggle(name, varName, callback)
    local b = Instance.new("TextButton", Content)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = name .. " : OFF"
    b.TextColor3 = Color3.fromRGB(0, 255, 0)
    b.Font = Enum.Font.GothamBold
    
    b.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        local s = _G[varName]
        b.Text = name .. (s and " : ON" or " : OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(30, 30, 30)
        b.TextColor3 = s and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 255, 0)
        if callback then callback(s) end
    end)
end

-- TABS
local function ShowAim()
    Content:ClearAllChildren()
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
    AddToggle("Aimlock Head", "Aimlock")
    AddToggle("FlyKill (Rush)", "FlyKill")
    AddToggle("MS10 (TP Near)", "MS10")
end

local function ShowVisual()
    Content:ClearAllChildren()
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
    AddToggle("ESP Green Box", "EspEnabled")
    AddToggle("Noclip (Wallhack)", "Noclip")
end

local function ShowConfig()
    Content:ClearAllChildren()
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
    AddToggle("Anti Lag", "LagFix", function(v)
        if v then settings().Rendering.QualityLevel = 1 else settings().Rendering.QualityLevel = 0 end
    end)
    AddToggle("HDR 3D Mode", "HDR", function(v)
        local lighting = game:GetService("Lighting")
        if v then
            local b = Instance.new("BloomEffect", lighting)
            b.Name = "VercoBloom" b.Intensity = 1
        elseif lighting:FindFirstChild("VercoBloom") then
            lighting.VercoBloom:Destroy()
        end
    end)
end

-- Navigation
local function CreateTab(name, func)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.Position = UDim2.new(0, 0, 0, (#Sidebar:GetChildren()-1) * 45)
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
Instance.new("UIStroke", CTBtn).Color = Color3.fromRGB(0, 255, 0)
local CL = Instance.new("TextButton", CTBtn)
CL.Size = UDim2.new(1,0,1,0) CL.BackgroundTransparency = 1
CL.Text = "CT" CL.TextColor3 = Color3.new(0,1,0)
CL.TextSize = 24 CL.Font = Enum.Font.GothamBold
CL.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
