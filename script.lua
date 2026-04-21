local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. HAPUS SEMUA BULATAN/DRAWING LAMA (PEMBERSIHAN TOTAL)
if cleardrawcache then cleardrawcache() end -- Fungsi khusus executor untuk hapus semua gambar

-- Hapus GUI lama
if CoreGui:FindFirstChild("VercoUltimate") then CoreGui.VercoUltimate:Destroy() end
if CoreGui:FindFirstChild("CT_Icon") then CoreGui.CT_Icon:Destroy() end

-- Variabel Global
_G.Aimlock = false
_G.EspEnabled = false
_G.FlyKill = false
_G.MS20 = false

-- DISINI TIDAK ADA LAGI Drawing.new("Circle") --
-- JADI LAYAR PASTI BERSIH DARI BULATAN MERAH --

-- Fungsi Wall Check (Raycast)
local function IsVisible(part)
    local char = Player.Character
    if not char then return false end
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char, part.Parent}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), rayParams)
    return result == nil
end

-- ================= SISTEM ESP 3D WIREFRAME (MERAH) =================
local function CreateESP(v)
    local Lines = {}
    for i = 1, 12 do
        Lines[i] = Drawing.new("Line")
        Lines[i].Color = Color3.fromRGB(255, 0, 0)
        Lines[i].Thickness = 1.5
        Lines[i].Visible = false
    end
    
    local Tracer = Drawing.new("Line")
    Tracer.Color = Color3.fromRGB(255, 0, 0)
    Tracer.Thickness = 1
    Tracer.Visible = false

    RunService.RenderStepped:Connect(function()
        if _G.EspEnabled and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local hrp = v.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local Pos, OnScreen = Camera:WorldToViewportPoint(hrp.Position)
                if OnScreen then
                    local size = Vector3.new(4, 5, 2)
                    local cf = hrp.CFrame
                    local vts = {
                        Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, size.Y/2, size.Z/2)).Position),
                        Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2)).Position),
                        Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2)).Position),
                        Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2)).Position),
                        Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2)).Position),
                        Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2)).Position),
                        Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)).Position),
                        Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2)).Position),
                    }
                    local con = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
                    for i, c in pairs(con) do
                        Lines[i].Visible = true
                        Lines[i].From = Vector2.new(vts[c[1]].X, vts[c[1]].Y)
                        Lines[i].To = Vector2.new(vts[c[2]].X, vts[c[2]].Y)
                    end
                    Tracer.Visible = true
                    Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    Tracer.To = Vector2.new(Pos.X, Pos.Y)
                else
                    for i=1,12 do Lines[i].Visible = false end Tracer.Visible = false
                end
            else
                for i=1,12 do Lines[i].Visible = false end Tracer.Visible = false
            end
        else
            for i=1,12 do Lines[i].Visible = false end Tracer.Visible = false
        end
    end)
end

for _, v in pairs(game.Players:GetPlayers()) do if v ~= Player then CreateESP(v) end end
game.Players.PlayerAdded:Connect(function(v) if v ~= Player then CreateESP(v) end end)

-- ================= LOGIC FITUR =================
RunService.RenderStepped:Connect(function()
    local Target = nil
    local shortestDist = math.huge
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local hrp = v.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local Mag = (hrp.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if Mag < shortestDist then
                    if _G.FlyKill or IsVisible(v.Character.Head) then
                        shortestDist = Mag
                        Target = v
                    end
                end
                if _G.MS20 and Mag < 65 then
                    hrp.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                end
            end
        end
    end

    if Target and Target.Character then
        if _G.Aimlock then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position), 0.15)
        end
        if _G.FlyKill then
            Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        end
    end
end)

-- ================= GUI DESIGN =================
local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "VercoUltimate"
local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 480, 0, 350)
Frame.Position = UDim2.new(0.5, -240, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Frame.Active = true Frame.Draggable = true
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
Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)

local function AddToggle(name, varName)
    local b = Instance.new("TextButton", Content)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = name .. " : OFF"
    b.TextColor3 = Color3.fromRGB(0, 255, 0)
    b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        b.Text = name .. (_G[varName] and " : ON" or " : OFF")
        b.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(30, 30, 30)
    end)
end

local function ShowAim()
    Content:ClearAllChildren()
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
    AddToggle("Aimlock (Global)", "Aimlock")
    AddToggle("FlyKill (Auto Pindah)", "FlyKill")
    AddToggle("MS20 (Tarik Musuh)", "MS20")
end

local function ShowVisual()
    Content:ClearAllChildren()
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
    AddToggle("ESP 3D Wireframe", "EspEnabled")
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

-- Tombol CT
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
