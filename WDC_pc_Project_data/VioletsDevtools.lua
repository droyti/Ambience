local devtoolsButtons         = { "Request Coord Update", "Remove Agent", "Disable Walkboxes", "Kill Player", "Print Agents to File", "Print Dialog Nodes to File"}
local maxIndex                = 6
local minIndex                = 1
local devtoolsMenuIndex       = 1
local inputHandlerUpdateCount = 0
local isDevtoolsMenuEnabled   = false
local isDebuggingDebugger     = false
local emptyWalkbox            = "adv_empty.wbox"
local kScene                  = ""

local devtoolsCamera = ""
--cam_orbit

--[[

READ ME - READ ME - READ ME - READ ME - READ ME - READ ME

The below init function is the only one that I'm going to bother commenting.
This menu is a complete mess code wise and it's honestly a miracle it even works at all.

To use it, call Devtools_Init() within a scene script. Because of the while loops, anything *after*
that call will not run. Proceed with caution, this thing is super broken and might crash the game / screw up your save file.
--]]
Devtools_Init = function(theScene)
  kScene         = theScene
  devtoolsCamera = SceneGetCamera(kScene)
  
  Devtools_InitMenuText()
  Devtools_InputHandler()
end

Devtools_InitMenuText = function()
  local CreateTextAgent = function(name, text, posx, posy, posz, halign, valign)
    local pos       = Vector(posx, posy, posz)
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

  
  local camPos      = AgentGetWorldPos(devtoolsCamera)
  local clemLooking = Look_GetFocus("Clementine")
  actor_text        = CreateTextAgent("violetsDevtools_Menu_text", "", camPos.x, camPos.y, camPos.z, 0, 0)
  
  AgentSetProperty(actor_text, "Text Render Layer", 99)
  
  local OnCallbackFired = function()
  
   --Devtools_InputHandler()
   
   local camPos    = AgentGetWorldPos(devtoolsCamera)
   local playerPos = AgentGetWorldPos("Clementine")
   local textAgent = AgentFind("violetsDevtools_Menu_text")
   
     local menuText = ""
     
     if isDebuggingDebugger then
         menuText = menuText .. "\nDebugMenu Debug Info:\n\nBottom Scene: " .. tostring(SceneGetBottomScene()) .. "\n" .. "devtoolsMenuIndex: " .. devtoolsMenuIndex .. "\nInputHandler Count: " .. inputHandlerUpdateCount .. "\n\n"
     end
     
     menuText = menuText .. "Violet's Devtools\n" .. "Coords: " .. tostring(playerPos) .. "\n" .. "Is Debug Build? " .. tostring(ResourceSetEnabled("Project")) .. "\n"
     
     for i,menuButton in ipairs(devtoolsButtons) do
         if i == devtoolsMenuIndex then
             --Selected
             menuText = menuText .. "← " .. menuButton .. "\n"
         else
             --Not Selected
             menuText = menuText .. "   " .. menuButton .. "\n"
         end
     end
   
   if not isDevtoolsMenuEnabled then
       TextSet(textAgent, "")
   else
       TextSet(textAgent, menuText)
   end
   AgentSetPosAndRot("violetsDevtools_Menu_text", camPos, AgentGetWorldRot(devtoolsCamera))
  end

  Callback_OnPostUpdate:Add(OnCallbackFired)
end

Devtools_ToggleMenu = function()
  isDevtoolsMenuEnabled = not isDevtoolsMenuEnabled
end

Devtools_InputHandler = function()
  
  --devtoolsPreviousInTime = os.time()
  while 1 do
    
    if Input_IsVKeyPressed(115) then
        --F4 key, toggle
        Devtools_ToggleMenu()
    end
      
    if isDevtoolsMenuEnabled then
      if Input_IsVKeyPressed(98) then
      --Numpad Down (2)
      inputHandlerUpdateCount = inputHandlerUpdateCount + 1
      local indexReq = devtoolsMenuIndex + 1 
      
      if indexReq > maxIndex then
          --DialogBox_Okay("requested index greater than maxIndex", "Out of range!")
      else
          devtoolsMenuIndex = indexReq 
      end
    elseif Input_IsVKeyPressed(104) then 
      --Numpad Up (8)
      inputHandlerUpdateCount = inputHandlerUpdateCount + 1
      local indexReq = devtoolsMenuIndex - 1 
      if indexReq < minIndex then
          --DialogBox_Okay("requested index less than minIndex", "Out of range!")
      else
          devtoolsMenuIndex = indexReq
      end
    elseif Input_IsVKeyPressed(101) then
      --Numpad Select (5)
      inputHandlerUpdateCount = inputHandlerUpdateCount + 1
      --DialogBox_Okay("Selected " .. devtoolsButtons[devtoolsMenuIndex], "Option selected!")
      Devtools_SelectOption(devtoolsMenuIndex)
    end
    end  
    WaitForNextFrame()
    WaitForNextFrame()
    WaitForNextFrame()
    WaitForNextFrame()
    WaitForNextFrame()
    WaitForNextFrame()
  end
end


Devtools_SelectOption = function(option)
  if option == 1 then
    Devtools_RequestCoordUpdate()
  elseif option == 2 then
    Devtools_RemoveAgent()
  elseif option == 3 then
    Devtools_DisableWalkboxes()
  elseif option == 4 then
    Devtools_KillPlayer()
  elseif option == 5 then
    Devtools_PrintAgentsToFile(kScene)
  elseif option == 6 then
    Devtools_MenuPrintDlg()
  else
    Game_PushMode(eModeDialogBox)
    DialogBox_Okay("You somehow selected a nonexistent option.", "...Err, this is awkward.")
    Game_PopMode(eModeDialogBox)
  end    
end

Devtools_MenuPrintDlg = function()
  Devtools_PrintSceneDialogs(kScene)
end

Devtools_RequestCoordUpdate = function()
Game_PushMode(eModeDialogBox)
local clementineMod         = AgentFind("Clementine")
  
local enteredText1, cancel1 = Menu_OpenTextEntryBox("1", Menu_Text("Coordinates x?"))  
if cancel1 then
Ambience_InvokeError("Cancelled Coordinate Dialog!")
Game_PopMode(eModeDialogBox)
return
end
local enteredText2, cancel2 = Menu_OpenTextEntryBox("5", Menu_Text("Coordinates y?"))
if cancel2 then
Ambience_InvokeError("Cancelled Coordinate Dialog!")
Game_PopMode(eModeDialogBox)
return
end
local enteredText3, cancel3 = Menu_OpenTextEntryBox("1", Menu_Text("Coordinates z?"))
if cancel3 then
Ambience_InvokeError("Cancelled Coordinate Dialog!")
Game_PopMode(eModeDialogBox)
return
end  
  
AgentSetPos(clementineMod, Vector(tonumber(enteredText1), tonumber(enteredText2), tonumber(enteredText3)))
Game_PopMode(eModeDialogBox)
end

Devtools_RemoveAgent = function()
  Game_PushMode(eModeDialogBox)
  local agent, cancel1 = Menu_OpenTextEntryBox("", Menu_Text("Please enter the Agent Name."))  
    if cancel1 then
      Ambience_InvokeError("Cancelled Dialog!")
      Game_PopMode(eModeDialogBox)
      return
    end
  
    if agent == "violetsDevtools_Menu_text" then
        DialogBox_Okay("You can't delete the debug menu.", "Seriously, dude?")
        Game_PopMode(eModeDialogBox)
        return
    elseif agent == "the Agent Name." then
        DialogBox_Okay("Ha-Ha, very funny.", "I'm getting tired of you.")
        Game_PopMode(eModeDialogBox)
        return
    end
    Game_PopMode(eModeDialogBox)
    --WalkBoxesDisableAreaAroundAgent(theScene, AgentFind(agent))
    PropertyRemove(props, kCollisionsEnabled)
    AgentHide(agent, true)
    AgentDetach(agent)
end

Devtools_KillPlayer = function()
  Game_PushMode(eModeDialogBox)
  local deathConfirm = DialogBox_YesNo("Would you like to die?", "Deathwish...?")
  if not deathConfirm then
      Game_PopMode(eModeDialogBox)
      return
  end
  Game_PopMode(eModeDialogBox)
  Death()
end

Devtools_DisableWalkboxes = function()
  PropertyRemove(kScene, "Walk Boxes")
  DialogBox_Okay("Disabled WalkBoxes!")
end

Devtools_PrintAgentsToFile = function(theScene)
  --PropertyGetKeys
  PrintSceneListToTXT(theScene)
--[[  
  local agentFilename = "AgentsOut.txt"
  io.open(agentFilename,"w"):close()
  
  local file        = io.open(agentFilename, "a")
  local totalAgents = SceneGetAgents(theScene)
  --local doProps     = false
  
  for i,theAgent in pairs(totalAgents) do
      file:write(i .. ' - ' .. tostring(AgentGetName(theAgent)), "\n")
      
      --AgentGetRuntimeProperties
      local sceneProps = AgentGetSceneProperties(theAgent)
      if sceneProps then
          local propKeys = PropertyGetKeys(sceneProps)
          for x,propKey in ipairs(propKeys) do
              file:write("   " .. i .. " - Property - " .. tostring(propKey) .. ", value: " .. tostring(PropertyGet(sceneProps, propKey)) .. "\n")
          end
          file:write("----------", "\n")
      end
  end

  file:close()
  
  DialogBox_Okay("Printed to File!")
  --]]
end

          --PropertyGet(sceneProps, propKey)
          --SymbolToString(propKey)
          
Devtools_CreateWalker = function()
Load("adv_boardingSchoolExterior_meshesDBuilding.prop")
local walkerAgent     = AgentCreate("devtools_walker_test", "adv_boardingSchoolExterior_meshesDBuilding.prop", Vector(1, 0, 1))
  if walkerAgent then
      
      DialogBox_Okay("Walker created!")
  else
      DialogBox_Okay("Walker not created?")
  end
end

Devtools_CreateWarpTrigger = function()
    Game_PushMode(eModeDialogBox)

    local triggerName, cancel1 = Menu_OpenTextEntryBox("trigger_warp_", Menu_Text("Enter the warp trigger name:"))
    if cancel1 then
        Ambience_InvokeError("Cancelled Dialog!")
        Game_PopMode(eModeDialogBox)
        return
    end

    if name ~= "" then
        local triggerAgent = AgentCreate(triggerName, "trigger_warp.prop", Vector(0, 0, 0))

        if triggerAgent then
            local triggerAgentProps = AgentGetSceneProperties(triggerAgent)

            local triggerTarget, cancel1 =
                Menu_OpenTextEntryBox("trigger_warp_", Menu_Text("Enter the warp target name:"))
            if cancel1 then
                Ambience_InvokeError("Cancelled Dialog!")
                Game_PopMode(eModeDialogBox)
                return
            end

            if triggerTarget ~= "" then
                AgentSetProperty(triggerAgentprops, "Trigger - Warp Target", triggerTarget)
            end

            Game_PopMode(eModeDialogBox)
        end
    end
end