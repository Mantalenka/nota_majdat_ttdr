local sensorInfo = {
  name = "appendIDfromGlobalArray",
  desc = "Append ID from global array",
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


-- SENSOR: smaže jednotku z global.allocated_units podle ID
return function(globalArray, unitID)

    table.insert(globalArray, unitID)

    return SUCCESS
end
