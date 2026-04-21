local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("VERCO X NUGI X", "BloodTheme")

-- TAB AIM (Scrollable otomatis oleh Library)
local Tab1 = Window:NewTab("Menu Aim")
local Aim = Tab1:NewSection("Fitur Aim")
Aim:NewToggle("Aimlock","Kunci Target",function(s) _G.Aim=s end)
Aim:NewToggle("Telekill","Tele Kill",function(s) _G.Tk=s end)
Aim:NewToggle("Underkill","Under Kill",function(s) _G.Uk=s end)
Aim:NewToggle("Fly kill","Fly Kill",function(s) _G.Fk=s end)
Aim:NewToggle("Esp Line","Esp Line",function(s) _G.El=s end)
Aim:NewToggle("Esp Box","Esp Box",function(s) _G.Eb=s end)

-- TAB AUTO
local Tab2 = Window:NewTab("Menu Auto")
local Auto = Tab2:NewSection("Fitur Auto")
Auto:NewToggle("AutoFarm","Auto Farm",function(s) _G.Af=s end)
Auto:NewButton("South bronx","Teleport",function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(100,20,100) end)
Auto:NewButton("Teleport Apartemen Jual","Teleport",function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-200,10,-150) end)

-- TAB MG
local Tab3 = Window:NewTab("Menu Mg")
local Mg = Tab3:NewSection("Fitur Mg")
Mg:NewToggle("AutoMancing","Auto Mancing",function(s) _G.Am=s end)
Mg:NewToggle("AutoKill Ikan","Auto Kill Ikan",function(s) _G.Ai=s end)
Mg:NewToggle("AutoJual","Auto Jual",function(s) _G.Aj=s end)

-- TAB RISK
local Tab4 = Window:NewTab("Menu Risk")
local Risk = Tab4:NewSection("Fitur Risk")
Risk:NewToggle("AutoFinish","Auto Finish",function(s) _G.An=s end)
Risk:NewToggle("MultiJump","Multi Jump",function(s) _G.Mj=s game:GetService("UserInputService").JumpRequest:Connect(function() if _G.Mj then game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end) end)
Risk:NewToggle("TembusBeton","Noclip",function(s) _G.Nc=s game:GetService("RunService").Stepped:Connect(function() if _G.Nc then for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end) end)
Risk:NewButton("Teleport ke player","Teleport",function() print("TP") end)
Risk:NewToggle("AutoJalan Fly ikuti Player","Follow",function(s) _G.Fl=s end)

-- ICON CT BULAT & DRAGGABLE
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("CT_Logo") then CoreGui.CT_Logo:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CT_Logo"

local ImageFrame = Instance.new("Frame", ScreenGui)
ImageFrame.Size = UDim2.new(0, 60, 0, 60)
ImageFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
ImageFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ImageFrame.Active = true
ImageFrame.Draggable = true -- Bisa digeser

local Corner = Instance.new("UICorner", ImageFrame)
Corner.CornerRadius = UDim.new(1, 0) -- Bulat sempurna

local LogoText = Instance.new("TextLabel", ImageFrame)
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.Text = "CT"
LogoText.TextColor3 = Color3.fromRGB(0, 0, 0)
LogoText.TextSize = 25
LogoText.Font = Enum.Font.SourceSansBold
LogoText.BackgroundTransparency = 1

local Button = Instance.new("TextButton", ImageFrame)
Button.Size = UDim2.new(1, 0, 1, 0)
Button.BackgroundTransparency = 1
Button.Text = ""

-- FUNGSI SHOW / HIDE
Button.MouseButton1Click:Connect(function()
    local menu = CoreGui:FindFirstChild("VERCO X NUGI X")
    if menu then
        menu.Enabled = not menu.Enabled
    end
end)

-- NOTIFIKASI BERHASIL
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "VERCO X NUGI X",
    Text = "Klik Logo CT untuk Show/Hide Menu",
    Duration = 5
})
