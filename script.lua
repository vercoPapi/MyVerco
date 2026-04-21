local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Hapus GUI lama
if CoreGui:FindFirstChild("VercoNeo") then CoreGui.VercoNeo:Destroy() end
if CoreGui:FindFirstChild("CT_Icon") then CoreGui.CT_Icon:Destroy() end

_G.Aimlock = false
_G.Esp3D = false
_G.Noclip = false

-- ================= 3D BOX ESP (RED) =================
local function Create3DBox(target)
    local Lines = {}
    for i = 1, 12 do
        Lines[i] = Drawing.new("Line")
        Lines[i].Color = Color3.fromRGB(255, 0, 0)
        Lines[i].Thickness = 1.5
        Lines[i].Visible = false
    end

    RunService.RenderStepped:Connect(function()
        if _G.Esp3D and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local char = target.Character
            local hrp = char.HumanoidRootPart
            local size = Vector3.new(4, 5, 2)
            local cf = hrp.CFrame
            
            local vertices = {
                Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, size.Y/2, size.Z/2)).Position),
                Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2)).Position),
                Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2)).Position),
                Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2)).Position),
                Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2)).Position),
                Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2)).Position),
                Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)).Position),
                Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2)).Position),
            }

            local connections = {
                {1,2},{2,3},{3,4},{4,1},
                {5,6},{6,7},{7,8},{8,5},
                {1,5},{2,6},{3,7},{4,8}
            }

            for i, conn in pairs(connections) do
                local p1, on1 = vertices[conn[1]], true
                local p2, on2 = vertices[conn[2]], true
                if p1.Z > 0 and p2.Z > 0 then
                    Lines[i].Visible = true
                    Lines[i].From = Vector2.new(p1.X, p1.Y)
                    Lines[i].To = Vector2.new(p2.X, p2.Y)
                else
                    Lines[i].Visible = false
                end
            end
        else
            for _, l in pairs(Lines) do l.Visible = false end
        end
    end)
end

for _, v in pairs(game.Players:GetPlayers()) do if v ~= Player then Create3DBox(v) end end
game.Players.PlayerAdded:Connect(function(v) Create3DBox(v) end)

-- ================= AIMLOCK SYSTEM (NON-SAVING) =================
RunService.RenderStepped:Connect(function()
    if _G.Aimlock then
        local target = nil
        local shortest = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mag < shortest then shortest = mag target = v end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
    end
end)

-- ================= GUI DESIGN (GREEN THEME) =================
local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "VercoNeo"

local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 480, 0, 340)
Frame.Position = UDim2.new(0.5, -240, 0.5, -170)
Frame.BackgroundColor3 = Color3.fromRGB(5, 15, 5)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Background Particle Green
for i = 1, 20 do
    local p = Instance.new("Frame", Frame)
    p.Size = UDim2.new(0, 2, 0, 2)
    p.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    spawn(function()
        while wait(0.05) do
            p.Position = UDim2.new(p.Position.X.Scale, 0, p.Position.Y.Scale + 0.01, 0)
            if p.Position.Y.Scale > 1 then p.Position = UDim2.new(math.random(), 0, 0, 0) end
        end
    end)
end

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(0, 255, 0)
UIStroke.Thickness = 2

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
Title.Text = "VERCO X NUGI"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24

-- Efek Tulisan Menyala Mati
spawn(function()
    while wait(0.5) do
        Title.TextTransparency = 0
        wait(0.5)
        Title.TextTransparency = 0.7
    end
end)

local Container = Instance.new("ScrollingFrame", Frame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Container.ScrollBarThickness = 3

local function AddToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(10, 30, 10)
    btn.Text = name .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local s = false
    btn.MouseButton1Click:Connect(function()
        s = not s
        btn.Text = name .. (s and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = s and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(10, 30, 10)
        btn.TextColor3 = s and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 255, 0)
        callback(s)
    end)
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)
end

AddToggle("Aimlock Head", function(v) _G.Aimlock = v end)
AddToggle("3D Box ESP Red", function(v) _G.Esp3D = v end)
AddToggle("Multi Jump", function(v) _G.Jump = v end)
AddToggle("Noclip (Wallhack)", function(v) _G.Noclip = v end)

-- ================= CT ICON NEO GREEN =================
local CTGui = Instance.new("ScreenGui", CoreGui)
local CTBtn = Instance.new("Frame", CTGui)
CTBtn.Size = UDim2.new(0, 65, 0, 65)
CTBtn.Position = UDim2.new(0, 20, 0.5, 0)
CTBtn.BackgroundColor3 = Color3.fromRGB(0, 20, 0)
CTBtn.Active = true
CTBtn.Draggable = true
Instance.new("UICorner", CTBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", CTBtn).Color = Color3.fromRGB(0, 255, 0)

local CL = Instance.new("TextButton", CTBtn)
CL.Size = UDim2.new(1, 0, 1, 0)
CL.BackgroundTransparency = 1
CL.Text = "CT"
CL.Font = Enum.Font.GothamBold
CL.TextSize = 26
CL.TextColor3 = Color3.fromRGB(0, 255, 0)
CL.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
