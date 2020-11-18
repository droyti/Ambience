require("AI_PlayerProjectile.lua")
local kScript      = "BoardingSchoolExteriorDuskAmb"
local kScene       = "adv_boardingSchoolExteriorDusk"
local kWalkbox     = "adv_boardingSchoolExteriorDusk.wbox"
local OnLogicReady = function()
  -- function num : 0_0 , upvalues : _ENV
  if IsPlatformNX() then
    Episode_SetFireShadows()
  end
  BoardingSchoolExteriorDuskAmb_UpdateWalkbox()
  if Game_GetLoaded() then
    return 
  end
  Episode_SetAJShirt()
  Episode_SetLouisDamage()
  if LogicGet("Debug ID") == 1 then
    Game_SetSceneDialogNode("cs_truthOrDare")
  end
end

BoardingSchoolExteriorDuskAmb = function()
  -- function num : 0_1 , upvalues : _ENV
  DlgPreloadAll(Game_GetPlayerDialog(), false)
  if Game_GetSkipEnterCutscenes() then
    Game_RunSceneDialog("logic_freeWalk", false)
  end

  Game_SetSceneDialogNode("cs_exit")
  Game_RunSceneDialog("logic_freeWalk", false)
  if kStartingPos ~= nil then
      AgentSetPosAndRot(Game_GetPlayer(), kStartingPos, kStartingRot)
  end
  
  Ambience_RemoveVanillaAgents(kScene)
  AmbienceWarps_Init(kScene)
  --AgentSetPos(Game_GetPlayer(), kStartingPos.x, kStartingPos.y, kStartingPos.z)
  --Devtools_Init(kScene)
end

BoardingSchoolExteriorDuskAmb_UpdateWalkbox = function()
  -- function num : 0_2 , upvalues : _ENV, kWalkbox
  WalkBoxesEnableAll(kWalkbox)
  local idle = AgentGetProperty("Louis", "Walk Animation - Idle")
  if idle then
    idle = ResourceGetName(idle)
  end
  if not AgentIsHidden("Louis") then
    if idle == "adv_boardingSchoolExteriorDusk_louisShooting.chore" then
      WalkBoxesDisableAreaAroundAgent(kWalkbox, "dummy_louisWalkboxBlockerShooting", 0.01)
    else
      if idle == "adv_boardingSchoolExteriorDusk_louisPickingUp.chore" then
        WalkBoxesDisableAreaAroundAgent(kWalkbox, "dummy_louisWalkboxBlockerStandingAround", 0.01)
      end
    end
  end
  Episode_SetZombieGrave()
end

BoardingSchoolExteriorDusk_CleanUpAuxiliaryChore = function()
  -- function num : 0_3 , upvalues : _ENV
  local controller = ControllerFind("zombat_clemStrafeBowNockedToDrawn.chore")
  while ControllerIsPlaying(controller) do
    WaitForNextFrame()
  end
  AgentSetProperty("Clementine", "Walk Animator - Auxiliary Chore", "")
end

Callback_OnLogicReady:Add(OnLogicReady)
Game_SceneOpen(kScene, kScript)

