-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: D:\Software\Ambience\WDC_pc_WalkingDead403_data\BoardingSchoolDorm_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
local kScript = "BoardingSchoolDormAmb"
local kScene  = "adv_boardingSchoolDorm"

BoardingSchoolDormAmb = function()
  if not Game_GetLoaded() then
    Collectible_SetVisibility()
  end

  Game_SetSceneDialogNode("cs_exit")
  Game_RunSceneDialog("logic_freeWalk", false)
  AgentSetPosAndRot(Game_GetPlayer(), Vector(-7.534330, 0, -0.035780), Vector(0, 90, 0))
  Ambience_RemoveVanillaAgents(kScene)
  AmbienceWarps_Init(kScene)
end

Game_SceneOpen(kScene, kScript)

