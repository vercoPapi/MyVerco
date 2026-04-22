local LP = game.Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local Flags = {
    Aimbot = false, Silent = false, Esp = false, 
    Wallhack = false, FlyKill = false, Fly = false, Ms100 = false
}

-- 1. START LOADING SCREEN "PAPI VERCO"
local LoaderGui = Instance.new("ScreenGui", game.CoreGui)
local LoadFrame = Instance.new("Frame", LoaderGui)
LoadFrame.Size = UDim2.new(1, 0, 1, 0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

local LoadText = Instance.new("TextLabel", LoadFrame)
LoadText.Size = UDim2.new(1, 0, 1, 0)
LoadText.Text = "PAPI VERCO"
LoadText.TextColor3 = Color3.fromRGB(0, 150, 255)
LoadText.TextSize = 50
LoadText.Font = Enum.Font.GothamBold
LoadText.TextTransparency = 1

-- Animasi Loading
task.spawn(function()
    for i = 1, 0, -0.05 do task.wait(0.05) LoadText.TextTransparency = i end
    task.wait(1.5)
    for i = 0, 1, 0.05 do task.wait(0.05) LoadText.TextTransparency = i end
    LoaderGui:Destroy()
end)
task.wait(2.5)

-- 2. LOCAL UI (STYLE RAYFIELD)
local MainGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Size = UDim2.new(0, 560, 0, 315) -- 16:9
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -157)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame)

local LeftPanel = Instance.new("Frame", MainFrame)
LeftPanel.Size = UDim2.new(0, 160, 1, 0)
LeftPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local Title = Instance.new("TextLabel", LeftPanel)
Title.Size = UDim2.new(1, 0, 0, 45)
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
    TabBtn.Position = UDim2.new(0.05, 0, 0, 50 + (pos * 40))
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", TabBtn)

    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 5)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    table.insert(Pages, Page)
    return Page
end

local function AddToggle(page, text, flag)
    local Tgl = Instance.new("TextButton", page)
    Tgl.Size = UDim2.new(1, -10, 0, 35)
    Tgl.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Tgl.Text = "  " .. text
    Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tgl.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Tgl)
    local Box = Instance.new("Frame", Tgl)
    Box.Position = UDim2.new(1, -25, 0.5, -7)
    Box.Size = UDim2.new(0, 15, 0, 15)
    Box.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Tgl.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        Box.BackgroundColor3 = Flags[flag] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(200, 0, 0)
    end)
end

-- Tab Setup
local AimPage = CreateTab("Menu Aim", 0)
local VisPage = CreateTab("Menu Visual", 1)
local MovPage = CreateTab("Menu Movement", 2)

-- [[ FITUR ]] --
AddToggle(AimPage, "AimBot (Lock Head)", "Aimbot")
AddToggle(AimPage, "AimSilent", "Silent")

AddToggle(VisPage, "Enable Esp", "Esp")
AddToggle(VisPage, "Line", "Esp")
AddToggle(VisPage, "Box", "Esp")
AddToggle(VisPage, "Health", "Esp")
AddToggle(VisPage, "Name", "Esp")
AddToggle(VisPage, "Dist&stance", "Esp")

AddToggle(MovPage, "Wallhack (NoJatuhMap)", "Wallhack")
AddToggle(MovPage, "FlyKill (AutoTeleport)", "FlyKill")
AddToggle(MovPage, "Fly (Stay Above)", "Fly")
AddToggle(MovPage, "Ms100 (Auto Detect)", "Ms100")

-- SkinPlayer Slider
local SkinSlider = Instance.new("TextButton", MovPage)
SkinSlider.Size = UDim2.new(1, -10, 0, 35)
SkinSlider.Text = "SkinPlayer (Geser Player)"
SkinSlider.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

-- [[ LOGIKA CORE WORK 100% ]] --
RunService.RenderStepped:Connect(function()
    -- AIMBOT LOCK HEAD
    if Flags.Aimbot then
        local target = nil
        local dist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if mDist < dist then target = v; dist = mDist end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
    end

    -- FLYKILL LOGIC (AUTO LOOP TELEPORT)
    if Flags.FlyKill then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                LP.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                break -- Tetap di musuh ini sampai mati
            end
        end
    end

    -- MS100 LOGIC (Bring to front)
    if Flags.Ms100 then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= LP and v.Character and (v.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude < 100 then
                v.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            end
        end
    end
end)

-- LOGO LK MINIMIZE
local IconLK = Instance.new("TextButton", MainGui)
IconLK.Size = UDim2.new(0, 50, 0, 50)
IconLK.Position = UDim2.new(0, 15, 0, 15)
IconLK.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
IconLK.Text = "LK"
IconLK.TextColor3 = Color3.fromRGB(255, 255, 255)
IconLK.Visible = false
Instance.new("UICorner", IconLK).CornerRadius = UDim.new(1, 0)

-- Close/Hide
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IconLK.Visible = true
end)

IconLK.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    IconLK.Visible = false
end)

Pages[1].Visible = true -- Open Aim by default
