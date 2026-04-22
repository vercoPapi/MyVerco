local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local VercoGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
VercoGui.Name = "VercoToHack"
VercoGui.ResetOnSpawn = false

-- Global States (Menjaga fitur tetap ON meski pindah menu)
_G.VercoStates = _G.VercoStates or {
    ["Aim Silent"] = false,
    ["AimBot"] = false,
    ["Esp Line"] = false,
    ["Esp Box"] = false,
    ["Wallhack"] = false,
    ["Fly Kill"] = false,
    ["Anti lag"] = false
}

-- Icon LK Kecil
local IconLK = Instance.new("TextButton", VercoGui)
IconLK.Size = UDim2.new(0, 40, 0, 40)
IconLK.Position = UDim2.new(0, 10, 0.5, 0)
IconLK.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
IconLK.BorderColor3 = Color3.fromRGB(255, 0, 0)
IconLK.Text = "LK"
IconLK.TextColor3 = Color3.fromRGB(255, 0, 0)
IconLK.Font = Enum.Font.GothamBlack
IconLK.TextSize = 20
IconLK.Visible = false
Instance.new("UICorner", IconLK).CornerRadius = UDim.new(0, 8)

local Main = Instance.new("Frame", VercoGui)
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
Main.Active = true
Main.Draggable = true

-- Background Partikel Merah
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
Title.TextSize = 24
Title.BackgroundTransparency = 1

local SideBar = Instance.new("ScrollingFrame", Main)
SideBar.Size = UDim2.new(0, 150, 0, 250)
SideBar.Position = UDim2.new(0, 10, 0, 60)
SideBar.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
SideBar.BorderSizePixel = 0
SideBar.ScrollBarThickness = 2

local FeaturePanel = Instance.new("ScrollingFrame", Main)
FeaturePanel.Size = UDim2.new(0, 360, 0, 250)
FeaturePanel.Position = UDim2.new(0, 170, 0, 60)
FeaturePanel.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
FeaturePanel.BorderSizePixel = 0
FeaturePanel.ScrollBarThickness = 2

Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 5)
Instance.new("UIListLayout", FeaturePanel).Padding = UDim.new(0, 5)

-- Logic Checkbox (Save State & Gahar)
local function CreateCheckbox(name, callback)
    local Frame = Instance.new("Frame", FeaturePanel)
    Frame.Size = UDim2.new(0.95, 0, 0, 40)
    Frame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local Box = Instance.new("TextButton", Frame)
    Box.Size = UDim2.new(0, 25, 0, 25)
    Box.Position = UDim2.new(0.85, 0, 0.2, 0)
    Box.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    Box.BorderColor3 = Color3.fromRGB(255, 0, 0)
    
    -- Sync dengan Global State
    Box.Text = _G.VercoStates[name] and "X" or ""
    Box.TextColor3 = Color3.fromRGB(255, 0, 0)

    Box.MouseButton1Click:Connect(function()
        _G.VercoStates[name] = not _G.VercoStates[name]
        Box.Text = _G.VercoStates[name] and "X" or ""
        callback(_G.VercoStates[name])
    end)
end

-- Fungsi ESP (Line & Box 2D Merah)
local function CreateESP(plr)
    local Line = Drawing.new("Line")
    local Box = Drawing.new("Square")

    local function Update()
        local c = RS.RenderStepped:Connect(function()
            if _G.VercoStates["Esp Line"] or _G.VercoStates["Esp Box"] then
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                    local hrpPos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                    if onScreen then
                        -- Line ESP
                        Line.Visible = _G.VercoStates["Esp Line"]
                        Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        Line.To = Vector2.new(hrpPos.X, hrpPos.Y)
                        Line.Color = Color3.fromRGB(255, 0, 0)
                        Line.Thickness = 1
                        
                        -- Box 2D ESP
                        local headPos = Camera:WorldToViewportPoint(plr.Character.Head.Position + Vector3.new(0, 0.5, 0))
                        local legPos = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                        
                        Box.Visible = _G.VercoStates["Esp Box"]
                        Box.Size = Vector2.new(2500 / hrpPos.Z, headPos.Y - legPos.Y)
                        Box.Position = Vector2.new(hrpPos.X - Box.Size.X / 2, hrpPos.Y - Box.Size.Y / 2)
                        Box.Color = Color3.fromRGB(255, 0, 0)
                        Box.Thickness = 1
                        Box.Filled = false
                    else
                        Line.Visible = false
                        Box.Visible = false
                    end
                else
                    Line.Visible = false
                    Box.Visible = false
                end
            else
                Line.Visible = false
                Box.Visible = false
            end
        end)
    end
    Update()
end

for _, v in pairs(Players:GetPlayers()) do
    if v ~= LP then CreateESP(v) end
end
Players.PlayerAdded:Connect(function(v) CreateESP(v) end)

-- Menu Content
local Tabs = {
    ["Menu Aim"] = function()
        for _,v in pairs(FeaturePanel:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
        CreateCheckbox("Aim Silent", function() end)
        CreateCheckbox("AimBot", function() end)
    end,
    ["Menu Esp"] = function()
        for _,v in pairs(FeaturePanel:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
        CreateCheckbox("Esp Line", function() end)
        CreateCheckbox("Esp Box", function() end)
    end,
    ["Menu Config"] = function()
        for _,v in pairs(FeaturePanel:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
        CreateCheckbox("Wallhack", function(v) 
            LP.Character.HumanoidRootPart.CanCollide = not v 
        end)
        CreateCheckbox("Fly Kill", function() end)
        CreateCheckbox("Anti lag", function() end)
    end
}

for tabName, func in pairs(Tabs) do
    local b = Instance.new("TextButton", SideBar)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    b.Text = tabName
    b.TextColor3 = Color3.fromRGB(255, 0, 0)
    b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(func)
end

-- Footer & Hide Logic
local Hide = Instance.new("TextButton", Main)
Hide.Text = "Hide"
Hide.Size = UDim2.new(0, 80, 0, 30)
Hide.Position = UDim2.new(0, 10, 1, -35)
Hide.BackgroundTransparency = 1
Hide.TextColor3 = Color3.fromRGB(255, 0, 0)
Hide.Font = Enum.Font.GothamBold
Hide.MouseButton1Click:Connect(function()
    Main.Visible = false
    IconLK.Visible = true
end)

local Exit = Instance.new("TextButton", Main)
Exit.Text = "Exit"
Exit.Size = UDim2.new(0, 80, 0, 30)
Exit.Position = UDim2.new(1, -90, 1, -35)
Exit.BackgroundTransparency = 1
Exit.TextColor3 = Color3.fromRGB(255, 0, 0)
Exit.Font = Enum.Font.GothamBold
Exit.MouseButton1Click:Connect(function() VercoGui:Destroy() end)

IconLK.MouseButton1Click:Connect(function()
    Main.Visible = true
    IconLK.Visible = false
end)
