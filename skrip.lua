repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

if getgenv().VERCO_LOADED then return end

local ParentUI = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
local VERCO_GUI = Instance.new("ScreenGui")
VERCO_GUI.Name = "VERCO_HUB"
VERCO_GUI.Parent = ParentUI
VERCO_GUI.ResetOnSpawn = false

-- Fungsi Utama Menu
local function StartHub()
    getgenv().VERCO_LOADED = true
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = VERCO_GUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 300, 0, 400) -- Ukuran diperbesar agar tidak sempit
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)

    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "VERCO HUB"
    Title.TextColor3 = Color3.fromRGB(0, 150, 255)
    Title.TextSize = 22

    local IconBtn = Instance.new("TextButton")
    IconBtn.Parent = VERCO_GUI
    IconBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    IconBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
    IconBtn.Size = UDim2.new(0, 55, 0, 55)
    IconBtn.Text = "LK"
    IconBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
    IconBtn.Visible = false
    IconBtn.Draggable = true
    Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", IconBtn).Color = Color3.fromRGB(0, 150, 255)

    local HideBtn = Instance.new("TextButton")
    HideBtn.Parent = MainFrame
    HideBtn.Size = UDim2.new(0, 30, 0, 30)
    HideBtn.Position = UDim2.new(1, -65, 0, 7)
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
    Container.Position = UDim2.new(0, 10, 0, 55)
    Container.Size = UDim2.new(1, -20, 1, -65)
    Container.BackgroundTransparency = 1
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.CanvasSize = UDim2.new(0,0,0,0)
    Container.ScrollBarThickness = 5

    local UIList = Instance.new("UIListLayout", Container)
    UIList.Padding = UDim.new(0, 10)

    local function CreateCheckbox(text, callback)
        local Box = Instance.new("TextButton", Container)
        Box.Size = UDim2.new(1, 0, 0, 45)
        Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Box.Text = "  " .. text .. " [OFF]"
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.TextXAlignment = Enum.TextXAlignment.Left
        Box.Font = Enum.Font.SourceSans
        Box.TextSize = 17
        local state = false
        Box.MouseButton1Click:Connect(function()
            state = not state
            Box.Text = "  " .. text .. (state and " [ON]" or " [OFF]")
            Box.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
            callback(state)
        end)
        Instance.new("UIStroke", Box).Color = Color3.fromRGB(50, 50, 50)
    end

    -- FITUR BARU: AIMKILL (Auto Chase Bullets)
    CreateCheckbox("AimKill (No Shoot)", function(v)
        _G.AimKill = v
        task.spawn(function()
            while _G.AimKill do task.wait(0.1)
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
                            local d = (LocalPlayer.Character.Head.Position - p.Character.Head.Position).Magnitude
                            if d <= 100 then
                                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                if tool then
                                    -- Simulasi peluru mengejar target
                                    tool:Activate()
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end)

    -- FITUR AIMBOT: SMOOTH LOCK (Hanya saat kelihatan)
    CreateCheckbox("AimBot (Smooth Head)", function(v)
        _G.AimBot = v
        RunService.RenderStepped:Connect(function()
            if _G.AimBot then
                local closest = nil
                local shortestDist = math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
                        local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                        if vis then
                            -- Check if blocked by wall
                            local ray = Ray.new(Camera.CFrame.Position, (p.Character.Head.Position - Camera.CFrame.Position).Unit * 500)
                            local part = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, p.Character})
                            if not part then
                                local mousePos = UserInputService:GetMouseLocation()
                                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                                if dist < shortestDist then
                                    closest = p
                                    shortestDist = dist
                                end
                            end
                        end
                    end
                end
                if closest then
                    local targetPos = Camera:WorldToViewportPoint(closest.Character.Head.Position)
                    local mousePos = UserInputService:GetMouseLocation()
                    mousemoverel((targetPos.X - mousePos.X)/5, (targetPos.Y - mousePos.Y)/5) -- Smooth Movement
                end
            end
        end)
    end)

    -- FITUR ESP: LINE & BOX 2D
    CreateCheckbox("ESP Line & Box 2D", function(v)
        _G.ESP = v
        RunService.RenderStepped:Connect(function()
            if _G.ESP then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if not p.Character:FindFirstChild("VercoLine") then
                            local line = Instance.new("LineHandleAdornment", p.Character)
                            line.Name = "VercoLine"
                            line.Length = 100
                            line.Thickness = 2
                            line.Color3 = Color3.fromRGB(255, 0, 0)
                            line.AlwaysOnTop = true
                            
                            local bg = Instance.new("BillboardGui", p.Character)
                            bg.Name = "VercoBox"
                            bg.AlwaysOnTop = true
                            bg.Size = UDim2.new(4,0,5,0)
                            local f = Instance.new("Frame", bg)
                            f.Size = UDim2.new(1,0,1,0)
                            f.BackgroundTransparency = 1
                            Instance.new("UIStroke", f).Color = Color3.fromRGB(255, 0, 0)
                        end
                    end
                end
            end
        end)
    end)

    -- FITUR TELEPORT: LOCK HEAD
    CreateCheckbox("Teleport (Stick Head)", function(v)
        _G.TPBack = v
        task.spawn(function()
            local target = nil
            while _G.TPBack do task.wait()
                pcall(function()
                    if not target or target.Character.Humanoid.Health <= 0 then
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character.Humanoid.Health > 0 then target = p break end
                        end
                    end
                    if target then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
                    end
                end)
            end
        end)
    end)

    -- FITUR NO RELOAD & AUTOMAKRO
    CreateCheckbox("No Reload (100% Work)", function(v)
        _G.NR = v
        RunService.Stepped:Connect(function()
            if _G.NR then
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Ammo") then tool.Ammo.Value = 999 end
                end)
            end
        end)
    end)

    CreateCheckbox("AutoMakro (Fast Shot)", function(v)
        _G.AM = v
        task.spawn(function()
            while _G.AM do task.wait()
                pcall(function()
                    LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
                end)
            end
        end)
    end)

    -- FITUR LAMA LAINNYA
    CreateCheckbox("Anti Crash & Lag", function(v) if v then setfpscap(120) end end)
    CreateCheckbox("WallHack", function(v) _G.WH = v end)
    CreateCheckbox("Anti Jatuh Map", function(v) _G.AF = v end)
    CreateCheckbox("Auto Farm", function(v) if v then loadstring(game:HttpGet("https://raw.githubusercontent.com/canhongson/CanHongSon/refs/heads/main/CanHongSonHub.lua"))() end end)
    CreateCheckbox("Speed Hack", function(v) if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 end end)

    task.delay(600, function() VERCO_GUI:Destroy() getgenv().VERCO_LOADED = false print("Experit Masa trial habis") end)
end

-- LOGIN SCREEN
local LoginFrame = Instance.new("Frame", VERCO_GUI)
LoginFrame.Size = UDim2.new(0, 260, 0, 190)
LoginFrame.Position = UDim2.new(0.5, -130, 0.5, -95)
LoginFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UIStroke", LoginFrame).Color = Color3.fromRGB(0, 150, 255)

local LTitle = Instance.new("TextLabel", LoginFrame)
LTitle.Size = UDim2.new(1, 0, 0, 45)
LTitle.Text = "Papi Verco"
LTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
LTitle.Font = Enum.Font.SourceSansBold
LTitle.TextSize = 22
LTitle.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox", LoginFrame)
KeyBox.Size = UDim2.new(0, 210, 0, 35)
KeyBox.Position = UDim2.new(0.5, -105, 0.4, 0)
KeyBox.PlaceholderText = "Masukan key"
KeyBox.Text = ""
KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local LoginBtn = Instance.new("TextButton", LoginFrame)
LoginBtn.Size = UDim2.new(0, 110, 0, 35)
LoginBtn.Position = UDim2.new(0.5, -55, 0.7, 0)
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
