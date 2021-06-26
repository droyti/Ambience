-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: D:\Software\AmbienceII\WDC_pc_Menu_data\Menu_seasons_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
require("Chunk.lua")
require("UI_SeasonButton.lua")
local kScene = "ui_seasons"
local kButtonPadding = 2
local mSeasonList, mButtonList = nil, nil
local mCurrentIndex = 0
local ShiftList = function()
  -- function num : 0_0 , upvalues : _ENV, mSeasonList, mCurrentIndex, kButtonPadding
  local listPos = AgentGetPos(mSeasonList.agent)
  listPos.x = (mCurrentIndex - kButtonPadding) * -3.02 - 1.5
  ChorePlayAndWait("ui_seasons_transitionOut")
  AgentSetPos(mSeasonList.agent, listPos)
end

Menu_Seasons = function()
  -- function num : 0_1 , upvalues : _ENV, kScene, mCurrentIndex, kButtonPadding, mSeasonList, mButtonList
  if not SceneIsActive(kScene) then
    MenuUtils_AddScene(kScene)
    SceneHide(kScene, true)
  end
  local menu = Menu_Create(ListMenu, "ui_seasons_reference", kScene)
  menu.align = "left"
  menu.alignV = "center"
  menu.isVertical = false
  mCurrentIndex = kButtonPadding + 1
  menu.Show = function(self)
    -- function num : 0_1_0 , upvalues : _ENV, kScene
    Menu_Main_SetIdle("env_clementineHouse400_seasonSelection")
    ChorePlayAndWait("env_clementineHouse400_mainMenuToSeasonSelection")
    SceneHide(kScene, false)
    ;
    (Menu.Show)(self, true, false, false, true)
  end

  menu.Hide = function(self)
    -- function num : 0_1_1 , upvalues : _ENV, kScene
    (Menu.Hide)(self, true, true, false, true)
    SceneHide(kScene, true)
    ChorePlayAndWait("env_clementineHouse400_seasonSelectionToMainMenu")
  end

  menu.Populate = function(self)
    -- function num : 0_1_2 , upvalues : mSeasonList, _ENV, mButtonList, menu
    mSeasonList = Menu_Add(SparseMenu, "groupButtons", 0.1, nil, "top")
    mSeasonList.isVertical = false
    mSeasonList.Place = function(self)
      -- function num : 0_1_2_0
      self:AnchorToAgent("ui_seasons_anchorButtons", "left", "center")
    end

    mButtonList = {}
    local kSeasons = {"walkingDeadSeasonOne", "walkingDeadSeasonTwo", "walkingDeadSeasonThree", "walkingDeadSeasonFour", "walkingDeadMichonne", "walkingDeadSeasonAmb"}
    local kSeasonCommands = {"Menu_Seasons_Play( 1 )", "Menu_Seasons_Play( 2 )", "Menu_Seasons_Play( 3 )", "Menu_Seasons_Play( 4 )", "Menu_Seasons_Play( \"M\" )", "Menu_Ambience_Play()"}
    ;
    (table.insert)(mButtonList, Menu_Insert(mSeasonList, SeasonButton, "padLeft1", kSeasons[5]))
    ;
    (table.insert)(mButtonList, Menu_Insert(mSeasonList, SeasonButton, "padLeft2", kSeasons[6]))
    for i,season in ipairs(kSeasons) do
      (table.insert)(mButtonList, Menu_Insert(mSeasonList, SeasonButton, season, season, kSeasonCommands[i]))
    end
    ;
    (table.insert)(mButtonList, Menu_Insert(mSeasonList, SeasonButton, "padRight1", kSeasons[1]))
    ;
    (table.insert)(mButtonList, Menu_Insert(mSeasonList, SeasonButton, "padRight2", kSeasons[2]))
    local arrowLeft = Menu_Add(MenuArrow, "arrowLeft", "left", "Menu_Seasons_OnLeft()", menu)
    arrowLeft.Place = function(self)
      -- function num : 0_1_2_1
      if not self.bPlaced then
        self:AnchorToAgent("ui_seasons_anchorArrowLeft", "left", "center")
        self.bPlaced = true
      end
    end

    local arrowRight = Menu_Add(MenuArrow, "arrowRight", "right", "Menu_Seasons_OnRight()", menu)
    arrowRight.Place = function(self)
      -- function num : 0_1_2_2
      if not self.bPlaced then
        self:AnchorToAgent("ui_seasons_anchorArrowRight", "right", "center")
        self.bPlaced = true
      end
    end

    local legendWidget = Menu_Add(Legend)
    legendWidget.Place = function(self)
      -- function num : 0_1_2_3
      self:AnchorToAgent("ui_seasons_anchorLegend", "left", "bottom")
    end

    Legend_Add("faceButtonDown", "legend_select")
    Legend_Add("faceButtonRight", "legend_previousMenu", "Menu_Pop()")
    local legendButton = Menu_Add(LegendButtonBack, nil, "Menu_Pop()", "legendButton_back")
    legendButton.Place = function(self)
      -- function num : 0_1_2_4
      self:AnchorToAgent("ui_seasons_anchorLegend", "left", "bottom")
    end

  end

  menu.OnKeyLeft = function(self, button, event)
    -- function num : 0_1_3 , upvalues : _ENV
    Menu_Seasons_OnLeft(event)
  end

  menu.OnKeyRight = function(self, button, event)
    -- function num : 0_1_4 , upvalues : _ENV
    Menu_Seasons_OnRight(event)
  end

  menu.OnWidgetInputChange = function(self, bUseCursor)
    -- function num : 0_1_5 , upvalues : mButtonList, mCurrentIndex
    (mButtonList[mCurrentIndex]):OnSetInputMode(bUseCursor)
  end

  Menu_Push(menu)
  for _,button in ipairs(mButtonList) do
    button:Deselect()
  end
  ;
  (mButtonList[mCurrentIndex]):Select()
end

Menu_Seasons_OnLeft = function(event)
  -- function num : 0_2 , upvalues : _ENV, mButtonList, mCurrentIndex, kButtonPadding, ShiftList
  WidgetInputHandler_EnableInput(false)
  if event then
    WidgetInputHandler_ConsumeEvent(event)
  end
  ;
  (mButtonList[mCurrentIndex]):Deselect()
  mCurrentIndex = mCurrentIndex - 1
  if mCurrentIndex < kButtonPadding + 1 then
    mCurrentIndex = #mButtonList - kButtonPadding
  end
  ShiftList()
  ;
  (mButtonList[mCurrentIndex]):Select()
  WidgetInputHandler_EnableInput(true)
end

Menu_Seasons_OnRight = function(event)
  -- function num : 0_3 , upvalues : _ENV, mButtonList, mCurrentIndex, kButtonPadding, ShiftList
  WidgetInputHandler_EnableInput(false)
  if event then
    WidgetInputHandler_ConsumeEvent(event)
  end
  ;
  (mButtonList[mCurrentIndex]):Deselect()
  mCurrentIndex = mCurrentIndex + 1
  if #mButtonList - kButtonPadding < mCurrentIndex then
    mCurrentIndex = kButtonPadding + 1
  end
  ShiftList()
  ;
  (mButtonList[mCurrentIndex]):Select()
  WidgetInputHandler_EnableInput(true)
end

Menu_Seasons_Select = function(seasonName)
  -- function num : 0_4 , upvalues : _ENV
  if seasonName == "walkingDeadSeasonAmb" then
    AgentSetProperty("ui_seasons_image", "material_ui_moreFromTelltale_mainImage_mainImage_m - Diffuse Texture", (string.format)("ui_moreFromTelltale_mainImage_%s.d3dtx", seasonName))
    AgentSetProperty("ui_seasons_textLabel", kTextNode, "")
    AgentSetProperty("ui_seasons_textDescription", kTextNode, "")
    AgentSetProperty("ui_seasons_textLabel", kText, "AMBIENCE")
    AgentSetProperty("ui_seasons_textDescription", kText, "Ambience allows you to explore various locations found within the Walking Dead universe freely.")
    ChorePlayAndWait("ui_seasons_transitionIn")
  else
    AgentSetProperty("ui_seasons_image", "material_ui_moreFromTelltale_mainImage_mainImage_m - Diffuse Texture", (string.format)("ui_moreFromTelltale_mainImage_%s.d3dtx", seasonName))
    AgentSetProperty("ui_seasons_textLabel", kTextNode, (string.format)("label_%s", seasonName))
    AgentSetProperty("ui_seasons_textDescription", kTextNode, (string.format)("desc_%s", seasonName))
    ChorePlayAndWait("ui_seasons_transitionIn")
   end
end

Menu_Seasons_Play = function(season)
  -- function num : 0_5 , upvalues : _ENV
  if season ~= 1 and not Chunk_PlayGo_PreBeginPlay("Season" .. season) then
    return 
  end
  Print("Switching to season " .. season)
  WidgetInputHandler_EnableInput(false)
  Menu_Music_FadeOut()
  local legend = AgentFind("ui_seasons_legend")
  if legend and legend.widget then
    (legend.widget):Suppress(nil, true)
  end
  local legendButton = AgentFind("ui_seasons_legendButtonBack")
  if legendButton and legendButton.widget then
    (legendButton.widget):Suppress(nil, true)
  end
  ChorePlayAndWait("ui_seasons_transitionOut")
  SubProject_Switch("MenuSeason" .. season)
end

Menu_Ambience_Play = function()
  WidgetInputHandler_EnableInput(false)
  ChorePlayAndWait("ui_seasons_transitionOut")
  local dialogResult = DialogBox_YesNo("Ambience allows you to freely roam through many maps appearing throughout the series. Potentially major spoilers ahead!\n\nAre you sure you'd like to continue?", "Spoiler Warning")
  if dialogResult then
    SubProject_Switch("WalkingDead402", "_BoardingSchoolExteriorDuskInitAmb.lua")
  else
    ChorePlayAndWait("ui_seasons_transitionIn")
    WidgetInputHandler_EnableInput(true)
  end
end

