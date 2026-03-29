local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Elite Utility",
   LoadingTitle = "Loading Systems...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Movement", 4483362458)

-- Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hum = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local flying = false
local noclip = false
local flySpeed = 50
local active = true

-- Refresh character references on respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    hum = newChar:WaitForChild("Humanoid")
    root = newChar:WaitForChild("HumanoidRootPart")
end)

-- Main Loop (Fly & Noclip logic)
local runConnection
runConnection = game:GetService("RunService").Stepped:Connect(function()
    if not active then runConnection:Disconnect() return end

    -- Fly Logic
    if flying and character and root then
        local moveDir = Vector3.new(0,0,0)
        local input = game:GetService("UserInputService")
        
        if input:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
        if input:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
        if input:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
        if input:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
        
        local bg = root:FindFirstChild("FlyGyro") or Instance.new("BodyGyro", root)
        bg.Name = "FlyGyro"
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = camera.CFrame
        
        local bv = root:FindFirstChild("FlyVel") or Instance.new("BodyVelocity", root)
        bv.Name = "FlyVel"
        bv.velocity = moveDir * flySpeed
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    else
        if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
        if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
    end

    -- Noclip Logic
    if noclip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- GUI Elements
MainTab:CreateSection("Flight")
MainTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(Value) flying = Value end,
})

MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 500},
   Increment = 10,
   CurrentValue = 50,
   Callback = function(Value) flySpeed = Value end,
})

MainTab:CreateSection("Character")
MainTab:CreateToggle({
   Name = "Noclip (Phase through walls)",
   CurrentValue = false,
   Callback = function(Value) noclip = Value end,
})

MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value) hum.WalkSpeed = Value end,
})

MainTab:CreateButton({
   Name = "Kill Script",
   Callback = function()
      active = false
      flying = false
      noclip = false
      hum.WalkSpeed = 16
      if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
      if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
      Rayfield:Destroy()
   end,
})
