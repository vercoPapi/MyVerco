local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = game.Workspace.CurrentCamera

-- Hapus GUI lama
if CoreGui:FindFirstChild("VercoMenu") then CoreGui.VercoMenu:Destroy() end
if CoreGui:FindFirstChild("CT_Icon") then CoreGui.CT_Icon:Destroy() end

-- Variabel Fitur
_G.Aimlock = false
_G.EspEnabled = false
_G.Noclip = false
_G.Jump = false

-- ================= LOGIC AIMLOCK (HEAD) =================
local function GetClosestPlayer()
    local target = nil
    local dist = math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then
                    target = v
                    dist = mag
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if _G.Aimlock then
        local target = GetClosestPlayer()
        if target and target.Character then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- ================= LOGIC ESP (RED BOX & LINE) =================
local function CreateESP(target)
    local Box = Drawing.new("Square")
    local Line = Drawing.new("Line")
    
    RunService.RenderStepped:Connect(function()
        if _G.EspEnabled and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local Root = target.Character.HumanoidRootPart
            local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
            
            if OnScreen then
                -- Box Merah
                Box.Visible = true
                Box.Color = Color3.fromRGB(255, 0, 0)
                Box.Thickness = 1
                Box.Size = Vector2.new(2000 / Pos.Z, 3000 / Pos.Z)
                Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                
                -- Line Merah
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

for _, v in pairs(game.Players:GetPlayers()) do
    if v ~= Player then CreateESP(v) end
end
game.Players.PlayerAdded:Connect(function(v) CreateESP(v) end)

-- ================= GUI DESIGN (BESAR & TAB) =================
local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "VercoMenu"

local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 450, 0, 320) -- UKURAN DIPERBESAR
Frame.Position = UDim2.new(0.5, -225, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.Text = "VERCO X NUGI X - PREMIUM"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22

-- Sistem Tab
local TabContainer = Instance.new("Frame", Frame)
TabContainer.Size = UDim2.new(0, 100, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(40, 0, 0)

local Content = Instance.new("ScrollingFrame", Frame)
Content.Size = UDim2.new(1, -110, 1, -50)
Content.Position = UDim2.new(0, 105, 0, 45)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 2, 0)
local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0, 5)

local function ClearContent()
    for _, v in pairs(Content:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
end

local function AddToggle(name, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    btn.Text = name .. " : OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.MouseButton1Click:Connect(function()
        local st = btn.Text:find("OFF")
        btn.Text = name .. (st and " : ON" or " : OFF")
        btn.BackgroundColor3 = st and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(60, 0, 0)
        btn.TextColor3 = st and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        callback(not not st)
    end)
end

-- Tombol Navigasi Tab
local function CreateTabBtn(name, func)
    local b = Instance.new("TextButton", TabContainer)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.Position = UDim2.new(0, 0, 0, (#TabContainer:GetChildren()-1) * 40)
    b.MouseButton1Click:Connect(func)
end

-- Isi Menu per Tab
local function ShowAim()
    ClearContent()
    AddToggle("Aimlock Head", function(v) _G.Aimlock = v end)
    AddToggle("ESP Red Box", function(v) _G.EspEnabled = v end)
    AddToggle("ESP Red Line", function(v) _G.EspEnabled = v end)
end

local function ShowFarm()
    ClearContent()
    AddToggle("Auto Farm", function(v) print("Farm") end)
    AddToggle("Auto Mancing", function(v) print("Fish") end)
end

local function ShowRisk()
    ClearContent()
    AddToggle("Multi Jump", function(v) _G.Jump = v end)
    AddToggle("Noclip", function(v) _G.Noclip = v end)
end

CreateTabBtn("AIM", ShowAim)
CreateTabBtn("FARM", ShowFarm)
CreateTabBtn("RISK", ShowRisk)
ShowAim() -- Default open

-- ================= CT ICON =================
local CTGui = Instance.new("ScreenGui", CoreGui)
local CTBtn = Instance.new("Frame", CTGui)
CTBtn.Size = UDim2.new(0, 60, 0, 60)
CTBtn.Position = UDim2.new(0, 20, 0.5, 0)
CTBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CTBtn.Active = true
CTBtn.Draggable = true
local CR = Instance.new("UICorner", CTBtn)
CR.CornerRadius = UDim.new(1, 0)
local CL = Instance.new("TextButton", CTBtn)
CL.Size = UDim2.new(1, 0, 1, 0)
CL.BackgroundTransparency = 1
CL.Text = "CT"
CL.Font = Enum.Font.SourceSansBold
CL.TextSize = 25
CL.TextColor3 = Color3.fromRGB(0,0,0)
CL.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
