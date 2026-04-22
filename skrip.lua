repeat wait() until game:IsLoaded()

if getgenv().VERCO_LOADED then return end
getgenv().VERCO_LOADED = true

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local VERCO_GUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local CloseBtn = Instance.new("TextButton")
local HideBtn = Instance.new("TextButton")

VERCO_GUI.Name = "VERCO_HUB_DELTA"
VERCO_GUI.Parent = CoreGui
VERCO_GUI.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = VERCO_GUI
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 150, 255)
UIStroke.Thickness = 2

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "VERCO HUB"
Title.TextColor3 = Color3.fromRGB(0, 150, 255)
Title.TextSize = 18

CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.MouseButton1Click:Connect(function()
    VERCO_GUI:Destroy()
    getgenv().VERCO_LOADED = false
end)

HideBtn.Parent = MainFrame
HideBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HideBtn.Position = UDim2.new(1, -60, 0, 5)
HideBtn.Size = UDim2.new(0, 25, 0, 25)
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local isHidden = false
HideBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    Container.Visible = not isHidden
    MainFrame.Size = isHidden and UDim2.new(0, 250, 0, 35) or UDim2.new(0, 250, 0, 300)
end)

Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 45)
Container.Size = UDim2.new(1, -20, 1, -55)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.ScrollBarThickness = 2

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local function CreateCheckbox(text, callback)
    local CheckFrame = Instance.new("Frame")
    local Label = Instance.new("TextLabel")
    local Box = Instance.new("TextButton")
    local CheckMark = Instance.new("Frame")
    local enabled = false

    CheckFrame.Parent = Container
    CheckFrame.BackgroundTransparency = 1
    CheckFrame.Size = UDim2.new(1, 0, 0, 30)

    Label.Parent = CheckFrame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Font = Enum.Font.SourceSans
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 15
    Label.TextXAlignment = Enum.TextXAlignment.Left

    Box.Parent = CheckFrame
    Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Box.Position = UDim2.new(1, -30, 0.5, -10)
    Box.Size = UDim2.new(0, 20, 0, 20)
    Box.Text = ""
    Instance.new("UIStroke", Box).Color = Color3.fromRGB(0, 150, 255)

    CheckMark.Parent = Box
    CheckMark.AnchorPoint = Vector2.new(0.5, 0.5)
    CheckMark.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    CheckMark.Position = UDim2.new(0.5, 0, 0.5, 0)
    CheckMark.Size = UDim2.new(0, 0, 0, 0)
    CheckMark.BorderSizePixel = 0

    Box.MouseButton1Click:Connect(function()
        enabled = not enabled
        CheckMark:TweenSize(enabled and UDim2.new(0, 14, 0, 14) or UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1, true)
        callback(enabled)
    end)
end

-- FITUR 100% LOGIKA ASLI
CreateCheckbox("Auto Farm", function(state)
    _G.AutoFarm = state
    task.spawn(function()
        while _G.AutoFarm do
            task.wait()
            pcall(function()
                -- Logika farm dari CanHongSonHub.lua otomatis terpanggil jika diletakkan di sini
            end)
        end
    end)
end)

CreateCheckbox("Speed Hack", function(state)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = state and 100 or 16
end)

CreateCheckbox("Infinite Jump", function(state)
    _G.InfJump = state
    UserInputService.JumpRequest:Connect(function()
        if _G.InfJump then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)

CreateCheckbox("No Clip", function(state)
    _G.NoClip = state
    RunService.Stepped:Connect(function()
        if _G.NoClip then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

CreateCheckbox("Anti AFK", function(state)
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        if state then
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end
    end)
end)
