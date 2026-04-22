local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ACETERNITY MOD MENU - " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, "DarkTheme")
local LP = game.Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
_G.Aimbot = false
_G.Tornado = false
_G.ESP = false
local Tab = Window:NewTab("Menu All")
local Combat = Tab:NewSection("Combat")
local Visual = Tab:NewSection("Visuals")
local Misc = Tab:NewSection("Misc & System")
Combat:NewToggle("Aimbot", "Lock Head - No Wall", function(state)
_G.Aimbot = state
RunService.RenderStepped:Connect(function()
if _G.Aimbot then
local target = nil
local dist = math.huge
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= LP and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
local head = v.Character.Head
local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
if onScreen then
local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).unit * 1000)
local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LP.Character})
if hit and hit:IsDescendantOf(v.Character) then
local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
if mouseDist < dist then
target = head
dist = mouseDist
end
end
end
end
end
if target then
Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
end
end
end)
end)
Combat:NewButton("Ms100", "Bawa musuh jarak 100m ke depan", function()
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
local distance = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
if distance <= 100 then
v.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
end
end
end
end)
Visual:NewToggle("Esp Line & Box", "3D Putih Mulus", function(state)
_G.ESP = state
RunService.RenderStepped:Connect(function()
if not _G.ESP then
for _, v in pairs(game.Players:GetPlayers()) do
if v.Character then
if v.Character:FindFirstChild("Box3D") then v.Character.Box3D:Destroy() end
if v.Character:FindFirstChild("Line3D") then v.Character.Line3D:Destroy() end
end
end
return
end
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
if not v.Character:FindFirstChild("Box3D") then
local b = Instance.new("BoxHandleAdornment", v.Character)
b.Name = "Box3D"
b.AlwaysOnTop = true
b.Adornee = v.Character
b.Size = v.Character:GetExtentsSize()
b.Color3 = Color3.new(1, 1, 1)
b.Transparency = 0.6
local l = Instance.new("LineHandleAdornment", v.Character)
l.Name = "Line3D"
l.AlwaysOnTop = true
l.Adornee = v.Character.HumanoidRootPart
l.Length = 15
l.Thickness = 3
l.Color3 = Color3.new(1, 1, 1)
end
end
end
end)
end)
Misc:NewToggle("Tornado", "Berputar kencang", function(state)
_G.Tornado = state
RunService.Heartbeat:Connect(function()
if _G.Tornado and LP.Character then
LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(70), 0)
end
end)
end)
Misc:NewButton("Wallhack", "Tembus dinding", function()
RunService.Stepped:Connect(function()
if LP.Character then
for _, v in pairs(LP.Character:GetDescendants()) do
if v:IsA("BasePart") then
v.CanCollide = false
end
end
end
end)
end)
Misc:NewSlider("DroneCamera", "Jarak Kamera 0-20", 20, 0, function(s)
LP.CameraMaxZoomDistance = s * 25
LP.CameraMinZoomDistance = s * 25
end)
Misc:NewButton("Anti Lag", "Anti Crash & Smooth", function()
local t = workspace:FindFirstChildOfClass('Terrain')
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0
settings().Rendering.QualityLevel = 1
for _, v in pairs(game:GetDescendants()) do
if v:IsA("Part") or v:IsA("MeshPart") then
v.Material = Enum.Material.Plastic
v.Reflectance = 0
elseif v:IsA("Decal") or v:IsA("Texture") then
v:Destroy()
end
end
end)
Misc:NewKeybind("Hide Menu", "RightControl untuk sembunyi", Enum.KeyCode.RightControl, function()
Library:ToggleUI()
end)
Misc:NewButton("Exit", "Hapus Menu", function()
game:GetService("CoreGui"):FindFirstChild("Kavo"):Destroy()
end)
