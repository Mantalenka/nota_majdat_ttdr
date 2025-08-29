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

  if not global.allocated_units then
    global.allocated_units = {}
  end

  local allUnits = SpringGetAllUnits()
  for _, unitID in ipairs(allUnits) do
    if SpringGetUnitTeam(unitID) == myTeamID then -- and not isAllocated(unitID) then
      local udid = SpringGetUnitDefID(unitID)
      local def = UnitDefs[udid]
      if def and def.name ~= "armatlas" and def.name ~= "armpeep" then
        local x, _, z = SpringGetUnitPosition(unitID)
		Spring.Echo(x,z, west, south, east, north)
        if x and z and x >= west and x <= east and z <= south and z >= north and Spring.ValidUnitID(unitID)then
          table.insert(global.allocated_units, unitID)
          return unitID
        end
      end
    end
  end
  return FAILURE
end
