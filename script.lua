local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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

-- ================= MAIN SCRIPT (FULL FEATURES) =================
local function StartMainScript()
    if KeyGui then KeyGui:Destroy() end
    
    -- Inisialisasi Status (Hanya jika belum ada)
    _G.Aimlock = _G.Aimlock or false
    _G.EspEnabled = _G.EspEnabled or false
    _G.FlyKill = _G.FlyKill or false
    _G.MS20 = _G.MS20 or false
    _G.SpeedRunning = _G.SpeedRunning or false
    _G.SpeedCar = _G.SpeedCar or false
    _G.AutoWins = _G.AutoWins or false

    local function IsVisible(part)
        local char = Player.Character
        if not char then return false end
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char, part.Parent}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), rayParams)
        return result == nil
    end

    -- ESP 3D WIREFRAME
    local function CreateESP(v)
        local Lines = {}
        for i = 1, 12 do Lines[i] = Drawing.new("Line") Lines[i].Color = Color3.fromRGB(0, 255, 0) Lines[i].Thickness = 1.5 Lines[i].Visible = false end
        local Tracer = Drawing.new("Line") Tracer.Color = Color3.fromRGB(0, 255, 0) Tracer.Visible = false

        RunService.RenderStepped:Connect(function()
            if _G.EspEnabled and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local Pos, OnScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if OnScreen then
                        local size = Vector3.new(4, 5, 2)
                        local cf = hrp.CFrame
                        local vts = {
                            Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, size.Y/2, size.Z/2)).Position),
                            Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2)).Position),
                            Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2)).Position),
                            Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2)).Position),
                            Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2)).Position),
                            Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2)).Position),
                            Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)).Position),
                            Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2)).Position),
                        }
                        local con = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
                        for i, c in pairs(con) do Lines[i].Visible = true Lines[i].From = Vector2.new(vts[c[1]].X, vts[c[1]].Y) Lines[i].To = Vector2.new(vts[c[2]].X, vts[c[2]].Y) end
                        Tracer.Visible = true Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y) Tracer.To = Vector2.new(Pos.X, Pos.Y)
                    else for i=1,12 do Lines[i].Visible = false end Tracer.Visible = false end
                end
            else for i=1,12 do Lines[i].Visible = false end Tracer.Visible = false end
        end)
    end
    for _, v in pairs(game.Players:GetPlayers()) do if v ~= Player then CreateESP(v) end end
    game.Players.PlayerAdded:Connect(function(v) if v ~= Player then CreateESP(v) end end)

    -- LOGIC LOOP
    RunService.RenderStepped:Connect(function()
        local Target = nil
        local shortestDist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local Mag = (hrp.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                    if Mag < shortestDist then
                        if _G.FlyKill or IsVisible(v.Character.Head) then shortestDist = Mag Target = v end
                    end
                    if _G.MS20 and Mag < 65 then hrp.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5) end
                end
            end
        end
        if Target and Target.Character then
            if _G.Aimlock then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position), 0.15) end
            if _G.FlyKill then Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0) end
        end
        if _G.SpeedRunning then Player.Character.Humanoid.WalkSpeed = 80 end
        if _G.SpeedCar and Player.Character.Humanoid.SeatPart then Player.Character.Humanoid.SeatPart.AssemblyLinearVelocity *= 1.1 end
        if _G.AutoWins then
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj.Name:lower():find("finish") or obj.Name:lower():find("win")) and obj:IsA("BasePart") then
                    Player.Character.HumanoidRootPart.CFrame = obj.CFrame break
                end
            end
        end
    end)

    -- GUI MENU UTAMA
    local MainGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", MainGui)
    Frame.Size = UDim2.new(0, 480, 0, 350)
    Frame.Position = UDim2.new(0.5, -240, 0.5, -175)
    Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Frame.ClipsDescendants = true
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 0)
    Frame.Active = true Frame.Draggable = true

    -- Partikel Hijau Latar Belakang
    for i = 1, 15 do
        local p = Instance.new("Frame", Frame)
        p.Size = UDim2.new(0, 2, 0, 2)
        p.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        local function anim()
            p.Position = UDim2.new(math.random(), 0, 1.1, 0)
            game:GetService("TweenService"):Create(p, TweenInfo.new(math.random(5,10)), {Position = UDim2.new(math.random(), 0, -0.1, 0)}):Play()
            task.delay(10, anim)
        end
        anim()
    end

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
    Title.Text = "VERCO X NUGI"
    Title.TextColor3 = Color3.fromRGB(0, 255, 0)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20

    local Sidebar = Instance.new("Frame", Frame)
    Sidebar.Size = UDim2.new(0, 110, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

    local Content = Instance.new("ScrollingFrame", Frame)
    Content.Size = UDim2.new(1, -120, 1, -50)
    Content.Position = UDim2.new(0, 115, 0, 45)
    Content.BackgroundTransparency = 1
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)

    -- FUNGSI TOGGLE YANG BISA DI-ON-KAN DENGAN WARNA HIJAU JELAS
    local function AddToggle(name, varName)
        local b = Instance.new("TextButton", Content)
        b.Size = UDim2.new(1, -10, 0, 40)
        b.Font = Enum.Font.GothamBold
        
        local function UpdateBtn()
            local status = _G[varName]
            b.Text = name .. (status and " : ON" or " : OFF")
            b.TextColor3 = Color3.fromRGB(0, 255, 0) -- TULISAN TETAP HIJAU MENYALA
            b.BackgroundColor3 = status and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(25, 25, 25)
            if varName == "SpeedRunning" and not status then Player.Character.Humanoid.WalkSpeed = 16 end
        end

        UpdateBtn()
        b.MouseButton1Click:Connect(function()
            _G[varName] = not _G[varName]
            UpdateBtn()
        end)
    end

    local function ShowAim() Content:ClearAllChildren() Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5) AddToggle("Aimlock Head", "Aimlock") AddToggle("FlyKill Target", "FlyKill") AddToggle("MS20 Pull", "MS20") end
    local function ShowVisual() Content:ClearAllChildren() Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5) AddToggle("ESP 3D Wireframe", "EspEnabled") end
    local function ShowConfig() Content:ClearAllChildren() Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5) AddToggle("Speed Running", "SpeedRunning") AddToggle("Speed Vehicle", "SpeedCar") AddToggle("Auto Wins", "AutoWins") end

    local function CreateTab(name, func)
        local b = Instance.new("TextButton", Sidebar)
        b.Size = UDim2.new(1, 0, 0, 45)
        b.Text = name
        b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        b.TextColor3 = Color3.fromRGB(0, 255, 0) -- TULISAN MENU HIJAU
        b.Font = Enum.Font.GothamBold
        b.Position = UDim2.new(0, 0, 0, (#Sidebar:GetChildren()-1) * 45)
        b.MouseButton1Click:Connect(func)
    end

    CreateTab("AIM", ShowAim) CreateTab("VISUAL", ShowVisual) CreateTab("CONFIG", ShowConfig)
    ShowAim()

    local CTBtn = Instance.new("TextButton", MainGui)
    CTBtn.Size = UDim2.new(0, 50, 0, 50)
    CTBtn.Position = UDim2.new(0, 10, 0.5, 0)
    CTBtn.Text = "CT"
    CTBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
    CTBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    CTBtn.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
end

-- ================= EXECUTION =================
LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CurrentKey then SaveTime() StartMainScript() else KeyInput.Text = "WRONG KEY!" end
end)

if CheckKey() then StartMainScript() end
