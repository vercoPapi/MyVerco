repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

if getgenv().VERCO_LOADED then return end

-- OPTIMASI ANTI CRASH (KHUSUS SOUTH BRONX)
task.spawn(function()
    setfpscap(120)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("PostProcessEffect") or v:IsA("ParticleEmitter") then v.Enabled = false end
    end
end)

local ParentUI = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
local VERCO_GUI = Instance.new("ScreenGui", ParentUI)
VERCO_GUI.Name = "VERCO_FINAL_PREMIUM"

-- Fungsi ESP Asli (Drawing API)
local function CreateESP(target)
    local Line = Drawing.new("Line")
    local Box = Drawing.new("Square")
    
    local function Update()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if target and target:FindFirstChild("HumanoidRootPart") and _G.ESP_MASTER then
                local Root = target.HumanoidRootPart
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
                
                if OnScreen then
                    -- Line dari Atas Layar
                    Line.Visible = true
                    Line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    Line.To = Vector2.new(ScreenPos.X, ScreenPos.Y)
                    Line.Color = Color3.fromRGB(255, 0, 0)
                    Line.Thickness = 1.5
                    Line.Transparency = 1
                    
                    -- Box 2D
                    local Size = (Camera:WorldToViewportPoint(Root.Position + Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(Root.Position + Vector3.new(0, -3.5, 0)).Y)
                    Box.Visible = true
                    Box.Size = Vector2.new(Size / 1.5, Size)
                    Box.Position = Vector2.new(ScreenPos.X - Box.Size.X / 2, ScreenPos.Y - Box.Size.Y / 2)
                    Box.Color = Color3.fromRGB(255, 0, 0)
                    Box.Thickness = 1.5
                    Box.Filled = false
                else
                    Line.Visible = false
                    Box.Visible = false
                end
            else
                Line.Visible = false
                Box.Visible = false
                if not _G.ESP_MASTER then connection:Disconnect() Line:Remove() Box:Remove() end
            end
        end)
    end
    coroutine.wrap(Update)()
end

local function StartHub()
    getgenv().VERCO_LOADED = true
    
    local MainFrame = Instance.new("Frame", VERCO_GUI)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.Size = UDim2.new(0, 320, 0, 180) -- Rasio 16:9
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)

    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -10, 1, -40)
    Container.Position = UDim2.new(0, 5, 0, 35)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 3
    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 5)

    local function Check(text, cb)
        local b = Instance.new("TextButton", Container)
        b.Size = UDim2.new(1, 0, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = "  " .. text .. " [OFF]"
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.TextXAlignment = 0
        local s = false
        b.MouseButton1Click:Connect(function()
            s = not s
            b.Text = "  " .. text .. (s and " [ON]" or " [OFF]")
            b.TextColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255,255,255)
            cb(s)
        end)
    end

    -- 1. ESP MASTER (Semua Target: Player & NPC)
    Check("ESP Line & Box (All Targets)", function(v)
        _G.ESP_MASTER = v
        if v then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("Humanoid") and obj ~= LocalPlayer.Character then
                    CreateESP(obj)
                end
            end
            workspace.DescendantAdded:Connect(function(obj)
                if _G.ESP_MASTER and obj:FindFirstChild("Humanoid") then CreateESP(obj) end
            end)
        end
    end)

    -- 2. AIMBOT SMOOTH (Lock Head)
    Check("AimBot Smooth Head", function(v)
        _G.AB = v
        RunService.RenderStepped:Connect(function()
            if _G.AB then
                local target = nil
                local dist = math.huge
                for _, p in pairs(workspace:GetDescendants()) do
                    if p:FindFirstChild("Head") and p:FindFirstChild("Humanoid") and p.Humanoid.Health > 0 and p ~= LocalPlayer.Character then
                        local pos, vis = Camera:WorldToViewportPoint(p.Head.Position)
                        if vis then
                            local mDist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                            if mDist < dist then target = p dist = mDist end
                        end
                    end
                end
                if target then
                    local p = Camera:WorldToViewportPoint(target.Head.Position)
                    local m = UserInputService:GetMouseLocation()
                    mousemoverel((p.X - m.X)/5, (p.Y - m.Y)/5)
                end
            end
        end)
    end)

    -- 3. AUTOPELURU 50 (SPEED 5X)
    Check("Auto Ammo 50 (Instant)", function(v)
        _G.Ammo = v
        task.spawn(function()
            while _G.Ammo do task.wait(0.01)
                pcall(function()
                    local t = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if t and t:FindFirstChild("Ammo") then
                        if t.Ammo.Value < 10 then t.Ammo.Value = 50 end
                        if t:FindFirstChild("Reloading") then t.Reloading.Value = false end
                    end
                end)
            end
        end)
    end)

    -- FITUR LAINNYA
    Check("WallHack (Chams)", function(v) _G.WH = v end)
    Check("Anti Crash & Lag", function(v) if v then setfpscap(120) end end)
    Check("Teleport Stay Target", function(v) _G.TP = v end)

    task.delay(600, function() VERCO_GUI:Destroy() end)
end

-- LOGIN SCREEN (16:9)
local LFrame = Instance.new("Frame", VERCO_GUI)
LFrame.Size = UDim2.new(0, 280, 0, 150)
LFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
LFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
local Key = Instance.new("TextBox", LFrame)
Key.Size = UDim2.new(0, 200, 0, 30)
Key.Position = UDim2.new(0.5, -100, 0.4, 0)
Key.PlaceholderText = "Input Key"
local Btn = Instance.new("TextButton", LFrame)
Btn.Size = UDim2.new(0, 100, 0, 30)
Btn.Position = UDim2.new(0.5, -50, 0.7, 0)
Btn.Text = "Login"
Btn.MouseButton1Click:Connect(function()
    if Key.Text == "trial" then LFrame:Destroy() StartHub() end
end)
