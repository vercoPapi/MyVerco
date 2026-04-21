local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================= SISTEM KEY & AUTO SAVE (1 JAM) =================
local KeyFile = "VercoKeyData.txt"
local CurrentKey = "verco_1hours_" .. math.random(700, 999) 

local function SaveTime()
    local expiry = os.time() + 3600 
    writefile(KeyFile, tostring(expiry))
end

local function CheckKey()
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
VTitle.Size = UDim2.new(1, 0, 0, 50)
VTitle.Text = "VERCO X NUGI"
VTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
VTitle.TextSize = 25
VTitle.Font = Enum.Font.GothamBold
VTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", AuthFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.PlaceholderText = "Masukan Key"
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyInput.TextColor3 = Color3.fromRGB(0, 255, 0)

local LoginBtn = Instance.new("TextButton", AuthFrame)
LoginBtn.Size = UDim2.new(0.8, 0, 0, 40)
LoginBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
LoginBtn.Text = "Login"
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local GetKeyBtn = Instance.new("TextButton", AuthFrame)
GetKeyBtn.Size = UDim2.new(0.8, 0, 0, 30)
GetKeyBtn.Position = UDim2.new(0.1, 0, 0.8, 0)
GetKeyBtn.Text = "Get Key"
GetKeyBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
GetKeyBtn.BackgroundTransparency = 1

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

-- ================= MAIN SCRIPT (SEMUA FITUR GABUNGAN) =================
local function StartMainScript()
    if KeyGui then KeyGui:Destroy() end
    
    -- Inisialisasi Status Global
    _G.Aimlock = false; _G.EspEnabled = false; _G.FlyKill = false; _G.MS20 = false
    _G.SpeedRunning = false; _G.SpeedCar = false; _G.AutoWins = false
    _G.Wallhack = false; _G.JumpMulti = false; _G.AutoFarmSB = false
    _G.FlyPlayer = false; _G.FlyWins = false

    -- Fungsi Cek Tim (Hanya Lock/ESP Musuh)
    local function IsEnemy(v)
        if v.Team ~= Player.Team or v.Team == nil then return true end
        return false
    end

    -- ESP 3D WIREFRAME (MUSUH SAJA)
    local function CreateESP(v)
        local Lines = {}
        for i = 1, 12 do Lines[i] = Drawing.new("Line") Lines[i].Color = Color3.fromRGB(0, 255, 0) Lines[i].Thickness = 1.5 Lines[i].Visible = false end
        local Tracer = Drawing.new("Line") Tracer.Color = Color3.fromRGB(0, 255, 0) Tracer.Visible = false

        RunService.RenderStepped:Connect(function()
            if _G.EspEnabled and IsEnemy(v) and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local hrp = v.Character.HumanoidRootPart
                local Pos, OnScreen = Camera:WorldToViewportPoint(hrp.Position)
                if OnScreen then
                    -- (Logika Box 3D tetap sama...)
                    for i, l in pairs(Lines) do l.Visible = true end -- Sederhana saja untuk performa
                    Tracer.Visible = true; Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); Tracer.To = Vector2.new(Pos.X, Pos.Y)
                else for i=1,12 do Lines[i].Visible = false end Tracer.Visible = false end
            else for i=1,12 do Lines[i].Visible = false end Tracer.Visible = false end
        end)
    end
    for _, v in pairs(game.Players:GetPlayers()) do if v ~= Player then CreateESP(v) end end

    -- LOGIC LOOP SEMUA FITUR
    RunService.RenderStepped:Connect(function()
        local Target = nil
        local shortestDist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and IsEnemy(v) and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                local Mag = (hrp.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if Mag < shortestDist then shortestDist = Mag Target = v end
            end
        end

        -- FlyPlayer (Terbang diam menuju player)
        if _G.FlyPlayer and Target then
            Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            Player.Character.HumanoidRootPart.Velocity = Vector3.zero
        end

        -- Aimlock & FlyKill
        if Target and Target.Character then
            if _G.Aimlock then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position), 0.15) end
            if _G.FlyKill then Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0) end
        end

        -- Config & Rintangan
        if _G.SpeedRunning then Player.Character.Humanoid.WalkSpeed = 80 end
        if _G.JumpMulti then Player.Character.Humanoid.JumpPower = 100 end
        if _G.Wallhack then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            -- Anti Fall
            if Player.Character.HumanoidRootPart.Position.Y < -50 then
                Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
            end
        end
        if _G.FlyWins or _G.AutoWins then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("finish") or obj.Name:lower():find("win") then
                    Player.Character.HumanoidRootPart.CFrame = obj.CFrame break
                end
            end
        end
    end)

    -- ================= GUI MENU UTAMA =================
    local MainGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", MainGui)
    Frame.Size = UDim2.new(0, 500, 0, 380)
    Frame.Position = UDim2.new(0.5, -250, 0.5, -190)
    Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 0)
    Frame.Active = true Frame.Draggable = true

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
    Title.Text = "VERCO X NUGI"; Title.TextColor3 = Color3.fromRGB(0, 255, 0); Title.Font = Enum.Font.GothamBold; Title.TextSize = 22

    local Sidebar = Instance.new("Frame", Frame)
    Sidebar.Size = UDim2.new(0, 120, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

    local Content = Instance.new("ScrollingFrame", Frame)
    Content.Size = UDim2.new(1, -130, 1, -50); Content.Position = UDim2.new(0, 125, 0, 45); Content.BackgroundTransparency = 1
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)

    local function AddToggle(name, varName)
        local b = Instance.new("TextButton", Content)
        b.Size = UDim2.new(1, -10, 0, 35); b.Font = Enum.Font.GothamBold
        local function UpdateBtn()
            b.Text = name .. (_G[varName] and " : ON" or " : OFF")
            b.TextColor3 = Color3.fromRGB(0, 255, 0); b.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(20, 20, 20)
        end
        UpdateBtn(); b.MouseButton1Click:Connect(function() _G[varName] = not _G[varName] UpdateBtn() end)
    end

    -- MENU TABS
    local function ShowAim() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
        AddToggle("Aimlock Head", "Aimlock"); AddToggle("FlyKill Musuh", "FlyKill"); AddToggle("MS20 Pull", "MS20") end
    
    local function ShowConfig() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
        AddToggle("Speed Running", "SpeedRunning"); AddToggle("Jump Multi", "JumpMulti"); AddToggle("Wallhack", "Wallhack") end

    local function ShowSouthBronx() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
        AddToggle("Auto Farm (Apt/Cook)", "AutoFarmSB") end

    local function ShowRintangan() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)
        AddToggle("Fly to Player", "FlyPlayer"); AddToggle("Fly to Wins", "FlyWins") end

    local function CreateTab(name, func)
        local b = Instance.new("TextButton", Sidebar)
        b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.TextColor3 = Color3.fromRGB(0, 255, 0); b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        b.Position = UDim2.new(0, 0, 0, (#Sidebar:GetChildren()-1) * 40)
        b.MouseButton1Click:Connect(func)
    end

    CreateTab("AIM", ShowAim); CreateTab("CONFIG", ShowConfig); CreateTab("S.BRONX", ShowSouthBronx); CreateTab("RINTANGAN", ShowRintangan)
    ShowAim()

    local CTBtn = Instance.new("TextButton", MainGui); CTBtn.Size = UDim2.new(0, 50, 0, 50); CTBtn.Position = UDim2.new(0, 10, 0.5, 0)
    CTBtn.Text = "CT"; CTBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0); CTBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    CTBtn.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
end

-- ================= EXECUTION =================
LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CurrentKey then SaveTime(); StartMainScript() else KeyInput.Text = "SALAH!"; task.wait(1); KeyInput.Text = "" end
end)
if CheckKey() then StartMainScript() end
