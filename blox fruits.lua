local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Isaac's Blox Fruits (Xeno-Optimized)",
   LoadingTitle = "Bypassing Server Sanity Checks...",
   LoadingSubtitle = "March 2026 Build",
   ConfigurationSaving = { Enabled = false }
})

-- // Services & Global Settings
local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

getgenv().Config = {
    Farm = false,
    Chest = false,
    Quest = "Bandit",
    NPC = "Bandit Quest Giver",
    Index = 1,
    Distance = 12
}

-- // Tabs
local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362343)

-- // UI Elements
MainTab:CreateToggle({
   Name = "Enable God-Mode Farm",
   CurrentValue = false,
   Callback = function(Value) getgenv().Config.Farm = Value end,
})

MainTab:CreateDropdown({
   Name = "Select Quest",
   Options = {"Bandit", "Gorilla"},
   CurrentOption = {"Bandit"},
   Callback = function(Option)
      getgenv().Config.Quest = Option[1]
      getgenv().Config.NPC = (Option[1] == "Bandit") and "Bandit Quest Giver" or "Adventurer"
      getgenv().Config.Index = (Option[1] == "Bandit") and 1 or 2
   end,
})

UtilityTab:CreateToggle({
   Name = "Slow Chest Farm",
   CurrentValue = false,
   Callback = function(Value) getgenv().Config.Chest = Value end,
})

-- // THE FIX: Modern 2026 Combat Logic
local function AttackTarget(target)
    pcall(function()
        local tool = Player.Character:FindFirstChildOfClass("Tool")
        if tool then
            -- 1. Scale the enemy's hitbox so we can't miss (The 'Magical' method)
            if target:FindFirstChild("HumanoidRootPart") then
                target.HumanoidRootPart.Size = Vector3.new(30, 30, 30)
                target.HumanoidRootPart.CanCollide = false
            end
            
            -- 2. Use the Tool's internal activation (much harder for server to block)
            tool:Activate()
            
            -- 3. Ping the Validator to keep the session alive
            RS.Remotes.Validator:FireServer(math.floor(tick()))
        end
    end)
end

-- // THE FIX: Verified Quest Logic
local function GetQuest()
    local questUI = Player.PlayerGui.Main:FindFirstChild("Quest")
    if not questUI or not questUI.Visible then
        local npc = workspace:FindFirstChild(getgenv().Config.NPC)
        if npc then
            -- Hover at NPC to trigger proximity
            Player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
            task.wait(0.5) -- Essential wait for the server to acknowledge you
            RS.Remotes.CommF_:InvokeServer("StartQuest", getgenv().Config.Quest, getgenv().Config.Index)
        end
    end
end

-- // THE FIX: Anti-Kick Movement
local function MoveTo(targetCFrame)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        -- Instead of just snapping, we add a small jitter to look 'active'
        Player.Character.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(math.random(-1,1)/10, 0, math.random(-1,1)/10)
    end
end

-- // Main Thread
task.spawn(function()
    while true do
        task.wait()
        if not getgenv().Config.Farm and not getgenv().Config.Chest then continue end
        
        if getgenv().Config.Farm then
            GetQuest()
            
            local enemy = nil
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    enemy = v break
                end
            end
            
            if enemy then
                -- Equip Tool
                local tool = Player.Backpack:FindFirstChildOfClass("Tool")
                if tool then Player.Character.Humanoid:EquipTool(tool) end
                
                -- Farm Position
                MoveTo(enemy.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().Config.Distance, 0))
                AttackTarget(enemy)
            end
            
        elseif getgenv().Config.Chest then
            for _, obj in pairs(game:GetDescendants()) do
                if getgenv().Config.Chest and obj.Name:find("Chest") and obj:FindFirstChild("TouchInterest") then
                    MoveTo(obj.CFrame)
                    task.wait(0.8) -- Slower speed to stop the Security Kick
                end
            end
        end
    end
end)

-- Anti-AFK
Player.Idled:Connect(function()
    VUser:CaptureController()
    VUser:ClickButton2(Vector2.new())
end)
