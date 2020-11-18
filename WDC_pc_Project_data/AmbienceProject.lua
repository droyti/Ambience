--[[
AmbienceProject.lua
A set of essential utilities for the mod Ambience.

Copyright (C) 2020 Droyti - MIT License.
--]]
--Constants--

AmbienceMod_IsDebug       = true
AmbienceMod_VersionString = "Preview Build 1"
AmbienceMod_DebugHeader   = "Ambience " .. AmbienceMod_VersionString .. "\nMod contents subject to change.\n"

--Vanilla Scene Agents (to be removed)--

local kSceneAgents = {}
kSceneAgents["adv_boardingSchoolDorm"] = {
    "AJ",
    "obj_coffeeStation",
    "obj_doorEntranceBoardingSchoolDorm",
    "Louis"
}
kSceneAgents["adv_boardingSchoolExteriorDusk"] = {
    "AJ",
    "Aasim",
    "Brody",
    "Marlon",
    "Mitch",
    "Omar",
    "Ruby",
    "Tennyson",
    "Violet",
    "Willy",
    "Louis",
    "obj_bannerRaiders",
    "obj_gatePedestrianBarricadeBoardingSchoolExteriorNight"
}
kSceneAgents["adv_boardingSchoolInterior"] = {
    "AJ",
    "Louis",
    "Ruby",
    "Marlon", 
    "Rosie",
    "obj_logicalPainting",
    "obj_logicalDeadEnd",
    "obj_logicalDiplomas",
    "obj_logicalWindowHall",
    "obj_flowersDaffodilFake"
    }

--Functions--

Ambience_RemoveVanillaAgents = function(theScene) --Removes the previously listed unwanted agents in a given scene.
    local kCollisionsEnabled = "Collisions Enabled"
    for _, agent in ipairs(kSceneAgents[theScene]) do
        local props = AgentGetProperties(agent)
        PropertyRemove(props, kCollisionsEnabled)
        AgentHide(agent, true)
        AgentDetach(agent)
    end
end

Ambience_DisplaySceneWelcome = function() --Displays a dialog box with welcoming info for new users.
    if ResourceSetEnabled("ProjectSeason4") then
        Game_PushMode(eModeDialogBox)
    end
    DialogBox_Okay(
        "This mod allows you to roam Ericson's Boarding School freely, without the pressures of the story. Sit back, relax, and enjoy the scenery!",
        "Welcome to Ambience!"
    )
    Game_PopMode(eModeDialogBox)
end

Ambience_InvokeError = function(errorText) --Notifies the user of an error.
    DialogBox_Okay(errorText, "Ambience Error")
end

--Debug Functions--

Ambience_CreateVersionText = function(theScene) --Creates version text visible in upper left. DEBUG MODE ONLY!
    if not AmbienceMod_IsDebug then
        return false
    end

    local CreateTextAgent = function(name, text, posx, posy, posz, halign, valign)
        local pos = Vector(posx, posy, posz)
        local textAgent = AgentCreate(name, "ui_text.prop", pos)
        if halign then
            TextSetHorizAlign(textAgent, halign)
        end
        if valign then
            TextSetVertAlign(textAgent, valign)
        end
        TextSet(textAgent, text)
        return textAgent
    end

    local debugText = CreateTextAgent("textAmb_DebugCornerText", "Ambience Development Build 1", -9.2, 5, 0, 0, 0)
end
