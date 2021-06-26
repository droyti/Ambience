--[[
AmbienceProject.lua
A set of essential utilities for the mod Ambience.

Copyright (C) 2020 Droyti - MIT License.
--]]
--Constants--

AmbienceMod_IsDebug       = true
AmbienceMod_VersionString = "Preview Build 2"
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
}

--obj_gatePedestrianBarricadeBoardingSchoolExteriorNight

--[[
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
--]]

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
    "obj_flowersDaffodilFake",
    "adv_boardingSchoolOffice_meshesABalcony",
    "adv_boardingSchoolOffice_meshesACeiling",
    "adv_boardingSchoolOffice_meshesACloth",
    "adv_boardingSchoolOffice_meshesAFloor",
    "adv_boardingSchoolOffice_meshesAFrames",
    "adv_boardingSchoolOffice_meshesAFurniture",
    "adv_boardingSchoolOffice_meshesALamps",
    "adv_boardingSchoolOffice_meshesAOfficeSupplies",
    "adv_boardingSchoolOffice_meshesAShelfStuff",
    "adv_boardingSchoolOffice_meshesAShelves",
    "adv_boardingSchoolOffice_meshesAWalls",
    "adv_commonRoomBoardingSchoolInterior",
    "adv_lobbyBoardingSchoolInterior",
    "adv_secondFloorHallwayBoardingSchoolInterior",
    "adv_stairWellBoardingSchoolInterior",
    "adv_furnitureCommonRoomBoardingSchoolInterior",
    "adv_furnitureLobbyBoardingSchoolInterior",
    "adv_hallwayABoardingSchoolInterior",
    "adv_wallACommonRoomBoardingSchoolInterior",
    "adv_hallwayBBoardingSchoolInterior",
    "adv_lobbyFloorClutterBoardingShoolInterior",
    "adv_wallBCommonRoomBoardingSchoolInterior",
    "adv_lobbyCeilingBoardingSchoolInterior",
    "adv_foliageCommonRoomBoardingSchoolInteriorMesh",
    "adv_foliageHallwayABoardingSchoolInterior",
    "adv_foliageHallwayBBoardingSchoolInterior",
    "obj_piano",
    "obj_doorEntranceABoardingSchoolInterior",
    "obj_matteBoardingSchoolOfficeExterior01",
    "obj_matteBoardingSchoolOfficeExterior02",
    "obj_matteBoardingSchoolOfficeExterior03",
    "obj_chairBoardingSchoolOffice",
    "obj_chairDeskBoardingSchoolOffice",
    "obj_chairFirePlace",
    "obj_arrow"
    }

    
    
--Scene Agents to be added--

local kSceneAgentsToAdd = {}

kSceneAgentsToAdd["adv_drugstoreInterior"] = {
    "adv_drugstoreInterior_meshesA",
    "adv_drugstoreInterior_meshesA_extra1",
    "adv_drugstoreInterior_meshesB",
    "adv_drugstoreInterior_meshesB_extra1",
    "adv_drugstoreInterior_meshesC",
    "adv_drugstoreInterior_meshesC_decals",
    "adv_drugstoreInterior_meshesC_extra1"
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

Ambience_AddAgentsFromScene = function(theScene, theSceneToAdd)
    for i,agent in ipairs(kSceneAgentsToAdd[theSceneToAdd]) do
        local agent0_prop = agent .. '.prop'
        local agent0 =
        AgentCreate(
        agent,
        agent0_prop,
        Vector(0, 0, 0),
        Vector(0, 0, 0),
        sceneObj,
        false,
        false
        )
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

--Sound Handler written by /u/changemymindpls1--

local ambient_prop_kEnabled = "Ambient Sound - Enabled"
local ambient_prop_kFile = "Ambient Sound - File"
local ambient_prop_kPitch = "Ambient Sound - Pitch"
local ambient_prop_kFadeTime = "Ambient Sound - Fade Time"
local ambient_prop_kControllerScene = "Ambient Sound - Controller Scene"
local ambient_prop_kPreviousFile = "Ambient Sound - Previous File"
local ambient_prop_kDelay = "Ambient Sound - Initial Delay"

CustomSound_Ambient_Setup = function(agentName, scene)
    ResourceSetEnable("ProjectSeason1")
    local propFile = "sound_ambient.prop"
    local agent_agent = AgentCreate(agentName, propFile, Vector(0,0,0), Vector(0,0,0), scene, false, false)
end

CustomSound_Ambient_SetProperties = function(agentName, soundFile, fadeTime, pitch, scene)
    local agent = AgentFindInScene(agentName, scene)
    PropertySet(agent.mProps, ambient_prop_kEnabled, true)
    PropertySet(agent.mProps, ambient_prop_kFile, soundFile)
    PropertySet(agent.mProps, ambient_prop_kPreviousFile, soundFile)
    PropertySet(agent.mProps, ambient_prop_kFadeTime, fadeTime)
    PropertySet(agent.mProps, ambient_prop_kPitch, pitch)
end

CustomSound_Ambient_Play = function(agentName, volume, scene)
    local agent = AgentFindInScene(agentName, scene)

    agent.ambientController = SoundPlay((agent.mProps)[ambient_prop_kFile], nil, nil, scene, true)
    local agent_controller = agent.ambientController

    SoundSetPitch(agent_controller, (agent.mProps)[ambient_prop_kPitch])
    
    ControllerSetScene(agent_controller, scene)
    ControllerSetTimeScale(agent_controller, SceneGetTimeScale(scene))
    ControllerDisableTimeSync(agent_controller, false)
    ControllerSetTime(agent_controller, 0.0)
    ControllerDrift(agent_controller, true)
    ControllerSetAmbient(agent_controller, true)
    ControllerSetName(agent_controller, AgentGetName(agent))
    ControllerFadeIn(agent_controller, agent.mProps[ambient_prop_kFadeTime])
    ControllerDisableTimeSync(agent_controller, true)
    ControllerSetLooping(agent_controller, true)
    ControllerSetSoundVolume(agent_controller, volume)
end

--End Sound Handler--

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

Ambience_ShowNotification = function()
    Notification_ShowText(eNotificationType.Tutorial, "Welcome to Ambience! Walk up to doors & press F to enter them.", 2, 10)
    --AgentSetProperty(AgentFindInScene("ui_notification_text", "ui_notification"), kText, "This is a test notification.")
end
