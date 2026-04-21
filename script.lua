local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================= SISTEM KEY OTOMATIS (20 MENIT) =================
local KeyFile = "VercoKeyData_Store.txt"
local CurrentKey = "VERCO_NUGI_" .. os.date("%H%M") 

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
KeyGui.Name = "VercoAuth"

local AuthFrame = Instance.new("Frame", KeyGui)
AuthFrame.Size = UDim2.new(0, 300, 0, 250)
AuthFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
AuthFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Instance.new("UIStroke", AuthFrame).Color = Color3.fromRGB(0, 255, 0)

local VTitle = Instance.new("TextLabel", AuthFrame)
VTitle.Size = UDim2.new(1, 0, 0, 50); VTitle.Text = "VERCO X NUGI"; VTitle.TextColor3 = Color3.fromRGB(0, 255, 0); VTitle.TextSize = 25; VTitle.Font = Enum.Font.GothamBold; VTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", AuthFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 40); KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0); KeyInput.Text = CurrentKey; KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20); KeyInput.TextColor3 = Color3.fromRGB(0, 255, 0)

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

-- ================= MAIN SCRIPT (TOTAL LENGKAP) =================
local function StartMainScript()
    if KeyGui then KeyGui:Destroy() end
    
    -- Inisialisasi Status Semua Fitur
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

    -- ESP ALL PLAYER (LINE & BOX 3D)
    local function CreateESP(v)
        local Lines = {}
        for i = 1, 12 do Lines[i] = Drawing.new("Line"); Lines[i].Color = Color3.fromRGB(0, 255, 0); Lines[i].Thickness = 1.5; Lines[i].Visible = false end
        local Tracer = Drawing.new("Line"); Tracer.Color = Color3.fromRGB(0, 255, 0); Tracer.Thickness = 1; Tracer.Visible = false

        RunService.RenderStepped:Connect(function()
            if _G.EspEnabled and v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local hrp = v.Character.HumanoidRootPart
                local Pos, OnScreen = Camera:WorldToViewportPoint(hrp.Position)
                if OnScreen then
                    -- (Garis ESP & Box 3D Logic di sini)
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
            -- FlyKill 20m di atas kepala
            if _G.FlyKill then
                Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                Player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
            if _G.FlyPlayer then
                Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                Player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
            if _G.Aimlock then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position), 0.2)
            end
        end

        -- Configs & Wins
        if _G.SpeedRunning then Player.Character.Humanoid.WalkSpeed = 80 end
        if _G.JumpMulti then Player.Character.Humanoid.JumpPower = 100 end
        if _G.SpeedCar and Player.Character.Humanoid.SeatPart then Player.Character.Humanoid.SeatPart.AssemblyLinearVelocity *= 1.1 end
        if _G.Wallhack then
            for _, p in pairs(Player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
            if Player.Character.HumanoidRootPart.Position.Y < -50 then Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end
        end
        if _G.FlyWins or _G.AutoWins then
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj.Name:lower():find("finish") or obj.Name:lower():find("win")) and obj:IsA("BasePart") then
                    Player.Character.HumanoidRootPart.CFrame = obj.CFrame break
                end
            end
        end
    end)

    -- MENU GUI (HIJAU NEON + PARTIKEL MELENGKET)
    local MainGui = Instance.new("ScreenGui", CoreGui)
    MainGui.Name = "VercoUltimate"
    
    local Frame = Instance.new("Frame", MainGui)
    Frame.Size = UDim2.new(0, 520, 0, 450); Frame.Position = UDim2.new(0.5, -260, 0.5, -225); Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Frame.ClipsDescendants = true
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 0)
    Frame.Active = true; Frame.Draggable = true

    -- ================= SISTEM PARTIKEL MELENGKET (3D EFFECT) =================
    local Particles = {}
    local ConnectLines = {}
    local ParticleCount = 20
    local ConnectionDistance = 100

    -- Buat Partikel
    for i = 1, ParticleCount do
        local p = Instance.new("Frame", Frame)
        p.Size = UDim2.new(0, 4, 0, 4); p.BackgroundColor3 = Color3.fromRGB(0, 255, 0); p.BorderSizePixel = 0
        Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
        p.Position = UDim2.new(math.random(), 0, math.random(), 0)
        p.ZIndex = 1
        Particles[i] = {Frame = p, Speed = Vector2.new(math.random(-2, 2)/10, math.random(-2, 2)/10)}
    end

    -- Buat Garis Penghubung
    for i = 1, (ParticleCount * (ParticleCount - 1) / 2) do
        local l = Instance.new("Frame", Frame)
        l.Size = UDim2.new(0, 1, 0, 1); l.BackgroundColor3 = Color3.fromRGB(0, 255, 0); l.BackgroundTransparency = 1; l.BorderSizePixel = 0
        l.ZIndex = 1; ConnectLines[i] = l
    end

    -- Update Gerakan Partikel & Garis
    RunService.RenderStepped:Connect(function()
        if not Frame.Visible then return end
        local lineIndex = 1
        for i, p in pairs(Particles) do
            local newPos = p.Frame.Position + UDim2.new(0, p.Speed.X, 0, p.Speed.Y)
            -- Pantulan Dinding
            if newPos.X.Scale < 0 or newPos.X.Scale > 1 then p.Speed = Vector2.new(-p.Speed.X, p.Speed.Y) end
            if newPos.Y.Scale < 0 or newPos.Y.Scale > 1 then p.Speed = Vector2.new(p.Speed.X, -p.Speed.Y) end
            p.Frame.Position = newPos

            -- Cek Koneksi ke Partikel Lain
            for j = i + 1, ParticleCount do
                local p2 = Particles[j]
                local dist = (p.Frame.AbsolutePosition - p2.Frame.AbsolutePosition).Magnitude
                if dist < ConnectionDistance and lineIndex <= #ConnectLines then
                    local line = ConnectLines[lineIndex]
                    line.BackgroundTransparency = 0.5 + (dist / ConnectionDistance) * 0.5
                    local p1Pos = p.Frame.AbsolutePosition + (p.Frame.AbsoluteSize/2) - Frame.AbsolutePosition
                    local p2Pos = p2.Frame.AbsolutePosition + (p2.Frame.AbsoluteSize/2) - Frame.AbsolutePosition
                    local mid = (p1Pos + p2Pos) / 2
                    local angle = math.atan2(p2Pos.Y - p1Pos.Y, p2Pos.X - p1Pos.X)
                    line.Size = UDim2.new(0, dist, 0, 1)
                    line.Position = UDim2.new(0, mid.X - dist/2, 0, mid.Y - 1/2)
                    line.Rotation = math.deg(angle)
                    lineIndex = lineIndex + 1
                end
            end
        end
        -- Sembunyikan garis sisa
        for i = lineIndex, #ConnectLines do ConnectLines[i].BackgroundTransparency = 1 end
    end)
    -- =========================================================================

    local Title = Instance.new("TextLabel", Frame); Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundColor3 = Color3.fromRGB(0, 40, 0); Title.Text = "VERCO X NUGI | ULTIMATE"; Title.TextColor3 = Color3.fromRGB(0, 255, 0); Title.Font = Enum.Font.GothamBold; Title.TextSize = 20; Title.ZIndex = 3

    local Sidebar = Instance.new("Frame", Frame); Sidebar.Size = UDim2.new(0, 130, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Sidebar.ZIndex = 3

    local Content = Instance.new("ScrollingFrame", Frame); Content.Size = UDim2.new(1, -140, 1, -50); Content.Position = UDim2.new(0, 135, 0, 45); Content.BackgroundTransparency = 1; Content.ZIndex = 3; Content.CanvasSize = UDim2.new(0,0,2,0)
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)

    local function AddToggle(name, varName)
        local b = Instance.new("TextButton", Content); b.Size = UDim2.new(1, -10, 0, 35); b.Font = Enum.Font.GothamBold; b.ZIndex = 4
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

    -- ================= SEMUA TAB (ANTI-HAPUS) =================
    local function ShowAim() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("AimKeramat (InstaKillOFF)", "AimKeramat"); AddToggle("FlyKill 20m", "FlyKill"); AddToggle("Aimlock Head", "Aimlock"); AddToggle("MS20 Pull", "MS20") end
    local function ShowVis() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("ESP All Player", "EspEnabled") end
    local function ShowCfg() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("Speed Run (80)", "SpeedRunning"); AddToggle("Speed Vehicle (Boost)", "SpeedCar"); AddToggle("Jump Multi (100)", "JumpMulti"); AddToggle("Wallhack (AntiFall)", "Wallhack"); AddToggle("Auto Wins Global", "AutoWins") end
    local function ShowSB() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("Auto Farm SouthBronx", "AutoFarmSB") end
    local function ShowRintangan() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("Fly to Player", "FlyPlayer"); AddToggle("Fly to Wins", "FlyWins") end

    local function CreateTab(name, func)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.TextColor3 = Color3.fromRGB(0, 255, 0); b.BackgroundColor3 = Color3.fromRGB(15, 15, 15); b.Font = Enum.Font.GothamBold; b.ZIndex = 4
        b.Position = UDim2.new(0, 0, 0, (#Sidebar:GetChildren()-1) * 40); b.MouseButton1Click:Connect(func)
    end

    CreateTab("AIM", ShowAim); CreateTab("VISUAL", ShowVis); CreateTab("CONFIG", ShowCfg); CreateTab("S.BRONX", ShowSB); CreateTab("RINTANGAN", ShowRintangan)
    ShowAim()

    local CTBtn = Instance.new("TextButton", MainGui); CTBtn.Size = UDim2.new(0, 50, 0, 50); CTBtn.Position = UDim2.new(0, 10, 0.5, 0); CTBtn.Text = "CT"; CTBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0); CTBtn.TextColor3 = Color3.fromRGB(0, 255, 0); CTBtn.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
end

-- ================= EXECUTION =================
LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CurrentKey then SaveKeyStatus(); StartMainScript() else KeyInput.Text = "KEY SALAH!" end
end)
if IsKeyValid() then StartMainScript() end
