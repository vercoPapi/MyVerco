repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

if getgenv().VERCO_LOADED then return end

local ParentUI = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
local VERCO_GUI = Instance.new("ScreenGui", ParentUI)
VERCO_GUI.Name = "VERCO_V4_LEFT"
VERCO_GUI.ResetOnSpawn = false

local function StartHub()
    getgenv().VERCO_LOADED = true

    -- Main Window di Samping Kiri
    local MainFrame = Instance.new("Frame", VERCO_GUI)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Position = UDim2.new(0, 20, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 350, 0, 300)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    -- Sidebar (Pilihan Menu)
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 100, 1, -10)
    Sidebar.Position = UDim2.new(0, 5, 0, 5)
    Sidebar.BackgroundTransparency = 0.9
    local SideLayout = Instance.new("UIListLayout", Sidebar)
    SideLayout.Padding = UDim.new(0, 5)

    -- Content Area
    local Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1, -115, 1, -10)
    Content.Position = UDim2.new(0, 110, 0, 5)
    Content.BackgroundTransparency = 1

    -- Icon Hide (LK)
    local IconBtn = Instance.new("TextButton", VERCO_GUI)
    IconBtn.Size = UDim2.new(0, 45, 0, 45)
    IconBtn.Position = UDim2.new(0, 20, 0, 20)
    IconBtn.Text = "LK"
    IconBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    IconBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
    IconBtn.Visible = false
    IconBtn.Draggable = true
    Instance.new("UIStroke", IconBtn).Color = Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)

    -- Tombol Keluar/Minimize di dalam Menu (-)
    local HideBtn = Instance.new("TextButton", MainFrame)
    HideBtn.Size = UDim2.new(0, 25, 0, 25)
    HideBtn.Position = UDim2.new(1, -30, 0, 5)
    HideBtn.Text = "-"
    HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    HideBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 4)

    -- Logika Toggle Hide
    HideBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        IconBtn.Visible = true
    end)

    IconBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        IconBtn.Visible = false
    end)

    local function ClearContent()
        for _, v in pairs(Content:GetChildren()) do 
            if v:IsA("ScrollingFrame") then v.Visible = false end 
        end
    end

    local function CreatePage(name)
        local Page = Instance.new("ScrollingFrame", Content)
        Page.Name = name
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)
        
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.Text = name
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.MouseButton1Click:Connect(function()
            ClearContent()
            Page.Visible = true
        end)
        return Page
    end

    local function AddToggle(parent, text, cb)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, -5, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = text .. " [OFF]"
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        local s = false
        b.MouseButton1Click:Connect(function()
            s = not s
            b.Text = text .. (s and " [ON]" or " [OFF]")
            b.TextColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
            cb(s)
        end)
    end

    -- 1. MENU BUY
    local PageBuy = CreatePage("Menu Buy")
    AddToggle(PageBuy, "AutoBuy (Free Items)", function(v)
        _G.AutoBuy = v
        task.spawn(function()
            while _G.AutoBuy do task.wait(1)
                for _, r in pairs(game:GetDescendants()) do
                    if r:IsA("RemoteFunction") and (r.Name:lower():find("buy") or r.Name:lower():find("purchase")) then
                        pcall(function() r:InvokeServer("All", 1) end)
                    end
                end
            end
        end)
    end)

    -- 2. MENU MANCING
    local PageMancing = CreatePage("Mancing")
    AddToggle(PageMancing, "Auto Mancing Fast", function(v)
        _G.AutoFish = v
        task.spawn(function()
            while _G.AutoFish do task.wait(0.1)
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end)
            end
        end)
    end)

    -- 3. MENU GENDONG
    local PageGendong = CreatePage("Gendong")
    AddToggle(PageGendong, "Auto Gendong Player", function(v)
        _G.AutoGendong = v
        task.spawn(function()
            while _G.AutoGendong do task.wait()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 50 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                        end
                    end
                end
            end
        end)
    end)

    -- 4. MENU ALL (MOVEMENT)
    local PageAll = CreatePage("Menu All")
    AddToggle(PageAll, "Jump 3x Tinggi", function(v)
        LocalPlayer.Character.Humanoid.JumpPower = v and 150 or 50
        LocalPlayer.Character.Humanoid.UseJumpPower = true
    end)
    AddToggle(PageAll, "Wallhack Tembus", function(v)
        _G.WH = v
        RunService.Stepped:Connect(function()
            if _G.WH then
                for _, x in pairs(LocalPlayer.Character:GetDescendants()) do
                    if x:IsA("BasePart") then x.CanCollide = false end
                end
            end
        end)
    end)
    AddToggle(PageAll, "AntiLag (3D HDR)", function(v)
        if v then
            local bloom = Instance.new("BloomEffect", game.Lighting)
            bloom.Intensity = 1
            game.Lighting.GlobalShadows = true
        end
    end)
    AddToggle(PageAll, "Fly Non Jatuh", function(v)
        _G.FlyNon = v
        if v then
            local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Name = "FlyStabilizer"
        else
            if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyStabilizer") then
                LocalPlayer.Character.HumanoidRootPart.FlyStabilizer:Destroy()
            end
        end
    end)
    AddToggle(PageAll, "Fly Jatuh", function(v)
        if v and LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyStabilizer") then
            LocalPlayer.Character.HumanoidRootPart.FlyStabilizer:Destroy()
        end
    end)

    PageAll.Visible = true 
end

-- LOGIN SCREEN
local LFrame = Instance.new("Frame", VERCO_GUI)
LFrame.Size = UDim2.new(0, 280, 0, 150)
LFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
LFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
local Key = Instance.new("TextBox", LFrame)
Key.Size = UDim2.new(0, 200, 0, 30)
Key.Position = UDim2.new(0.5, -100, 0.4, 0)
Key.PlaceholderText = "Masukkan Key (trial)"
local Btn = Instance.new("TextButton", LFrame)
Btn.Size = UDim2.new(0, 100, 0, 30)
Btn.Position = UDim2.new(0.5, -50, 0.7, 0)
Btn.Text = "Login"
Btn.MouseButton1Click:Connect(function()
    if Key.Text == "trial" then LFrame:Destroy() StartHub() end
end)
