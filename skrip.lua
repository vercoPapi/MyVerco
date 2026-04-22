repeat task.wait() until game:IsLoaded()

-- SISTEM KEY & CLOUD SAVING (Trial 10 Menit)
local KeyFile = "VercoKey_Save.txt"
local function SaveKey(key)
    if writefile then
        writefile(KeyFile, HttpService:JSONEncode({key = key, time = os.time()}))
    end
end

local function LoadSavedKey()
    if isfile and isfile(KeyFile) then
        local data = HttpService:JSONDecode(readfile(KeyFile))
        if data.key == "TRIAL" and (os.time() - data.time) < 600 then
            return true
        end
    end
    return false
end

if getgenv().VERCO_LOADED then return end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Parent UI
local ParentUI = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")

local VERCO_GUI = Instance.new("ScreenGui")
VERCO_GUI.Name = "VERCO_HUB"
VERCO_GUI.Parent = ParentUI
VERCO_GUI.ResetOnSpawn = false

-- PANEL LOGIN
local LoginFrame = Instance.new("Frame")
if not LoadSavedKey() then
    LoginFrame.Size = UDim2.new(0, 250, 0, 180)
    LoginFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
    LoginFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    LoginFrame.Parent = VERCO_GUI
    Instance.new("UIStroke", LoginFrame).Color = Color3.fromRGB(0, 150, 255)

    local LTitle = Instance.new("TextLabel")
    LTitle.Size = UDim2.new(1, 0, 0, 40)
    LTitle.Text = "Papi Verco"
    LTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
    LTitle.Font = Enum.Font.SourceSansBold
    LTitle.TextSize = 20
    LTitle.BackgroundTransparency = 1
    LTitle.Parent = LoginFrame

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0, 200, 0, 35)
    KeyBox.Position = UDim2.new(0.5, -100, 0.4, 0)
    KeyBox.PlaceholderText = "Masukan key"
    KeyBox.Text = ""
    KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.Parent = LoginFrame

    local LoginBtn = Instance.new("TextButton")
    LoginBtn.Size = UDim2.new(0, 100, 0, 35)
    LoginBtn.Position = UDim2.new(0.5, -50, 0.7, 0)
    LoginBtn.Text = "Login"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoginBtn.Parent = LoginFrame

    LoginBtn.MouseButton1Click:Connect(function()
        if KeyBox.Text == "TRIAL" then
            SaveKey("TRIAL")
            LoginFrame:Destroy()
            task.spawn(function() task.wait(600) VERCO_GUI:Destroy() print("Experit Masa trial habis") end)
            _G.StartVerco()
        else
            KeyBox.Text = ""
            KeyBox.PlaceholderText = "Key Salah!"
        end
    end)
else
    LoginFrame:Destroy()
    _G.StartVerco()
    task.spawn(function() task.wait(600) VERCO_GUI:Destroy() end)
end

-- MAIN HUB FUNCTION
_G.StartVerco = function()
    getgenv().VERCO_LOADED = true

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = VERCO_GUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 250, 0, 350)
    MainFrame.Draggable = true
    MainFrame.Active = true
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "VERCO HUB"
    Title.TextColor3 = Color3.fromRGB(0, 150, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.BackgroundTransparency = 1
    Title.TextSize = 20
    Title.Parent = MainFrame

    local Container = Instance.new("ScrollingFrame")
    Container.Parent = MainFrame
    Container.Size = UDim2.new(1, -20, 1, -60)
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.BackgroundTransparency = 1
    Container.CanvasSize = UDim2.new(0, 0, 5, 0)
    Container.ScrollBarThickness = 3

    local UIList = Instance.new("UIListLayout", Container)
    UIList.Padding = UDim.new(0, 8)

    local function CreateCheckbox(text, callback)
        local Box = Instance.new("TextButton", Container)
        Box.Size = UDim2.new(1, 0, 0, 35)
        Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Box.Text = text .. " [OFF]"
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        local st = false
        Box.MouseButton1Click:Connect(function()
            st = not st
            Box.Text = text .. (st and " [ON]" or " [OFF]")
            Box.TextColor3 = st and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 255, 255)
            callback(st)
        end)
    end

    -- FITUR ANTI CRASH & FPS (AUTO ON)
    task.spawn(function()
        setfpscap(120)
        RunService:Set3dRenderingEnabled(true)
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
    end)

    CreateCheckbox("Anti Crash & Lag", function(v)
        if v then
            for _, l in pairs(game:GetDescendants()) do
                if l:IsA("BlurEffect") or l:IsA("SunRaysEffect") then l.Enabled = false end
            end
        end
    end)

    CreateCheckbox("No Reload", function(v)
        _G.NoReload = v
        RunService.Heartbeat:Connect(function()
            if _G.NoReload then
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Ammo") then
                        tool.Ammo.Value = 999
                        if tool:FindFirstChild("Reloading") then tool.Reloading.Value = false end
                    end
                end)
            end
        end)
    end)

    CreateCheckbox("AutoMakro (Fast Shot)", function(v)
        _G.AutoMakro = v
        while _G.AutoMakro do task.wait()
            pcall(function()
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then 
                    tool:Activate()
                    if tool:FindFirstChild("Cooldown") then tool.Cooldown.Value = 0 end
                end
            end)
        end
    end)

    CreateCheckbox("AimMagnet (100m)", function(v)
        _G.AimM = v
        RunService.RenderStepped:Connect(function()
            if _G.AimM then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        local d = (LocalPlayer.Character.Head.Position - p.Character.Head.Position).Magnitude
                        if d < 100 then p.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.Head.CFrame * CFrame.new(0, 0, -3) end
                    end
                end
            end
        end)
    end)

    CreateCheckbox("Teleport (Back)", function(v)
        _G.TP = v
        while _G.TP do task.wait()
            pcall(function()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character.Humanoid.Health > 0 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        break
                    end
                end
            end)
        end
    end)

    -- Fitur lama tetap ada (Auto Farm, Speed, Jump, Noclip, Anti AFK)
    CreateCheckbox("Auto Farm", function(v) 
        if v then loadstring(game:HttpGet("https://raw.githubusercontent.com/canhongson/CanHongSon/refs/heads/main/CanHongSonHub.lua"))() end
    end)
    CreateCheckbox("Speed Hack", function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 end)
    CreateCheckbox("Infinite Jump", function(v) _G.IJ = v UserInputService.JumpRequest:Connect(function() if _G.IJ then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end) end)
    CreateCheckbox("Noclip", function(v) _G.NC = v RunService.Stepped:Connect(function() if _G.NC then for _, x in pairs(LocalPlayer.Character:GetDescendants()) do if x:IsA("BasePart") then x.CanCollide = false end end end end) end)
    CreateCheckbox("Anti AFK", function(v) local vu = game:GetService("VirtualUser") LocalPlayer.Idled:Connect(function() if v then vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end end) end)
end
