Menu_DroytiAmbience = function()
    WidgetInputHandler_EnableInput(false)
    local loadAmbience = DialogBox_YesNo(
        "This mod allows you to roam Ericson's Boarding School freely, without the pressures of the story.\nTo return to the normal game, simply use the pause menu as usual.\n\nWould you like to continue?",
        "Hold up a moment..."
        )
    if loadAmbience then
        SubProject_Switch("WalkingDead402", "_BoardingSchoolExteriorDuskInitAmb.lua")
    end
    WidgetInputHandler_EnableInput(true)
end