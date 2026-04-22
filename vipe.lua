local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ACETERNITY UI | " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
   LoadingTitle = "Delta Mod Menu",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

local Tab = Window:CreateTab("Menu All", 4483362458)

local AimbotEnabled = false
local TornadoEnabled = false
local ESPEnabled = false

-- [ LOGIKA AIMBOT SMART ] --
local function GetClosestPlayer()
    local target = nil
    local shortestDistance = math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local ray = Ray.new(workspace.CurrentCamera.CFrame.Position, (v.Character.Head.Position - workspace.CurrentCamera.CFrame.Position).unit * 500)
                local hit = workspace:FindPartOnRayWithIgnoreList(ray, {game.Players.LocalPlayer.Character})
                if hit and hit:IsDescendantOf(v.Character) then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)).magnitude
                    if distance < shortestDistance then
                        target = v.Character.Head
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return target
end

game:GetService("RunService").RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = GetClosestPlayer()
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
        end
    end
end)

-- [ FITUR SECTIONS ] --

Tab:CreateToggle({
   Name = "Aimbot (Lock Head & Visible)",
   CurrentValue = false,
   Callback = function(Value)
      AimbotEnabled = Value
   end,
})

Tab:CreateButton({
   Name = "Ms100 (Pull Enemy 100m)",
   Callback = function()
      for _, v in pairs(game.Players:GetPlayers()) do
         if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist <= 100 then
               v.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            end
         end
      end
   end,
})

Tab:CreateToggle({
   Name = "Tornado (Spin)",
   CurrentValue = false,
   Callback = function(Value)
      TornadoEnabled = Value
      task.spawn(function()
         while TornadoEnabled do
            if game.Players.LocalPlayer.Character then
               game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
            end
            task.wait()
         end
      end)
   end,
})

Tab:CreateButton({
   Name = "Wallhack (NoClip All)",
   Callback = function()
      game:GetService("RunService").Stepped:Connect(function()
         if game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
               if v:IsA("BasePart") then v.CanCollide = false end
            end
         end
      end)
   end,
})

Tab:CreateSlider({
   Name = "Drone Camera",
   Range = {0, 20},
   Increment = 1,
   CurrentValue = 0,
   Callback = function(Value)
      game.Players.LocalPlayer.CameraMaxZoomDistance = Value * 50
      game.Players.LocalPlayer.CameraMinZoomDistance = Value * 50
   end,
})

Tab:CreateButton({
   Name = "Anti Lag (Boost FPS)",
   Callback = function()
      settings().Rendering.QualityLevel = 1
      for _, v in pairs(game:GetDescendants()) do
         if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
         elseif v:IsA("Decal") then
            v:Destroy()
         end
      end
   end,
})

Tab:CreateToggle({
   Name = "Esp Line & Box (White 3D)",
   CurrentValue = false,
   Callback = function(Value)
      ESPEnabled = Value
      while ESPEnabled do
         for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
               if not v.Character:FindFirstChild("ESPHolder") then
                  local holder = Instance.new("Folder", v.Character)
                  holder.Name = "ESPHolder"
                  
                  local box = Instance.new("BoxHandleAdornment", holder)
                  box.Adornee = v.Character
                  box.AlwaysOnTop = true
                  box.Size = v.Character:GetExtentsSize()
                  box.Color3 = Color3.new(1, 1, 1)
                  box.Transparency = 0.5
                  
                  local line = Instance.new("LineHandleAdornment", holder)
                  line.Adornee = v.Character.HumanoidRootPart
                  line.AlwaysOnTop = true
                  line.Length = 10
                  line.Thickness = 2
                  line.Color3 = Color3.new(1, 1, 1)
               end
            end
         end
         task.wait(1)
         if not ESPEnabled then
            for _, v in pairs(game.Players:GetPlayers()) do
               if v.Character and v.Character:FindFirstChild("ESPHolder") then
                  v.Character.ESPHolder:Destroy()
               end
            end
         end
      end
   end,
})

Tab:CreateSection("System")

Tab:CreateKeybind({
   Name = "Hide Menu",
   CurrentKeybind = "RightControl",
   HoldToInteract = false,
   SaveCustomKeybind = false,
   Callback = function(Keybind)
      Rayfield:ToggleUI()
   end,
})

Tab:CreateButton({
   Name = "Exit Mod Menu",
   Callback = function()
      Rayfield:Destroy()
   end,
})
