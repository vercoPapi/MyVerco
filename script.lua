local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Bersihkan GUI lama agar tidak tumpuk
if CoreGui:FindFirstChild("VercoFinal") then CoreGui.VercoFinal:Destroy() end
if CoreGui:FindFirstChild("CT_Icon") then CoreGui.CT_Icon:Destroy() end

-- Variabel Global (Pastikan tidak bentrok)
_G.Aimlock = false
_G.FovSize = 100
_G.EspEnabled = false
_G.FlyKill = false
_G.MS20 = false
_G.Noclip = false

-- FOV Circle Merah (Tengah)
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1.5
FovCircle.NumSides = 360
FovCircle.Radius = _G.FovSize
FovCircle.Filled = false
FovCircle.Color = Color3.fromRGB(255, 0, 0)
FovCircle.Visible = true

-- Fungsi Wall Check (Cek apakah musuh tertutup tembok)
local function IsVisible(part)
    local char = Player.Character
    if not char then return false end
    local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {char, part.Parent})
    return hit == nil
end

-- ================= SISTEM ESP 3D & LINE (MERAH) =================
local function CreateESP(v)
    local Box = Drawing.new("Square")
    local Line = Drawing.new("Line")

    RunService.RenderStepped:Connect(function()
        if _G.EspEnabled and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local Root = v.Character.HumanoidRootPart
            local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
            
            if OnScreen then
                -- ESP BOX 3D (Simulasi Square)
                Box.Visible = true
                Box.Color = Color3.fromRGB(255, 0, 0)
                Box.Thickness = 1.5
                Box.Size = Vector2.new(2500 / Pos.Z, 3500 / Pos.Z)
                Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                
                -- ESP LINE
                Line.Visible = true
                Line.Color = Color3.fromRGB(255, 0, 0)
                Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Line.To = Vector2.new(Pos.X, Pos.Y)
            else
                Box.Visible = false
                Line.Visible = false
            end
        else
            Box.Visible = false
            Line.Visible = false
        end
    end)
end

for _, v in pairs(game.Players:GetPlayers()) do if v ~= Player then CreateESP(v) end end
game.Players.PlayerAdded:Connect(function(v) if v ~= Player then CreateESP(v) end end)

-- ================= LOOP UTAMA =================
RunService.RenderStepped:Connect(function()
    FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    local Target = nil
    local Dist = _G.FovSize
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
            local char = v.Character
            local Pos, OnScreen = Camera:WorldToViewportPoint(char.Head.Position)
            
            if OnScreen then
                local Mag = (Vector2.new(Pos.X, Pos.Y) - FovCircle.Position).Magnitude
                if Mag < Dist and IsVisible(char.Head) then
                    Dist = Mag
                    Target = v
                end
            end

            -- Logic MS20 (20m TP)
            if _G.MS20 and (char.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude < 60 then
                char.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            end
        end
    end

    if Target and Target.Character then
        if _G.Aimlock then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position), 0.15) end
        if _G.FlyKill then Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end
    end
end)

-- ================= GUI DESIGN (TAB SYSTEM) =================
local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "VercoFinal"

local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 480, 0, 330)
Frame.Position = UDim2.new(0.5, -240, 0.5, -165)
Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Frame.Active = true
Frame.Draggable = true
Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 0)

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

-- Fungsi Toggle diperbaiki agar status tetap (tidak reset sendiri)
local function AddToggle(name, varName)
    local b = Instance.new("TextButton", Content)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = name .. " : OFF"
    b.TextColor3 = Color3.fromRGB(0, 255, 0)
    b.Font = Enum.Font.GothamBold
    
    -- Load status awal
    if _G[varName] then
        b.Text = name .. " : ON"
        b.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    end

    b.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        b.Text = name .. (_G[varName] and " : ON" or " : OFF")
        b.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(30, 30, 30)
    end)
end

-- TABS
local function ShowAim()
    Content:ClearAllChildren()
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
    AddToggle("Aimlock Head (Wallcheck)", "Aimlock")
    AddToggle("FlyKill (Rush)", "FlyKill")
    AddToggle("MS20 (TP Near)", "MS20")
end

local function ShowVisual()
    Content:ClearAllChildren()
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
    AddToggle("ESP Red 3D & Line", "EspEnabled")
    AddToggle("Noclip", "Noclip")
end

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
