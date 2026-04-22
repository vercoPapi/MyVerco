repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

if getgenv().VERCO_LOADED then return end

local ParentUI = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
local VERCO_GUI = Instance.new("ScreenGui", ParentUI)
VERCO_GUI.Name = "VERCO_PREMIUM_V5"
VERCO_GUI.ResetOnSpawn = false

local function StartHub()
    getgenv().VERCO_LOADED = true

    -- Main Window (Bisa digeser)
    local MainFrame = Instance.new("Frame", VERCO_GUI)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Position = UDim2.new(0, 50, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Active = true
    MainFrame.Draggable = true -- FITUR GESER AKTIF
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    -- Logo/Icon LK (Tetap muncul saat menu dibuka sebagai identitas)
    local Logo = Instance.new("TextLabel", MainFrame)
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.Position = UDim2.new(0, 5, 0, 0)
    Logo.Text = "LK"
    Logo.TextColor3 = Color3.fromRGB(0, 150, 255)
    Logo.Font = Enum.Font.SourceSansBold
    Logo.TextSize = 25
    Logo.BackgroundTransparency = 1

    -- Sidebar Navigasi (Kiri)
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 120, 1, -50)
    Sidebar.Position = UDim2.new(0, 5, 0, 45)
    Sidebar.BackgroundTransparency = 0.9
    local SideLayout = Instance.new("UIListLayout", Sidebar)
    SideLayout.Padding = UDim.new(0, 5)

    -- Content Area (Kanan)
    local Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1, -135, 1, -50)
    Content.Position = UDim2.new(0, 130, 0, 45)
    Content.BackgroundTransparency = 1

    -- Tombol Minimize/Hide (-)
    local HideBtn = Instance.new("TextButton", MainFrame)
    HideBtn.Size = UDim2.new(0, 30, 0, 30)
    HideBtn.Position = UDim2.new(1, -35, 0, 5)
    HideBtn.Text = "-"
    HideBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 5)

    -- Floating Icon LK (Saat Hide)
    local IconBtn = Instance.new("TextButton", VERCO_GUI)
    IconBtn.Size = UDim2.new(0, 50, 0, 50)
    IconBtn.Position = UDim2.new(0, 20, 0, 20)
    IconBtn.Text = "LK"
    IconBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    IconBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
    IconBtn.Visible = false
    IconBtn.Draggable = true
    Instance.new("UIStroke", IconBtn).Color = Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)

    HideBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        IconBtn.Visible = true
    end)
    IconBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        IconBtn.Visible = false
    end)

    local function CreatePage(name)
        local Page = Instance.new("ScrollingFrame", Content)
        Page.Name = name
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)
        
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.Text = name
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Page.Visible = true
        end)
        return Page
    end

    local function AddToggle(parent, text, cb)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, -10, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = " " .. text .. " [OFF]"
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextXAlignment = 0
        local s = false
        b.MouseButton1Click:Connect(function()
            s = not s
            b.Text = " " .. text .. (s and " [ON]" or " [OFF]")
            b.TextColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
            cb(s)
        end)
    end

    -- [[ MENU BUY ]]
    local PageBuy = CreatePage("Menu Buy")
    AddToggle(PageBuy, "AutoBuy (Free/Item/Bundle)", function(v)
        _G.AutoBuy = v
        task.spawn(function()
            while _G.AutoBuy do task.wait(0.5)
                pcall(function()
                    for _, r in pairs(game:GetDescendants()) do
                        if r:IsA("RemoteFunction") or r:IsA("RemoteEvent") then
                            if r.Name:lower():find("buy") or r.Name:lower():find("purchase") then
                                r:FireServer(1) -- Simulasi beli otomatis
                            end
                        end
                    end
                end)
            end
        end)
    end)

    -- [[ MENU MANCING ]]
    local PageMancing = CreatePage("Mancing")
    AddToggle(PageMancing, "Auto Mancing (Auto Walk)", function(v)
        _G.AutoFish = v
        task.spawn(function()
            while _G.AutoFish do task.wait(0.1)
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool and tool.Name:lower():find("rod") then
                        tool:Activate() -- Tarik/Lempar instan
                    end
                end)
            end
        end)
    end)

    -- [[ MENU GENDONG ]]
    local PageGendong = CreatePage("Gendong")
    AddToggle(PageGendong, "Auto Gendong Player", function(v)
        _G.AutoCarry = v
        task.spawn(function()
            while _G.AutoCarry do task.wait()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = p.Character.HumanoidRootPart
                        if (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 15 then
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                            LocalPlayer.Character.Humanoid.WalkSpeed = 0 -- Diam setelah gendong
                        end
                    end
                end
            end
        end)
    end)

    -- [[ MENU ALL ]]
    local PageAll = CreatePage("Menu All")
    AddToggle(PageAll, "Jump 3x Multi", function(v) LocalPlayer.Character.Humanoid.JumpPower = v and 150 or 50 end)
    AddToggle(PageAll, "Wallhack (Anti Fall)", function(v)
        _G.WH = v
        RunService.Stepped:Connect(function()
            if _G.WH then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end)
    AddToggle(PageAll, "AntiLag (3D HDR)", function(v)
        if v then
            local e = Instance.new("ColorCorrectionEffect", game.Lighting)
            e.Contrast = 0.1 e.Saturation = 0.2
            game.Lighting.GlobalShadows = true
        end
    end)
    AddToggle(PageAll, "Fly Non Jatuh", function(v)
        if v then
            local bp = Instance.new("BodyPosition", LocalPlayer.Character.HumanoidRootPart)
            bp.Name = "FlyNP" bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bp.Position = LocalPlayer.Character.HumanoidRootPart.Position
        else
            if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyNP") then LocalPlayer.Character.HumanoidRootPart.FlyNP:Destroy() end
        end
    end)
    AddToggle(PageAll, "Fly Jatuh", function(v)
        if v and LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyNP") then
            LocalPlayer.Character.HumanoidRootPart.FlyNP:Destroy()
        end
    end)

    PageBuy.Visible = true -- Halaman utama saat login
end

-- LOGIN SCREEN
local LFrame = Instance.new("Frame", VERCO_GUI)
LFrame.Size = UDim2.new(0, 300, 0, 160)
LFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
LFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UIStroke", LFrame).Color = Color3.fromRGB(0, 150, 255)

local Key = Instance.new("TextBox", LFrame)
Key.Size = UDim2.new(0, 220, 0, 40)
Key.Position = UDim2.new(0.5, -110, 0.35, 0)
Key.PlaceholderText = "Input Key (trial)"
Key.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Key.TextColor3 = Color3.fromRGB(255, 255, 255)

local Btn = Instance.new("TextButton", LFrame)
Btn.Size = UDim2.new(0, 120, 0, 40)
Btn.Position = UDim2.new(0.5, -60, 0.7, 0)
Btn.Text = "Login"
Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)

Btn.MouseButton1Click:Connect(function()
    if Key.Text == "trial" then LFrame:Destroy() StartHub() end
end)
