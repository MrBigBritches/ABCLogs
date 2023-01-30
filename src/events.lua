local _, Addon = ...

local EventHandler = {}
EventHandler.__index = EventHandler

function EventHandler:new()
  local eventHandler = {}
  setmetatable(eventHandler, EventHandler)

  return eventHandler
end

Addon.EventHandler = EventHandler

function EventHandler:Initialize(onEvent)
  self.frame = CreateFrame("frame", "ABCLogs_EventFrame")

  self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  self.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
  self.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  self.frame:RegisterEvent("UPDATE_INSTANCE_INFO")


  self.frame:SetScript("OnEvent", function(_, event)
    onEvent(event)
  end)
end
