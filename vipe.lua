local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Content = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "AceternityDeltaCustom"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "ACETERNITY | " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

Content.Parent = MainFrame
Content.Position = UDim2.new(0, 10, 0, 60)
Content.Size = UDim2.new(1, -20, 1, -70)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2
Content.CanvasSize = UDim2.new(0, 0, 1.5, 0)

UIListLayout.Parent = Content
UIListLayout.Padding = UDim.new(0, 8)

local function CreateToggle(name, callback)
    local Button = Instance.new("TextButton")
    local Corner = Instance.new("UICorner")
    Button.Name = name
    Button.Parent = Content
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Button.Text = "  " .. name
    Button.TextColor3 = Color3.fromRGB(150, 150, 150)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    
    local active = false
    Button.MouseButton1Click:Connect(function()
        active = not active
        Button.TextColor3 = active and Color3.fromRGB(0, 255, 159) or Color3.fromRGB(150, 150, 150)
        callback(active)
    end)
end

local function CreateSlider(name, min, max, callback)
    local Frame = Instance.new("Frame")
    local Label = Instance.new("TextLabel")
    local SliderBtn = Instance.new("TextButton")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Content
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = name
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.Parent = Frame
    SliderBtn.Size = UDim2.new(1, 0, 0, 20)
    SliderBtn.Position = UDim2.new(0, 0, 0, 25)
    SliderBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SliderBtn.Text = "Drag to Set"
    SliderBtn.TextColor3 = Color3.new(1, 1, 1)
    SliderBtn.Parent = Frame
    Instance.new("UICorner", SliderBtn).CornerRadius = UDim.new(0, 5)
    SliderBtn.MouseButton1Click:Connect(function()
        local input = math.clamp((game.Players.LocalPlayer:GetMouse().X - SliderBtn.AbsolutePosition.X) / SliderBtn.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * input)
        SliderBtn.Text = tostring(val)
        callback(val)
    end)
end

local function CreateButton(name, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = Content
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.Text = name
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    Button.MouseButton1Click:Connect(callback)
end

local LP = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local AimActive = false
local TornadoActive = false
local WallActive = false
local EspActive = false

CreateToggle("Aimbot Head (Visible)", function(state)
    AimActive = state
    task.spawn(function()
        while AimActive do
            local target = nil
            local dist = math.huge
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                    local pos, visible = Camera:WorldToViewportPoint(v.Character.Head.Position)
                    if visible then
                        local ray = RaycastParams.new()
                        ray.FilterType = Enum.RaycastFilterType.Exclude
                        ray.FilterDescendantsInstances = {LP.Character, v.Character}
                        if not workspace:Raycast(Camera.CFrame.Position, (v.Character.Head.Position - Camera.CFrame.Position).Unit * 1000, ray) then
                            local mag = (Vector2.new(LP:GetMouse().X, LP:GetMouse().Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                            if mag < dist then target = v dist = mag end
                        end
                    end
                end
            end
            if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
            task.wait()
        end
    end)
end)

CreateButton("Execute MS100", function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if (v.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude <= 100 then
                v.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            end
        end
    end
end)

CreateToggle("Tornado Mode", function(state)
    TornadoActive = state
    task.spawn(function()
        while TornadoActive do
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(50), 0)
            end
            task.wait()
        end
    end)
end)

CreateToggle("Wallhack (No Fall)", function(state)
    WallActive = state
    game:GetService("RunService").Stepped:Connect(function()
        if WallActive and LP.Character then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

CreateSlider("Drone Camera Distance", 0, 20, function(val)
    Camera.FieldOfView = 70 + (val * 2)
    LP.CameraMaxZoomDistance = 12.8 + (val * 15)
end)

CreateButton("Anti Lag System", function()
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") then
            v.Enabled = false
        end
    end
end)

CreateToggle("ESP Line & Box 3D White", function(state)
    EspActive = state
    task.spawn(function()
        while EspActive do
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if not v.Character:FindFirstChild("3DESP") then
                        local h = Instance.new("Folder", v.Character); h.Name = "3DESP"
                        local b = Instance.new("BoxHandleAdornment", h)
                        b.Size = v.Character:GetExtentsSize(); b.Adornee = v.Character; b.AlwaysOnTop = true; b.Color3 = Color3.new(1,1,1); b.Transparency = 0.5
                        local l = Instance.new("LineHandleAdornment", h)
                        l.Length = 0; l.Thickness = 2; l.Adornee = v.Character.HumanoidRootPart; l.AlwaysOnTop = true; l.Color3 = Color3.new(1,1,1)
                        task.spawn(function()
                            while EspActive and v.Character and h do
                                l.CFrame = CFrame.new(Vector3.new(), (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position))
                                l.Length = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                                task.wait()
                            end
                            h:Destroy()
                        end)
                    end
                end
            end
            task.wait(1)
        end
    end)
end)

CreateButton("Hide Menu (RightCtrl)", function() ScreenGui.Enabled = not ScreenGui.Enabled end)
CreateButton("Exit Script", function() ScreenGui:Destroy() end)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then ScreenGui.Enabled = not ScreenGui.Enabled end
end)
