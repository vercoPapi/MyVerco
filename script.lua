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
GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
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

-- ================= MAIN SCRIPT (SEMUA FITUR LENGKAP) =================
local function StartMainScript()
    if KeyGui then KeyGui:Destroy() end
    
    -- Status Fitur (Variabel Global)
    _G.Aimlock = false
    _G.EspEnabled = false
    _G.FlyKill = false
    _G.MS20 = false
    _G.SpeedRunning = false
    _G.SpeedCar = false
    _G.AutoWins = false

    -- Fungsi Wall Check agar Aimlock tidak tembus tembok
    local function IsVisible(part)
        local char = Player.Character
        if not char then return false end
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char, part.Parent}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), rayParams)
        return result == nil
    end

    -- ================= SISTEM ESP 3D WIREFRAME =================
    local function CreateESP(v)
        local Lines = {}
        for i = 1, 12 do
            Lines[i] = Drawing.new("Line")
            Lines[i].Color = Color3.fromRGB(255, 0, 0)
            Lines[i].Thickness = 1.5
            Lines[i].Visible = false
        end
        local Tracer = Drawing.new("Line")
        Tracer.Color = Color3.fromRGB(255, 0, 0)
        Tracer.Visible = false

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
                        for i, c in pairs(con) do
                            Lines[i].Visible = true
                            Lines[i].From = Vector2.new(vts[c[1]].X, vts[c[1]].Y)
                            Lines[i].To = Vector2.new(vts[c[2]].X, vts[c[2]].Y)
                        end
                        Tracer.Visible = true
                        Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        Tracer.To = Vector2.new(Pos.X, Pos.Y)
                    else for i=1,12 do Lines[i].Visible = false end Tracer.Visible = false end
                end
            else for i=1,12 do Lines[i].Visible = false end Tracer.Visible = false end
        end)
    end
    for _, v in pairs(game.Players:GetPlayers()) do if v ~= Player then CreateESP(v) end end
    game.Players.PlayerAdded:Connect(function(v) if v ~= Player then CreateESP(v) end end)

    -- ================= LOGIC SEMUA FITUR =================
    RunService.RenderStepped:Connect(function()
        local Target = nil
        local shortestDist = math.huge
        
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local Mag = (hrp.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                    if Mag < shortestDist then
                        -- FlyKill & Aimlock Target Logic
                        if _G.FlyKill or IsVisible(v.Character.Head) then
                            shortestDist = Mag
                            Target = v
                        end
                    end
                    -- MS20 Pull
                    if _G.MS20 and Mag < 65 then
                        hrp.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    end
                end
            end
        end

        -- FlyKill & Aimlock Action
        if Target and Target.Character then
            if _G.Aimlock then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position), 0.15)
            end
            if _G.FlyKill then
                Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
            end
        end

        -- Config Features
        if _G.SpeedRunning and Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 80
        end
        if _G.SpeedCar and Player.Character.Humanoid.SeatPart then
            Player.Character.Humanoid.SeatPart.AssemblyLinearVelocity *= 1.1
        end
        if _G.AutoWins then
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj.Name:lower():find("finish") or obj.Name:lower():find("win")) and obj:IsA("BasePart") then
                    Player.Character.HumanoidRootPart.CFrame = obj.CFrame
                    break
                end
            end
        end
    end)

    -- ================= GUI MENU DENGAN PARTIKEL HIJAU =================
    local MainGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", MainGui)
    Frame.Size = UDim2.new(0, 480, 0, 350)
    Frame.Position = UDim2.new(0.5, -240, 0.5, -175)
    Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Frame.ClipsDescendants = true
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 0)
    Frame.Active = true Frame.Draggable = true

    -- Efek Partikel Background (Hijau Bergerak)
    for i = 1, 15 do
        local p = Instance.new("Frame", Frame)
        p.Size = UDim2.new(0, 2, 0, 2)
        p.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        p.BackgroundTransparency = 0.5
        local function anim()
            p.Position = UDim2.new(math.random(), 0, 1.1, 0)
            local speed = math.random(5, 10)
            local t = game:GetService("TweenService"):Create(p, TweenInfo.new(speed, Enum.EasingStyle.Linear), {Position = UDim2.new(math.random(), 0, -0.1, 0)})
            t:Play()
            t.Completed:Connect(anim)
        end
        anim()
    end

    local Sidebar = Instance.new("Frame", Frame)
    Sidebar.Size = UDim2.new(0, 110, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Sidebar.ZIndex = 2

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
    Title.Text = " VERCO ULTIMATE "
    Title.TextColor3 = Color3.fromRGB(0, 255, 0)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.ZIndex = 3

    local Content = Instance.new("ScrollingFrame", Frame)
    Content.Size = UDim2.new(1, -120, 1, -50)
    Content.Position = UDim2.new(0, 115, 0, 45)
    Content.BackgroundTransparency = 1
    Content.ZIndex = 2
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)

    local function AddToggle(name, varName)
        local b = Instance.new("TextButton", Content)
        b.Size = UDim2.new(1, -10, 0, 40)
        b.Font = Enum.Font.GothamBold
        local function Upd()
            b.Text = name .. (_G[varName] and " : ON" or " : OFF")
            b.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(30, 30, 30)
            if varName == "SpeedRunning" and not _G[varName] then Player.Character.Humanoid.WalkSpeed = 16 end
        end
        Upd()
        b.MouseButton1Click:Connect(function() _G[varName] = not _G[varName] Upd() end)
    end

    local function ShowAim() Content:ClearAllChildren() Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5) AddToggle("Aimlock Head", "Aimlock") AddToggle("FlyKill (Auto Pindah)", "FlyKill") AddToggle("MS20 Pull", "MS20") end
    local function ShowVisual() Content:ClearAllChildren() Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5) AddToggle("ESP 3D Wireframe Red", "EspEnabled") end
    local function ShowConfig() Content:ClearAllChildren() Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5) AddToggle("Speed Running (5x)", "SpeedRunning") AddToggle("Speed Car/Motor", "SpeedCar") AddToggle("Auto Wins", "AutoWins") end

    local function CreateTab(name, func)
        local b = Instance.new("TextButton", Sidebar)
        b.Size = UDim2.new(1, 0, 0, 45)
        b.Text = name
        b.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
        b.TextColor3 = Color3.new(1,1,1)
        b.Position = UDim2.new(0, 0, 0, (#Sidebar:GetChildren()-1) * 45)
        b.MouseButton1Click:Connect(func)
    end

    CreateTab("AIM", ShowAim)
    CreateTab("VISUAL", ShowVisual)
    CreateTab("CONFIG", ShowConfig)
    ShowAim()

    -- Icon CT
    local CTBtn = Instance.new("TextButton", MainGui)
    CTBtn.Size = UDim2.new(0, 50, 0, 50)
    CTBtn.Position = UDim2.new(0, 10, 0.5, 0)
    CTBtn.Text = "CT"
    CTBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
    CTBtn.TextColor3 = Color3.new(0,1,0)
    CTBtn.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
end

-- ================= EXECUTION =================
LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CurrentKey then SaveTime() StartMainScript() else KeyInput.Text = "WRONG KEY!" end
end)

if CheckKey() then StartMainScript() end
