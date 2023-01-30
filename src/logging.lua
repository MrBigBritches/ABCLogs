local AddonName, Addon = ...

local MSG = Addon.Messages
local Result = Addon.Result

ENABLE_LOGGING_MODAL = AddonName .. '_Enable'
DISABLE_LOGGING_MODAL = AddonName .. '_Disable'

local Logging = {}
Logging.__index = Logging

function Logging:new()
  local logging = {}
  setmetatable(logging, Logging)

  CreatePopup(ENABLE_LOGGING_MODAL, MSG.ENABLE_LOGGING, true)
  CreatePopup(DISABLE_LOGGING_MODAL, MSG.DISABLE_LOGGING, false)

  return logging
end

Addon.Logging = Logging

function Logging:ShouldStart(instance)
  local isLogging = LoggingCombat()

  -- Check if logging is already enabled
  if isLogging then
    return Result(false, "Logging is already enabled")
  end

  -- Do not log if the instance is not a raid
  if not instance:IsRaid() then
    return Result(false, "Instance is not a raid, logging will not be enabled")
  end

  -- Do not log if all raid bosses are dead
  if instance:IsComplete() then
    return Result(false, "Instance has been completed, logging will not be enabled")
  end

  return Result(true, "Logging should be enabled for this instance")
end

function Logging:ShouldStop(instance)
  local isSolo = GetNumGroupMembers() == 0
  local isLogging = LoggingCombat()

  -- Check if logging is already disabled
  if not isLogging then
    return Result(false, "Logging is already enabled")
  end

  -- Stop logging if all bosses have been killed
  if instance:IsRaid() and instance:IsComplete() then
    return Result(true, "Raid instance has been completed, logging should be disabled")
  end

  -- Stop logging if player has left their group
  if isSolo then
    return Result(true, "Player is solo, logging should be disabled")
  end

  return Result(false, "Logging should not be disabled at this time")
end

function Logging:Start()
  local isLogging = LoggingCombat()

  if not isLogging then
    if Addon.Options.prompt then
      StaticPopup_Show(ENABLE_LOGGING_MODAL)
      Addon.Debug("Prompted player to start logging")
    else
      StaticPopupDialogs[ENABLE_LOGGING_MODAL].OnAccept()
    end
  else
    Addon.Debug("Logging is already enabled, player was not prompted to start")
  end
end

function Logging:Stop()
  local isLogging = LoggingCombat()

  if isLogging then
    if Addon.Options.prompt then
      StaticPopup_Show(DISABLE_LOGGING_MODAL)
      Addon.Debug("Prompted player to end logging")
    else
      StaticPopupDialogs[DISABLE_LOGGING_MODAL].OnAccept()
    end
  else
    Addon.Debug("Logging is currently disabled, player was not prompted to stop")
  end
end

-- Private
function CreatePopup(name, message, enableLogging)
  StaticPopupDialogs[name] = {
    button1 = MSG.CTA_YES,
    button2 = MSG.CTA_NO,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,

    text = message,
    OnAccept = function()
      Addon.Notify("Logging was turned " .. ((enableLogging and 'on') or 'off'))
      LoggingCombat(enableLogging)
    end
  }
end
