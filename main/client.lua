local function calculateHealth(ped)
    local healthBase = GetEntityHealth(ped) - 100
    return GetEntityModel(ped) == `mp_f_freemode_01` and (healthBase + 25) or healthBase
 end


local function sendPlayerStats(ped)
    SendNUIMessage({ action = 'HEALTH&ARMOR', health = calculateHealth(ped), armor = GetPedArmour(ped) })
 end

 RegisterCommand("setvalues", function(source, args, rawCommand)
   local percentage = tonumber(args[1])  -- Komuttan girilen yüzdelik değeri al
 
   if percentage and percentage >= 0 and percentage <= 100 then
     local value = percentage * 10000  -- Yüzdeliği esx_status modülünün anlayacağı formata dönüştür
     
     TriggerEvent("esx_status:set", "thirst", value)
     TriggerEvent("esx_status:set", "hunger", value)
   else
     print("Lütfen 0 ile 100 arasında bir değer girin!")
   end
 end, false)
 
 Citizen.CreateThread(function()
    while true do
       Citizen.Wait(1000)
       local ped = PlayerPedId()
       sendPlayerStats(ped)
       Citizen.Wait(2500)
    end
 end)
 
 RegisterNetEvent("esx_status:onTick")
 AddEventHandler("esx_status:onTick", function(data)
 for _,v in pairs(data) do
    if v.name == "hunger" then
       SendNUIMessage({
          action = "HUNGER",
          hunger = math.floor(v.percent)
       })   
       print(" HUNGER " , math.floor(v.percent))
      elseif v.name == "thirst" then
         print(" WATER " , math.floor(v.percent))
       SendNUIMessage({
          action = "WATER",
          water = math.floor(v.percent)
       })
    end
 end
 end)

  
 RegisterNetEvent("HudPlayerLoad")
 AddEventHandler("HudPlayerLoad", function()
   SendNUIMessage({ action = 'CONNECTED'})
 end)


 
TriggerEvent('esx_status:getStatus', 'hunger', function(status) 
  hunger = math.floor(status.val / 10000) 
end)

TriggerEvent('esx_status:getStatus', 'thirst', function(status) 
  thirst = math.floor(status.val / 10000) 
end)

Citizen.CreateThread(function()
   local LastStreetName1, LastStreetName2 = nil, nil
   while true do
      Citizen.Wait(2000)
     local Coords = GetEntityCoords(PlayerPedId())
     local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
     local StreetName1 = GetLabelText(GetNameOfZone(Coords.x, Coords.y, Coords.z))
     local StreetName2 = GetStreetNameFromHashKey(Street1)
     if StreetName1 ~= LastStreetName1 or StreetName2 ~= LastStreetName2 then
       if StreetName1 ~= nil and StreetName1 ~= "" and StreetName2 ~= nil and StreetName2 ~= "" then
         SendNUIMessage({
           action = 'STREET',
           StreetName1 = StreetName1,
           StreetName2 = StreetName2,
         })
         LastStreetName1, LastStreetName2 = StreetName1, StreetName2
       end
     end
     local wait = IsPedInAnyVehicle(PlayerPedId()) and 500 or 2000
     Citizen.Wait(wait)
   end
 end)
 

 RegisterCommand("Notification", function() -- Test Command
   Citizen.Wait(1000)
   exports[GetCurrentResourceName()]:Notification('NOTIFICATION', 'To purchase the product visit <span style="color: #FF5733;">https://</span><span style="color: #33B1FF;">dark</span><span style="color: #33FF57;">-store</span><span style="color: #FFD833;">.tebex.io</span> you can trigger this notification with export, we are happy and proud to serve you.')
   Citizen.Wait(1000)
   exports[GetCurrentResourceName()]:Notification('NOTIFICATION', 'To purchase the product visit <span style="color: #FF5733;">https://</span><span style="color: #33B1FF;">dark</span><span style="color: #33FF57;">-store</span><span style="color: #FFD833;">.tebex.io</span> you can trigger this notification with export, we are happy and proud to serve you.')
   Citizen.Wait(1000)
   exports[GetCurrentResourceName()]:Notification('NOTIFICATION', 'To purchase the product visit <span style="color: #FF5733;">https://</span><span style="color: #33B1FF;">dark</span><span style="color: #33FF57;">-store</span><span style="color: #FFD833;">.tebex.io</span> you can trigger this notification with export, we are happy and proud to serve you.')
   end)
   

   
   RegisterNetEvent('HudNotification') -- Trigger ==> Export
   AddEventHandler('HudNotification', function(Type, Header,Message)
      exports[GetCurrentResourceName()]:Notification(Header, Message)
   end)
   
   exports('Notification', function(Header,Message)
      SendNUIMessage({
         action = "NOTIFICATION",
         label = Header, 
         description = Message
      })
end)
      

Citizen.CreateThread(function()
   while true do
       Citizen.Wait(100)
       local ped = PlayerPedId()
       local vehicle = GetVehiclePedIsIn(ped, false)
       if IsPedInVehicle(ped, vehicle, true) then
           SendNUIMessage({ action = 'STATUS', variable = true })
           DisplayRadar(true)
       else
           SendNUIMessage({ action = 'STATUS', variable = false })
           DisplayRadar(false)
           Citizen.Wait(500)
       end
   end
end)

Citizen.CreateThread(function()
   local minimap = RequestScaleformMovie("minimap")
   SetRadarBigmapEnabled(true, false)
   Wait(0)
   SetRadarBigmapEnabled(false, false)
   while true do
       Wait(0)
       BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
       ScaleformMovieMethodAddParamInt(3)
       EndScaleformMovieMethod()
   end
end)