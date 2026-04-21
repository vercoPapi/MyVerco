local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local CoreGui = game:GetService("CoreGui")

-- Membersihkan GUI lama
if CoreGui:FindFirstChild("CT_Logo") then CoreGui.CT_Logo:Destroy() end

-- BUAT WINDOW (Tema Merah BloodTheme)
local Window = Library.CreateLib("VERCO X NUGI X", "BloodTheme")

-- TAB AIM (Bisa di-scroll otomatis)
local Tab1 = Window:NewTab("Menu Aim")
local S1 = Tab1:NewSection("Fitur Aim")
S1:NewToggle("Aimlock", "Kunci Target", function(v) _G.Aim = v end)
S1:NewToggle("Telekill", "Tele Kill", function(v) _G.Tk = v end)
S1:NewToggle("Underkill", "Under Kill", function(v) _G.Uk = v end)
S1:NewToggle("Fly kill", "Fly Kill", function(v) _G.Fk = v end)
S1:NewToggle("Esp Line", "Esp Line", function(v) _G.El = v end)
S1:NewToggle("Esp Box", "Esp Box", function(v) _G.Eb = v end)

-- TAB AUTO
local Tab2 = Window:NewTab("Menu Auto")
local S2 = Tab2:NewSection("Fitur Auto")
S2:NewToggle("AutoFarm", "Farm Otomatis", function(v) _G.Af = v end)
S2:NewButton("South Bronx", "Teleport", function() 
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(100, 20, 100) 
end)
S2:NewButton("Teleport Apartemen", "Teleport", function() 
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-200, 10, -150) 
end)

-- TAB MG
local Tab3 = Window:NewTab("Menu Mg")
local S3 = Tab3:NewSection("Fitur Mancing")
S3:NewToggle("AutoMancing", "Fish", function(v) _G.Am = v end)
S3:NewToggle("AutoKill Ikan", "Kill", function(v) _G.Ai = v end)
S3:NewToggle("AutoJual", "Sell", function(v) _G.Aj = v end)

-- TAB RISK
local Tab4 = Window:NewTab("Menu Risk")
local S4 = Tab4:NewSection("Fitur Berisiko")
S4:NewToggle("MultiJump", "Lompat Terus", function(v)
    _G.MJ = v
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.MJ then game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
    end)
end)
S4:NewToggle("TembusBeton", "Noclip", function(v) _G.Nc = v end)
S4:NewToggle("AutoJalan Follow", "Follow", function(v) _G.Fl = v end)

-- ICON CT BULAT (DRAGGABLE & PERMANEN)
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CT_Logo"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 60, 0, 60)
Frame.Position = UDim2.new(0.1, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Frame.Active = true
Frame.Draggable = true

local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(1, 0)

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1, 0, 1, 0)
Button.BackgroundTransparency = 1
Button.Text = "CT"
Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Button.TextSize = 22
Button.Font = Enum.Font.SourceSansBold

-- FUNGSI SHOW / HIDE
Button.MouseButton1Click:Connect(function()
    local menu = CoreGui:FindFirstChild("VERCO X NUGI X")
    if menu then
        menu.Enabled = not menu.Enabled
    end
end)
