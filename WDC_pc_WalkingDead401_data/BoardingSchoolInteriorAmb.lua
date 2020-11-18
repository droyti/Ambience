-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: D:\Software\Ambience\WDC_pc_WalkingDead401_data\BoardingSchoolInterior_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
local kScript = "BoardingSchoolInteriorAmb"
local kScene  = "adv_boardingSchoolInterior"

BoardingSchoolInteriorAmb = function()
  Game_SetSceneDialog("env_boardingSchoolInterior_act2")
  if not Game_GetLoaded() then
    AgentRestore("obj_backpackClem400", 1)
  end
  Game_SetSceneDialogNode("cs_exit")  
  Game_RunSceneDialog("logic_freeWalk", false)
  Ambience_RemoveVanillaAgents(kScene)
  AmbienceWarps_Init(kScene)
end

Game_SceneOpen(kScene, kScript)

