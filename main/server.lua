
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(src)
    Wait(1000)
    TriggerClientEvent('HudPlayerLoad', src)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded')
AddEventHandler('QBCore:Server:OnPlayerLoaded', function()
  local source = source
  TriggerClientEvent('HudPlayerLoad', source)
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
      TriggerClientEvent('HudPlayerLoad', -1)
end)
