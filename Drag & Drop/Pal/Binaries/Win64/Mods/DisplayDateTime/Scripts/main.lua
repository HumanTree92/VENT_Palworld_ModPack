-- Author: yakuzadeso

--------------------------------------------------------------------------------
-- Settings
widget_x = -1633.0
widget_y = 508.0

--------------------------------------------------------------------------------

local clientRestarted = false
local ready = false
local Player = nil
local timeManager = nil
local PalUtility = StaticFindObject("/Script/Pal.Default__PalUtility")
local WBP_Ingame_PlayerGauge_KeyGuide_C_new = nil

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(Context)
	-- Player = Context:get().Pawn
	PalUtility = StaticFindObject("/Script/Pal.Default__PalUtility")
	Player = FindFirstOf("PalPlayerCharacter")
	timeManager = PalUtility:GetTimeManager(Player)

	if not clientRestarted then
		print("[DisplayDateTime] DisplayDateTime hooked on Client Restart!")
		if not hooked then
			DoHooks()
		end
	end
	clientRestarted = true
end)

function DoHooks()
	print("[DisplayDateTime] Doing DisplayDateTime hooks!")
	RegisterHook("/Game/Pal/Blueprint/System/BP_PalGameInstance.BP_PalGameInstance_C:StartLoading", function()
		ready = false
		print("[DisplayDateTime] The game is loading..")
	end)

	RegisterHook("/Game/Pal/Blueprint/System/BP_PalGameInstance.BP_PalGameInstance_C:LoadingFinished", function()
		print("[DisplayDateTime] Loading finished! Checking objects..")
		if timeManager ~= nil and timeManager:IsValid() and
			Image_32 ~= nil and Image_32:IsValid() and
			nightIcon ~= nil and nightIcon:IsValid() and
			dayIcon ~= nil and dayIcon:IsValid() and
			WBP_Ingame_PlayerGauge_KeyGuide_C_new ~= nil and WBP_Ingame_PlayerGauge_KeyGuide_C_new:IsValid() then
			ready = true
			print("[DisplayDateTime] Initialization successful!")
		else
			ready = false
			print("[DisplayDateTime] Initialization failed! Some objects are invalid.")
		end
	end)

	RegisterHook("/Game/Pal/Blueprint/UI/UserInterface/InGame/TimeZone/WBP_Ingame_TimeZone.WBP_Ingame_TimeZone_C:OnInitialized", function()
		print("[DisplayDateTime] Timezone object initialized! Constructing widget!")

		dayIcon = StaticFindObject("/Game/Pal/Texture/UI/Main_Menu/T_icon_timezone_daytime.T_icon_timezone_daytime")
		nightIcon = StaticFindObject("/Game/Pal/Texture/UI/Main_Menu/T_icon_timezone_night.T_icon_timezone_night")
		WBP_Ingame_PlayerGauge_KeyGuide_C_base = StaticFindObject("/Game/Pal/Blueprint/UI/UserInterface/InGame/PlayerGauge/WBP_Ingame_PlayerGauge_KeyGuide.WBP_Ingame_PlayerGauge_KeyGuide_C")
		WBP_Ingame_PlayerGauge_KeyGuide_C_new = StaticConstructObject(WBP_Ingame_PlayerGauge_KeyGuide_C_base, FindFirstOf("GameInstance"))
		WBP_Ingame_PlayerGauge_KeyGuide_C_new:AddToViewport(99)
		Image_32 = WBP_Ingame_PlayerGauge_KeyGuide_C_new.WBP_PlayerInputKeyGuideIcon_ChangeBallAiming_1.Image_32
		WBP_Ingame_PlayerGauge_KeyGuide_C_new:SetRenderTranslation({ X = widget_x, Y = widget_y })
	end)

	RegisterHook("/Game/Pal/Blueprint/UI/UserInterface/InGame/TimeZone/WBP_Ingame_TimeZone.WBP_Ingame_TimeZone_C:UpdateTime", function()
		if not ready then
			return
		end

		local day = timeManager:GetCurrentPalWorldTime_Day()
		local hour = timeManager:GetCurrentPalWorldTime_Hour()
		local minute = timeManager:GetCurrentPalWorldTime_Minute()

		if hour < 3 or hour >= 21 then
			Image_32:SetBrushResourceObject(nightIcon)
		else
			Image_32:SetBrushResourceObject(dayIcon)
		end

		local is_am = hour < 12

		if hour > 12 then
			hour = hour - 12
		elseif hour == 0 then
			hour = 12
		end

		local time = string.format("%02d:%02d %s", hour, minute, is_am and "AM" or "PM")
		WBP_Ingame_PlayerGauge_KeyGuide_C_new.Text_KeyGuide:SetText(FText("Real: " .. os.date("%I:%M %p", os.time()) .. "  Game: " .. time))
		--WBP_Ingame_PlayerGauge_KeyGuide_C_new.Text_KeyGuide:SetText(FText("Date: " .. day .. "  Time: " .. time))
	end)
	hooked = true
end
