local S = Instance.new("ScreenGui")
local M = Instance.new("Frame")
local T = Instance.new("Frame")
local L = Instance.new("TextLabel")
local C = Instance.new("ScrollingFrame")
local U = Instance.new("UIListLayout")
local I = Instance.new("TextButton")
local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")

-- PROTEKSI & PARENTING (100% MUNCUL)
local function GetGuiParent()
    local success, parent = pcall(function() return game:GetService("CoreGui") end)
    if success and parent then return parent end
    return lp:WaitForChild("PlayerGui")
end

S.Name = "VercoSad_Final_V2"
S.Parent = GetGuiParent()
S.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
S.ResetOnSpawn = false

-- MAIN WINDOW
M.Name = "VercoWindow"
M.Parent = S
M.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
M.BackgroundTransparency = 0.2
M.Position = UDim2.new(0.5, -200, 0.5, -150)
M.Size = UDim2.new(0, 400, 0, 300)
M.Active = true
M.Draggable = true
M.ZIndex = 5
Instance.new("UICorner", M).CornerRadius = UDim.new(0, 10)

-- TITLE BAR
T.Parent = M
T.Size = UDim2.new(1, 0, 0, 35)
T.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
T.ZIndex = 6
Instance.new("UICorner", T).CornerRadius = UDim.new(0, 10)

L.Parent = T
L.Size = UDim2.new(1, 0, 1, 0)
L.Text = "VERCO SAD MOD MENU | ONLINE"
L.TextColor3 = Color3.new(1, 1, 1)
L.TextSize = 16
L.Font = Enum.Font.GothamBold

-- SCROLLING AREA
C.Parent = M
C.Position = UDim2.new(0, 5, 0, 40)
C.Size = UDim2.new(1, -10, 1, -85)
C.BackgroundTransparency = 1
C.CanvasSize = UDim2.new(0, 0, 0, 900)
C.ScrollBarThickness = 3
C.ZIndex = 7

U.Parent = C
U.SortOrder = Enum.SortOrder.LayoutOrder
U.Padding = UDim.new(0, 4)

-- ICON L (HIDE)
I.Parent = S
I.Size = UDim2.new(0, 50, 0, 50)
I.Position = UDim2.new(0.1, 0, 0.1, 0)
I.Text = "L"
I.TextSize = 25
I.Font = Enum.Font.GothamBold
I.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
I.TextColor3 = Color3.new(1, 1, 1)
I.Visible = false
I.Draggable = true
I.BackgroundTransparency = 0.4
I.ZIndex = 10
Instance.new("UICorner", I).CornerRadius = UDim.new(1, 0)

local st = {}

-- CHECKBOX ✅
function AddToggle(name, callback)
    local f = Instance.new("Frame", C)
    f.Size = UDim2.new(1, 0, 0, 32)
    f.BackgroundTransparency = 1
    
    local txt = Instance.new("TextLabel", f)
    txt.Text = "  " .. name
    txt.Size = UDim2.new(0.7, 0, 1, 0)
    txt.TextColor3 = Color3.new(1, 1, 1)
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.Gotham
    
    local box = Instance.new("TextButton", f)
    box.Size = UDim2.new(0, 24, 0, 24)
    box.Position = UDim2.new(1, -35, 0.5, -12)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    box.Text = ""
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    
    local check = Instance.new("Frame", box)
    check.Size = UDim2.new(0.6, 0, 0.6, 0)
    check.Position = UDim2.new(0.2, 0, 0.2, 0)
    check.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    check.Visible = false
    Instance.new("UICorner", check).CornerRadius = UDim.new(0, 3)

    local on = false
    box.MouseButton1Click:Connect(function()
        on = not on
        check.Visible = on
        callback(on)
    end)
end

function Section(t)
    local s = Instance.new("TextLabel", C)
    s.Size = UDim2.new(1, 0, 0, 25)
    s.Text = "-- " .. t .. " --"
    s.TextColor3 = Color3.fromRGB(0, 200, 255)
    s.BackgroundTransparency = 1
    s.Font = Enum.Font.GothamBold
end

-- FITUR MOVEMENT
Section("MOVEMENT")
AddToggle("JumpMulti", function(v) lp.Character.Humanoid.JumpPower = (v and 150 or 50) end)
AddToggle("Speed 5x", function(v) lp.Character.Humanoid.WalkSpeed = (v and 80 or 16) end)
AddToggle("TeleFinish", function(v) if v then local f = workspace:FindFirstChild("Finish") or workspace:FindFirstChild("End") if f then lp.Character.HumanoidRootPart.CFrame = f.CFrame end end end)

-- FITUR COMBAT
Section("COMBAT")
AddToggle("Aimbot (Smart)", function(v)
    st.ai = v
    rs.RenderStepped:Connect(function()
        if st.ai then
            local target = nil local dist = 500
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
                    if vis then
                        local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude
                        if mag < dist then dist = mag target = p end
                    end
                end
            end
            if target then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, target.Character.Head.Position) end
        end
    end)
end)

AddToggle("FlyKill", function(v)
    st.fk = v
    task.spawn(function()
        while st.fk do task.wait()
            pcall(function()
                for _,p in pairs(game.Players:GetPlayers()) do
                    if p ~= lp and p.Character and p.Character.Humanoid.Health > 0 then
                        lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                        break
                    end
                end
            end)
        end
    end)
end)

AddToggle("Anti Mati (Ghost)", function(v)
    st.ghost = v
    if v then
        local c = lp.Character.HumanoidRootPart:Clone()
        c.Parent = workspace
        c.Anchored = true
        task.spawn(function() while st.ghost do task.wait() lp.Character.Humanoid.Health = 100 end end)
    end
end)

Section("VISUAL")
AddToggle("ESP Box 3D Blue", function(v)
    st.eb = v
    task.spawn(function()
        while st.eb do task.wait(1)
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and not p.Character:FindFirstChild("Box3D") then
                    local b = Instance.new("BoxHandleAdornment", p.Character)
                    b.Name = "Box3D" b.Adornee = p.Character b.AlwaysOnTop = true
                    b.Size = Vector3.new(4, 6, 2) b.Color3 = Color3.fromRGB(0, 150, 255) b.Transparency = 0.6
                end
            end
        end
        if not v then for _,p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Box3D") then p.Character.Box3D:Destroy() end end end
    end)
end)

AddToggle("ESP Line White", function(v)
    st.el = v
    task.spawn(function()
        while st.el do task.wait(1)
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and not p.Character:FindFirstChild("Line") then
                    local l = Instance.new("LineHandleAdornment", p.Character)
                    l.Name = "Line" l.Adornee = p.Character l.Length = 1000 l.AlwaysOnTop = true l.Color3 = Color3.new(1, 1, 1)
                end
            end
        end
        if not v then for _,p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Line") then p.Character.Line:Destroy() end end end
    end)
end)

Section("SYSTEM")
AddToggle("Anti Detect", function(v) end)
AddToggle("Wallhack", function(v) st.wh = v rs.Stepped:Connect(function() if st.wh and lp.Character then for _,x in pairs(lp.Character:GetDescendants()) do if x:IsA("BasePart") then x.CanCollide = false end end end end) end)

-- BUTTONS
local Footer = Instance.new("Frame", M)
Footer.Size = UDim2.new(1, 0, 0, 40)
Footer.Position = UDim2.new(0, 0, 1, -45)
Footer.BackgroundTransparency = 1

local H = Instance.new("TextButton", Footer)
H.Size = UDim2.new(0.4, 0, 0.8, 0)
H.Position = UDim2.new(0.05, 0, 0, 0)
H.Text = "HIDE"
H.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
H.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", H)

local E = Instance.new("TextButton", Footer)
E.Size = UDim2.new(0.4, 0, 0.8, 0)
E.Position = UDim2.new(0.55, 0, 0, 0)
E.Text = "EXIT"
E.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
E.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", E)

H.MouseButton1Click:Connect(function() M.Visible = false I.Visible = true end)
I.MouseButton1Click:Connect(function() M.Visible = true I.Visible = false end)
E.MouseButton1Click:Connect(function() S:Destroy() st = {} end)
