-----Variables-----
local kScene = ""
local kWarps = {}
local sceneWarps = {}

--Scene Warps Initialization--
require("WarpDeclarations.lua")

sceneWarps["adv_boardingSchoolInterior"] = {kWarp_BoardingSchoolInt_Exit}
sceneWarps["adv_boardingSchoolExteriorDusk"] = {
    kWarp_BoardingSchoolExt_AdminBldg,
    kWarp_BoardingSchoolExt_GateExit,
    kWarp_BoardingSchoolExt_Dorms
}
sceneWarps["adv_boardingSchoolDorm"] = { kWarp_BoardingSchoolDorm_Exit }

--Loops--

--[[
Notes:

These loops certainly *are not* nearly as well optimized / written as they could (and probably should) be.
I'm mostly focused on getting a working result for now - improvements might come in the future,
although no promises! :p
--]]
AmbienceWarps_InputLoop = function() --Input Loop. Should be run *after* the main loop.
    local player = Game_GetPlayer()
    WaitForNextFrame()
    Notification_HideObjective()
    while true do --it's generally a *really* bad idea to do this! they stop all further code from running after being called. use wisely!
        local playerPos = AgentGetWorldPos(player)
        local playerRot = AgentGetWorldRot(player)
        if AmbienceMod_IsDebug then
            local textToSet = AmbienceMod_DebugHeader .. "Position: " .. tostring(playerPos) .. "\nRotation: " .. tostring(playerRot)
            TextSet(AgentFind("textAmb_DebugCornerText"), textToSet)
        end
        for z, theWarp in ipairs(kWarps) do
            local distToAgent = VectorDistance(theWarp["Position"], playerPos)
            if Input_IsVKeyPressed(70) then
                if distToAgent < theWarp["Radius"] then
                    --AmbienceDebug_WarpOutside()
                    theWarp["Activate"]()
                end
            end
        end
        WaitForNextFrame()
    end
end

AmbienceWarps_MainLoop = function() --Main loop. Should be run *before* the input loop.
    local AmbienceWarps_OnPostUpdate = function()
        for x, theWarp in ipairs(kWarps) do
            local agentName = "ambience_warpText_" .. tostring(theWarp["ID"])
            local textAgent = AgentFind(agentName)

            if not textAgent then --A bit of a safety measure to prevent gnarly things from happening. Auto-crashes the game.
                EngineQuit()
            end

            if AmbienceWarps_IsPlayerWithinWarpRadius(textAgent, theWarp) then
            --break
            end
        end
    end

    Callback_OnPostUpdate:Add(AmbienceWarps_OnPostUpdate)
    AmbienceWarps_InputLoop()
end

--Regular Functions--


AmbienceWarps_IsPlayerWithinWarpRadius = function(textAgent, theWarp) --Checks if the player is within the radius of a given warp & updates the UI accordingly.
    local player = Game_GetPlayer()
    local playerPos = AgentGetWorldPos(player)

    local distToAgent = VectorDistance(theWarp["Position"], playerPos)
    if distToAgent < theWarp["Radius"] then
        TextSet(textAgent, theWarp["Message"])
        return true
    else
        TextSet(textAgent, "")
        return false
    end
end

AmbienceWarps_Init = function(theScene) --Initialization Function
    kScene = theScene
    theCamera = SceneGetCamera(kScene)

    if theCamera == nil then
        Ambience_InvokeError("Failed to initialize warps! Broken Camera.")
        return
    end

    if sceneWarps[theScene] ~= nil then
        kWarps = sceneWarps[theScene]
    else
        Ambience_InvokeError("Failed to initialize warps!")
        return
    end

    for x, theWarp in pairs(kWarps) do
        AmbienceWarps_CreateTextAgent("ambience_warpText_" .. tostring(theWarp["ID"]), "", 0, -5, 0)
    end
    
    if AmbienceMod_IsDebug then
        Ambience_CreateVersionText(kScene)
    end

    AmbienceWarps_MainLoop()
end

AmbienceWarps_CreateTextAgent = function(name, text, posx, posy, posz, halign, valign) --Creates a text agent.
    local pos = Vector(posx, posy, posz)
    local textAgent = AgentCreate(name, "ui_text.prop", pos)
    if halign then
        TextSetHorizAlign(textAgent, halign)
    end
    if valign then
        TextSetVertAlign(textAgent, valign)
    end
    TextSet(textAgent, text)
    TextSetColor(textAgent, Ambience_UtilsReturnColorFromRGBA(135, 52, 191, 1))
    return textAgent
end

Ambience_UtilsReturnColorFromRGBA = function(r, g, b, a) --Utility function. Returns Telltale Color from standard RGBA. 0-255 for RGB, 0-1 for alpha.
    return Color((r / 255), (g / 255), (b / 255), a)
end