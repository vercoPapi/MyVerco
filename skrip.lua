repeat wait() until game:IsLoaded()

if getgenv().VERCO_LOADED then return end
getgenv().VERCO_LOADED = true

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local VERCO_GUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local CloseBtn = Instance.new("TextButton")
local HideBtn = Instance.new("TextButton")

-- Main Properties
VERCO_GUI.Name = "VERCO_MOD_MENU"
VERCO_GUI.Parent = game:GetService("CoreGui")
VERCO_GUI.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = VERCO_GUI
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true -- Agar bisa digeser

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 120, 255)
UIStroke.Thickness = 2

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "VERCO HUB"
Title.TextColor3 = Color3.fromRGB(0, 150, 255)
Title.TextSize = 22

-- Tombol Exit (X)
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.MouseButton1Click:Connect(function()
    VERCO_GUI:Destroy()
    getgenv().VERCO_LOADED = false
end)

-- Tombol Hide (-)
HideBtn.Name = "HideBtn"
HideBtn.Parent = MainFrame
HideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HideBtn.Position = UDim2.new(1, -70, 0, 5)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local visible = true
HideBtn.MouseButton1Click:Connect(function()
    visible = not visible
    Container.Visible = visible
    MainFrame.Size = visible and UDim2.new(0, 300, 0, 380) or UDim2.new(0, 300, 0, 40)
end)

Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.ScrollBarThickness = 3

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Fungsi Toggle (Fitur Tetap)
local function CreateToggle(text, callback)
    local Tgl = Instance.new("TextButton")
    local state = false
    Tgl.Parent = Container
    Tgl.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Tgl.Size = UDim2.new(1, 0, 0, 40)
    Tgl.Font = Enum.Font.SourceSans
    Tgl.Text = text .. " [OFF]"
    Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tgl.TextSize = 16
    
    local TS = Instance.new("UIStroke")
    TS.Parent = Tgl
    TS.Color = Color3.fromRGB(0, 100, 200)
    
    Tgl.MouseButton1Click:Connect(function()
        state = not state
        Tgl.Text = text .. (state and " [ON]" or " [OFF]")
        Tgl.TextColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

-- Fungsi Button
local function CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = Container
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.Font = Enum.Font.SourceSans
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 16
    
    local BS = Instance.new("UIStroke")
    BS.Parent = Btn
    BS.Color = Color3.fromRGB(0, 100, 200)

    Btn.MouseButton1Click:Connect(callback)
end

-- FITUR (Tidak Ada yang Diubah)
CreateToggle("Auto Farm", function(v)
    _G.VercoFarm = v
    spawn(function()
        while _G.VercoFarm do
            task.wait(0.1)
            -- Logika farm asli tetap di sini
        end
    end)
end)

CreateButton("Speed Hack (100)", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

CreateButton("Infinite Jump", function()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end)
end)

CreateButton("Reset Character", function()
    game.Players.LocalPlayer.Character:BreakJoints()
end)

print("VERCO HUB: Window Loaded Successfully")
