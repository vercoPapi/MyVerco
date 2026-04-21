local P,R,C=game:GetService("Players"),game:GetService("RunService"),workspace.CurrentCamera
local lp=P.LocalPlayer
local off=Vector3.new(0,0.5,0)

R.RenderStepped:Connect(function()
    local t,d=nil,math.huge
    for _,v in pairs(P:GetPlayers())do
        if v~=lp and v.Character and v.Character:FindFirstChild("Head")and v.Character:FindFirstChild("Humanoid")and v.Character.Humanoid.Health>0 then
            local pos,vis=C:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local m=(Vector2.new(pos.X,pos.Y)-Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)).Magnitude
                if m<d then d=m t=v end
            end
        end
    end
    if t then
        C.CFrame=CFrame.new(C.CFrame.p,t.Character.Head.Position+off)
    end
end)
