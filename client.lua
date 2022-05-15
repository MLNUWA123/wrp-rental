local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX          = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function()
	for _, info in pairs(Config.MarkerZones) do
		if not info.boat then
			info.blip = AddBlipForCoord(info.x, info.y, info.z)
			SetBlipPriority(info.blip, 1)
			SetBlipSprite(info.blip, 348)
			SetBlipScale(info.blip, 0.7)
			SetBlipColour(info.blip, 24)
			SetBlipAsShortRange(info.blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Wypożyczalnia")
			EndTextCommandSetBlipName(info.blip)
			exports['WyspaRP']:SetBlipWyspa(info.blip, 'rental') 
		end
		if info.boat then
			info.blip = AddBlipForCoord(info.x, info.y, info.z)
			SetBlipPriority(info.blip, 1)
			SetBlipSprite(info.blip, 427)
			SetBlipScale(info.blip, 0.7)
			SetBlipColour(info.blip, 47)
			SetBlipAsShortRange(info.blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Wypożyczalnia łodzi")
			EndTextCommandSetBlipName(info.blip)
		end
	end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(Config.MarkerZones) do
            DrawMarker(Config.TypeMarker, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z, 0, 0, 0, 0, 0, 0, Config.MarkerScale.x, Config.MarkerScale.y, Config.MarkerScale.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, 0, 0, 0, 0)	
		end
    end
end)

Citizen.CreateThread(function()
    LocalPlayer.state:set('RentedBike', false, true)
    while true do
        Citizen.Wait(0)
	
        for k, zone in pairs(Config.MarkerZones) do
        	local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed, false)
            local distance = Vdist(coords.x, coords.y, coords.z, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z)
            if distance <= 1.40 then
				if not LocalPlayer.state.RentedBike then
					helptext(_U('open_menu'))
					
					if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(playerPed) then
						if not zone.boat then
							OpenBikesMenu()
						else
							OpenBoatsMenu()
						end
					end 	
				elseif LocalPlayer.state.RentedBike then
					helptext(_U('del_veh'))
					if IsControlJustPressed(0, Keys['E']) and IsPedOnAnyBike(playerPed) then
						TriggerEvent('esx:deleteVehicle')
						LocalPlayer.state:set('RentedBike', false, true)
					end 		
				end
			elseif distance < 1.45 then
				ESX.UI.Menu.CloseAll()
            end
        end
    end
end)



function OpenBikesMenu()
	local elements = {
		{label = _U('bike'), value = 'bike'},
		{label = 'Hulajnoga elektryczna', value = 'scooter'},
		{label = _U('scorcher'), value = 'scorcher'},
		{label = _U('faggio'), value = 'faggio'},
		{label = _U('skateboard'), value = 'skateboard'}
	}
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'rent',
    {
		title    = _U('biketitle'),
		align    = 'bottom-right',
		elements = elements,
    },
	function(data, menu)
	if data.current.value == 'bike' then
			TriggerServerEvent("esx_rental:rent", Config.Price) 
			TriggerEvent('esx:spawnVehicle', "tribike2")
		end

	if data.current.value == 'scooter' then
			TriggerServerEvent("esx_rental:rent", Config.Price) 
			TriggerEvent('esx:spawnVehicle', "serv_electricscooter")
		end
	
	if data.current.value == 'scorcher' then
			TriggerServerEvent("esx_rental:rent", Config.Price) 
			TriggerEvent('esx:spawnVehicle', "scorcher")
		end
	
	if data.current.value == 'faggio' then
			TriggerServerEvent("esx_rental:rent", Config.Price) 
			TriggerEvent('esx:spawnVehicle', "faggio")
		end
	
	if data.current.value == 'skateboard' then
			TriggerServerEvent("esx_rental:rent", Config.Price) 
			TriggerEvent('esx:spawnVehicle', "skateboard")
		end

	ESX.UI.Menu.CloseAll()
    LocalPlayer.state:set('RentedBike', true, true)
	ESX.ShowNotification("Wypożyczyłeś sprzęt, pobrano ~g~$"..Config.Price.."~s~")
    end,
	function(data, menu)
		menu.close()
	end)
end

function OpenBoatsMenu()
	local elements = {
		{label = 'Dinka Marquis', value = 'marquis'},
		{label = 'Shitzu Tropic', value = 'tropic'},
		{label = 'Speedophile Seashark', value = 'seashark'}
	}
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'rentboat',
    {
		title    = "Wypożyczalnia łodzi",
		align    = 'bottom-right',
		elements = elements,
    },
	function(data, menu)
	if data.current.value == 'marquis' then
			TriggerServerEvent("esx_rental:rentboat", Config.Boats) 
			ESX.Game.SpawnVehicle("marquis", Config.Spawn.Pos, Config.Spawn.Heading, function (vehicle)
		end)
	end

	if data.current.value == 'tropic' then
			TriggerServerEvent("esx_rental:rentboat", Config.Boats) 
			ESX.Game.SpawnVehicle("tropic", Config.Spawn.Pos, Config.Spawn.Heading, function (vehicle)
		end)
	end
	
	if data.current.value == 'seashark' then
			TriggerServerEvent("esx_rental:rentboat", Config.Boats) 
			ESX.Game.SpawnVehicle("seashark", Config.Spawn.Pos, Config.Spawn.Heading, function (vehicle)
		end)
	end
	
	ESX.UI.Menu.CloseAll()
	ESX.ShowNotification("Wypożyczyłeś sprzęt, pobrano ~g~$"..Config.Boats.."~s~")
    end,
	function(data, menu)
		menu.close()
	end)
end


function helptext(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
