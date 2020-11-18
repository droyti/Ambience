--[[
Most of this file was written (and commented) by /u/changemymindpls1.
I've explicitly noted anything written by me.
--]]

function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end

--gets the key and if it's a symbol it removes the symbol: tag and quotations
local keyToString_mine = function(key)
    --convert the key to a string
    local keyAsString = tostring(key)
    
    --if the string contains symbol: then remove it, otherwise keep the string as is
    if (string.match)(keyAsString, "symbol: ") then
        keyAsString = (string.sub)(keyAsString, 9)
    else
        keyAsString = keyAsString
    end
    
    --remove any leftover quotations from the string
    keyAsString = keyAsString:gsub('"','')

    --return the final result
    return keyAsString
end

Devtools_PrintSceneDialogs = function(theScene) --This one was written by me! Just a quick test function that I threw together in a pinch. Not very useful.
  --In true Droyti fashion, this one isn't very thorougly commented either (or really, at all). Should be fairly self explanitory, though.
  local printer = io.open('agents/dlg/' .. theScene .. '_dlg_nodes.txt', "a") 

  local sceneDialog = Game_GetSceneDialog()
  local nodeIDs     = DlgGetChainHeadNodes(sceneDialog, "Cutscenes")
  
  for i,theNode in ipairs(nodeIDs) do
      printer:write(i .. " - " .. tostring(theNode), "\n")
      
      local nextNode = DlgNodeGetNextNode(sceneDialog, theNode)
      while 1 do --I REALLY need to stop doing these.
          if nextNode then
              local nextNodeType = nextNode.Type
              local nextNodeName = nextNode.Name
              
              printer:write(i .. " - " .. tostring(nextNodeType), "\n")
              printer:write(i .. " - " .. tostring(nextNodeName), "\n")
              
              nextNode = DlgNodeGetNextNode(sceneDialog, nextNode)
          else
              break
          end
      end
  end
  
  printer:close()
  
  DialogBox_Okay("Dialog nodes printed!")
end

--prints an entire scene and its contents to a text file
Devtools_PrintSceneList = function(SceneObject)
    local main_txt_file                 = io.open('agents/' .. SceneObject .. "_scene_output.txt", "a") --I added the agents/ subfolder. Just for better organization.
    local scene_agents                  = SceneGetAgents(SceneObject)
    local print_agent_transformation    = true
    local print_agent_properties        = true
    local print_agent_properties_keyset = false --not that useful

    --being looping through the list of agents gathered from the scene
    for i, agent_object in pairs(scene_agents) do
        --get the agent name and the type
        local agent_name = tostring(AgentGetName(agent_object))
        local agent_type = tostring(TypeName(agent_object))--type(agent_object)
        
        --start writing the agent information to the file
        main_txt_file:write(i, "\n")
        main_txt_file:write(i .. " Agent Name: " .. agent_name, "\n")
        main_txt_file:write(i .. " Agent Type: " .. agent_type, "\n")
        
        --if true, then it also writes information regarding the transformation properties of the agent
        if print_agent_transformation then
            local agent_pos = tostring(AgentGetPos(agent_object))
            local agent_rot = tostring(AgentGetRot(agent_object))
            
            local agent_pos_world = tostring(AgentGetWorldPos(agent_object))
            local agent_rot_world = tostring(AgentGetWorldRot(agent_object))
            
            main_txt_file:write(i .. " Agent Position: " .. agent_pos, "\n")
            main_txt_file:write(i .. " Agent Rotation: " .. agent_rot, "\n")
            main_txt_file:write(i .. " Agent World Position: " .. agent_pos_world, "\n")
            main_txt_file:write(i .. " Agent World Rotation: " .. agent_rot_world, "\n")
        end

        --get the properties list from the agent
        local agent_properties = AgentGetProperties(agent_object)
        
        --if the properties field isnt null and print_agent_properties is true
        if agent_properties and print_agent_properties then
            --write a quick header to seperate
            main_txt_file:write(i .. " --- Agent Properties ---", "\n")
            
            --get the property keys list
            local agent_property_keys = PropertyGetKeys(agent_properties)
            
            --begin looping through each property key found in the property keys list
            for x, agent_property_key in ipairs(agent_property_keys) do
                --get the key type and the value, as well as the value type
                local agent_property_key_type   = TypeName(PropertyGetKeyType(agent_properties, agent_property_key))
                local agent_property_value      = PropertyGet(agent_properties, agent_property_key)
                local agent_property_value_type = TypeName(PropertyGet(agent_properties, agent_property_key))

                --convert these to a string using a special function to format it nicely
                local agent_propety_key_string       = keyToString_mine(agent_property_key)
                local agent_property_key_type_string = keyToString_mine(agent_property_value_type)
                
                --convert these to a string using a special function to format it nicely
                local agent_property_value_string      = keyToString_mine(agent_property_value)
                local agent_property_value_type_string = keyToString_mine(agent_property_key_type)
                
                --begin writing these values to file
                main_txt_file:write(i .. " " .. x .. " [Agent Property]", "\n")
                main_txt_file:write(i .. " " .. x .. " Key: " .. agent_propety_key_string, "\n")
                main_txt_file:write(i .. " " .. x .. " Value: " .. agent_property_value_string, "\n")
                main_txt_file:write(i .. " " .. x .. " Key Type: " .. agent_property_key_type_string, "\n")
                main_txt_file:write(i .. " " .. x .. " Value Type: " .. agent_property_value_type_string, "\n")

                --if the key type is of a table type, then print out the values of the table
                if agent_property_key_type_string == "table" then
                    main_txt_file:write(i .. " " .. x .. " Value Table", "\n")
                    main_txt_file:write(tprint(agent_property_value), "\n")
                end
                
                --for printing the key property set of the agent properties
                if print_agent_properties_keyset then
                    local property_key_set = PropertyGetKeyPropertySet(agent_properties, agent_property_key)
                    
                    main_txt_file:write(i .. " " .. x .. " [Key Property Set] " .. tostring(property_key_set), "\n")
                    
                    for y, property_key in pairs(property_key_set) do
                        main_txt_file:write(i .. " " .. x .. " Key Property Set Key: " .. tostring(property_key), "\n")
                        main_txt_file:write(i .. " " .. x .. " Key Property Set Value: " .. tostring(PropertyGet(agent_properties, property_key)), "\n")
                    end
                end
            end
            
            --write a header to indicate the end of the agent properties information
            main_txt_file:write(i .. " ---Agent Properties END ---", "\n")
            
        end
    end
    
    --close the file stream
    main_txt_file:close()

    --for testing/validating
    DialogBox_Okay("Printed Output")
end