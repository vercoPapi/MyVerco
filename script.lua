local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================= SISTEM KEY 20 MENIT + GET KEY 10S =================
local KeyFile = "VercoKeyData_Final.txt"
local CurrentKey = "VERCO_NUGI_" .. os.date("%d%H") 

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

-- ================= GUI LOGIN =================
local KeyGui = Instance.new("ScreenGui", CoreGui)
local AuthFrame = Instance.new("Frame", KeyGui)
AuthFrame.Size = UDim2.new(0, 280, 0, 220) -- Menu dikecilkan
AuthFrame.Position = UDim2.new(0.5, -140, 0.5, -110)
AuthFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Instance.new("UIStroke", AuthFrame).Color = Color3.fromRGB(0, 255, 0)

local VTitle = Instance.new("TextLabel", AuthFrame)
VTitle.Size = UDim2.new(1, 0, 0, 40); VTitle.Text = "VERCO X NUGI"; VTitle.TextColor3 = Color3.fromRGB(0, 255, 0); VTitle.TextSize = 20; VTitle.Font = Enum.Font.GothamBold; VTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", AuthFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 35); KeyInput.Position = UDim2.new(0.1, 0, 0.25, 0); KeyInput.PlaceholderText = "Input Key Here"; KeyInput.Text = ""; KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20); KeyInput.TextColor3 = Color3.fromRGB(0, 255, 0)

local LoginBtn = Instance.new("TextButton", AuthFrame)
LoginBtn.Size = UDim2.new(0.8, 0, 0, 35); LoginBtn.Position = UDim2.new(0.1, 0, 0.5, 0); LoginBtn.Text = "Login"; LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0); LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local GetKeyBtn = Instance.new("TextButton", AuthFrame)
GetKeyBtn.Size = UDim2.new(0.8, 0, 0, 30); GetKeyBtn.Position = UDim2.new(0.1, 0, 0.75, 0); GetKeyBtn.Text = "Get Key (Wait 10s)"; GetKeyBtn.TextColor3 = Color3.fromRGB(0, 255, 0); GetKeyBtn.BackgroundTransparency = 1

GetKeyBtn.MouseButton1Click:Connect(function()
    GetKeyBtn.Active = false
    for i = 10, 1, -1 do
        GetKeyBtn.Text = "Wait " .. i .. "s..."
        task.wait(1)
    end
    setclipboard("https://link-key-lu.com/" .. CurrentKey)
    GetKeyBtn.Text = "Key Copied to Clipboard!"
    KeyInput.Text = CurrentKey -- Otomatis masukan key
    task.wait(2)
    GetKeyBtn.Text = "Get Key (Wait 10s)"
    GetKeyBtn.Active = true
end)

-- ================= MAIN CORE =================
local function StartMainScript()
    if KeyGui then KeyGui:Destroy() end
    
    _G.Aimlock = false; _G.EspEnabled = false; _G.FlyKill = false; _G.MS20 = false
    _G.SpeedRunning = false; _G.Wallhack = false; _G.JumpMulti = false; _G.AutoFarmSB = false
    _G.FlyPlayer = false; _G.FlyWins = false; _G.AimKeramat = false; _G.AutoWins = false

    local MarkedPlayers = {}

    -- ESP FULL (BOX 3D + LINE) SEMUA PLAYER
    local function CreateESP(v)
        local Lines = {}
        for i = 1, 12 do Lines[i] = Drawing.new("Line"); Lines[i].Color = Color3.fromRGB(0, 255, 0); Lines[i].Thickness = 1.5; Lines[i].Visible = false end
        local Tracer = Drawing.new("Line"); Tracer.Color = Color3.fromRGB(0, 255, 0); Tracer.Thickness = 1; Tracer.Visible = false

        RunService.RenderStepped:Connect(function()
            if _G.EspEnabled and v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                local cf = hrp.CFrame
                local size = Vector3.new(4, 5, 2)
                local pts = {
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
                    local p1, p2 = pts[c[1]], pts[c[2]]
                    if p1.Z > 0 and p2.Z > 0 then
                        Lines[i].Visible = true; Lines[i].From = Vector2.new(p1.X, p1.Y); Lines[i].To = Vector2.new(p2.X, p2.Y)
                    else Lines[i].Visible = false end
                end
                local rootPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then Tracer.Visible = true; Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); Tracer.To = Vector2.new(rootPos.X, rootPos.Y) else Tracer.Visible = false end
            else for i=1,12 do Lines[i].Visible = false end Tracer.Visible = false end
        end)
    end
    for _, v in pairs(game.Players:GetPlayers()) do CreateESP(v) end
    game.Players.PlayerAdded:Connect(CreateESP)

    -- MAIN LOOP SISTEM
    RunService.RenderStepped:Connect(function()
        local Target = nil
        local shortestDist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local hrp = v.Character.HumanoidRootPart
                local Mag = (hrp.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if _G.MS20 and Mag < 25 then hrp.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5) end
                if Mag < shortestDist then Target = v; shortestDist = Mag end
            end
        end

        -- AIM KERAMAT (LOCK BODY TAPI HEAD DAMAGE)
        if _G.AimKeramat and Target then
            Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position), 0.3)
        end

        if Target and Target.Character then
            -- FLY KILL (DI ATAS KEPALA PAS)
            if _G.FlyKill then
                Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                Player.Character.HumanoidRootPart.Velocity = Vector3.zero
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position), 0.3)
            end
            if _G.Aimlock then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position), 0.2) end
        end

        if _G.SpeedRunning then Player.Character.Humanoid.WalkSpeed = 80 end
        if _G.Wallhack then for _, p in pairs(Player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    end)

    -- MENU GUI (UKURAN DIKECILKAN)
    local MainGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", MainGui)
    Frame.Size = UDim2.new(0, 480, 0, 380); Frame.Position = UDim2.new(0.5, -240, 0.5, -190); Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Frame.ClipsDescendants = true
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 255, 0)
    Frame.Active = true; Frame.Draggable = true

    -- PARTIKEL JALAN
    local Particles = {}
    for i = 1, 15 do
        local p = Instance.new("Frame", Frame); p.Size = UDim2.new(0, 3, 0, 3); p.BackgroundColor3 = Color3.fromRGB(0, 255, 0); p.Position = UDim2.new(math.random(), 0, math.random(), 0)
        Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
        Particles[i] = {Obj = p, Vel = Vector2.new(math.random(-1,1)/1.5, math.random(-1,1)/1.5)}
    end
    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Particles) do
            p.Obj.Position = p.Obj.Position + UDim2.new(0, p.Vel.X, 0, p.Vel.Y)
            if p.Obj.Position.X.Scale < 0 or p.Obj.Position.X.Scale > 1 then p.Vel = Vector2.new(-p.Vel.X, p.Vel.Y) end
            if p.Obj.Position.Y.Scale < 0 or p.Obj.Position.Y.Scale > 1 then p.Vel = Vector2.new(p.Vel.X, -p.Vel.Y) end
        end
    end)

    local Sidebar = Instance.new("Frame", Frame); Sidebar.Size = UDim2.new(0, 110, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Sidebar.ZIndex = 3
    local Content = Instance.new("ScrollingFrame", Frame); Content.Size = UDim2.new(1, -120, 1, -50); Content.Position = UDim2.new(0, 115, 0, 45); Content.BackgroundTransparency = 1; Content.ZIndex = 3
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5)

    local function AddToggle(name, varName)
        local b = Instance.new("TextButton", Content); b.Size = UDim2.new(1, -10, 0, 32); b.Font = Enum.Font.GothamBold; b.ZIndex = 4
        local function Upd()
            b.Text = name .. (_G[varName] and " : ON" or " : OFF")
            b.TextColor3 = Color3.fromRGB(0, 255, 0); b.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(20, 20, 20)
        end
        Upd(); b.MouseButton1Click:Connect(function() _G[varName] = not _G[varName]; Upd() end)
    end

    local function ShowAim() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("AimKeramat", "AimKeramat"); AddToggle("FlyKill Head", "FlyKill"); AddToggle("Aimlock Head", "Aimlock"); AddToggle("MS20 Pull", "MS20") end
    local function ShowVis() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("ESP Full Player", "EspEnabled") end
    local function ShowCfg() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("Speed Run", "SpeedRunning"); AddToggle("Jump Multi", "JumpMulti"); AddToggle("Wallhack", "Wallhack") end
    local function ShowSB() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("Auto Farm SB", "AutoFarmSB") end
    local function ShowRin() Content:ClearAllChildren(); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 5); AddToggle("Fly Player", "FlyPlayer"); AddToggle("Fly Wins", "FlyWins") end

    local function Tab(name, idx, func)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 40); b.Position = UDim2.new(0, 0, 0, idx*40); b.Text = name; b.TextColor3 = Color3.fromRGB(0, 255, 0); b.BackgroundColor3 = Color3.fromRGB(15, 15, 15); b.Font = Enum.Font.GothamBold; b.ZIndex = 4
        b.MouseButton1Click:Connect(func)
    end

    Tab("AIM", 0, ShowAim); Tab("VISUAL", 1, ShowVis); Tab("CONFIG", 2, ShowCfg); Tab("S.BRONX", 3, ShowSB); Tab("RINTANGAN", 4, ShowRin)
    ShowAim()

    local Title = Instance.new("TextLabel", Frame); Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundColor3 = Color3.fromRGB(0, 40, 0); Title.Text = "VERCO X NUGI | ULTIMATE"; Title.TextColor3 = Color3.fromRGB(0, 255, 0); Title.Font = Enum.Font.GothamBold; Title.TextSize = 18; Title.ZIndex = 4
    local CTBtn = Instance.new("TextButton", MainGui); CTBtn.Size = UDim2.new(0, 45, 0, 45); CTBtn.Position = UDim2.new(0, 10, 0.5, 0); CTBtn.Text = "CT"; CTBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0); CTBtn.TextColor3 = Color3.fromRGB(0, 255, 0); CTBtn.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
end

LoginBtn.MouseButton1Click:Connect(function() if KeyInput.Text == CurrentKey then SaveKeyStatus(); StartMainScript() end end)
if IsKeyValid() then StartMainScript() end
