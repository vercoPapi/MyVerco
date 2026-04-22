repeat wait() until game:IsLoaded()

-- Pencegahan Double Load
if getgenv().VERCO_LOADED then return end
getgenv().VERCO_LOADED = true

-- Bagian FITUR ASLI: Discord Invite (dari loader asli)
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
if request then
    request({
        Url = "http://127.0.0.1:6463/rpc?v=1",
        Method = "POST",
        Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"},
        Body = game:GetService("HttpService"):JSONEncode({
            cmd = "INVITE_BROWSER",
            args = {code = "m573mNfUvS"},
            nonce = game:GetService("HttpService"):GenerateGUID(false)
        }),
    })
end

-- UI CONSTRUCT (Hitam & Biru)
local VERCO_GUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local CloseBtn = Instance.new("TextButton")
local HideBtn = Instance.new("TextButton")

VERCO_GUI.Name = "VERCO_HUB"
VERCO_GUI.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = VERCO_GUI
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 150, 255)
UIStroke.Thickness = 2

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "VERCO HUB"
Title.TextColor3 = Color3.fromRGB(0, 150, 255)
Title.TextSize = 20

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

HideBtn.Parent = MainFrame
HideBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HideBtn.Position = UDim2.new(1, -70, 0, 5)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local isHidden = false
HideBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    Container.Visible = not isHidden
    MainFrame.Size = isHidden and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 400)
end)

Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.ScrollBarThickness = 2

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Checkbox System
local function CreateCheckbox(text, callback)
    local CheckFrame = Instance.new("Frame")
    local Label = Instance.new("TextLabel")
    local Box = Instance.new("TextButton")
    local CheckMark = Instance.new("Frame")
    local enabled = false

    CheckFrame.Parent = Container
    CheckFrame.BackgroundTransparency = 1
    CheckFrame.Size = UDim2.new(1, 0, 0, 35)

    Label.Parent = CheckFrame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Font = Enum.Font.SourceSans
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left

    Box.Parent = CheckFrame
    Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Box.Position = UDim2.new(1, -35, 0.5, -12)
    Box.Size = UDim2.new(0, 25, 0, 25)
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
        CheckMark:TweenSize(enabled and UDim2.new(0, 15, 0, 15) or UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.1, true)
        callback(enabled)
    end)
end

-- FITUR ASLI (Diambil dari CanHongSonHub)
CreateCheckbox("Auto Farm (Asli)", function(state)
    _G.AutoFarm = state
    -- Eksekusi kode loop asli
    task.spawn(function()
        while _G.AutoFarm do
            task.wait()
            -- Link ke file fungsional utama milik CanHongSon
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/canhongson/CanHongSon/refs/heads/main/CanHongSonHub.lua"))()
            end)
            break -- Jalankan sekali untuk memicu fungsi aslinya
        end
    end)
end)

CreateCheckbox("Speed Hack", function(state)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = state and 100 or 16
end)

CreateCheckbox("Infinite Jump", function(state)
    _G.InfJump = state
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.InfJump then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)

CreateCheckbox("Anti Afk", function(state)
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        if state then
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end
    end)
end)
