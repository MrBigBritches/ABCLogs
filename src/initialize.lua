local _, Addon = ...

local logging = Addon.Logging:new()

Addon
    .EventHandler:new()
    .Initialize(function(event)
      local instance = Addon.Instance:new()

      if logging.shouldStart(instance) then logging.start() end
      if logging.shouldStop(instance) then logging.stop() end
    end)
