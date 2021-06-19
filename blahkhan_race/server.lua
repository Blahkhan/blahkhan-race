ESX = nil
local racersOrder = 1
local racersList = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("b_race:annon")
AddEventHandler("b_race:annon", function(msg, pp)
  for _, playerId in ipairs(pp) do
    local p = ESX.GetPlayerFromId(playerId)
    if p.job.name ~= 'police' then
      TriggerClientEvent("b_race:showAnonn", playerId, msg)
    end
  end
  TriggerClientEvent("b_race:showAnonn", source, msg)
end)

RegisterServerEvent("b_race:setBegBlip")
AddEventHandler("b_race:setBegBlip", function(coords, h, pp)
  for _, playerId in ipairs(pp) do
    local p = ESX.GetPlayerFromId(playerId)
    if p.job.name ~= 'police' then
      TriggerClientEvent("b_race:setBegBlipClient", playerId, coords, h)
    end
  end
  TriggerClientEvent("b_race:setBegBlipClient", source, coords, h)
end)

RegisterServerEvent("b_race:setEndBlip")
AddEventHandler("b_race:setEndBlip", function(coords, h, pp)
  for _, playerId in ipairs(pp) do
    local p = ESX.GetPlayerFromId(playerId)
    if p.job.name ~= 'police' then
      TriggerClientEvent("b_race:setEndBlipClient", playerId, coords, h)
    end
  end
  TriggerClientEvent("b_race:setEndBlipClient", source, coords, h)
end)

RegisterServerEvent("b_race:resetServer")
AddEventHandler("b_race:resetServer", function(pp)
  racersOrder = 1
  racersList = {}
  for _, playerId in ipairs(pp) do
    local p = ESX.GetPlayerFromId(playerId)
    if p.job.name ~= 'police' then
      TriggerClientEvent("b_race:reset", playerId)
    end
  end
  TriggerClientEvent("b_race:reset", source)
end)

RegisterServerEvent("b_race:addRacer")
AddEventHandler("b_race:addRacer", function()
  local sourceXPlayer = ESX.GetPlayerFromId(source)
  for _,v in pairs(racersList) do
    if v == source then
      return
    end
  end
  if racersOrder == 1 then
    table.insert(racersList, source)
    local name = sourceXPlayer.getName()
    LoopRacing(name)
  elseif racersOrder == 2 then
    table.insert(racersList, source)
    local name = sourceXPlayer.getName()
    LoopRacing(name)
  elseif racersOrder == 3 then
    table.insert(racersList, source)
    local name = sourceXPlayer.getName()
    LoopRacing(name)
  end
end)

function LoopRacing(name)
  for _, playerId in ipairs(GetPlayers()) do
    local p = ESX.GetPlayerFromId(playerId)
    if p.job.name == Config.jobName then
      TriggerClientEvent("b_race:printWinners", playerId, name, racersOrder)
    end
  end
  racersOrder = racersOrder + 1
end
