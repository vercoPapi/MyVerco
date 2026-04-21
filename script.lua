local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local CoreGui = game:GetService("CoreGui")

-- Hapus GUI lama agar tidak tumpuk
if CoreGui:FindFirstChild("CT_Permanent") then CoreGui.CT_Permanent:Destroy() end

-- KONFIGURASI WINDOW (Bisa Digeser & Scrollable)
local Window = OrionLib:MakeWindow({
    Name = "VERCO X NUGI X", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroText = "VERCO X NUGI X",
    IntroIcon = "rbxassetid://4483345998"
})

-- ================= TAB AIM (BISA DI SCROLL) =================
local Tab1 = Window:MakeTab({Name = "Menu Aim", Icon = "rbxassetid://4483345998"})
Tab1:AddToggle({Name = "Aimlock", Default = false, Callback = function(v) _G.Aim = v end})
Tab1:AddToggle({Name = "Telekill", Default = false, Callback = function(v) _G.Tk = v end})
Tab1:AddToggle({Name = "Underkill", Default = false, Callback = function(v) _G.Uk = v end})
Tab1:AddToggle({Name = "Fly kill", Default = false, Callback = function(v) _G.Fk = v end})
Tab1:AddToggle({Name = "Esp Line", Default = false, Callback = function(v) _G.El = v end})
Tab1:AddToggle({Name = "Esp Box", Default = false, Callback = function(v) _G.Eb = v end})

-- ================= TAB AUTO =================
local Tab2 = Window:MakeTab({Name = "Menu Auto", Icon = "rbxassetid://4483345998"})
Tab2:AddToggle({Name = "AutoFarm", Default = false, Callback = function(v) _G.Af = v end})
Tab2:AddButton({Name = "South Bronx", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(100,20,100) end})
Tab2:AddButton({Name = "Teleport Apartemen", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-200,10,-150) end})

-- ================= TAB MG =================
local Tab3 = Window:MakeTab({Name = "Menu Mg", Icon = "rbxassetid://4483345998"})
Tab3:AddToggle({Name = "AutoMancing", Default = false, Callback = function(v) _G.Am = v end})
Tab3:AddToggle({Name = "AutoKill Ikan", Default = false, Callback = function(v) _G.Ai = v end})
Tab3:AddToggle({Name = "AutoJual", Default = false, Callback = function(v) _G.Aj = v end})

-- ================= TAB RISK =================
local Tab4 = Window:MakeTab({Name = "Menu Risk", Icon = "rbxassetid://4483345998"})
Tab4:AddToggle({Name = "MultiJump", Default = false, Callback = function(v) _G.Mj = v end})
Tab4:AddToggle({Name = "TembusBeton (Noclip)", Default = false, Callback = function(v) _G.Nc = v end})
Tab4:AddToggle({Name = "AutoJalan (Fly Follow)", Default = false, Callback = function(v) _G.Fl = v end})

-- ================= ICON CT BULAT (PERMANEN & DRAGGABLE) =================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CT_Permanent"

local DragFrame = Instance.new("Frame", ScreenGui)
DragFrame.Size = UDim2.new(0, 60, 0, 60)
DragFrame.Position = UDim2.new(0, 10, 0.5, 0) -- Posisi awal di pinggir
DragFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
DragFrame.Active = true
DragFrame.Draggable = true -- BISA DIGESER KE MANA SAJA

local Corner = Instance.new("UICorner", DragFrame)
Corner.CornerRadius = UDim.new(1, 0) -- Bulat Sempurna

local Button = Instance.new("TextButton", DragFrame)
Button.Size = UDim2.new(1, 0, 1, 0)
Button.BackgroundTransparency = 1
Button.Text = "CT"
Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Button.TextSize = 22
Button.Font = Enum.Font.SourceSansBold

-- FUNGSI: Klik CT untuk Show/Hide Menu
Button.MouseButton1Click:Connect(function()
    local mainGui = CoreGui:FindFirstChild("Orion")
    if mainGui then
        mainGui.Enabled = not mainGui.Enabled
    end
end)

OrionLib:Init()
