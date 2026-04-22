repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

if getgenv().VERCO_LOADED then return end

local ParentUI = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
local VERCO_GUI = Instance.new("ScreenGui")
VERCO_GUI.Name = "VERCO_HUB"
VERCO_GUI.Parent = ParentUI
VERCO_GUI.ResetOnSpawn = false

-- Fungsi Utama Menu (Dijalankan setelah login)
local function StartHub()
    getgenv().VERCO_LOADED = true
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = VERCO_GUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 250, 0, 320)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)

    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "VERCO HUB"
    Title.TextColor3 = Color3.fromRGB(0, 150, 255)
    Title.TextSize = 20

    local IconBtn = Instance.new("TextButton")
    IconBtn.Parent = VERCO_GUI
    IconBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    IconBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
    IconBtn.Size = UDim2.new(0, 50, 0, 50)
    IconBtn.Text = "LK"
    IconBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
    IconBtn.Visible = false
    IconBtn.Draggable = true
    Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", IconBtn).Color = Color3.fromRGB(0, 150, 255)

    local HideBtn = Instance.new("TextButton")
    HideBtn.Parent = MainFrame
    HideBtn.Size = UDim2.new(0, 25, 0, 25)
    HideBtn.Position = UDim2.new(1, -60, 0, 7)
    HideBtn.Text = "-"
    HideBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    HideBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        IconBtn.Visible = true
    end)

    IconBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        IconBtn.Visible = false
    end)

    local Container = Instance.new("ScrollingFrame")
    Container.Parent = MainFrame
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.Size = UDim2.new(1, -20, 1, -60)
    Container.BackgroundTransparency = 1
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.ScrollBarThickness = 4

    local UIList = Instance.new("UIListLayout", Container)
    UIList.Padding = UDim.new(0, 10)

    local function CreateCheckbox(text, callback)
        local Box = Instance.new("TextButton", Container)
        Box.Size = UDim2.new(1, 0, 0, 40)
        Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Box.Text = "  " .. text .. " [OFF]"
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.TextXAlignment = Enum.TextXAlignment.Left
        local state = false
        Box.MouseButton1Click:Connect(function()
            state = not state
            Box.Text = "  " .. text .. (state and " [ON]" or " [OFF]")
            Box.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
            callback(state)
        end)
        Instance.new("UIStroke", Box).Color = Color3.fromRGB(50, 50, 50)
    end

    -- SISTEM OPTIMASI (ANTI LAG & CRASH)
    setfpscap(120)
    RunService:Set3dRenderingEnabled(true)

    CreateCheckbox("Anti Crash & Lag", function(v)
        if v then
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
            for _, l in pairs(game:GetDescendants()) do
                if l:IsA("BlurEffect") or l:IsA("SunRaysEffect") or l:IsA("BloomEffect") then l.Enabled = false end
            end
        end
    end)

    CreateCheckbox("No Reload (Instan)", function(v)
        _G.NoReload = v
        task.spawn(function()
            while _G.NoReload do task.wait()
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        if tool:FindFirstChild("Ammo") then tool.Ammo.Value = 999 end
                        if tool:FindFirstChild("Reloading") then tool.Reloading.Value = false end
                    end
                end)
            end
        end)
    end)

    CreateCheckbox("AutoMakro (Fast Shot)", function(v)
        _G.AutoMakro = v
        task.spawn(function()
            while _G.AutoMakro do task.wait()
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                        if tool:FindFirstChild("Cooldown") then tool.Cooldown.Value = 0 end
                    end
                end)
            end
        end)
    end)

    CreateCheckbox("AimMagnet (Head Lock)", function(v)
        _G.AimMagnet = v
        RunService.RenderStepped:Connect(function()
            if _G.AimMagnet then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        local dist = (LocalPlayer.Character.Head.Position - p.Character.Head.Position).Magnitude
                        if dist <= 100 then 
                            p.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.Head.CFrame * CFrame.new(0, 0, -3) 
                        end
                    end
                end
            end
        end)
    end)

    CreateCheckbox("Teleport Back (Stick)", function(v)
        _G.TPBack = v
        task.spawn(function()
            while _G.TPBack do task.wait()
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            break
                        end
                    end
                end)
            end
        end)
    end)

    -- FITUR LAMA
    CreateCheckbox("Auto Farm", function(v) if v then loadstring(game:HttpGet("https://raw.githubusercontent.com/canhongson/CanHongSon/refs/heads/main/CanHongSonHub.lua"))() end end)
    CreateCheckbox("Speed Hack", function(v) if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 end end)
    CreateCheckbox("Infinite Jump", function(v) _G.IJ = v UserInputService.JumpRequest:Connect(function() if _G.IJ then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end) end)
    CreateCheckbox("Noclip", function(v) _G.NC = v RunService.Stepped:Connect(function() if _G.NC and LocalPlayer.Character then for _, x in pairs(LocalPlayer.Character:GetDescendants()) do if x:IsA("BasePart") then x.CanCollide = false end end end end) end)
    CreateCheckbox("Anti AFK", function(v) local vu = game:GetService("VirtualUser") LocalPlayer.Idled:Connect(function() if v then vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end end) end)

    -- Timer Expired 10 Menit
    task.delay(600, function()
        VERCO_GUI:Destroy()
        getgenv().VERCO_LOADED = false
        warn("Experit Masa trial habis")
    end)
end

-- TAMPILAN LOGIN
local LoginFrame = Instance.new("Frame", VERCO_GUI)
LoginFrame.Size = UDim2.new(0, 250, 0, 180)
LoginFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
LoginFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LoginFrame.Active = true
LoginFrame.Draggable = true
Instance.new("UIStroke", LoginFrame).Color = Color3.fromRGB(0, 150, 255)

local LTitle = Instance.new("TextLabel", LoginFrame)
LTitle.Size = UDim2.new(1, 0, 0, 40)
LTitle.Text = "Papi Verco"
LTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
LTitle.Font = Enum.Font.SourceSansBold
LTitle.TextSize = 20
LTitle.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox", LoginFrame)
KeyBox.Size = UDim2.new(0, 200, 0, 35)
KeyBox.Position = UDim2.new(0.5, -100, 0.4, 0)
KeyBox.PlaceholderText = "Masukan key"
KeyBox.Text = ""
KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local LoginBtn = Instance.new("TextButton", LoginFrame)
LoginBtn.Size = UDim2.new(0, 100, 0, 35)
LoginBtn.Position = UDim2.new(0.5, -50, 0.7, 0)
LoginBtn.Text = "Login"
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

LoginBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == "trial" then
        LoginFrame:Destroy()
        StartHub()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Key Salah!"
    end
end)
