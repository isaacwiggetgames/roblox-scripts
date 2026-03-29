-- // GaabisHub.lua | v1.0.2
-- // Created by Isaac
-- // Powered by Gemini 3 Flash

local version = "1.0.2"
local cloneref = cloneref or function(...) return ... end

-- Clean Console Header
print([[
  ________             ___.   .__        
 /  _____/_____  _____ \_ |__ |__| ______
/   \  ___\__  \ \__  \ | __ \|  |/  ___/
\    \_\  \/ __ \ / __ \| \_\ \  |\___ \ 
 \______  (____  (____  /___  /__/____  >
        \/     \/     \/    \/        \/ 
]])
print("GaabisHub Loaded | Version: " .. version)
print("Welcome back, Isaac.")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Configuration & Links
local ScriptLinks = {
    SlapBattles = "https://raw.githubusercontent.com/isaacwiggetgames/roblox-scripts/refs/heads/main/slap%20battles.lua",
    BloxFruits = "https://raw.githubusercontent.com/isaacwiggetgames/roblox-scripts/refs/heads/main/blox%20fruits.lua",
    Universal = "https://raw.githubusercontent.com/isaacwiggetgames/roblox-scripts/refs/heads/main/Universal.lua"
}

local GameIDs = {
    SlapBattles = {6403373529, 11520107397, 124596094333302, 9015014224},
    BloxFruits = {2753915549, 4442272183, 7449925053}
}

local function getGameType()
    for name, ids in pairs(GameIDs) do
        if table.find(ids, game.PlaceId) then return name end
    end
    return "Unknown"
end

local detected = getGameType()

local function LoadScript(name)
    local link = ScriptLinks[name]
    if link then
        Rayfield:Notify({
            Title = "GaabisHub",
            Content = "Executing: " .. name,
            Duration = 3,
            Image = 4483362458,
        })
        task.spawn(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(link))()
            end)
            if not success then warn("GaabisHub Error: " .. err) end
        end)
    end
end

-- // Entry Logic
if detected ~= "Unknown" then
    LoadScript(detected)
else
    local Window = Rayfield:CreateWindow({
       Name = "GaabisHub | Multi-Game Loader",
       LoadingTitle = "Identifying Game...",
       LoadingSubtitle = "by Isaac",
       ConfigurationSaving = { Enabled = false }
    })

    local MainTab = Window:CreateTab("Hub Selector", 4483362458)

    MainTab:CreateSection("Status")
    MainTab:CreateLabel("Detected Game: " .. detected)
    MainTab:CreateLabel("Current User: Isaac")

    MainTab:CreateSection("Manual Script Selection")

    MainTab:CreateButton({
       Name = "Launch Slap Battles Script",
       Callback = function() LoadScript("SlapBattles") end,
    })

    MainTab:CreateButton({
       Name = "Launch Blox Fruits Script",
       Callback = function() LoadScript("BloxFruits") end,
    })

    MainTab:CreateButton({
       Name = "Launch Universal Script",
       Callback = function() LoadScript("Universal") end,
    })

    MainTab:CreateSection("Quick Actions")
    MainTab:CreateButton({
       Name = "Infinite Yield",
       Callback = function() 
           loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() 
       end,
    })
end
