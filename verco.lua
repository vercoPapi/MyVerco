--[[
    VERCO X NUGI X - OFFICIAL SCRIPT
    Template: Orion Library
    Customization: Red & Black Theme + Floating CT Button
]]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- PENGATURAN TEMA (MERAH MENYALA & HITAM)
OrionLib.Theme = {
    Main = Color3.fromRGB(255, 0, 0),
    Accent = Color3.fromRGB(0, 0, 0),
    BackgroundColor = Color3.fromRGB(150, 0, 0),
    TextColor = Color3.fromRGB(0, 0, 0)
}

local Window = OrionLib:MakeWindow({
    Name = "VERCO  X  NUGI X", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "VercoNugi",
    IntroText = "WELCOME VERCO X NUGI X"
})

-- ================= TOMBOL CT (ICON MELAYANG) =================
local CT_Gui = Instance.new("ScreenGui")
local CT_Frame = Instance.new("Frame")
local CT_Corner = Instance.new("UICorner")
local CT_Label = Instance.new("TextLabel")
local CT_Button = Instance.new("TextButton")

CT_Gui.Name = "CT_Floating"
CT_Gui.Parent = CoreGui
CT_Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

CT_Frame.Name = "MainFrame"
CT_Frame.Parent = CT_Gui
CT_Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CT_Frame.Position = UDim2.new(0.12, 0, 0.15, 0)
CT_Frame.Size = UDim2.new(0, 50, 0, 50)
CT_Frame.Active = true
CT_Frame.Draggable = true -- Bisa digeser di HP

CT_Corner.CornerRadius = UDim.new(1, 0)
CT_Corner.Parent = CT_Frame

CT_Label.Parent = CT_Frame
CT_Label.BackgroundTransparency = 1
CT_Label.Size = UDim2.new(1, 0, 1, 0)
CT_Label.Font = Enum.Font.SourceSansBold
CT_Label.Text = "CT"
CT_Label.TextColor3 = Color3.fromRGB(0, 0, 0)
CT_Label.TextSize = 22

CT_Button.Parent = CT_Frame
CT_Button.BackgroundTransparency = 1
CT_Button.Size = UDim2.new(1, 0, 1, 0)
CT_Button.Text = ""

CT_Button.MouseButton1Click:Connect(function()
    local gui = CoreGui:FindFirstChild("Orion")
    if gui then
        gui.Enabled = not gui.Enabled
    end
end)

-- ================= MENU AIM =================
local TabAim = Window:MakeTab({Name = "Menu Aim", Icon = "rbxassetid://4483345998"})

TabAim:AddToggle({Name = "Aimlock", Default = false, Callback = function(v) _G.Aimlock = v end})
TabAim:AddToggle({Name = "Telekill", Default = false, Callback = function(v) _G.Telekill = v end})
TabAim:AddToggle({Name = "Underkill", Default = false, Callback = function(v) _G.Underkill = v end})
TabAim:AddToggle({Name = "Fly kill", Default = false, Callback = function(v) _G.FlyKill = v end})
TabAim:AddToggle({Name = "Esp Line", Default = false, Callback = function(v) _G.EspLine = v end})
TabAim:AddToggle({Name = "Esp Box", Default = false, Callback = function(v) _G.EspBox = v end})

-- ================= MENU AUTO =================
local TabAuto = Window:MakeTab({Name = "Menu Auto", Icon = "rbxassetid://4483345998"})

TabAuto:AddToggle({Name = "AutoFarm", Default = false, Callback = function(v) _G.AutoFarm = v end})
TabAuto:AddButton({Name = "South Bronx", Callback = function() print("Teleport South Bronx") end})
TabAuto:AddButton({Name = "Teleport Apartemen Jual", Callback = function() print("Teleport Apartemen") end})

-- ================= MENU MG =================
local TabMg = Window:MakeTab({Name = "Menu Mg", Icon = "rbxassetid://4483345998"})

TabMg:AddToggle({Name = "AutoMancing", Default = false, Callback = function(v) _G.AutoMancing = v end})
TabMg:AddToggle({Name = "AutoKill Ikan", Default = false, Callback = function(v) _G.AutoKillIkan = v end})
TabMg:AddToggle({Name = "AutoJual", Default = false, Callback = function(v) _G.AutoJual = v end})

-- ================= MENU RISK =================
local TabRisk = Window:MakeTab({Name = "Menu Risk", Icon = "rbxassetid://4483345998"})

TabRisk:AddToggle({Name = "AutoFinish", Default = false, Callback = function(v) _G.AutoFinish = v end})
TabRisk:AddToggle({Name = "MultiJump", Default = false, Callback = function(v)
    _G.MultiJump = v
    UserInputService.JumpRequest:Connect(function()
        if _G.MultiJump then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
    end)
end})
TabRisk:AddToggle({Name = "TembusBeton", Default = false, Callback = function(v)
    _G.Noclip = v
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Noclip then
            for _, obj in pairs(Player.Character:GetDescendants()) do
                if obj:IsA("BasePart") then obj.CanCollide = false end
            end
        end
    end)
end})
TabRisk:AddButton({Name = "Teleport ke player", Callback = function() print("Teleport ke Player") end})
TabRisk:AddToggle({Name = "AutoJalan (Fly Ikuti Player)", Default = false, Callback = function(v) _G.Follow = v end})

-- ================= SETTINGS =================
local TabSet = Window:MakeTab({Name = "Hide/Exit", Icon = "rbxassetid://4483345998"})

TabSet:AddButton({
    Name = "Hide Menu",
    Callback = function()
        CoreGui:FindFirstChild("Orion").Enabled = false
    end
})

TabSet:AddButton({
    Name = "Exit Script",
    Callback = function()
        OrionLib:Destroy()
        CT_Gui:Destroy()
    end
})

OrionLib:Init()
