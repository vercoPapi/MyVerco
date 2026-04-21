local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local CoreGui = game:GetService("CoreGui")

-- Hapus GUI lama jika ada
if CoreGui:FindFirstChild("CT_Permanent") then CoreGui.CT_Permanent:Destroy() end

local Window = Rayfield:CreateWindow({
   Name = "VERCO X NUGI X",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Verco & Nugi",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

-- ================= TAB AIM (AUTO SCROLL) =================
local Tab1 = Window:CreateTab("Menu Aim", 4483345998)
Tab1:CreateToggle({
   Name = "Aimlock",
   CurrentValue = false,
   Callback = function(Value) _G.Aim = Value end,
})
Tab1:CreateToggle({Name = "Telekill", CurrentValue = false, Callback = function(v) _G.Tk = v end})
Tab1:CreateToggle({Name = "Underkill", CurrentValue = false, Callback = function(v) _G.Uk = v end})
Tab1:CreateToggle({Name = "Fly kill", CurrentValue = false, Callback = function(v) _G.Fk = v end})
Tab1:CreateToggle({Name = "Esp Line", CurrentValue = false, Callback = function(v) _G.El = v end})
Tab1:CreateToggle({Name = "Esp Box", CurrentValue = false, Callback = function(v) _G.Eb = v end})

-- ================= TAB AUTO =================
local Tab2 = Window:CreateTab("Menu Auto", 4483345998)
Tab2:CreateToggle({Name = "AutoFarm", CurrentValue = false, Callback = function(v) _G.Af = v end})
Tab2:CreateButton({
   Name = "South Bronx",
   Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(100,20,100) end,
})
Tab2:CreateButton({
   Name = "Teleport Apartemen Jual",
   Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-200,10,-150) end,
})

-- ================= TAB MG =================
local Tab3 = Window:CreateTab("Menu Mg", 4483345998)
Tab3:CreateToggle({Name = "AutoMancing", CurrentValue = false, Callback = function(v) _G.Am = v end})
Tab3:CreateToggle({Name = "AutoKill Ikan", CurrentValue = false, Callback = function(v) _G.Ai = v end})
Tab3:CreateToggle({Name = "AutoJual", CurrentValue = false, Callback = function(v) _G.Aj = v end})

-- ================= TAB RISK =================
local Tab4 = Window:CreateTab("Menu Risk", 4483345998)
Tab4:CreateToggle({Name = "MultiJump", CurrentValue = false, Callback = function(v) _G.Mj = v end})
Tab4:CreateToggle({Name = "TembusBeton", CurrentValue = false, Callback = function(v) _G.Nc = v end})
Tab4:CreateToggle({Name = "AutoJalan (Fly Follow)", CurrentValue = false, Callback = function(v) _G.Fl = v end})

-- ================= ICON CT BULAT (PERMANEN & DRAGGABLE) =================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CT_Permanent"

local DragFrame = Instance.new("Frame", ScreenGui)
DragFrame.Size = UDim2.new(0, 60, 0, 60)
DragFrame.Position = UDim2.new(0, 15, 0.5, 0)
DragFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
DragFrame.Active = true
DragFrame.Draggable = true

local Corner = Instance.new("UICorner", DragFrame)
Corner.CornerRadius = UDim.new(1, 0)

local Button = Instance.new("TextButton", DragFrame)
Button.Size = UDim2.new(1, 0, 1, 0)
Button.BackgroundTransparency = 1
Button.Text = "CT"
Button.TextColor3 = Color3.fromRGB(0, 0, 0)
Button.TextSize = 22
Button.Font = Enum.Font.SourceSansBold

-- FUNGSI: Klik CT untuk Buka/Tutup Rayfield
Button.MouseButton1Click:Connect(function()
    local rayfieldGui = CoreGui:FindFirstChild("Rayfield")
    if rayfieldGui then
        rayfieldGui.Enabled = not rayfieldGui.Enabled
    end
end)
