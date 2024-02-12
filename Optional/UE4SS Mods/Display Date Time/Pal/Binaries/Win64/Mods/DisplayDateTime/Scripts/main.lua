-- Author: yakuzadeso

local clientRestarted = false
local Player = nil
local timeManager = nil
local PalUtility = StaticFindObject("/Script/Pal.Default__PalUtility")

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(Context)
	Player = Context:get().Pawn

	if not clientRestarted then
		print("[DisplayDateTime] DisplayDateTime hooked on Client Restart!")
		if not hooked then
			DoHooks()
		end
	end

	clientRestarted = true
end)

function DoHooks()
	NotifyOnNewObject("/Game/Pal/Blueprint/UI/UserInterface/InGame/TimeZone/WBP_Ingame_TimeZone.WBP_Ingame_TimeZone_C", function()
		if not PalUtility then
			PalUtility = StaticFindObject("/Script/Pal.Default__PalUtility")
		end

		if not Player or not Player:IsValid() then
			Player = FindFirstOf("PalPlayerCharacter")
		end

		timeManager = PalUtility:GetTimeManager(Player)
		dayIcon = StaticFindObject("/Game/Pal/Texture/UI/Main_Menu/T_icon_timezone_daytime.T_icon_timezone_daytime")
		nightIcon = StaticFindObject("/Game/Pal/Texture/UI/Main_Menu/T_icon_timezone_night.T_icon_timezone_night")
		WBP_Ingame_PlayerGauge_KeyGuide_C_base = "/Game/Pal/Blueprint/UI/UserInterface/InGame/PlayerGauge/WBP_Ingame_PlayerGauge_KeyGuide.WBP_Ingame_PlayerGauge_KeyGuide_C"
		WBP_Ingame_PlayerGauge_KeyGuide_C_new = StaticConstructObject(StaticFindObject(WBP_Ingame_PlayerGauge_KeyGuide_C_base), FindFirstOf("GameInstance"))
		WBP_Ingame_PlayerGauge_KeyGuide_C_new:AddToViewport(99)
		Image_32 = WBP_Ingame_PlayerGauge_KeyGuide_C_new.WBP_PlayerInputKeyGuideIcon_ChangeBallAiming_1.Image_32
		WBP_Ingame_PlayerGauge_KeyGuide_C_new:SetRenderTranslation({ X = -1570.0, Y = 508.0 })
		print("[DisplayDateTime] Found new TimeZone object! Constructed widget!")
	end)

	RegisterHook("/Game/Pal/Blueprint/UI/UserInterface/InGame/TimeZone/WBP_Ingame_TimeZone.WBP_Ingame_TimeZone_C:UpdateTime", function()
		local hour = timeManager:GetCurrentPalWorldTime_Hour()
		local minute = timeManager:GetCurrentPalWorldTime_Minute()

		if hour < 3 or hour >= 22 then
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
	end)

	print("[DisplayDateTime] Did DisplayDateTime hooks!")
	hooked = true
end
