ESX = exports['es_extended']:getSharedObject()

local fuelStations = {
    vector3(265.648, -1261.309, 29.292), -- Beispiel-Koordinaten, füge mehr hinzu
    -- Weitere Tankstellen-Koordinaten können hier hinzugefügt werden
}

local isNearFuelStation = false
local isFueling = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        isNearFuelStation = false

        for _, coords in pairs(fuelStations) do
            local distance = #(playerCoords - coords)

            if distance < 5.0 then
                isNearFuelStation = true

                if not isFueling then
                    ESX.ShowHelpNotification('Drücke ~INPUT_CONTEXT~ um zu tanken.')

                    if IsControlJustReleased(0, 38) then -- Taste E
                        TriggerServerEvent('esx_fuel:checkMoney')
                    end
                end
            end
        end

        if not isNearFuelStation then
            Citizen.Wait(500)
        end
    end
end)

RegisterNetEvent('esx_fuel:startFueling')
AddEventHandler('esx_fuel:startFueling', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 then
        ESX.ShowNotification('Du bist in keinem Fahrzeug!')
        return
    end

    local coords = GetEntityCoords(playerPed)
    local npcModel = GetHashKey('s_m_m_autoshop_02')

    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Citizen.Wait(100)
    end

    local npc = CreatePed(4, npcModel, coords.x, coords.y, coords.z, 0.0, true, false)
    TaskGoToEntity(npc, vehicle, -1, 3.0, 1.0, 1073741824, 0)

    isFueling = true
    ESX.ShowNotification('Der NPC tankt dein Fahrzeug...')

    Citizen.Wait(10000) -- 10 Sekunden warten

    SetVehicleFuelLevel(vehicle, 100.0)
    ESX.ShowNotification('Dein Fahrzeug ist vollgetankt!')

    DeleteEntity(npc)
    isFueling = false
end)
