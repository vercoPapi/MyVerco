local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

if CoreGui:FindFirstChild("VercoMenu") then CoreGui.VercoMenu:Destroy() end
if CoreGui:FindFirstChild("CT_Icon") then CoreGui.CT_Icon:Destroy() end

_G.Noclip = false
_G.Jump = false
_G.Speed = 16

RunService.Stepped:Connect(function()
    if _G.Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if _G.Jump and Player.Character then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "VercoMenu"

local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 320, 0, 220)
Frame.Position = UDim2.new(0.5, -160, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.Text = "VERCO X NUGI X"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Size = UDim2.new(1, -10, 1, -45)
Scroll.Position = UDim2.new(0, 5, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
Scroll.ScrollBarThickness = 4

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)

local function AddToggle(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    btn.Text = name .. " : OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    
    local st = false
    btn.MouseButton1Click:Connect(function()
        st = not st
        btn.Text = name .. " : " .. (st and "ON" or "OFF")
        btn.BackgroundColor3 = st and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(50, 0, 0)
        btn.TextColor3 = st and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        callback(st)
    end)
end

AddToggle("Aimlock", function(v) print("Aim: "..tostring(v)) end)
AddToggle("Telekill", function(v) print("TK: "..tostring(v)) end)
AddToggle("Underkill", function(v) print("UK: "..tostring(v)) end)
AddToggle("Fly Kill", function(v) print("FK: "..tostring(v)) end)
AddToggle("Esp Box", function(v) print("Esp: "..tostring(v)) end)
AddToggle("Auto Farm", function(v) print("Farm: "..tostring(v)) end)
AddToggle("Auto Mancing", function(v) print("Fish: "..tostring(v)) end)
AddToggle("Multi Jump", function(v) _G.Jump = v end)
AddToggle("Noclip (Tembus)", function(v) _G.Noclip = v end)

local CTGui = Instance.new("ScreenGui", CoreGui)
CTGui.Name = "CT_Icon"
local CTBtn = Instance.new("Frame", CTGui)
CTBtn.Size = UDim2.new(0, 55, 0, 55)
CTBtn.Position = UDim2.new(0, 20, 0.5, 0)
CTBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CTBtn.Active = true
CTBtn.Draggable = true
local CR = Instance.new("UICorner", CTBtn)
CR.CornerRadius = UDim.new(1, 0)
local CL = Instance.new("TextButton", CTBtn)
CL.Size = UDim2.new(1, 0, 1, 0)
CL.BackgroundTransparency = 1
CL.Text = "CT"
CL.TextSize = 22
CL.Font = Enum.Font.SourceSansBold
CL.TextColor3 = Color3.fromRGB(0, 0, 0)
CL.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
