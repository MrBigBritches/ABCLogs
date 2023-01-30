local _, Addon = ...

local Instance = {}
Instance.__index = Instance

function Instance:new()
  local instance = { name = nil, type = nil, difficulty = nil, encounters = nil, progress = nil }
  setmetatable(instance, Instance)

  HydrateInstanceInformation(instance)
  HydrateInstanceEncounters(instance)

  return instance
end

function Instance:IsRaid()
  return self.type == 'raid'
end

function Instance:IsComplete()
  return self.encounters ~= nil and self.encounters == self.progress
end

function Instance:IsMatch(name, difficulty)
  local matchName = self.name == name
  local matchDifficulty = self.difficulty == difficulty

  return matchName and matchDifficulty
end

Addon.Instance = Instance

-- Private
function HydrateInstanceInformation(instance)
  -- Extract relevant information for the current instance
  local name, type, difficulty = GetInstanceInfo()

  instance.name = name
  instance.type = type
  instance.difficulty = difficulty
end

function HydrateInstanceEncounters(instance)
  -- Ignore instances that are not a raid
  if not instance:IsRaid() then return end

  -- We need to match the current instance against the various saved instances
  -- to figure out which one has the relevant details about encounter progress.
  for index = 1, GetNumSavedInstances() do
    local name, _, _, difficulty, _, _, _, _, _, _, encountercount, encounterProgress = GetSavedInstanceInfo(index)
    if instance:IsMatch(name, difficulty) then
      instance.encounters = encountercount
      instance.progress = encounterProgress

      return
    end
  end
end
