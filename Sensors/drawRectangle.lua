local sensorInfo = {
  name = "drawRectangle",
  desc = "Draw rectangle",
  author = "MajdaT_ChatGPT",
  date = "2025-08-29",
  license = "notAlicense"
}

local EVAL_PERIOD_DEFAULT = -1

function getInfo()
  return {
    period = EVAL_PERIOD_DEFAULT
  }
end

return function(units, west, south, east, north, ID)

	local topLeftCorner = Vec3(north, 0, west)
	local topRightCorner = Vec3(north, 0, east)
	local bottomLeftCorner = Vec3(south, 0, west)
	local bottomRightCorner = Vec3(south, 0, east)
	
	-- draw debug rectangle
	if (Script.LuaUI('exampleDebug_update')) then
		Script.LuaUI.exampleDebug_update(
      "top" .. ID, -- key
      {	-- data
        startPos = topLeftCorner, 
        endPos = topRightCorner
      }
    )
    Script.LuaUI.exampleDebug_update(
      "right" .. ID, -- key
      {	-- data
        startPos = topRightCorner, 
        endPos = bottomRightCorner
      }
    )
    Script.LuaUI.exampleDebug_update(
      "bottom" .. ID, -- key
      {	-- data
        startPos = bottomRightCorner, 
        endPos = bottomLeftCorner
      }
    )
    Script.LuaUI.exampleDebug_update(
      "left" .. ID, -- key
      {	-- data
        startPos = bottomLeftCorner, 
        endPos = topLeftCorner
      }
    )
	end
	--Spring.Echo("topLeftCorner: ", topLeftCorner, " topRightCorner: ", topRightCorner, " bottomLeftCorner: ", bottomLeftCorner, " bottomRightCorner: ", bottomRightCorner)

  return SUCCESS
end
