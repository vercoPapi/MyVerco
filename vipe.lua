local LP = game.Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local Flags = {
    Aimbot = false,
    Silent = false,
    Esp = false,
    Wallhack = false,
    FlyKill = false,
    Fly = false,
    Ms100 = false,
    Box = false,
    Line = false,
    Name = false,
    Health = false
}

local LoaderGui = Instance.new("ScreenGui", game.CoreGui)
local LoadFrame = Instance.new("Frame", LoaderGui)
LoadFrame.Size = UDim2.new(1, 0, 1, 0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)

local LoadText = Instance.new("TextLabel", LoadFrame)
LoadText.Size = UDim2.new(1, 0, 1, 0)
LoadText.Text = "PAPI VERCO"
LoadText.TextColor3 = Color3.fromRGB(0, 150, 255)
LoadText.TextSize = 80
LoadText.Font = Enum.Font.GothamBold
LoadText.TextTransparency = 1

task.spawn(function()
    for i = 1, 0, -0.05 do task.wait(0.03) LoadText.TextTransparency = i end
    task.wait(2)
    for i = 0, 1, 0.05 do task.wait(0.03) LoadText.TextTransparency = i end
    LoaderGui:Destroy()
end)
task.wait(2.6)

local MainGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Size = UDim2.new(0, 560, 0, 315)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -157)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame)

local LeftPanel = Instance.new("Frame", MainFrame)
LeftPanel.Size = UDim2.new(0, 160, 1, 0)
LeftPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", LeftPanel)

local Title = Instance.new("TextLabel", LeftPanel)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "Verco Paniel V.12"
Title.TextColor3 = Color3.fromRGB(0, 150, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local Container = Instance.new("Frame", MainFrame)
Container.Position = UDim2.new(0, 170, 0, 10)
Container.Size = UDim2.new(1, -180, 1, -20)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(name, pos)
    local TabBtn = Instance.new("TextButton", LeftPanel)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.Position = UDim2.new(0.05, 0, 0, 60 + (pos * 42))
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", TabBtn)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 6)
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    table.insert(Pages, Page)
    return Page
end

local function AddToggle(page, text, flag)
    local Tgl = Instance.new("TextButton", page)
    Tgl.Size = UDim2.new(1, -5, 0, 38)
    Tgl.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Tgl.Text = "   " .. text
    Tgl.TextColor3 = Color3.fromRGB(220, 220, 220)
    Tgl.TextXAlignment = Enum.TextXAlignment.Left
    Tgl.Font = Enum.Font.Gotham
    Instance.new("UICorner", Tgl)
    local Indicator = Instance.new("Frame", Tgl)
    Indicator.Position = UDim2.new(1, -30, 0.5, -8)
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    Tgl.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        Indicator.BackgroundColor3 = Flags[flag] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(200, 0, 0)
    end)
end

local AimPage = CreateTab("Menu Aim", 0)
local VisPage = CreateTab("Menu Visual", 1)
local MovPage = CreateTab("Menu Movement", 2)

AddToggle(AimPage, "AimBot", "Aimbot")
AddToggle(AimPage, "AimSilent", "Silent")

AddToggle(VisPage, "Enable Esp", "Esp")
AddToggle(VisPage, "Line", "Line")
AddToggle(VisPage, "Box", "Box")
AddToggle(VisPage, "Health", "Health")
AddToggle(VisPage, "Name", "Name")
AddToggle(VisPage, "Dist&stance", "Esp")

AddToggle(MovPage, "Wallhack (NoJatuhMap)", "Wallhack")
local SpeedBtn = Instance.new("TextButton", MovPage)
SpeedBtn.Size = UDim2.new(1, -5, 0, 38)
SpeedBtn.Text = "Speed (running) [Click 100]"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
Instance.new("UICorner", SpeedBtn)
SpeedBtn.MouseButton1Click:Connect(function() LP.Character.Humanoid.WalkSpeed = 100 end)

AddToggle(MovPage, "FlyKill (TeleportKeMusuh)", "FlyKill")
AddToggle(MovPage, "Fly (diam di atas map)", "Fly")
AddToggle(MovPage, "Ms100 (dekat musuh 100Meter)", "Ms100")

local SkinSlider = Instance.new("TextButton", MovPage)
SkinSlider.Size = UDim2.new(1, -5, 0, 38)
SkinSlider.Text = "SkinPlayer (Geser Ganti)"
SkinSlider.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Instance.new("UICorner", SkinSlider)

local function CreateESP(plr)
    local Box = Instance.new("BoxHandleAdornment")
    Box.Name = "VercoBox"
    Box.AlwaysOnTop = true
    Box.ZIndex = 10
    Box.Adornee = plr.Character
    Box.Color3 = Color3.fromRGB(0, 150, 255)
    Box.Size = Vector3.new(4, 6, 1)
    Box.Transparency = 0.5
    Box.Parent = plr.Character

    local NameTag = Instance.new("BillboardGui", plr.Character)
    NameTag.Name = "VercoTag"
    NameTag.Size = UDim2.new(0, 100, 0, 50)
    NameTag.AlwaysOnTop = true
    NameTag.Adornee = plr.Character:FindFirstChild("Head")
    NameTag.ExtentsOffset = Vector3.new(0, 3, 0)
    
    local NameLabel = Instance.new("TextLabel", NameTag)
    NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    NameLabel.Text = plr.Name
    NameLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextSize = 14
    NameLabel.Font = Enum.Font.GothamBold

    local HealthLabel = Instance.new("TextLabel", NameTag)
    HealthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    HealthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    HealthLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    HealthLabel.BackgroundTransparency = 1
    HealthLabel.TextSize = 12
    HealthLabel.Font = Enum.Font.Gotham

    return NameTag, Box
end

local function IsVisible(part)
    local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 500)
    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LP.Character, Camera})
    if hit and hit:IsDescendantOf(part.Parent) then return true end
    return false
end

RunService.RenderStepped:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local char = v.Character
            local hum = char:FindFirstChild("Humanoid")
            if Flags.Esp then
                if not char:FindFirstChild("VercoBox") and Flags.Box then CreateESP(v) end
                if char:FindFirstChild("VercoBox") then char.VercoBox.Visible = Flags.Box end
                if char:FindFirstChild("VercoTag") then
                    char.VercoTag.Enabled = true
                    char.VercoTag.TextLabel.Visible = Flags.Name
                    char.VercoTag.TextLabel.Text = v.Name .. " [" .. math.floor((LP.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude) .. "m]"
                    char.VercoTag.HealthLabel.Visible = Flags.Health
                    if hum then char.VercoTag.HealthLabel.Text = "HP: " .. math.floor(hum.Health) end
                end
            else
                if char:FindFirstChild("VercoBox") then char.VercoBox:Destroy() end
                if char:FindFirstChild("VercoTag") then char.VercoTag:Destroy() end
            end
        end
    end

    if Flags.Aimbot then
        local target = nil
        local maxDist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                local head = v.Character.Head
                local pos, vis = Camera:WorldToViewportPoint(head.Position)
                if vis and IsVisible(head) then
                    local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if mouseDist < maxDist then target = head; maxDist = mouseDist end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end

    if Flags.FlyKill then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                LP.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                break
            end
        end
    end

    if Flags.Ms100 then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (v.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                if dist < 100 and IsVisible(v.Character.Head) then
                    v.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, v.Character.Head.Position)
                end
            end
        end
    end
end)

local IconLK = Instance.new("TextButton", MainGui)
IconLK.Size = UDim2.new(0, 50, 0, 50)
IconLK.Position = UDim2.new(0, 20, 0, 20)
IconLK.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
IconLK.Text = "LK"
IconLK.TextColor3 = Color3.fromRGB(255, 255, 255)
IconLK.Font = Enum.Font.GothamBold
IconLK.Visible = false
Instance.new("UICorner", IconLK).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IconLK.Visible = true
end)
IconLK.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    IconLK.Visible = false
end)
Pages[1].Visible = true
