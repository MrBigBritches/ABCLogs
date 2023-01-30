local _, Addon = ...

function Addon.Debug(message)
  if not Addon.Options.debugging then return end

  if type(message) == "table" then
    DevTools_Dump(message)
  else
    Addon.Notify("[Debug] " .. message)
  end
end

function Addon.Notify(message)
  print("[ABCLogs] " .. message)
end

function Addon.Result(value, message)
  Addon.Debug(message)
  return value
end
