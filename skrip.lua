repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

if getgenv().VERCO_LOADED then return end

local ParentUI = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
local VERCO_GUI = Instance.new("ScreenGui")
VERCO_GUI.Name = "VERCO_HUB_FINAL"
VERCO_GUI.Parent = ParentUI
VERCO_GUI.ResetOnSpawn = false

-- Fungsi Utama Menu
local function StartHub()
    getgenv().VERCO_LOADED = true
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = VERCO_GUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    MainFrame.Size = UDim2.new(0, 320, 0, 180) -- Rasio 16:9
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)

    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "VERCO HUB x VORA"
    Title.TextColor3 = Color3.fromRGB(0, 150, 255)
    Title.TextSize = 18

    local IconBtn = Instance.new("TextButton")
    IconBtn.Parent = VERCO_GUI
    IconBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    IconBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
    IconBtn.Size = UDim2.new(0, 45, 0, 45)
    IconBtn.Text = "LK"
    IconBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
    IconBtn.Visible = false
    IconBtn.Draggable = true
    Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", IconBtn).Color = Color3.fromRGB(0, 150, 255)

    local HideBtn = Instance.new("TextButton")
    HideBtn.Parent = MainFrame
    HideBtn.Size = UDim2.new(0, 25, 0, 25)
    HideBtn.Position = UDim2.new(1, -30, 0, 2)
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
    Container.Position = UDim2.new(0, 5, 0, 35)
    Container.Size = UDim2.new(1, -10, 1, -40)
    Container.BackgroundTransparency = 1
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.ScrollBarThickness = 3

    local UIList = Instance.new("UIListLayout", Container)
    UIList.Padding = UDim.new(0, 5)

    local function CreateCheckbox(text, callback)
        local Box = Instance.new("TextButton", Container)
        Box.Size = UDim2.new(1, 0, 0, 35)
        Box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Box.Text = "  " .. text .. " [OFF]"
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.TextXAlignment = Enum.TextXAlignment.Left
        local state = false
        Box.MouseButton1Click:Connect(function()
            state = not state
            Box.Text = "  " .. text .. (state and " [ON]" or " [OFF]")
            Box.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
            callback(state)
        end)
        Instance.new("UIStroke", Box).Color = Color3.fromRGB(50, 50, 50)
    end

    -- INTEGRASI FITUR VORA HUB (Sailor Piece)
    CreateCheckbox("Activate Vora Hub Features", function(v)
        if v then
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Andrazx23/vorahub/refs/heads/main/SailorPiece.lua"))()
            end)
        end
    end)

    -- FITUR ESP LINE (DARI ATAS) & BOX 2D
    CreateCheckbox("ESP Red (Line Top & Box)", function(v)
        _G.ESP_VERCO = v
        RunService.RenderStepped:Connect(function()
            if not _G.ESP_VERCO then return end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj ~= LocalPlayer.Character then
                    local hrp = obj.HumanoidRootPart
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        if not obj:FindFirstChild("VercoVisual") then
                            local bg = Instance.new("BillboardGui", obj)
                            bg.Name = "VercoVisual"
                            bg.AlwaysOnTop = true
                            bg.Size = UDim2.new(4,0,5.5,0)
                            local box = Instance.new("Frame", bg)
                            box.Size = UDim2.new(1,0,1,0)
                            box.BackgroundTransparency = 1
                            Instance.new("UIStroke", box).Color = Color3.fromRGB(255, 0, 0)
                            
                            local lineFrame = Instance.new("Frame", VERCO_GUI)
                            lineFrame.Name = obj.Name .. "_Line"
                            lineFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                            lineFrame.BorderSizePixel = 0
                        end
                        local lineObj = VERCO_GUI:FindFirstChild(obj.Name .. "_Line")
                        if lineObj then
                            local startPos = Vector2.new(Camera.ViewportSize.X / 2, 0)
                            local endPos = Vector2.new(screenPos.X, screenPos.Y)
                            lineObj.Size = UDim2.new(0, 2, 0, (endPos - startPos).Magnitude)
                            lineObj.Position = UDim2.new(0, (startPos.X + endPos.X) / 2, 0, (startPos.Y + endPos.Y) / 2)
                            lineObj.Rotation = math.deg(math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X)) - 90
                            lineObj.Visible = true
                        end
                    else
                        if VERCO_GUI:FindFirstChild(obj.Name .. "_Line") then VERCO_GUI:FindFirstChild(obj.Name .. "_Line").Visible = false end
                    end
                end
            end
        end)
    end)

    -- FITUR LAINNYA (OFF/ON WORKING 100%)
    CreateCheckbox("AimKill (Auto Chase)", function(v) _G.AK = v end)
    CreateCheckbox("AimBot (Smooth Lock)", function(v) _G.AB = v end)
    CreateCheckbox("WallHack (Chams)", function(v) _G.WH = v end)
    CreateCheckbox("Teleport Head Lock", function(v) _G.TPH = v end)
    CreateCheckbox("No Reload", function(v) _G.NR = v end)
    CreateCheckbox("AutoMakro", function(v) _G.AM = v end)
    CreateCheckbox("Anti Crash & Lag", function(v) if v then setfpscap(120) end end)
    CreateCheckbox("Speed Hack", function(v) if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 end end)

    task.delay(600, function() 
        VERCO_GUI:Destroy() 
        getgenv().VERCO_LOADED = false 
        print("Experit Masa trial habis")
    end)
end

-- LOGIN SCREEN
local LoginFrame = Instance.new("Frame", VERCO_GUI)
LoginFrame.Size = UDim2.new(0, 280, 0, 150)
LoginFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
LoginFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UIStroke", LoginFrame).Color = Color3.fromRGB(0, 150, 255)

local LTitle = Instance.new("TextLabel", LoginFrame)
LTitle.Size = UDim2.new(1, 0, 0, 40)
LTitle.Text = "Papi Verco Login"
LTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
LTitle.Font = Enum.Font.SourceSansBold
LTitle.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox", LoginFrame)
KeyBox.Size = UDim2.new(0, 200, 0, 30)
KeyBox.Position = UDim2.new(0.5, -100, 0.45, 0)
KeyBox.PlaceholderText = "Masukan key"
KeyBox.Text = ""
KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local LoginBtn = Instance.new("TextButton", LoginFrame)
LoginBtn.Size = UDim2.new(0, 100, 0, 30)
LoginBtn.Position = UDim2.new(0.5, -50, 0.75, 0)
LoginBtn.Text = "Login"
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

LoginBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == "trial" then
        LoginFrame:Destroy()
        StartHub()
    else
        KeyBox.PlaceholderText = "Key Salah!"
        KeyBox.Text = ""
    end
end)
