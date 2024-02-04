----------------------------------------------------------
----------------------------------------------------------
-----------------  AUTHOR: Inhumanity  -------------------
-----------------  MOD: PalInfo        -------------------
-----------------  VERSION: 1.7.2      -------------------
----------------------------------------------------------
----------------------------------------------------------



---- Keybind to toggle mod UI on or off. Just change this to Key.R or whatever else you want
---- To have Modifier keys included add this as a parameter {ModifierKey.CONTROL, ModifierKey.ALT, ModifierKey.SHIFT}
---- Example (CTRL+o keybind):
----          RegisterKeyBind(Key.O, {ModifierKey.CONTROL} function() 
---- Example (L keybind):
----          RegisterKeyBind(Key.L, {}, function() 
RegisterKeyBind(Key.O, {ModifierKey.SHIFT}, function()
    local ModActors = FindAllOf("ModActor_C")
    if not ModActors then
        print("No instances of 'ModActor_C' were found\n")
    else
        for Index, Mod in pairs(ModActors) do
            -- Check that the ModActor is a PalInfo instance
            if Mod.PalInfo ~= nil and Mod.PalInfo then
                Mod.Enabled = not Mod.Enabled
            end
        end
    end
end)

---- Register custom event "PalInfo_LuaConfig" declared in ModActor event graph 
----   - This event is called as a function at start of PostBeginPlay custom event
----   - This event also has a string input for debug that the BP is asking for Lua configs
RegisterCustomEvent("PalInfo_LuaConfig", function(Context, message)
    print(message:get():ToString())

----------------------------------------------------------
------------------ START OF MOD CONFIGS ------------------ 
----------------------------------------------------------

    ---- Whether to enable or disable the mod (true/false)
    local Enabled = true           -- (default: true)

    ---- Whether to hide certain aspects of the UI (true/false)
    local HideIcon = false         -- (default: false)
    local HidePalName = false      -- (default: false)
    local HideLevel = false        -- (default: false)
    local HideGender = false       -- (default: false)
    local HideCaught = false       -- (default: false)
    local HidePalsInBox = false    -- (default: false)
    local HideHPText = false       -- (default: false)
    local HideHPBar = false        -- (default: false)
    local HideElements = false     -- (default: false)
    local HideStats = false        -- (default: false)
    local HidePassives = false     -- (default: false)
    local HideDrops = false        -- (default: false)

    ---- Center Align Drops Container (default alignment is justified / fill / left-aligned)
    local CenterDrops = false      -- (default: false)

    ---- UI Background Opacity / Transparency
    local UIOpacity = 0.55         -- (default: 0.55) (any decimal from 0 to 1, inclusive)

    ---- Distance to trigger UI
    local LookDistance = 15000     -- (default: 15000) (any positive number greater than 1, higher is further)

    ---- Number of seconds until UI hides after looking away
    local UntilHideDuration = 5    -- (default: 5) (any positive number greater than 0.1, higher is longer)
    
    ---- Position of the UI (like pixels) from its TOP LEFT corner
    ---- X = 0, Y = 0 is usually the TOP LEFT corner of the SCREEN
    local UI_X_Position = 4        -- (default: 4)
    local UI_Y_Position = 4        -- (default: 4)

    ---- UI Scale (like %) - this messes with UI Position so considering messing with those values too
    local UI_X_Scale = 1           -- (default: 1)
    local UI_Y_Scale = 1           -- (default: 1)

----------------------------------------------------------
------------------- END OF MOD CONFIGS ------------------- 
----------------------------------------------------------




----------------------------------------------------------
--------------- DON'T TOUCH ANYTHING BELOW ---------------
----------------------------------------------------------

    -- Get All Mod Actors
    local ModActors = FindAllOf("ModActor_C")
    if not ModActors then
        print("No instances of 'ModActor_C' were found\n")
    else
        for Index, Mod in pairs(ModActors) do
            -- Disable BP Keybind if Lua Configs present
            Mod.DisableBPKeybind = true

            -- Check that the ModActor is a PalInfo instance
            if Mod.PalInfo ~= nil and Mod.PalInfo then
                -- Check if each variable was changed
                if (Enabled ~= nil and type(Enabled) == "boolean") then
                    Mod.Enabled = Enabled
                end
                
                if (HideIcon ~= nil and type(HideIcon) == "boolean") then
                    Mod.HideIcon = HideIcon
                end

                if (HidePalName ~= nil and type(HidePalName) == "boolean") then
                    Mod.HidePalName = HidePalName
                end

                if (HideLevel ~= nil and type(HideLevel) == "boolean") then
                    Mod.HideLevel = HideLevel
                end

                if (HideGender ~= nil and type(HideGender) == "boolean") then
                    Mod.HideGender = HideGender
                end

----------------------------------------------------------
--------------- DON'T TOUCH ANYTHING STILL ---------------
----------------------------------------------------------

                if (HideCaught ~= nil and type(HideCaught) == "boolean") then
                    Mod.HideCaught = HideCaught
                end

                if (HidePalsInBox ~= nil and type(HidePalsInBox) == "boolean") then
                    Mod.HidePalsInBox = HidePalsInBox
                end

                if (HideHPText ~= nil and type(HideHPText) == "boolean") then
                    Mod.HideHPText = HideHPText
                end

                if (HideHPBar ~= nil and type(HideHPBar) == "boolean") then
                    Mod.HideHPBar = HideHPBar
                end

                if (HideElements ~= nil and type(HideElements) == "boolean") then
                    Mod.HideElements = HideElements
                end

                if (HideStats ~= nil and type(HideStats) == "boolean") then
                    Mod.HideStats = HideStats
                end

                if (HidePassives ~= nil and type(HidePassives) == "boolean") then
                    Mod.HidePassives = HidePassives
                end

                if (HideDrops ~= nil and type(HideDrops) == "boolean") then
                    Mod.HideDrops = HideDrops
                end

                if (CenterDrops ~= nil and type(CenterDrops) == "boolean") then
                    Mod.CenterDrops = CenterDrops
                end

                if (UIOpacity ~= nil and type(UIOpacity) == "number") then
                    Mod.Opacity = UIOpacity
                end

                if (LookDistance ~= nil and type(LookDistance) == "number") then
                    Mod.Distance = LookDistance
                end

                if (UntilHideDuration ~= nil and type(UntilHideDuration) == "number") then
                    Mod.TimerDuration = UntilHideDuration
                end

                if (UI_X_Position ~= nil and type(UI_X_Position) == "number") then
                    Mod.X_Pos = UI_X_Position
                end

                if (UI_Y_Position ~= nil and type(UI_X_Position) == "number") then
                    Mod.Y_Pos = UI_Y_Position
                end

                if (UI_X_Scale ~= nil and type(UI_X_Scale) == "number") then
                    Mod.X_Scale = UI_X_Scale
                end

                if (UI_Y_Scale ~= nil and type(UI_Y_Scale) == "number") then
                    Mod.Y_Scale = UI_Y_Scale
                end

                print("[PalInfoConfig] Lua Configs applied")
            end
        end
    end
end)

----------------------------------------------------------
--------------- DON'T TOUCH ANYTHING ABOVE ---------------
----------------------------------------------------------