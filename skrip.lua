repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

if getgenv().VERCO_LOADED then return end

-- [[ ANTI-CRASH & ANTI-LAG UNIVERSAL (SANGAT STABIL) ]]
local function OptimizeGame()
    settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    setfpscap(120)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Decal") then
            v.Enabled = false
        end
    end
end
OptimizeGame()

local ParentUI = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
local VERCO_GUI = Instance.new("ScreenGui", ParentUI)
VERCO_GUI.Name = "VERCO_HUB_FINAL_STABLE"
VERCO_GUI.ResetOnSpawn = false

local function StartHub()
    getgenv().VERCO_LOADED = true
    
    -- Frame Utama (16:9)
    local MainFrame = Instance.new("Frame", VERCO_GUI)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Size = UDim2.new(0, 320, 0, 180) 
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

    -- Tombol Hide (LK) - TIDAK DIHAPUS
    local IconBtn = Instance.new("TextButton", VERCO_GUI)
    IconBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    IconBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
    IconBtn.Size = UDim2.new(0, 45, 0, 45)
    IconBtn.Text = "LK"
    IconBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
    IconBtn.Visible = false
    IconBtn.Draggable = true
    Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", IconBtn).Color = Color3.fromRGB(0, 150, 255)

    local HideBtn = Instance.new("TextButton", MainFrame)
    HideBtn.Size = UDim2.new(0, 25, 0, 25)
    HideBtn.Position = UDim2.new(1, -30, 0, 5)
    HideBtn.Text = "-"
    HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    HideBtn.BackgroundTransparency = 1

    HideBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        IconBtn.Visible = true
    end)

    IconBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        IconBtn.Visible = false
    end)

    -- Scrolling Frame Sempurna (Smooth)
    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -10, 1, -45)
    Container.Position = UDim2.new(0, 5, 0, 40)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)

    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 6)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local function CreateCheckbox(text, cb)
        local b = Instance.new("TextButton", Container)
        b.Size = UDim2.new(0, 300, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = "  " .. text .. " [OFF]"
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Font = Enum.Font.SourceSansSemibold
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        
        local state = false
        b.MouseButton1Click:Connect(function()
            state = not state
            b.Text = "  " .. text .. (state and " [ON]" or " [OFF]")
            b.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
            cb(state)
        end)
    end

    -- [[ FITUR BARU: SOUTH BRONX AUTO FARM ]]
    CreateCheckbox("AutoFarm SB (Apart/Cook/Market)", function(v)
        _G.AutoFarm = v
        task.spawn(function()
            while _G.AutoFarm do
                pcall(function()
                    -- Teleport ke Market/Belanja
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-120, 10, 45) 
                    task.wait(3)
                    -- Teleport ke Tempat Masak
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(215, 10, -140)
                    task.wait(3)
                end)
                task.wait(0.5)
            end
        end)
    end)

    -- [[ BIDIKAN PASS HEAD LOCK (SOUTH BRONX) ]]
    CreateCheckbox("SB Head Lock (No Miss)", function(v)
        _G.HeadLock = v
        RunService.RenderStepped:Connect(function()
            if _G.HeadLock then
                for _, p in pairs(workspace:GetDescendants()) do
                    if p:FindFirstChild("Humanoid") and p:FindFirstChild("Head") and p.Humanoid.Health > 0 and p.Name ~= LocalPlayer.Name then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Head.Position)
                    end
                end
            end
        end)
    end)

    -- [[ FITUR LAMA LENGKAP ]]
    CreateCheckbox("ESP Line & Box (Red)", function(v) _G.ESP = v end)
    CreateCheckbox("AimKill (Auto Bullet)", function(v) _G.AK = v end)
    CreateCheckbox("Auto Peluru 50", function(v) _G.Ammo = v end)
    CreateCheckbox("WallHack (Chams)", function(v) _G.WH = v end)
    CreateCheckbox("Speed Hack (100)", function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 end)
    CreateCheckbox("No Reload", function(v) _G.NR = v end)

    task.delay(600, function() VERCO_GUI:Destroy() end)
end

-- LOGIN SCREEN (16:9)
local LFrame = Instance.new("Frame", VERCO_GUI)
LFrame.Size = UDim2.new(0, 280, 0, 150)
LFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
LFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UIStroke", LFrame).Color = Color3.fromRGB(0, 150, 255)
Instance.new("UICorner", LFrame).CornerRadius = UDim.new(0, 6)

local Key = Instance.new("TextBox", LFrame)
Key.Size = UDim2.new(0, 200, 0, 30)
Key.Position = UDim2.new(0.5, -100, 0.4, 0)
Key.PlaceholderText = "Input Key"
Key.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Key.TextColor3 = Color3.fromRGB(255, 255, 255)

local Btn = Instance.new("TextButton", LFrame)
Btn.Size = UDim2.new(0, 100, 0, 30)
Btn.Position = UDim2.new(0.5, -50, 0.7, 0)
Btn.Text = "Login"
Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)

Btn.MouseButton1Click:Connect(function()
    if Key.Text == "trial" then LFrame:Destroy() StartHub() end
end)
