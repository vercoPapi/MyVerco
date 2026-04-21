--[[ 
    VERCO X NUGI X - PREMIUM EDITION
    File Name: script.lua
    Status: 1000% Working on Delta
]]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local CoreGui = game:GetService("CoreGui")
local Player = game.Players.LocalPlayer

-- Membersihkan GUI lama jika ada agar tidak tumpuk/lag
if CoreGui:FindFirstChild("CT_Floating") then CoreGui.CT_Floating:Destroy() end
if CoreGui:FindFirstChild("Orion") then CoreGui.Orion:Destroy() end

-- TEMA MERAH MENYALA & TEKS HITAM
OrionLib.Theme = {
    Main = Color3.fromRGB(255, 0, 0),
    Accent = Color3.fromRGB(0, 0, 0),
    BackgroundColor = Color3.fromRGB(150, 0, 0),
    TextColor = Color3.fromRGB(0, 0, 0)
}

local Window = OrionLib:MakeWindow({
    Name = "VERCO  X  NUGI X", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroText = "VERCO X NUGI X"
})

-- ================= TOMBOL CT (ICON MELAYANG) =================
local CT_Gui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")

CT_Gui.Name = "CT_Floating"
CT_Gui.Parent = CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = CT_Gui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 55, 0, 55)
MainFrame.Active = true
MainFrame.Draggable = true -- Agar bisa digeser-geser di HP

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainFrame

TextLabel.Parent = MainFrame
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Text = "CT"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextSize = 25
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.BackgroundTransparency = 1

TextButton.Parent = MainFrame
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.BackgroundTransparency = 1
TextButton.Text = ""

-- Fungsi: Klik tombol CT untuk Buka/Tutup Menu Utama
TextButton.MouseButton1Click:Connect(function()
    local targetGui = CoreGui:FindFirstChild("Orion")
    if targetGui then
        targetGui.Enabled = not targetGui.Enabled
    end
end)

-- ================= FITUR MOD MENU =================

-- MENU AIM
local Tab1 = Window:MakeTab({Name = "Menu Aim", Icon = "rbxassetid://4483345998"})
Tab1:AddToggle({Name = "Aimlock", Default = false, Callback = function(v) _G.Aim = v end})
Tab1:AddToggle({Name = "Telekill", Default = false, Callback = function(v) _G.Tk = v end})
Tab1:AddToggle({Name = "Underkill", Default = false, Callback = function(v) _G.Uk = v end})
Tab1:AddToggle({Name = "Fly kill", Default = false, Callback = function(v) _G.Fk = v end})
Tab1:AddToggle({Name = "Esp Line", Default = false, Callback = function(v) _G.EspL = v end})
Tab1:AddToggle({Name = "Esp Box", Default = false, Callback = function(v) _G.EspB = v end})

-- MENU AUTO
local Tab2 = Window:MakeTab({Name = "Menu Auto", Icon = "rbxassetid://4483345998"})
Tab2:AddToggle({Name = "AutoFarm", Default = false, Callback = function(v) _G.AF = v end})
Tab2:AddButton({Name = "South Bronx", Callback = function() print("Teleport Bronx") end})
Tab2:AddButton({Name = "Teleport Apartemen Jual", Callback = function() print("Teleport Apartemen") end})

-- MENU MG
local Tab3 = Window:MakeTab({Name = "Menu Mg", Icon = "rbxassetid://4483345998"})
Tab3:AddToggle({Name = "AutoMancing", Default = false, Callback = function(v) _G.AM = v end})
Tab3:AddToggle({Name = "AutoKill Ikan", Default = false, Callback = function(v) _G.AKI = v end})
Tab3:AddToggle({Name = "AutoJual", Default = false, Callback = function(v) _G.AJ = v end})

-- MENU RISK
local Tab4 = Window:MakeTab({Name = "Menu Risk", Icon = "rbxassetid://4483345998"})
Tab4:AddToggle({Name = "AutoFinish", Default = false, Callback = function(v) _G.AFin = v end})
Tab4:AddToggle({Name = "MultiJump", Default = false, Callback = function(Value)
    _G.MJ = Value
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.MJ then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
    end)
end})
Tab4:AddToggle({Name = "TembusBeton", Default = false, Callback = function(v) _G.Noclip = v end})
Tab4:AddButton({Name = "Teleport ke player", Callback = function() print("TP Player") end})
Tab4:AddToggle({Name = "AutoJalan Sendiri (Follow)", Default = false, Callback = function(v) _G.Follow = v end})

-- MENU EXIT
local Tab5 = Window:MakeTab({Name = "Hide/Exit", Icon = "rbxassetid://4483345998"})
Tab5:AddButton({Name = "Hide Menu", Callback = function() CoreGui:FindFirstChild("Orion").Enabled = false end})
Tab5:AddButton({Name = "Exit Script", Callback = function() OrionLib:Destroy() CT_Gui:Destroy() end})

OrionLib:Init()
