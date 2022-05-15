ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 


RegisterServerEvent('esx_rental:rent')
AddEventHandler('esx_rental:rent', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local whatever = xPlayer.getMoney - Config.Price

    if xPlayer.getMoney => Config.Price then 
        xPlayer.removeMoney(Config.Price)
    else 
        TriggerClientEvent('pNotify:SendNotification', source, 'Brakuje Ci: $' ..whatever)
    end
end)


RegisterServerEvent('esx_rental:rentboat')
AddEventHandler('esx_rental:rentboat', function()
        local xPlayer = ESX.GetPlayerFromId(source) 
        local whatever = xPlayer.getMoney - Config.Boats
        
      if xPlayer.getMoney => Config.Boats then 
        xPlayer.removeMoney(Config.Boats)
    else 
        TriggerClientEvent('pNotify:SendNotification', source, 'Brakuje Ci: $' ..whatever)
    end
end)
