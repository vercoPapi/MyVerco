repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

if getgenv().VERCO_LOADED then return end

-- [[ SISTEM ANTI CRASH & ANTI LAG UNIVERSAL ]]
task.spawn(function()
    setfpscap(120)
    RunService:Set3dRenderingEnabled(true)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("PostProcessEffect") then
            v.Enabled = false
        elseif v:IsA("BasePart") and v.Material == Enum.Material.Glass then
            v.Material = Enum.Material.Plastic
        end
    end
end)

local ParentUI = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
local VERCO_GUI = Instance.new("ScreenGui", ParentUI)
VERCO_GUI.Name = "VERCO_HUB_STABLE"
VERCO_GUI.ResetOnSpawn = false

local function StartHub()
    getgenv().VERCO_LOADED = true
    
    -- Tampilan 16:9
    local MainFrame = Instance.new("Frame", VERCO_GUI)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.Size = UDim2.new(0, 320, 0, 180)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)

    -- Tombol HIDE (LK)
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
    HideBtn.Position = UDim2.new(1, -30, 0, 2)
    HideBtn.Text = "-"
    HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    HideBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        IconBtn.Visible = true
    end)

    IconBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        IconBtn.Visible = false
    end)

    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -10, 1, -40)
    Container.Position = UDim2.new(0, 5, 0, 35)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 3
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

    local function CreateCheckbox(text, cb)
        local b = Instance.new("TextButton", Container)
        b.Size = UDim2.new(1, 0, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = "  " .. text .. " [OFF]"
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.TextXAlignment = Enum.TextXAlignment.Left
        local s = false
        b.MouseButton1Click:Connect(function()
            s = not s
            b.Text = "  " .. text .. (s and " [ON]" or " [OFF]")
            b.TextColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255,255,255)
            cb(s)
        end)
    end

    -- [[ FITUR BARU: AUTO FARM SOUTH BRONX ]]
    CreateCheckbox("Auto Farm (Cook/Market/Apart)", function(v)
        _G.AutoFarmSB = v
        task.spawn(function()
            while _G.AutoFarmSB do
                pcall(function()
                    -- Simulasi Teleport Ke Market
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-100, 10, 50) -- Koordinat Market
                    task.wait(2)
                    -- Simulasi Teleport Ke Tempat Masak
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(200, 10, -150) -- Koordinat Cook
                    task.wait(2)
                end)
                task.wait(1)
            end
        end)
    end)

    -- [[ BIDIKAN PASS HEAD LOCK SOUTH BRONX ]]
    CreateCheckbox("SB Head Lock (No Miss)", function(v)
        _G.SB_Head = v
        RunService.RenderStepped:Connect(function()
            if _G.SB_Head then
                for _, p in pairs(workspace:GetDescendants()) do
                    if p:FindFirstChild("Head") and p:FindFirstChild("Humanoid") and p.Humanoid.Health > 0 and p.Name ~= LocalPlayer.Name then
                        local pos, vis = Camera:WorldToViewportPoint(p.Head.Position)
                        if vis then
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Head.Position)
                        end
                    end
                end
            end
        end)
    end)

    -- [[ FITUR LAMA ]]
    CreateCheckbox("ESP Line & Box (All)", function(v) _G.ESP_MASTER = v end)
    CreateCheckbox("Auto Peluru 50", function(v) _G.FastAmmo = v end)
    CreateCheckbox("WallHack", function(v) _G.WH = v end)
    CreateCheckbox("Speed Hack", function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 end)

    task.delay(600, function() VERCO_GUI:Destroy() end)
end

-- LOGIN SCREEN
local LFrame = Instance.new("Frame", VERCO_GUI)
LFrame.Size = UDim2.new(0, 280, 0, 150)
LFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
LFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UIStroke", LFrame).Color = Color3.fromRGB(0, 150, 255)
local Key = Instance.new("TextBox", LFrame)
Key.Size = UDim2.new(0, 200, 0, 30)
Key.Position = UDim2.new(0.5, -100, 0.4, 0)
Key.PlaceholderText = "Input Key"
local Btn = Instance.new("TextButton", LFrame)
Btn.Size = UDim2.new(0, 100, 0, 30)
Btn.Position = UDim2.new(0.5, -50, 0.7, 0)
Btn.Text = "Login"
Btn.MouseButton1Click:Connect(function()
    if Key.Text == "trial" then LFrame:Destroy() StartHub() end
end)
