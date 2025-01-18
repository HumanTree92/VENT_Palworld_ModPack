-- This file is really only needed on the server

-- Constants
local ModFunctionName = "palegginfo_connect"

-- Stored Refs
local Connector = nil

-- Log message to UE4SS log file
local DEBUG_MODE = false
local function Log(message)
    print("[PalEggInfo:Lua][LOG] " .. message)
end
local function Error(message)
    print("[PalEggInfo:Lua][ERROR] " .. message)
end
local function Debug(message)
    if DEBUG_MODE then
        print("[PalEggInfo:Lua][DEBUG] " .. message)
    end
end


-- Store a reference to the Connector in Lua
-- (Usage meant for on a Server)
RegisterCustomEvent("LUA_PEI_StoreConnectorRef", function (Context)
    Connector = Context:get()
    Debug("Stored Connector")
end)

-- Hook for when this function gets called on the Server by a Client with the mod
-- (Usage meant for on a Server)
RegisterHook("/Script/Pal.PalNetworkBaseCampComponent:Request_Server_void", function (Context, _, FunctionName)
    Debug("Hook with: " .. FunctionName:get():ToString())

    -- Ensure the Request is about THIS Mod
    if ModFunctionName ~= FunctionName:get():ToString() then return end
    Debug("Function seen")

    -- Ensure the stored Connector reference is valid
    if Connector == nil or not Connector:IsValid() then Error("Connector invalid") return end
    Debug("Connector valid")

    -- Get the Network Transmitter for the Client, and ensure it is valid
    local NetworkTransmitter = Context:get():GetOuter()
    if not NetworkTransmitter:IsValid() then Error("Transmitter invalid") return end
    Debug("Transmitter valid")

    -- Get the Client Player Controller, and ensure it is valid
    local ClientPPC = NetworkTransmitter.Owner
    if not ClientPPC:IsValid() then Error("Client PPC invalid") return end
    Debug("Client PPC valid")

    -- Tell the Server the Client has the mod
    Connector:SERVER_AcknowledgeClient(ClientPPC)
    Debug("Tried to ACK")
end)
