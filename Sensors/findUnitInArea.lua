local sensorInfo = {
  name = "findUnitInArea",
  desc = "Find unallocated unit of my team in given area",
  author = "MajdaT_ChatGPT",
  date = "2025-08-28",
  license = "notAlicense"
}

local EVAL_PERIOD_DEFAULT = 1 -- update every frame


function getInfo()
  return {
	period = EVAL_PERIOD_DEFAULT,
    onNoUnits = FAILURE,
    tooltip = "Find unallocated unit in given area",
    parameterDefs = {
      { name = "west_limit", variableType = "expression", componentType = "editBox", defaultValue = 0 },
      { name = "south_limit", variableType = "expression", componentType = "editBox", defaultValue = 0 },
      { name = "east_limit", variableType = "expression", componentType = "editBox", defaultValue = 0 },
      { name = "north_limit", variableType = "expression", componentType = "editBox", defaultValue = 0 }
    }
  }
end

local SpringGetAllUnits = Spring.GetAllUnits
local SpringGetUnitTeam = Spring.GetUnitTeam
local SpringGetUnitDefID = Spring.GetUnitDefID
local SpringGetUnitPosition = Spring.GetUnitPosition
local myTeamID = Spring.GetMyTeamID()

function WriteDebug(unitID, msg)
    local file = io.open("LuaUI/debug_log.txt", "a")
    if file then
        local x, y, z = Spring.GetUnitPosition(unitID)
        file:write(string.format(
            "Unit %d: %s  (x=%.1f, z=%.1f)\n",
            unitID, msg, x or -1, z or -1
        ))
        file:close()
    end
end

-- helper: check if unit is already allocated
local function isAllocated(unitID)
  if not global.allocated_units then return false end
  for _, id in ipairs(global.allocated_units) do
    if id == unitID then
      return true
    end
  end
  return false
end

return function(units, west, south, east, north)

  --if not global.allocated_units then
    --global.allocated_units = {}
  --end

  local allUnits = SpringGetAllUnits()
  for _, unitID in ipairs(allUnits) do
    if SpringGetUnitTeam(unitID) == myTeamID then -- and not isAllocated(unitID) then
      local udid = SpringGetUnitDefID(unitID)
      local def = UnitDefs[udid]
      if def and def.name ~= "armatlas" and def.name ~= "armpeep" and def.name ~= "armseer" then
        local x, _, z = SpringGetUnitPosition(unitID)
		Spring.Echo(x,z, west, south, east, north)
		local msg = string.format("Hledaná jednotka %d je na souřadnicích (%.1f, %.1f), west %d, south %d, east %d, north %d", unitID, x, z, west, south, east, north)
        if x and z and x >= west and x <= east and z <= south and z >= north and Spring.ValidUnitID(unitID)then
          table.insert(global.allocated_units, unitID)
		  WriteDebug(unitID, msg)
          return unitID
        end
      end
    end
  end
  return FAILURE
end
