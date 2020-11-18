﻿require("Logic.lua")
require("UI.lua")
require("TVRemoteManager.lua")
require("Credits.lua")
require("DialogInstanceManager.lua")
require("DialogChoices.lua")
require("InventoryWD.lua")
require("Notification.lua")
require("Peek.lua")
require("ReticleWD.lua")
require("ReticleCameraControlWD.lua")
require("ReticleController.lua")
require("ReticleSelectionWD.lua")
require("Subtitle.lua")
require("Swipe.lua")
if IsPlatformTouch(true) then
  require("Vignette.lua")
end
require("Audio.lua")
require("AutoFocuser.lua")
require("Brightness.lua")
require("Camera.lua")
require("CameraLens.lua")
require("Character.lua")
require("Crosshair.lua")
require("Death.lua")
require("Drag.lua")
require("LightComposerCharacter.lua")
require("Look.lua")
require("NavigateWD.lua")
require("OrbitCam.lua")
require("PanicMeter.lua")
require("PersistentLogic.lua")
require("QuickTimeEvent.lua")
require("RichPresence.lua")
require("SceneDelta.lua")
require("SessionProperties.lua")
require("Station.lua")
require("StruggleQTE.lua")
require("TriggerWD.lua")
require("VirtualStick.lua")
require("WDAchievements.lua")
require("AI_Player.lua")
require("AI_Agent.lua")
require("AI_Radar.lua")
require("AI_Trap.lua")
require("BackButton.lua")
require("Foliage.lua")
require("Shooter.lua")
require("Useable.lua")
require("Vibration.lua")
require("Menu_Pause.lua")
require("Game.lua")
require("GameOverrides.lua")
require("WalkingDead.lua")
require("AmbienceWarps.lua")
require("AmbienceProject.lua")
if AmbienceMod_IsDebug then
  --These don't really *do* anything at the moment.
  --I mean, they do stuff. But they're not implemented anywhere.
  --You get a free (albeit kind of terrible) debug menu, though! <3
  require("DevtoolsPrinter.lua")
  require("VioletsDevtools.lua")
end
if ResourceSetResourceExists(SubProject_GetCurrent(), "Episode.lua") then
  require("Episode.lua")
end
if IsToolBuild() then
  require("ChoreUtilities.lua")
  require("DialogBlocker.lua")
  require("GameTimer.lua")
  require("KitCharacter.lua")
end

