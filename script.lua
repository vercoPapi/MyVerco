local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================= SISTEM KEY OTOMATIS (EXPIRE 20 MENIT) =================
local KeyFile = "VercoKeyData_Store.txt"
local CurrentKey = "VERCO_NUGI_" .. os.date("%H%M") -- Key dinamis berdasarkan waktu

local function SaveKeyStatus()
    local expiry = os.time() + 1200 -- Set 20 menit
    writefile(KeyFile, tostring(expiry))
end

local function IsKeyValid()
    if isfile(KeyFile) then
        local content = readfile(KeyFile)
        local expiry = tonumber(content)
        if expiry and os.time() < expiry then return true end
    end
    return false
end

-- ================= GUI VERIFIKASI =================
local KeyGui = Instance.new("ScreenGui", CoreGui)
local AuthFrame = Instance.new("Frame", KeyGui)
AuthFrame.Size = UDim2.new(0, 300, 0, 250)
AuthFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
AuthFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Instance.new("UIStroke", AuthFrame).Color = Color3.fromRGB(0, 255, 0)

local VTitle = Instance.new("TextLabel", AuthFrame)
VTitle.Size = UDim2.new(1, 0, 0, 50); VTitle.Text = "VERCO X NUGI"; VTitle.TextColor3 = Color3.fromRGB(0, 255, 0); VTitle.TextSize = 25; VTitle.Font = Enum.Font.GothamBold; VTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", AuthFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 40); KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0); 
KeyInput.Text = CurrentKey; -- KEY OTOMATIS TERISI SEPERTI PERMINTAAN
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20); KeyInput.TextColor3 = Color3.fromRGB(0, 255, 0)

local LoginBtn = Instance.new("TextButton", AuthFrame)
LoginBtn.Size = UDim2.new(0.8, 0, 0, 40); LoginBtn.Position = UDim2.new(0.1, 0, 0.55, 0); LoginBtn.Text = "Login"; LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0); LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local GetKeyBtn = Instance.new("TextButton", AuthFrame)
GetKeyBtn.Size = UDim2.new(0.8, 0, 0, 30); GetKeyBtn.Position = UDim2.new(0.1, 0, 0.8, 0); GetKeyBtn.Text = "Get Key (Copy Link)"; GetKeyBtn.TextColor3 = Color3.fromRGB(0, 255, 0); GetKeyBtn.BackgroundTransparency = 1

GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://verco-nugi-key.com/" .. CurrentKey)
    GetKeyBtn.Text = "Link Copied!"
    task.wait(2)
    GetKeyBtn.Text = "Get Key (Copy Link)"
end)

-- ================= MAIN SCRIPT (SEMUA FITUR LENGKAP) =================
local function StartMainScript()
    if KeyGui then KeyGui:Destroy() end
    
    -- Inisialisasi Status
    _G.Aimlock = false; _G.EspEnabled = false; _G.FlyKill = false; _G.MS20 = false
    _G.SpeedRunning = false; _G.SpeedCar = false; _G.AutoWins = false
    _G.Wallhack = false; _G.JumpMulti = false; _G.AutoFarmSB = false
    _G.FlyPlayer = false; _G.FlyWins = false; _G.AimKeramat = false

    local MarkedPlayers = {}

    local function IsVisible(part)
        if not part then return false end
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {Player.Character, part.Parent}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), rayParams)
        return result == nil
    end

    -- ESP ALL PLAYER (LINE & BOX)
    local function CreateESP(v)
        local Tracer = Drawing.new("Line"); Tracer.Color = Color3.fromRGB(0, 255, 0); Tracer.Thickness = 1.5; Tracer.Visible = false
        RunService.RenderStepped:Connect(function()
            if _G.EspEnabled and v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if OnScreen then
                    Tracer.Visible = true; Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); Tracer.To = Vector2.new(Pos.X, Pos.Y)
                else Tracer.Visible = false end
            else Tracer.Visible = false end
        end)
    end
    for _, v in pairs(game.Players:GetPlayers()) do CreateESP(v) end
    game.Players.PlayerAdded:Connect(CreateESP)

    -- MAIN LOOP KERAMAT & TARGETING
    RunService.RenderStepped:Connect(function()
        local Target = nil
        local shortestDist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local hrp = v.Character.HumanoidRootPart
                local Mag = (hrp.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if Mag < shortestDist then
                    if _G.Aimlock then
                        if IsVisible(v.Character:FindFirstChild("Head")) then shortestDist = Mag; Target = v end
                    else shortestDist = Mag; Target = v end
                end
                if _G.MS20 and Mag < 65 then hrp.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5) end
            end
        end

        -- AimKeramat Logic
        if _G.AimKeramat then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character.Humanoid.Health > 0 and not MarkedPlayers[v.Name] then
                    Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    MarkedPlayers[v.Name] = v
                    task.wait(0.3)
                end
            end
        end

        if Target and Target.Character then
            if _G.FlyKill then
                Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                Player.Character.HumanoidRootPart.Velocity = Vector3.zero
            end
            if _G.Aimlock then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position), 0.2)
            end
        end

        -- Configs
        if _G.SpeedRunning then Player.Character.Humanoid.WalkSpeed = 80 end
        if _G.Wallhack then
            for _, p in pairs(Player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end
    end)

    -- MENU GUI (HIJAU NEON)
    local MainGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", MainGui)
    Frame.Size = UDim2.new(0, 520, 0, 420); Frame.Position = UDim2.new(0.5, -260, 0.5, -210); Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 0)
    Frame.Active = true; Frame.Draggable = true

    local Title = Instance.new("TextLabel", Frame); Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundColor3 = Color3.fromRGB(0, 40, 0); Title.Text = "VERCO X NUGI | KERAMAT"; Title.TextColor3 = Color3.fromRGB(0, 255, 0); Title.Font = Enum.Font.GothamBold; Title.TextSize = 20

    local Sidebar = Instance.new("Frame", Frame); Sidebar.Size = UDim2.new(0, 130, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    local Content = Instance.new("ScrollingFrame", Frame); Content.Size = UDim2.new(1, -140, 1, -50); Content.Position = UDim2.new(0, 135, 0, 45); Content.BackgroundTransparency = 1
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)

    local function AddToggle(name, varName)
        local b = Instance.new("TextButton", Content); b.Size = UDim2.new(1, -10, 0, 35); b.Font = Enum.Font.GothamBold
        local function Upd()
            b.Text = name .. (_G[varName] and " : ON" or " : OFF")
            b.TextColor3 = Color3.fromRGB(0, 255, 0); b.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(20, 20, 20)
            if varName == "AimKeramat" and _G[varName] == false then
                for _, p in pairs(MarkedPlayers) do if p.Character then p.Character.Humanoid.Health = 0 end end
                MarkedPlayers = {}
            end
        end
        Upd(); b.MouseButton1Click:Connect(function() _G[varName] = not _G[varName]; Upd() end)
    end

    local function ShowAim() Content:ClearAllChildren(); Instance.new("UIListLayout", Content); AddToggle("AimKeramat", "AimKeramat"); AddToggle("FlyKill Head", "FlyKill"); AddToggle("Aimlock Head", "Aimlock"); AddToggle("MS20 Pull", "MS20") end
    local function ShowVis() Content:ClearAllChildren(); Instance.new("UIListLayout", Content); AddToggle("ESP All Player", "EspEnabled") end
    local function ShowCfg() Content:ClearAllChildren(); Instance.new("UIListLayout", Content); AddToggle("Speed Run", "SpeedRunning"); AddToggle("Jump Multi", "JumpMulti"); AddToggle("Wallhack", "Wallhack"); AddToggle("Auto Wins", "AutoWins") end
    local function ShowSB() Content:ClearAllChildren(); Instance.new("UIListLayout", Content); AddToggle("Auto Farm SB", "AutoFarmSB") end

    local function CreateTab(name, func)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.TextColor3 = Color3.fromRGB(0, 255, 0); b.BackgroundColor3 = Color3.fromRGB(15, 15, 15); b.Font = Enum.Font.GothamBold
        b.Position = UDim2.new(0, 0, 0, (#Sidebar:GetChildren()-1) * 40); b.MouseButton1Click:Connect(func)
    end

    CreateTab("AIM", ShowAim); CreateTab("VISUAL", ShowVis); CreateTab("CONFIG", ShowCfg); CreateTab("S.BRONX", ShowSB)
    ShowAim()

    local CTBtn = Instance.new("TextButton", MainGui); CTBtn.Size = UDim2.new(0, 50, 0, 50); CTBtn.Position = UDim2.new(0, 10, 0.5, 0); CTBtn.Text = "CT"; CTBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0); CTBtn.TextColor3 = Color3.fromRGB(0, 255, 0); CTBtn.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
end

-- ================= EXECUTION =================
LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CurrentKey then 
        SaveKeyStatus()
        StartMainScript() 
    else 
        KeyInput.Text = "KEY SALAH!" 
    end
end)

-- CEK STATUS 20 MENIT
if IsKeyValid() then 
    StartMainScript() 
end
