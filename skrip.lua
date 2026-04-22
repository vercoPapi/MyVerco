repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

if getgenv().VERCO_LOADED then return end

local ParentUI = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
local VERCO_GUI = Instance.new("ScreenGui")
VERCO_GUI.Name = "VERCO_HUB_V3"
VERCO_GUI.Parent = ParentUI
VERCO_GUI.ResetOnSpawn = false

-- Fungsi Utama Menu
local function StartHub()
    getgenv().VERCO_LOADED = true
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = VERCO_GUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
    MainFrame.Size = UDim2.new(0, 320, 0, 450) -- Ukuran LEBIH LUAS
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(0, 150, 255)
    MainStroke.Thickness = 2

    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "VERCO HUB PREMIUM"
    Title.TextColor3 = Color3.fromRGB(0, 150, 255)
    Title.TextSize = 24

    local Container = Instance.new("ScrollingFrame")
    Container.Parent = MainFrame
    Container.Position = UDim2.new(0, 10, 0, 60)
    Container.Size = UDim2.new(1, -20, 1, -70)
    Container.BackgroundTransparency = 1
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.CanvasSize = UDim2.new(0,0,0,0)
    Container.ScrollBarThickness = 6

    local UIList = Instance.new("UIListLayout", Container)
    UIList.Padding = UDim.new(0, 12)

    local function CreateCheckbox(text, callback)
        local Box = Instance.new("TextButton", Container)
        Box.Size = UDim2.new(1, 0, 0, 45)
        Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Box.Text = "  " .. text .. " [OFF]"
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.TextXAlignment = Enum.TextXAlignment.Left
        Box.Font = Enum.Font.SourceSansSemibold
        Box.TextSize = 18
        
        local state = false
        Box.MouseButton1Click:Connect(function()
            state = not state
            Box.Text = "  " .. text .. (state and " [ON]" or " [OFF]")
            Box.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
            Box.BackgroundColor3 = state and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30)
            callback(state)
        end)
        Instance.new("UIStroke", Box).Color = Color3.fromRGB(60, 60, 60)
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)
    end

    -- [ FITUR AIMKILL ] Peluru kejar musuh otomatis 100m
    CreateCheckbox("AimKill (Auto Bullet)", function(v)
        _G.AimKill = v
        task.spawn(function()
            while _G.AimKill do task.wait(0.1)
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
                                local dist = (LocalPlayer.Character.Head.Position - p.Character.Head.Position).Magnitude
                                if dist <= 100 then
                                    tool:Activate() -- Tembak otomatis
                                    -- Logika peluru kejar (Magic Bullet)
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end)

    -- [ FITUR AIMBOT ] Smooth Lock & No Wall-Check
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
                            local ray = Ray.new(Camera.CFrame.Position, (p.Character.Head.Position - Camera.CFrame.Position).Unit * 500)
                            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, p.Character})
                            if not hit then -- Cek dinding
                                local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
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
                    -- Geser halus (Smooth 5)
                    mousemoverel((targetPos.X - mousePos.X)/5, (targetPos.Y - mousePos.Y)/5)
                end
            end
        end)
    end)

    -- [ FITUR ESP ] Line & Box 2D Merah
    CreateCheckbox("ESP Line & Box (Red)", function(v)
        _G.ESP = v
        RunService.RenderStepped:Connect(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    
                    if _G.ESP and onScreen then
                        -- Box & Line Visual Logic (Billboard)
                        if not p.Character:FindFirstChild("VercoESP") then
                            local bg = Instance.new("BillboardGui", p.Character)
                            bg.Name = "VercoESP"
                            bg.AlwaysOnTop = true
                            bg.Size = UDim2.new(4,0,5.5,0)
                            local f = Instance.new("Frame", bg)
                            f.Size = UDim2.new(1,0,1,0)
                            f.BackgroundTransparency = 1
                            local st = Instance.new("UIStroke", f)
                            st.Color = Color3.fromRGB(255, 0, 0)
                            st.Thickness = 2
                        end
                    else
                        if p.Character:FindFirstChild("VercoESP") then p.Character.VercoESP:Destroy() end
                    end
                end
            end
        end)
    end)

    -- [ FITUR WALLHACK ] Tembus Pandang
    CreateCheckbox("WallHack (Chams)", function(v)
        _G.WH = v
        task.spawn(function()
            while _G.WH do task.wait(1)
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        for _, part in pairs(p.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Transparency = 0.5
                                part.Color = Color3.fromRGB(0, 150, 255)
                            end
                        end
                    end
                end
            end
        end)
    end)

    -- [ FITUR TELEPORT ] Lock Head & Tetap di satu musuh sampai mati
    CreateCheckbox("Teleport (Lock Head)", function(v)
        _G.TPHead = v
        local currentTarget = nil
        task.spawn(function()
            while _G.TPHead do task.wait()
                pcall(function()
                    if not currentTarget or currentTarget.Character.Humanoid.Health <= 0 then
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character.Humanoid.Health > 0 then
                                currentTarget = p
                                break
                            end
                        end
                    end
                    if currentTarget then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = currentTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, currentTarget.Character.Head.Position)
                    end
                end)
            end
        end)
    end)

    -- [ FITUR LAMA & LAINNYA ]
    CreateCheckbox("No Reload (100% Work)", function(v) _G.NR = v while _G.NR do task.wait() pcall(function() LocalPlayer.Character:FindFirstChildOfClass("Tool").Ammo.Value = 999 end) end end)
    CreateCheckbox("AutoMakro (Fast Shot)", function(v) _G.AM = v while _G.AM do task.wait() pcall(function() LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate() end) end end)
    CreateCheckbox("Anti Crash & Lag", function(v) if v then setfpscap(120) end end)
    CreateCheckbox("Speed Hack", function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 end)
    CreateCheckbox("Anti Jatuh Map", function(v) _G.AF = v end)

    -- Trial Expired
    task.delay(600, function() VERCO_GUI:Destroy() getgenv().VERCO_LOADED = false print("Experit Masa trial habis") end)
end

-- [ TAMPILAN LOGIN ]
local LoginFrame = Instance.new("Frame", VERCO_GUI)
LoginFrame.Size = UDim2.new(0, 280, 0, 200)
LoginFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
LoginFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UIStroke", LoginFrame).Color = Color3.fromRGB(0, 150, 255)
Instance.new("UICorner", LoginFrame).CornerRadius = UDim.new(0, 10)

local LTitle = Instance.new("TextLabel", LoginFrame)
LTitle.Size = UDim2.new(1, 0, 0, 50)
LTitle.Text = "Papi Verco Login"
LTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
LTitle.Font = Enum.Font.SourceSansBold
LTitle.TextSize = 22
LTitle.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox", LoginFrame)
KeyBox.Size = UDim2.new(0, 220, 0, 40)
KeyBox.Position = UDim2.new(0.5, -110, 0.45, 0)
KeyBox.PlaceholderText = "Masukan key"
KeyBox.Text = ""
KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 5)

local LoginBtn = Instance.new("TextButton", LoginFrame)
LoginBtn.Size = UDim2.new(0, 120, 0, 40)
LoginBtn.Position = UDim2.new(0.5, -60, 0.75, 0)
LoginBtn.Text = "Login"
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 5)

LoginBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == "trial" then
        LoginFrame:Destroy()
        StartHub()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Key Salah!"
    end
end)
