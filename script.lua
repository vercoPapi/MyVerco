local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================= SISTEM KEY & TIME (AUTO SAVE) =================
local KeyFile = "VercoKeyData.txt"
local CurrentKey = "verco_1hours_" .. math.random(100, 999) -- Key acak sistem

local function SaveTime()
    local expiry = os.time() + 3600 -- 1 jam dari sekarang
    writefile(KeyFile, tostring(expiry))
end

local function CheckKey()
    if isfile(KeyFile) then
        local content = readfile(KeyFile)
        local expiry = tonumber(content)
        if expiry and os.time() < expiry then
            return true -- Masih dalam masa berlaku
        end
    end
    return false
end

-- ================= GUI VERIFIKASI =================
local KeyGui = Instance.new("ScreenGui", CoreGui)
KeyGui.Name = "VercoAuth"

local AuthFrame = Instance.new("Frame", KeyGui)
AuthFrame.Size = UDim2.new(0, 300, 0, 250)
AuthFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
AuthFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UIStroke", AuthFrame).Color = Color3.fromRGB(0, 255, 0)

local VTitle = Instance.new("TextLabel", AuthFrame)
VTitle.Size = UDim2.new(1, 0, 0, 50)
VTitle.Text = "Verco"
VTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
VTitle.TextSize = 25
VTitle.Font = Enum.Font.GothamBold
VTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", AuthFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.PlaceholderText = "Masukan Key"
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local LoginBtn = Instance.new("TextButton", AuthFrame)
LoginBtn.Size = UDim2.new(0.8, 0, 0, 40)
LoginBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
LoginBtn.Text = "Login"
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
LoginBtn.TextColor3 = Color3.new(1, 1, 1)

local GetKeyBtn = Instance.new("TextButton", AuthFrame)
GetKeyBtn.Size = UDim2.new(0.8, 0, 0, 30)
GetKeyBtn.Position = UDim2.new(0.1, 0, 0.8, 0)
GetKeyBtn.Text = "Get Key"
GetKeyBtn.BackgroundTransparency = 1
GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)

-- ================= LOGIC KEY =================
GetKeyBtn.MouseButton1Click:Connect(function()
    for i = 10, 1, -1 do
        GetKeyBtn.Text = "Wait.. (" .. i .. ")"
        task.wait(1)
    end
    setclipboard(CurrentKey)
    GetKeyBtn.Text = "Key Copied!"
    task.wait(2)
    GetKeyBtn.Text = "Get Key"
end)

-- ================= MAIN SCRIPT (DIJALANKAN SETELAH LOGIN) =================
local function StartMainScript()
    KeyGui:Destroy()
    
    -- Variabel Global
    _G.SpeedRunning = false
    _G.SpeedCar = false
    _G.AutoWins = false
    _G.EspEnabled = false
    _G.FlyKill = false

    -- GUI UTAMA
    local MainGui = Instance.new("ScreenGui", CoreGui)
    MainGui.Name = "VercoUltimate"
    local Frame = Instance.new("Frame", MainGui)
    Frame.Size = UDim2.new(0, 480, 0, 350)
    Frame.Position = UDim2.new(0.5, -240, 0.5, -175)
    Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Frame.Visible = true Frame.Active = true Frame.Draggable = true
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 0)

    local Sidebar = Instance.new("Frame", Frame)
    Sidebar.Size = UDim2.new(0, 110, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

    local Content = Instance.new("ScrollingFrame", Frame)
    Content.Size = UDim2.new(1, -120, 1, -50)
    Content.Position = UDim2.new(0, 115, 0, 45)
    Content.BackgroundTransparency = 1
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)

    local function AddToggle(name, varName, callback)
        local b = Instance.new("TextButton", Content)
        b.Size = UDim2.new(1, -10, 0, 40)
        b.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(30, 30, 30)
        b.Text = name .. (_G[varName] and " : ON" or " : OFF")
        b.TextColor3 = Color3.fromRGB(0, 255, 0)
        b.Font = Enum.Font.GothamBold
        b.MouseButton1Click:Connect(function()
            _G[varName] = not _G[varName]
            b.Text = name .. (_G[varName] and " : ON" or " : OFF")
            b.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(30, 30, 30)
            if callback then callback(_G[varName]) end
        end)
    end

    -- TAB CONFIG
    local function ShowConfig()
        Content:ClearAllChildren()
        Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
        
        AddToggle("Speed Running (5x)", "SpeedRunning", function(v)
            Player.Character.Humanoid.WalkSpeed = v and 80 or 16
        end)

        AddToggle("Speed Car/Motor", "SpeedCar", function(v)
            RunService.Stepped:Connect(function()
                if _G.SpeedCar and Player.Character.Humanoid.SeatPart then
                    Player.Character.Humanoid.SeatPart.AssemblyLinearVelocity *= 1.2 -- Percepat 20% setiap frame
                end
            end)
        end)

        AddToggle("Auto Wins (Teleport)", "AutoWins", function(v)
            if v then
                -- Mencari objek bernama "Finish" atau "Win" di map
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("finish") or obj.Name:lower():find("win") then
                        Player.Character.HumanoidRootPart.CFrame = obj.CFrame
                        break
                    end
                end
            end
        end)
    end

    -- Tab visual & Aim (Masih sama dengan sebelumnya)
    local function ShowAim()
        Content:ClearAllChildren()
        Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
        AddToggle("Aimlock Head", "Aimlock")
        AddToggle("FlyKill", "FlyKill")
    end

    local function CreateTab(name, func)
        local b = Instance.new("TextButton", Sidebar)
        b.Size = UDim2.new(1, 0, 0, 45)
        b.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
        b.Text = name
        b.TextColor3 = Color3.new(1,1,1)
        b.Position = UDim2.new(0, 0, 0, (#Sidebar:GetChildren()-1) * 45)
        b.MouseButton1Click:Connect(func)
    end

    CreateTab("CONFIG", ShowConfig)
    CreateTab("AIM", ShowAim)
    ShowConfig()
    
    -- Floating Icon CT
    local CTBtn = Instance.new("TextButton", MainGui)
    CTBtn.Size = UDim2.new(0, 50, 0, 50)
    CTBtn.Position = UDim2.new(0, 10, 0.5, 0)
    CTBtn.Text = "CT"
    CTBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
    CTBtn.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
end

-- ================= EXECUTION =================
LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CurrentKey then
        SaveTime()
        StartMainScript()
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "KEY SALAH!"
    end
end)

-- Cek jika sudah pernah login (Auto Login)
if CheckKey() then
    StartMainScript()
end
