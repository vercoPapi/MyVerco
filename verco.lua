local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- TEMA MERAH PEKAT & TEKS HITAM
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
    IntroText = "VERCO X NUGI X"
})

-- ================= TOMBOL CT (FLOATING ICON) =================
local CTButton = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")

CTButton.Name = "CT_FloatingIcon"
CTButton.Parent = CoreGui
CTButton.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = CTButton
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 50, 0, 50) -- Ukuran bulat
MainFrame.Active = true
MainFrame.Draggable = true -- Agar bisa digeser

UICorner.CornerRadius = UDim.new(1, 0) -- Membuat jadi bulat sempurna
UICorner.Parent = MainFrame

TextLabel.Parent = MainFrame
TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "CT"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextSize = 25

-- Fungsi Klik Ikon CT untuk Munculkan Menu
local btn = Instance.new("TextButton")
btn.Parent = MainFrame
btn.BackgroundTransparency = 1
btn.Size = UDim2.new(1, 0, 1, 0)
btn.Text = ""
btn.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
    -- Orion otomatis sembunyi/muncul dengan tombol tertentu, 
    -- atau kita panggil manual jika library mendukung toggle
end)

-- ================= MENU AIM =================
local Tab1 = Window:MakeTab({Name = "Menu Aim", Icon = "rbxassetid://4483345998"})
Tab1:AddToggle({Name = "Aimlock", Default = false, Callback = function(v) _G.Aim = v end})
Tab1:AddToggle({Name = "Telekill", Default = false, Callback = function(v) _G.Tk = v end})
Tab1:AddToggle({Name = "Underkill", Default = false, Callback = function(v) _G.Uk = v end})
Tab1:AddToggle({Name = "Fly kill", Default = false, Callback = function(v) _G.Fk = v end})
Tab1:AddToggle({Name = "Esp Line", Default = false, Callback = function(v) _G.EspL = v end})
Tab1:AddToggle({Name = "Esp Box", Default = false, Callback = function(v) _G.EspB = v end})

-- ================= MENU AUTO =================
local Tab2 = Window:MakeTab({Name = "Menu Auto", Icon = "rbxassetid://4483345998"})
Tab2:AddToggle({Name = "AutoFarm", Default = false, Callback = function(v) _G.AF = v end})
Tab2:AddButton({Name = "South Bronx", Callback = function() Player.Character.HumanoidRootPart.CFrame = CFrame.new(100, 20, 100) end})
Tab2:AddButton({Name = "Teleport Apartemen Jual", Callback = function() Player.Character.HumanoidRootPart.CFrame = CFrame.new(-200, 20, -100) end})

-- ================= MENU MG =================
local Tab3 = Window:MakeTab({Name = "Menu Mg", Icon = "rbxassetid://4483345998"})
Tab3:AddToggle({Name = "AutoMancing", Default = false, Callback = function(v) _G.AM = v end})
Tab3:AddToggle({Name = "AutoKill Ikan", Default = false, Callback = function(v) _G.AKI = v end})
Tab3:AddToggle({Name = "AutoJual", Default = false, Callback = function(v) _G.AJ = v end})

-- ================= MENU RISK =================
local Tab4 = Window:MakeTab({Name = "Menu Risk", Icon = "rbxassetid://4483345998"})
Tab4:AddToggle({Name = "AutoFinish", Default = false, Callback = function(v) _G.AFin = v end})
Tab4:AddToggle({Name = "MultiJump", Default = false, Callback = function(Value)
    _G.MJ = Value
    UserInputService.JumpRequest:Connect(function()
        if _G.MJ then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
    end)
end})
Tab4:AddToggle({Name = "TembusBeton", Default = false, Callback = function(v)
    _G.Noclip = v
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Noclip then
            for _, obj in pairs(Player.Character:GetDescendants()) do
                if obj:IsA("BasePart") then obj.CanCollide = false end
            end
        end
    end)
end})
Tab4:AddToggle({Name = "Follow Player (Atas Kepala)", Default = false, Callback = function(v)
    _G.Follow = v
    while _G.Follow do
        pcall(function()
            local target = nil
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character then target = p break end
            end
            if target then
                Player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
            end
        end)
        task.wait()
    end
end})

-- ================= EXIT & HIDE =================
local TabEnd = Window:MakeTab({Name = "Exit", Icon = "rbxassetid://4483345998"})

TabEnd:AddButton({
    Name = "Hide Menu",
    Callback = function()
        -- Orion tidak punya fungsi minimize bawaan yang sempurna di mobile, 
        -- jadi kita sembunyikan GUI Orion, dan biarkan tombol CT tetap ada.
        CoreGui:FindFirstChild("Orion").Enabled = false
    end
})

-- Tambahkan fungsi pada tombol CT agar bisa memunculkan kembali
btn.MouseButton1Click:Connect(function()
    local gui = CoreGui:FindFirstChild("Orion")
    if gui then
        gui.Enabled = not gui.Enabled
    end
end)

TabEnd:AddButton({
    Name = "Exit Script",
    Callback = function()
        OrionLib:Destroy()
        CTButton:Destroy()
    end
})

OrionLib:Init()
