local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local VercoGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
VercoGui.Name = "VercoToHack"
VercoGui.ResetOnSpawn = false

local States = {
    ["Aim Silent"] = false,
    ["AimBot"] = false,
    ["Esp Line"] = false,
    ["Esp Box"] = false,
    ["Wallhack"] = false,
    ["Fly Kill"] = false,
    ["Anti lag"] = false,
    ["ms100"] = false
}

local IconLK = Instance.new("TextButton", VercoGui)
IconLK.Size = UDim2.new(0, 45, 0, 45)
IconLK.Position = UDim2.new(0, 15, 0.5, 0)
IconLK.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
IconLK.BorderColor3 = Color3.fromRGB(255, 0, 0)
IconLK.BorderSizePixel = 2
IconLK.Text = "LK"
IconLK.TextColor3 = Color3.fromRGB(255, 0, 0)
IconLK.Font = Enum.Font.GothamBlack
IconLK.TextSize = 22
IconLK.Visible = false
Instance.new("UICorner", IconLK).CornerRadius = UDim.new(0, 10)

local Main = Instance.new("Frame", VercoGui)
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true

local BgEffect = Instance.new("Frame", Main)
BgEffect.Size = UDim2.new(1, 0, 1, 0)
BgEffect.BackgroundTransparency = 1
BgEffect.ClipsDescendants = true

task.spawn(function()
    while task.wait(0.1) do
        local p = Instance.new("Frame", BgEffect)
        p.Size = UDim2.new(0, 2, 0, 2)
        p.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        p.Position = UDim2.new(math.random(), 0, 1, 0)
        p.BorderSizePixel = 0
        TS:Create(p, TweenInfo.new(3), {Position = UDim2.new(math.random(), 0, -0.1, 0), BackgroundTransparency = 1}):Play()
        game:GetService("Debris"):AddItem(p, 3)
    end
end)

local Title = Instance.new("TextLabel", Main)
Title.Text = "VERCO TO HACK"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.BackgroundTransparency = 1

local SideBar = Instance.new("ScrollingFrame", Main)
SideBar.Size = UDim2.new(0, 150, 0, 250)
SideBar.Position = UDim2.new(0, 10, 0, 60)
SideBar.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
SideBar.BorderSizePixel = 0
SideBar.ScrollBarThickness = 2
SideBar.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)

local FeaturePanel = Instance.new("ScrollingFrame", Main)
FeaturePanel.Size = UDim2.new(0, 365, 0, 250)
FeaturePanel.Position = UDim2.new(0, 170, 0, 60)
FeaturePanel.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
FeaturePanel.BorderSizePixel = 0
FeaturePanel.ScrollBarThickness = 2
FeaturePanel.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)

Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 5)
Instance.new("UIListLayout", FeaturePanel).Padding = UDim.new(0, 5)

local function CreateCheckbox(name, callback)
    local Frame = Instance.new("Frame", FeaturePanel)
    Frame.Size = UDim2.new(0.95, 0, 0, 45)
    Frame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.Text = name
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local Box = Instance.new("TextButton", Frame)
    Box.Size = UDim2.new(0, 25, 0, 25)
    Box.Position = UDim2.new(0.85, 0, 0.2, 0)
    Box.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
    Box.BorderColor3 = Color3.fromRGB(255, 0, 0)
    Box.Text = States[name] and "X" or ""
    Box.TextColor3 = Color3.new(1, 0, 0)
    Box.Font = Enum.Font.GothamBlack
    
    Box.MouseButton1Click:Connect(function()
        States[name] = not States[name]
        Box.Text = States[name] and "X" or ""
        callback(States[name])
    end)
end

local function CreateESP(plr)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1, 0, 0)
    Box.Thickness = 2
    Box.Transparency = 1
    Box.Filled = false

    local Line = Drawing.new("Line")
    Line.Visible = false
    Line.Color = Color3.new(1, 0, 0)
    Line.Thickness = 1.5
    Line.Transparency = 1

    RS.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and plr ~= LP then
            local Root = plr.Character.HumanoidRootPart
            local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)

            if OnScreen then
                if States["Esp Box"] then
                    local SizeY = (Camera.ViewportSize.Y / Pos.Z) * 2
                    local SizeX = SizeY / 1.5
                    Box.Size = Vector2.new(SizeX, SizeY)
                    Box.Position = Vector2.new(Pos.X - SizeX / 2, Pos.Y - SizeY / 2)
                    Box.Visible = true
                else Box.Visible = false end

                if States["Esp Line"] then
                    Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    Line.To = Vector2.new(Pos.X, Pos.Y)
                    Line.Visible = true
                else Line.Visible = false end
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

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

local function GetClosest()
    local target = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
            end
        end
    end
    return target
end

-- Fly Kill & MS100 Logic
RS.RenderStepped:Connect(function()
    local t = GetClosest()
    if t and t.Character and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = t.Character.HumanoidRootPart
        local targetHum = t.Character.Humanoid
        local myRoot = LP.Character.HumanoidRootPart

        -- MS100 Logic: Jika musuh < 100m, tarik ke depan kita
        if States["ms100"] then
            local distance = (myRoot.Position - targetRoot.Position).Magnitude
            if distance <= 300 then -- 100 meter in studs approx 300
                targetRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
            end
        end

        -- Fly Kill Logic: Pindah & Tembak, Pindah jika mati
        if States["Fly Kill"] then
            if targetHum.Health > 0 then
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                -- Simulating Auto Shoot (Tergantung Game, biasanya klik mouse)
                mouse1click() 
            end
        end

        -- AimBot Logic
        if States["AimBot"] then
            local head = t.Character:FindFirstChild("Head")
            if head then
                local lookAt = CFrame.new(Camera.CFrame.Position, head.Position)
                Camera.CFrame = Camera.CFrame:Lerp(lookAt, 0.08)
            end
        end
    end
end)

local function Clear() for _,v in pairs(FeaturePanel:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end end

local Tabs = {
    ["Menu Aim"] = function()
        Clear()
        CreateCheckbox("Aim Silent", function(v) States["Aim Silent"] = v end)
        CreateCheckbox("AimBot", function(v) States["AimBot"] = v end)
    end,
    ["Menu Esp"] = function()
        Clear()
        CreateCheckbox("Esp Line", function(v) States["Esp Line"] = v end)
        CreateCheckbox("Esp Box", function(v) States["Esp Box"] = v end)
    end,
    ["Menu Config"] = function()
        Clear()
        CreateCheckbox("Wallhack", function(v) 
            States["Wallhack"] = v
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CanCollide = not v
            end
        end)
        CreateCheckbox("Fly Kill", function(v) States["Fly Kill"] = v end)
        CreateCheckbox("ms100", function(v) States["ms100"] = v end)
        CreateCheckbox("Anti lag", function(v) 
            States["Anti lag"] = v
            if v then
                game.Lighting.Brightness = 2
                game.Lighting.GlobalShadows = false
            end
        end)
    end
}

for n, f in pairs(Tabs) do
    local b = Instance.new("TextButton", SideBar)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    b.Text = n
    b.TextColor3 = Color3.new(1, 0, 0)
    b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(f)
end

local Hide = Instance.new("TextButton", Main)
Hide.Text = "Hide"
Hide.Size = UDim2.new(0, 80, 0, 30)
Hide.Position = UDim2.new(0, 10, 1, -40)
Hide.BackgroundTransparency = 1
Hide.TextColor3 = Color3.new(1, 0, 0)
Hide.Font = Enum.Font.GothamBold
Hide.MouseButton1Click:Connect(function() Main.Visible = false IconLK.Visible = true end)

local Exit = Instance.new("TextButton", Main)
Exit.Text = "Exit"
Exit.Size = UDim2.new(0, 80, 0, 30)
Exit.Position = UDim2.new(1, -90, 1, -40)
Exit.BackgroundTransparency = 1
Exit.TextColor3 = Color3.new(1, 0, 0)
Exit.Font = Enum.Font.GothamBold
Exit.MouseButton1Click:Connect(function() VercoGui:Destroy() end)

IconLK.MouseButton1Click:Connect(function() Main.Visible = true IconLK.Visible = false end)
Tabs["Menu Aim"]()
