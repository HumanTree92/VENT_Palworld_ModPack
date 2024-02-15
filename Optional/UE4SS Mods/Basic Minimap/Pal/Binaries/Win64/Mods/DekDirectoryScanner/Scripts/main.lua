---
--- DekModConfigMenu
--- Author: dekitarpg@gmail.com
--- This "mod" provides an all important helper function to allow
--- .pak file logic mods to scan local directories for files.
--- THIS IS REQUIRED BY THE MOD CONFIG MENU TO WORK PROPERLY!
---

---
-- Helper functions for logging / errors
---
local LOG_PREFIX = "[DekModConfigMenu] "
local function Log(message) print(LOG_PREFIX .. message .. "\n") end
local function Error(message) error(LOG_PREFIX .. message .. "\n") end

---
-- GetModDirectories() 
-- Returns the games LogicMods and LuaMods directories
--- 
local function GetModDirectories() 
    -- get the game directory tree as a table 
    local Dirs = IterateGameDirectories();
    if not Dirs then Error("Issue scanning directories!") end
    -- scan for logic mods folder
    -- throw error if not found
    local LogicModsDir = Dirs.Game.Content.Paks.LogicMods
    if not LogicModsDir then Error("Unable to find Content/Paks/LogicMods directory!") end
    -- scan for lua mods folder
    -- throw error if not found
    local LuaModsDir
    if Dirs.Game.Binaries.WinGDK then 
        Log("Reading LUA Mod config from: WinGDK!")
        LuaModsDir = Dirs.Game.Binaries.WinGDK.Mods
    elseif Dirs.Game.Binaries.Win64 then 
        Log("Reading LUA Mod config from: Win64!")
        LuaModsDir = Dirs.Game.Binaries.Win64.Mods
    end
    if not LuaModsDir then Error("Unable to find LUA Mods directory!") end
    -- return the mod directories
    return LogicModsDir, LuaModsDir
end

---
-- Register the custom event to scan for config files
---
RegisterCustomEvent("DekScanModDirectories", function(ParamContext, OutArrayParam)
    ---
    -- Ensure OutArrayParam is of type TArray
    ---
    local OutArray = OutArrayParam:get()
    if OutArray:type() ~= "TArray" then 
        Error("DekScanModDirectories OutParam#1 must be TArray but was " .. OutArray:type()) 
    end
    ---
    -- Load configurations for mods.
    ---
    LogicModsDir, LuaModsDir = GetModDirectories()
    local NoModError = "[DekScanDirectory] Issue locating mod directories.\n"
    if not LogicModsDir then error(NoModError) end
    if not LuaModsDir then error(NoModError) end
    ---
    -- store the mod config file paths found
    ---
    local ConfigurableMods = {}
    ---
    -- iterate over each lua mods folder to search for its modconfig file
    ---
    for _, ModFolder in pairs(LuaModsDir) do
        local FolderName = ModFolder.__name
        Log("FOUND ModFolder: " .. FolderName)
        -- iterate over each mod folders inner files 
        -- normally only enabled.txt, and a Scripts folder with main.lua file
        -- but we only care about .modconfig.json files 
        for _, PotentialConfigFile in pairs(ModFolder.__files) do
            local FileName = PotentialConfigFile.__name
            if string.find(FileName, "modconfig.json") then
                Log("FOUND LUA MOD CONFIG: " .. FileName)
                table.insert(ConfigurableMods, PotentialConfigFile.__absolute_path)
            else
                Log("IGNORING: Mods/" .. FolderName .. "/" .. FileName)
            end
        end
    end
    ---
    -- iterate over logic mod folder to search for modconfig files
    ---
    for _, PotentialConfigFile in pairs(LogicModsDir.__files) do
        local FileName = PotentialConfigFile.__name
        if string.find(FileName, "modconfig.json") then
            Log("FOUND BP MOD CONFIG: " .. FileName)
            table.insert(ConfigurableMods, PotentialConfigFile.__absolute_path)
        else
            Log("IGNORING: LogicMods/" .. FileName)
        end
    end
    --- 
    -- update OutArrayParam to list the scanned file paths
    --- 
    OutArrayParam:get():ForEach(function(i, v)
        if ConfigurableMods[i] then 
            v:set(ConfigurableMods[i]) 
            Log("ADDED: " .. ConfigurableMods[i])
        end
    end)
end)
