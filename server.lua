ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent('esx_fuel:checkMoney')
AddEventHandler('esx_fuel:checkMoney', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 50 -- Preis fürs Tanken

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('esx_fuel:startFueling', source)
    else
        TriggerClientEvent('esx:showNotification', source, 'Du hast nicht genug Geld!')
    end
end)
