--[[
Notes:

The IDs must ALWAYS be unique within a scene.

Some gnarly stuff might happen if 2 warps are too close to each-other (read: within each-others ranges),
so it's probably a good idea to keep them reasonably separated.

These are designed to be as versatile as possible (despite not looking quite as pretty as the vanilla ones),
so you can put just about any code you want within the Activate function. 
--]]


--Boarding School Interior

kWarp_BoardingSchoolInt_Exit = {}
kWarp_BoardingSchoolInt_Exit["ID"] = "warpBoardingSchoolExit"
kWarp_BoardingSchoolInt_Exit["Position"] = Vector(0.022439, 0, 10.547670)
kWarp_BoardingSchoolInt_Exit["Radius"] = 1
kWarp_BoardingSchoolInt_Exit["Message"] = "[F] - Courtyard"
kWarp_BoardingSchoolInt_Exit["Activate"] = function()
    SubProject_Switch("WalkingDead402", "_BoardingSchoolExteriorDuskAdminAmb.lua")
end

--Boarding School Exterior

kWarp_BoardingSchoolExt_AdminBldg = {}
kWarp_BoardingSchoolExt_AdminBldg["ID"] = "warpBoardingSchoolAdminBldg" --
kWarp_BoardingSchoolExt_AdminBldg["Position"] = Vector(0.070420, 0.715000, 6.036319)
kWarp_BoardingSchoolExt_AdminBldg["Radius"] = 1
kWarp_BoardingSchoolExt_AdminBldg["Message"] = "[F] - Admin Building"
kWarp_BoardingSchoolExt_AdminBldg["Activate"] = function()
    SubProject_Switch("WalkingDead401", "BoardingSchoolInteriorAmb.lua")
end

kWarp_BoardingSchoolExt_GateExit = {}
kWarp_BoardingSchoolExt_GateExit["ID"] = "warpBoardingSchoolCourtyardExit" --
kWarp_BoardingSchoolExt_GateExit["Position"] = Vector(-5.129817, 0, 33.923332)
kWarp_BoardingSchoolExt_GateExit["Radius"] = 1
kWarp_BoardingSchoolExt_GateExit["Message"] = "[F] - Fishing Shack"
kWarp_BoardingSchoolExt_GateExit["Activate"] = function()
    --SubProject_Switch("WalkingDead401", "ForestShackAmb.lua")
    DialogBox_Okay("I promise, I'm working on it!", "STILL not implemented")
end

kWarp_BoardingSchoolExt_Dorms = {}
kWarp_BoardingSchoolExt_Dorms["ID"] = "warpBoardingSchoolDormsEntrance" --
kWarp_BoardingSchoolExt_Dorms["Position"] = Vector(18.855585, 0, 25.006113)
kWarp_BoardingSchoolExt_Dorms["Radius"] = 1
kWarp_BoardingSchoolExt_Dorms["Message"] = "[F] - Dorm Rooms"
kWarp_BoardingSchoolExt_Dorms["Activate"] = function()
    SubProject_Switch("WalkingDead403", "BoardingSchoolDormAmb.lua")
end

--Boarding School Dorm

kWarp_BoardingSchoolDorm_Exit = {}
kWarp_BoardingSchoolDorm_Exit["ID"] = "warpBoardingSchoolDormExit"
kWarp_BoardingSchoolDorm_Exit["Position"] = Vector(-8.44003, 0, 0.03292)
kWarp_BoardingSchoolDorm_Exit["Radius"] = 1
kWarp_BoardingSchoolDorm_Exit["Message"] = "[F] - Courtyard"
kWarp_BoardingSchoolDorm_Exit["Activate"] = function()
    SubProject_Switch("WalkingDead402", "_BoardingSchoolExteriorDuskDormsAmb.lua")
end
