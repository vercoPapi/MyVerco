local S = Instance.new("ScreenGui", game.CoreGui)
local M = Instance.new("Frame", S)
local UICorner_M = Instance.new("UICorner", M)
local T = Instance.new("Frame", M)
local L = Instance.new("TextLabel", T)
local C = Instance.new("ScrollingFrame", M)
local U = Instance.new("UIListLayout", C)
local I = Instance.new("TextButton", S)
local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")

-- Menu Setup (Besar di Tengah)
M.Name = "VercoSad_Pro"
M.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
M.BackgroundTransparency = 0.2
M.BorderSizePixel = 0
M.Position = UDim2.new(0.5, -250, 0.5, -175)
M.Size = UDim2.new(0, 500, 0, 350)
M.Active = true
M.Draggable = true

T.Size = UDim2.new(1, 0, 0, 40)
T.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
L.Size = UDim2.new(1, 0, 1, 0)
L.Text = "VERCO SAD PREMIUM | Players: " .. #game.Players:GetPlayers()
L.TextColor3 = Color3.new(1,1,1)
L.TextSize = 18
L.Font = Enum.Font.GothamBold

C.Position = UDim2.new(0, 10, 0, 50)
C.Size = UDim2.new(1, -20, 1, -60)
C.BackgroundTransparency = 1
C.CanvasSize = UDim2.new(0, 0, 4, 0)
C.ScrollBarThickness = 3
U.Padding = UDim.new(0, 5)

-- Icon L Bulat
I.Size = UDim2.new(0, 50, 0, 50)
I.Position = UDim2.new(0.05, 0, 0.1, 0)
I.Text = "L"
I.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
I.TextColor3 = Color3.new(1,1,1)
I.Visible = false
I.Draggable = true
Instance.new("UICorner", I).CornerRadius = UDim.new(1, 0)

local st = {}

-- Custom CheckBox Function
function AddToggle(name, callback)
    local frame = Instance.new("Frame", C)
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundTransparency = 1
    
    local lab = Instance.new("TextLabel", frame)
    lab.Text = "  " .. name
    lab.Size = UDim2.new(0.7, 0, 1, 0)
    lab.TextColor3 = Color3.new(1,1,1)
    lab.TextXAlignment = Enum.TextXAlignment.Left
    lab.BackgroundTransparency = 1
    lab.Font = Enum.Font.Gotham
    
    local box = Instance.new("TextButton", frame)
    box.Size = UDim2.new(0, 25, 0, 25)
    box.Position = UDim2.new(1, -40, 0.5, -12)
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    box.Text = ""
    local bc = Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    
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

function Section(txt)
    local l = Instance.new("TextLabel", C)
    l.Size = UDim2.new(1, 0, 0, 25)
    l.Text = "-- " .. txt .. " --"
    l.TextColor3 = Color3.fromRGB(0, 200, 255)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBold
end

-- --- CATEGORY: MOVEMENT ---
Section("MOVEMENT")
AddToggle("JumpMulti", function(v) lp.Character.Humanoid.JumpPower = (v and 150 or 50) end)
AddToggle("Speed 5x", function(v) lp.Character.Humanoid.WalkSpeed = (v and 80 or 16) end)
AddToggle("TeleFinish", function(v) if v then local f = workspace:FindFirstChild("Finish") or workspace:FindFirstChild("End") if f then lp.Character.HumanoidRootPart.CFrame = f.CFrame end end end)

-- --- CATEGORY: COMBAT ---
Section("COMBAT")
AddToggle("Aimbot (Auto Switch)", function(v)
    st.ai = v
    rs.RenderStepped:Connect(function()
        if st.ai then
            local target = nil
            local dist = math.huge
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
    while st.fk do wait()
        pcall(function()
            for _,p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character.Humanoid.Health > 0 then
                    lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
                    break
                end
            end
        end)
    end
end)

AddToggle("Anti Mati (Ghost)", function(v)
    if v then
        local clone = lp.Character.HumanoidRootPart:Clone()
        clone.Parent = workspace
        clone.Anchored = true
        st.ghost = true
        while st.ghost do wait()
            lp.Character.Humanoid.Health = 100
        end
    else
        st.ghost = false
    end
end)

-- --- CATEGORY: ESP ---
Section("VISUAL (BLUE 3D)")
AddToggle("ESP Box 3D", function(v)
    st.eb = v
    while st.eb do wait(1)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and not p.Character:FindFirstChild("Box3D") then
                local b = Instance.new("BoxHandleAdornment", p.Character)
                b.Name = "Box3D"
                b.Adornee = p.Character
                b.AlwaysOnTop = true
                b.Size = Vector3.new(4, 5.5, 2)
                b.Color3 = Color3.fromRGB(0, 150, 255)
                b.Transparency = 0.6
            end
        end
    end
    if not v then for _,p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Box3D") then p.Character.Box3D:Destroy() end end end
end)

AddToggle("ESP Line", function(v)
    st.el = v
    while st.el do wait(1)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and not p.Character:FindFirstChild("Line") then
                local l = Instance.new("LineHandleAdornment", p.Character)
                l.Name = "Line"
                l.Adornee = p.Character
                l.Length = 1000
                l.AlwaysOnTop = true
                l.Color3 = Color3.new(1,1,1)
            end
        end
    end
    if not v then for _,p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Line") then p.Character.Line:Destroy() end end end
end)

-- --- CATEGORY: CONFIG ---
Section("CONFIG")
AddToggle("Wallhack", function(v) st.wh = v rs.Stepped:Connect(function() if st.wh and lp.Character then for _,x in pairs(lp.Character:GetDescendants()) do if x:IsA("BasePart") then x.CanCollide = false end end end end) end)
AddToggle("Anti Detect", function(v) end)

-- Footer Buttons
local Exit = Instance.new("TextButton", M)
Exit.Size = UDim2.new(0, 100, 0, 30)
Exit.Position = UDim2.new(1, -110, 1, -35)
Exit.Text = "EXIT"
Exit.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Exit.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Exit)

local Hide = Instance.new("TextButton", M)
Hide.Size = UDim2.new(0, 100, 0, 30)
Hide.Position = UDim2.new(0, 10, 1, -35)
Hide.Text = "HIDE"
Hide.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Hide.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Hide)

Hide.MouseButton1Click:Connect(function() M.Visible = false I.Visible = true end)
I.MouseButton1Click:Connect(function() M.Visible = true I.Visible = false end)
Exit.MouseButton1Click:Connect(function() S:Destroy() st = {} end)
