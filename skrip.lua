repeat task.wait() until game:IsLoaded()

if getgenv().VERCO_LOADED then return end
getgenv().VERCO_LOADED = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ParentUI
local success = pcall(function()
    ParentUI = game:GetService("CoreGui")
end)
if not success then
    ParentUI = LocalPlayer:WaitForChild("PlayerGui")
end

local VERCO_GUI = Instance.new("ScreenGui")
VERCO_GUI.Name = "VERCO_HUB"
VERCO_GUI.Parent = ParentUI
VERCO_GUI.ResetOnSpawn = false
VERCO_GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = VERCO_GUI
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 150, 255)
UIStroke.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "VERCO HUB"
Title.TextColor3 = Color3.fromRGB(0, 150, 255)
Title.TextSize = 20

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 7)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.MouseButton1Click:Connect(function()
    VERCO_GUI:Destroy()
    getgenv().VERCO_LOADED = false
end)

local IconBtn = Instance.new("TextButton")
local IconCorner = Instance.new("UICorner")
local IconStroke = Instance.new("UIStroke")

IconBtn.Name = "IconBtn"
IconBtn.Parent = VERCO_GUI
IconBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
IconBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
IconBtn.Size = UDim2.new(0, 50, 0, 50)
IconBtn.Font = Enum.Font.SourceSansBold
IconBtn.Text = "LK"
IconBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
IconBtn.TextSize = 20
IconBtn.Visible = false
IconBtn.Active = true
IconBtn.Draggable = true

IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = IconBtn

IconStroke.Parent = IconBtn
IconStroke.Color = Color3.fromRGB(0, 150, 255)
IconStroke.Thickness = 2

local HideBtn = Instance.new("TextButton")
HideBtn.Parent = MainFrame
HideBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HideBtn.Position = UDim2.new(1, -60, 0, 7)
HideBtn.Size = UDim2.new(0, 25, 0, 25)
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IconBtn.Visible = true
end)

IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    IconBtn.Visible = false
end)

local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateCheckbox(text, callback)
    local Box = Instance.new("TextButton")
    local state = false
    
    Box.Parent = Container
    Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Box.Size = UDim2.new(1, 0, 0, 40)
    Box.Font = Enum.Font.SourceSans
    Box.Text = "  " .. text .. " [OFF]"
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.TextSize = 16
    Box.TextXAlignment = Enum.TextXAlignment.Left

    local BStroke = Instance.new("UIStroke")
    BStroke.Parent = Box
    BStroke.Color = Color3.fromRGB(50, 50, 50)

    Box.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Box.Text = "  " .. text .. " [ON]"
            Box.TextColor3 = Color3.fromRGB(0, 255, 150)
            BStroke.Color = Color3.fromRGB(0, 150, 255)
        else
            Box.Text = "  " .. text .. " [OFF]"
            Box.TextColor3 = Color3.fromRGB(255, 255, 255)
            BStroke.Color = Color3.fromRGB(50, 50, 50)
        end
        callback(state)
    end)
end

-- FITUR TELEPORT (BARU)
CreateCheckbox("Teleport", function(val)
    _G.TPBack = val
    local target = nil
    task.spawn(function()
        while _G.TPBack do
            task.wait()
            pcall(function()
                if not target or not target.Character or not target.Character:FindFirstChild("Humanoid") or target.Character.Humanoid.Health <= 0 then
                    local closestDist = math.huge
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                target = p
                            end
                        end
                    end
                end
                
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position)
                end
            end)
        end
    end)
end)

-- FITUR LAINNYA (DARI SEBELUMNYA)
CreateCheckbox("AutoMakro", function(val)
    _G.AutoMakro = val
    task.spawn(function()
        while _G.AutoMakro do
            task.wait()
            pcall(function()
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    if tool:FindFirstChild("Ammo") then tool.Ammo.Value = 999 end
                    if tool:FindFirstChild("Cooldown") then tool.Cooldown.Value = 0 end
                end
            end)
        end
    end)
end)

CreateCheckbox("AimMagnet", function(val)
    _G.AimMagnet = val
    RunService.RenderStepped:Connect(function()
        if _G.AimMagnet then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= 100 then
                        player.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.Head.CFrame * CFrame.new(0, 0, -3)
                    end
                end
            end
        end
    end)
end)

CreateCheckbox("Auto Farm", function(val)
    _G.AutoFarmVerco = val
    task.spawn(function()
        while _G.AutoFarmVerco do
            task.wait()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/canhongson/CanHongSon/refs/heads/main/CanHongSonHub.lua"))()
            end)
            break
        end
    end)
end)

CreateCheckbox("Speed Hack", function(val)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = val and 100 or 16 end
end)

CreateCheckbox("Infinite Jump", function(val)
    _G.InfJump = val
    UserInputService.JumpRequest:Connect(function()
        if _G.InfJump then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)

CreateCheckbox("Noclip", function(val)
    _G.NoclipVerco = val
    RunService.Stepped:Connect(function()
        if _G.NoclipVerco and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

CreateCheckbox("Anti AFK", function(val)
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if val then
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end
    end)
end)
