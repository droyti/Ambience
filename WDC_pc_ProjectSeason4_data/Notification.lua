local kScene = "ui_notification"
eNotificationType = {
  Choice = 1,
  Tutorial = 2,
  Branch = 3,
  Move = 4,
  Relationship = 5,
  Gift = 6,
  Inventory = 7,
  Objective = 8
}
local kChoresShow = {
  "ui_notification_choiceShow",
  "ui_notification_tutorialShow",
  "ui_notification_branchShow",
  "ui_notification_movementIconShow",
  "ui_notification_relationshipShow",
  "ui_notification_giftShow",
  "ui_notification_inventoryShow",
  "ui_notification_objectiveShow"
}
local kChoresHide = {
  "ui_notification_choiceHide",
  "ui_notification_tutorialHide",
  "ui_notification_branchHide",
  "ui_notification_movementIconHide",
  "ui_notification_relationshipHide",
  "ui_notification_giftHide",
  "ui_notification_inventoryHide",
  "ui_notification_objectiveHide"
}
local kTextAgent = "ui_notification_text"
local mThreads = {}
local mControllers = {}
local mShowFunctions = {}
local mHideFunctions = {}
local mLockIndex
local mbHiding = {}
local PlayNotificationChore = function(index, choreTable)
  mControllers[index] = ChorePlayAndSync(choreTable[index], mControllers[index])
end
local HideNotification = function(index)
  if not mThreads[index] or mbHiding[index] then
    return
  end
  ThreadKill(mThreads[index])
  local Hide = function()
    mbHiding[index] = true
    if mControllers[index] then
      PlayNotificationChore(index, kChoresHide)
      ControllerWait(mControllers[index])
      mControllers[index] = nil
    end
    if mHideFunctions[index] then
      mHideFunctions[index]()
    end
    mThreads[index] = nil
    mbHiding[index] = nil
  end
  local thread = ThreadStart(Hide)
  if ThreadIsRunning(thread) then
    mThreads[index] = thread
  end
end
local ShowNotification = function(index, delay, duration)
  if mThreads[index] then
    ThreadKill(mThreads[index])
    mbHiding[index] = nil
    if mLockIndex == index then
      mLockIndex = nil
    end
  end
  duration = duration or 6
  local Show = function()
    if not SceneIsActive(kScene) then
      SceneAdd(kScene)
      WaitForNextFrame()
      if IsPlatformSmallScreen() then
        ChorePlay("ui_notification_smallScreen")
      end
    end
    if delay then
      Wait(delay)
    end
    if mShowFunctions[index] then
      mShowFunctions[index]()
    end
    SceneHide(kScene, false)
    PlayNotificationChore(index, kChoresShow)
    if duration > 0 then
      Wait(duration)
      HideNotification(index)
    end
  end
  mThreads[index] = ThreadStart(Show)
end
local UpdateText = function(bUseCursor)
  if not AgentIsHidden(kTextAgent) then
    local props = AgentGetProperties(kTextAgent)
    local textNode = PropertyGet(props, kTextNode)
    PropertySet(props, kTextNode, "")
    WaitForCallbacks()
    PropertySet(props, kTextNode, textNode)
  end
end
local ShowTextNotification = function(index, dialogNode, delay, duration, textOverride)
  local SetupText = function()
    while mLockIndex do
      WaitForNextFrame()
    end
    mLockIndex = index
    if textOverride then
        AgentSetProperty(kTextAgent, kTextNode, "")
        AgentSetProperty(kTextAgent, kText, dialogNode)
    else
        AgentSetProperty(kTextAgent, kTextNode, dialogNode)
    end
  end
  local HideText = function()
    Callback_OnSetInputMode:Remove(UpdateText)
    PropertyRemove(AgentGetProperties(kTextAgent), kTextNode)
    AgentHide(kTextAgent, true)
    if mLockIndex == index then
      mLockIndex = nil
    end
  end
  mShowFunctions[index] = SetupText
  mHideFunctions[index] = HideText
  Callback_OnSetInputMode:Add(UpdateText)
  ShowNotification(index, delay, duration)
end
local UpdateMoveIcon = function(bUseCursor)
  local bUseTouch = Input_UseTouch()
  AgentHide("ui_notification_movementIconKeyboard", not bUseCursor or bUseTouch)
  AgentHide("ui_notification_movementIconController", bUseCursor)
end
local SetupMoveIcon = function()
  Callback_OnSetInputMode:Add(UpdateMoveIcon)
  UpdateMoveIcon(Input_UseCursor())
end
local HideMoveIcon = function()
  Callback_OnSetInputMode:Remove(UpdateMoveIcon)
  AgentHide("ui_notification_movementIconParent", true, true)
end
local OnGameSceneOpen = function(scene)
  Preload_Scene(kScene, 0, 0, not Game_IsSwappingScenes())
end
function Notification_ShowChoice(dialogNode, delay, duration)
  if PropertyGet(GetPreferences(), "Enable Reticle Hint Dots") then
    ShowTextNotification(eNotificationType.Choice, dialogNode, delay, duration)
  end
end
function Notification_HideChoice()
  HideNotification(eNotificationType.Choice)
end
function Notification_ShowText(notificationType, text, delay, duration)
    ShowTextNotification(notificationType, text, delay, duration, true)
end
function Notification_ShowTutorial(dialogNode, delay, duration)
  ShowTextNotification(eNotificationType.Tutorial, dialogNode, delay, duration)
end
function Notification_HideTutorial()
  HideNotification(eNotificationType.Tutorial)
end
function Notification_ShowBranch(dialogNode, delay, duration)
  ShowTextNotification(eNotificationType.Branch, dialogNode, delay, duration)
end
function Notification_HideBranch()
  HideNotification(eNotificationType.Branch)
end
function Notification_ShowMoveIcon(delay, duration)
  mShowFunctions[eNotificationType.Move] = SetupMoveIcon
  mHideFunctions[eNotificationType.Move] = HideMoveIcon
  ShowNotification(eNotificationType.Move, delay, duration)
end
function Notification_HideMoveIcon()
  HideNotification(eNotificationType.Move)
end
function Notification_ShowRelationship(dialogNode, delay, duration)
  ShowTextNotification(eNotificationType.Relationship, dialogNode, delay, duration)
end
function Notification_HideRelationship()
  HideNotification(eNotificationType.Relationship)
end
function Notification_ShowGift(dialogNode, delay, duration)
  ShowTextNotification(eNotificationType.Gift, dialogNode, delay, duration)
end
function Notification_HideGift()
  HideNotification(eNotificationType.Gift)
end
function Notification_ShowInventory(dialogNode, delay, duration)
  ShowTextNotification(eNotificationType.Inventory, dialogNode, delay, duration)
end
function Notification_HideInventory()
  HideNotification(eNotificationType.Inventory)
end
function Notification_ShowObjective(dialogNode, delay, duration)
  ShowTextNotification(eNotificationType.Objective, dialogNode, delay, duration)
end
function Notification_HideObjective()
  HideNotification(eNotificationType.Objective)
end
function Notification_Hide()
  for _, index in pairs(eNotificationType) do
    HideNotification(index)
  end
end
function Notification_IsShowing(notificationType)
  if notificationType then
    local index = notificationType
    if IsString(notificationType) then
      index = eNotificationType[notificationType]
    end
    if not IsNumber(index) or not table.find(eNotificationType, index) then
      Print("Notification_IsShowing: invalid notification type " .. notificationType)
    end
    return mThreads[index] ~= nil
  else
    return #mThreads > 0
  end
end
Callback_OnGameSceneOpen:Add(OnGameSceneOpen)
