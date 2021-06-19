local playerData = {}
local ESX = nil
local showBlipBeg = false
local heading
local begBlipCoords
local showBlipEnd = false
local endBlipCoords
local pp

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    if showBlipBeg then
      if GetDistanceBetweenCoords(coords, begBlipCoords.x, begBlipCoords.y, begBlipCoords.z, true) < 350 then
        DrawMarker(4, begBlipCoords.x, begBlipCoords.y, begBlipCoords.z - 0.4, 0.0, 0.0, 0.0, 0, 0.0, heading, 15.0, 1.5, 15.0, 255, 255, 255, 100, false, false, 2, false, false, false, false)
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    if showBlipEnd then
      if GetDistanceBetweenCoords(coords, endBlipCoords.x, endBlipCoords.y, endBlipCoords.z, true) < 350 then
        DrawMarker(4, endBlipCoords.x, endBlipCoords.y, endBlipCoords.z - 0.4, 0.0, 0.0, 0.0, 0, 0.0, heading, 15.0, 1.5, 15.0, 0, 0, 0, 100, false, false, 2, false, false, false, false)
      end
      if GetDistanceBetweenCoords(coords, endBlipCoords.x, endBlipCoords.y, endBlipCoords.z, true) < 10 then
        if IsPedInAnyVehicle(playerPed, false) then
          TriggerServerEvent("b_race:addRacer")
        end
      end
    end
  end
end)

RegisterCommand("race", function(source, args, rawCommand)
  local playerPed = GetPlayerPed(-1)
  playerData = ESX.GetPlayerData(GetPlayerPed(-1))
  local playerCoords = GetEntityCoords(playerPed)
  local lHeading = GetEntityHeading(playerPed)

  if playerData.job.name ~= Config.jobName then
    exports['mythic_notify']:DoCustomHudText('inform', "Nie pracujesz w firmie" .. Config.jobName, 5000)
    return
  end

  if args[1] == nil then
    exports['mythic_notify']:DoCustomHudText('inform', "Musisz podać czy to początek czy koniec", 5000)
    Citizen.Wait(10)
    exports['mythic_notify']:DoCustomHudText('inform', "/race beg|end|reset|anon", 5000)
    return
  end

  pp = ESX.Game.GetPlayersInArea(playerCoords, 150.0)

  if args[1] == "beg" then
    TriggerServerEvent("b_race:setBegBlip", playerCoords, lHeading, pp)
  elseif args[1] == "end" then
    TriggerServerEvent("b_race:setEndBlip", playerCoords, lHeading, pp)
  elseif args[1] == "reset" then
    TriggerServerEvent("b_race:resetServer", pp)
  elseif args[1] == "anon" then
    local msg = ""
    for i = 2, 100, 1 do
      if args[i] == nil then
        break
      end
      msg = msg .. " " .. args[i]
    end
    TriggerServerEvent("b_race:annon", msg, pp)
  end
end, false)

RegisterNetEvent("b_race:setBegBlipClient")
AddEventHandler("b_race:setBegBlipClient", function(c, h)
  showBlipBeg = true
  begBlipCoords = c
  heading = h
end)

RegisterNetEvent("b_race:setEndBlipClient")
AddEventHandler("b_race:setEndBlipClient", function(c, h)
  showBlipEnd = true
  endBlipCoords = c
  heading = h
end)

RegisterNetEvent("b_race:reset")
AddEventHandler("b_race:reset", function()
  showBlipEnd = false
  showBlipBeg = false
end)

RegisterNetEvent("b_race:printWinners")
AddEventHandler("b_race:printWinners", function(winnerName, place)
  exports['mythic_notify']:DoCustomHudText('inform', "Miejsce " .. place .. " zdobył " .. winnerName, 5000)
end)

RegisterNetEvent("b_race:showAnonn")
AddEventHandler("b_race:showAnonn", function(msg)
  exports['mythic_notify']:DoCustomHudText('inform', "Organizator Wyścigu:" .. msg, 5000)
end)
