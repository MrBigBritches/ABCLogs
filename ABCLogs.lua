local _, Addon = ...
local logging = Addon.Logging:new()

Addon.EventHandler
    :new()
    :Initialize(function(event)
      local instance = Addon.Instance:new()

      if logging:ShouldStart(instance) then logging:Start() end
      if logging:ShouldStop(instance) then logging:Stop() end

      if event == "PLAYER_REGEN_ENABLED" then RequestRaidInfo() end
    end)
