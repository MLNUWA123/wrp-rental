ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 


RegisterServerEvent('esx_rental:rent')
AddEventHandler('esx_rental:rent', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney => Config.Price then 
        xPlayer.removeMoney(Config.Price)
    else 
        TriggerClientEvent('pNotify:SendNotification', source, 'Nie posiadasz wystarczająco gotówki')
    end
end)