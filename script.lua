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
    local expiry = os.time() + 1200 
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
KeyInput.Size = UDim2.new(0.8, 0, 0, 40); KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0); KeyInput.Text = CurrentKey; KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20); KeyInput.TextColor3 = Color3.fromRGB(0, 255, 0)

local LoginBtn = Instance.new("TextButton", AuthFrame)
LoginBtn.Size = UDim2.new(0.8, 0, 0, 40); LoginBtn.Position = UDim2.new(0.1, 0, 0.55, 0); LoginBtn.Text = "Login"; LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0); LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ================= MAIN SCRIPT =================
local function StartMainScript()
    if KeyGui then KeyGui:Destroy() end
    
    _G.Aimlock = false; _G.EspEnabled = false; _G.FlyKill = false; _G.MS20 = false
    _G.SpeedRunning = false; _G.SpeedCar = false; _G.AutoWins = false
    _G.Wallhack = false; _G.JumpMulti = false; _G.AutoFarmSB = false
    _G.FlyPlayer = false; _G.FlyWins = false; _G.AimKeramat = false

    local MarkedPlayers = {}

    -- ESP 3D WIREFRAME (ALL PLAYERS)
    local function CreateESP(v)
        local Lines = {}
        for i = 1, 12 do Lines[i] = Drawing.new("Line"); Lines[i].Color = Color3.fromRGB(0, 255, 0); Lines[i].Thickness = 1.5; Lines[i].Visible = false end
        
        RunService.RenderStepped:Connect(function()
            if _G.EspEnabled and v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local hrp = v.Character.HumanoidRootPart
                local cf = hrp.CFrame
                local size = Vector3.new(4, 5, 2)
                
                local points = {
                    Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, size.Y/2, size.Z/2)).Position),
                    Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2)).Position),
                    Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2)).Position),
                    Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2)).Position),
                    Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2)).Position),
                    Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2)).Position),
                    Camera:WorldToViewportPoint((cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)).Position),
                    Camera:WorldToViewportPoint((cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2)).Position),
                }

                local connections = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
                for i, conn in pairs(connections) do
                    local p1, p2 = points[conn[1]], points[conn[2]]
                    if p1.Z > 0 and p2.Z > 0 then
                        Lines[i].Visible = true
                        Lines[i].From = Vector2.new(p1.X, p1.Y)
                        Lines[i].To = Vector2.new(p2.X, p2.Y)
                    else Lines[i].Visible = false end
                end
            else
                for i=1,12 do Lines[i].Visible = false end
            end
        end)
    end
    for _, v in pairs(game.Players:GetPlayers()) do CreateESP(v) end
    game.Players.PlayerAdded:Connect(CreateESP)

    -- MAIN LOOP
    RunService.RenderStepped:Connect(function()
        local Target = nil
        local shortestDist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local hrp = v.Character.HumanoidRootPart
                local Mag = (hrp.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if Mag < shortestDist then Target = v; shortestDist = Mag end
                if _G.MS20 and Mag < 65 then hrp.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5) end
            end
        end

        -- AimKeramat (Lock Badan Sakti)
        if _G.AimKeramat then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character.Humanoid.Health > 0 and not MarkedPlayers[v.Name] then
                    Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, v.Character.HumanoidRootPart.Position)
                    MarkedPlayers[v.Name] = v
                    task.wait(0.2)
                end
            end
        end

        if Target and Target.Character then
            if _G.FlyKill then
                Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                Player.Character.HumanoidRootPart.Velocity = Vector3.zero
            end
            if _G.Aimlock then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.HumanoidRootPart.Position), 0.15)
            end
        end

        -- Configs
        if _G.SpeedRunning then Player.Character.Humanoid.WalkSpeed = 80 end
        if _G.Wallhack then
            for _, p in pairs(Player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end
        if _G.FlyWins or _G.AutoWins then
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj.Name:lower():find("finish") or obj.Name:lower():find("win")) then
                    Player.Character.HumanoidRootPart.CFrame = obj.CFrame break
                end
            end
        end
    end)

    -- GUI DENGAN PARTIKEL MELENGKET JALAN
    local MainGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", MainGui)
    Frame.Size = UDim2.new(0, 520, 0, 450); Frame.Position = UDim2.new(0.5, -260, 0.5, -225); Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Frame.ClipsDescendants = true
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 0)
    Frame.Active = true; Frame.Draggable = true

    -- ANIMASI PARTIKEL JALAN
    local Parts = {}
    local Lines = {}
    for i = 1, 15 do
        local p = Instance.new("Frame", Frame); p.Size = UDim2.new(0, 3, 0, 3); p.BackgroundColor3 = Color3.fromRGB(0, 255, 0); p.Position = UDim2.new(math.random(), 0, math.random(), 0)
        Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
        Parts[i] = {Obj = p, Vel = Vector2.new(math.random(-1,1), math.random(-1,1))}
    end

    RunService.Heartbeat:Connect(function()
        for i, p in pairs(Parts) do
            p.Obj.Position = p.Obj.Position + UDim2.new(0, p.Vel.X, 0, p.Vel.Y)
            if p.Obj.Position.X.Scale < 0 or p.Obj.Position.X.Scale > 1 then p.Vel = Vector2.new(-p.Vel.X, p.Vel.Y) end
            if p.Obj.Position.Y.Scale < 0 or p.Obj.Position.Y.Scale > 1 then p.Vel = Vector2.new(p.Vel.X, -p.Vel.Y) end
        end
    end)

    local Sidebar = Instance.new("Frame", Frame); Sidebar.Size = UDim2.new(0, 130, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Sidebar.ZIndex = 2
    local Content = Instance.new("ScrollingFrame", Frame); Content.Size = UDim2.new(1, -140, 1, -50); Content.Position = UDim2.new(0, 135, 0, 45); Content.BackgroundTransparency = 1; Content.ZIndex = 2
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)

    local function AddToggle(name, varName)
        local b = Instance.new("TextButton", Content); b.Size = UDim2.new(1, -10, 0, 35); b.Font = Enum.Font.GothamBold; b.ZIndex = 3
        local function Upd()
            b.Text = name .. (_G[varName] and " : ON" or " : OFF")
            b.TextColor3 = Color3.fromRGB(0, 255, 0); b.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(20, 20, 20)
            if varName == "AimKeramat" and not _G[varName] then
                for _, p in pairs(MarkedPlayers) do if p.Character then p.Character.Humanoid.Health = 0 end end
                MarkedPlayers = {}
            end
        end
        Upd(); b.MouseButton1Click:Connect(function() _G[varName] = not _G[varName]; Upd() end)
    end

    local function ShowAim() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("AimKeramat (Body)", "AimKeramat"); AddToggle("FlyKill 20m", "FlyKill"); AddToggle("Aimlock Body", "Aimlock"); AddToggle("MS20 Pull", "MS20") end
    local function ShowVis() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("ESP 3D Wireframe", "EspEnabled") end
    local function ShowCfg() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("Speed Run", "SpeedRunning"); AddToggle("Wallhack", "Wallhack") end
    local function ShowRin() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("Fly to Player", "FlyPlayer"); AddToggle("Fly to Wins", "FlyWins") end

    local function CreateTab(name, func)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.TextColor3 = Color3.fromRGB(0, 255, 0); b.BackgroundColor3 = Color3.fromRGB(15, 15, 15); b.Font = Enum.Font.GothamBold; b.ZIndex = 3
        b.Position = UDim2.new(0, 0, 0, (#Sidebar:GetChildren()-1) * 40); b.MouseButton1Click:Connect(func)
    end

    CreateTab("AIM", ShowAim); CreateTab("VISUAL", ShowVis); CreateTab("CONFIG", ShowCfg); CreateTab("RINTANGAN", ShowRin)
    ShowAim()

    local CTBtn = Instance.new("TextButton", MainGui); CTBtn.Size = UDim2.new(0, 50, 0, 50); CTBtn.Position = UDim2.new(0, 10, 0.5, 0); CTBtn.Text = "CT"; CTBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0); CTBtn.TextColor3 = Color3.fromRGB(0, 255, 0); CTBtn.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
end

-- EXECUTION
LoginBtn.MouseButton1Click:Connect(function() if KeyInput.Text == CurrentKey then SaveKeyStatus(); StartMainScript() end end)
if IsKeyValid() then StartMainScript() end
