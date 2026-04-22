repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

if getgenv().VERCO_LOADED then return end

local ParentUI = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
local VERCO_GUI = Instance.new("ScreenGui", ParentUI)
VERCO_GUI.Name = "VERCO_FORSAKEN_V1"
VERCO_GUI.ResetOnSpawn = false

local function StartHub()
    getgenv().VERCO_LOADED = true

    -- Main Window (16:9 & Draggable)
    local MainFrame = Instance.new("Frame", VERCO_GUI)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.Position = UDim2.new(0, 30, 0.5, -100)
    MainFrame.Size = UDim2.new(0, 380, 0, 215) -- Rasio 16:9 sempurna
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

    -- Sidebar Navigasi
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 110, 1, -10)
    Sidebar.Position = UDim2.new(0, 5, 0, 5)
    Sidebar.BackgroundTransparency = 1
    local SideLayout = Instance.new("UIListLayout", Sidebar)
    SideLayout.Padding = UDim.new(0, 5)

    -- Content Area
    local Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1, -125, 1, -15)
    Content.Position = UDim2.new(0, 120, 0, 10)
    Content.BackgroundTransparency = 1

    -- Icon LK (Hide System)
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

    local HideBtn = Instance.new("TextButton", MainFrame)
    HideBtn.Size = UDim2.new(0, 25, 0, 25)
    HideBtn.Position = UDim2.new(1, -30, 0, 5)
    HideBtn.Text = "-"
    HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    HideBtn.BackgroundTransparency = 1
    HideBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false IconBtn.Visible = true end)
    IconBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true IconBtn.Visible = false end)

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
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.Font = Enum.Font.SourceSansBold
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Page.Visible = true
        end)
        return Page
    end

    local function AddToggle(parent, text, cb)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, -10, 0, 32)
        b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        b.Text = " " .. text .. " [OFF]"
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextXAlignment = 0
        local s = false
        b.MouseButton1Click:Connect(function()
            s = not s
            b.Text = " " .. text .. (s and " [ON]" or " [OFF]")
            b.TextColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
            cb(s)
        end)
    end

    -- [[ KATEGORI COMBAT (FORSAKEN) ]]
    local CombatPage = CreatePage("Combat")
    AddToggle(CombatPage, "Silent Aim", function(v) _G.SilentAim = v end)
    AddToggle(CombatPage, "Lock Head", function(v) _G.LockHead = v end)
    AddToggle(CombatPage, "No Recoil", function(v) _G.NoRecoil = v end)

    -- [[ KATEGORI VISUAL (FORSAKEN) ]]
    local VisualPage = CreatePage("Visual")
    AddToggle(VisualPage, "ESP Box", function(v) _G.ESP_Box = v end)
    AddToggle(VisualPage, "ESP Tracers", function(v) _G.ESP_Line = v end)
    AddToggle(VisualPage, "ESP Name", function(v) _G.ESP_Name = v end)

    -- [[ KATEGORI MOVEMENT ]]
    local MovePage = CreatePage("Movement")
    AddToggle(MovePage, "Speedhack (Fast)", function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 end)
    AddToggle(MovePage, "Infinite Jump", function(v) _G.InfJump = v end)

    -- [[ EXTERNAL LOADER (Load Forsaken Asli) ]]
    local MiscPage = CreatePage("Misc")
    AddToggle(MiscPage, "Load Forsaken Script", function(v)
        if v then loadstring(game:HttpGet("https://raw.githubusercontent.com/zxcursedsocute/Forsaken-Script/refs/heads/main/lua"))() end
    end)

    CombatPage.Visible = true
end

-- Login Screen
local LFrame = Instance.new("Frame", VERCO_GUI)
LFrame.Size = UDim2.new(0, 260, 0, 140)
LFrame.Position = UDim2.new(0.5, -130, 0.5, -70)
LFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UIStroke", LFrame).Color = Color3.fromRGB(0, 150, 255)
local Key = Instance.new("TextBox", LFrame)
Key.Size = UDim2.new(0, 200, 0, 30)
Key.Position = UDim2.new(0.5, -100, 0.35, 0)
Key.PlaceholderText = "Input Key (trial)"
local Btn = Instance.new("TextButton", LFrame)
Btn.Size = UDim2.new(0, 100, 0, 30)
Btn.Position = UDim2.new(0.5, -50, 0.7, 0)
Btn.Text = "Login"
Btn.MouseButton1Click:Connect(function() if Key.Text == "trial" then LFrame:Destroy() StartHub() end end)
