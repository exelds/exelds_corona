ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local isMaskOn = false
local maskNumber = 23
local maskColorNumber = 1

RegisterNetEvent('ExeLds:wearMask')
AddEventHandler('ExeLds:wearMask', function(durum)
	local playerPed = GetPlayerPed(-1)

    RequestAnimDict('misscommon@std_take_off_masks')
    while not HasAnimDictLoaded('misscommon@std_take_off_masks') do
        Citizen.Wait(1)
    end

	if durum then
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Maske taktın', length = 3000, style = { ['background-color'] = '#0066CC', ['color'] = '#FFFFFF' } })
		isMaskOn = true
		TaskPlayAnim(playerPed, "misscommon@std_take_off_masks", "take_off_mask_rps", 3.5, -8, -1, 49, 0, 0, 0, 0)
		Citizen.Wait(1000)
		SetPedComponentVariation(playerPed, 1, maskNumber, maskColorNumber, 2)
		ClearPedTasks(playerPed)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Maskeyi çıkarttın', length = 3000, style = { ['background-color'] = '#0066CC', ['color'] = '#FFFFFF' } })
		isMaskOn = false		
		TaskPlayAnim(playerPed, "misscommon@std_take_off_masks", "take_off_mask_rps", 3.5, -8, -1, 49, 0, 0, 0, 0)
		Citizen.Wait(1000)
		SetPedComponentVariation(playerPed, 1, 0, 0, 2)
		ClearPedTasks(playerPed)
	end

end)

RegisterNetEvent('ExeLds:covidTest')
AddEventHandler('ExeLds:covidTest', function()
	local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local elements = {}	
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()	
		for i = 1, #players, 1 do
            if players[i] ~= 1 then 
                    ESX.TriggerServerCallback('ExeLds:GetCharacterNameServer', function(playerss)
								if players[i] == PlayerId() then
									table.insert(
										elements,
										{
											label = playerss..' <span style="color:aqua;"> (Kendin)</span>',
											value = GetPlayerServerId(players[i])
										}
									)
								else
									table.insert(
										elements,
										{
											label = playerss,
											value = GetPlayerServerId(players[i])
										}
									)
								end
								ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'confirm',
										{
											title = 'Covid-19 Testi Yapılacak Kişi?',
											align = 'top-left',
											elements = elements
										},
										function(data2, menu2)																					
                                            if data2.current.value == 'kapat' then
												menu2.close()
											else	
												menu2.close()
												TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_PARKING_METER', 0, true)
												TriggerServerEvent("ExeLds:removeInventoryItem", 'covidtest', 1)											
												exports['mythic_notify']:SendAlert('inform', 'Covid-19 Testi uygulanıyor...', 3500, { ['background-color'] = '#0066CC', ['color'] = '#FFFFFF' })
												TriggerServerEvent('ExeLds:sendEmote', 'Covid-19 Testi uygulanıyor')
												Citizen.Wait(4000)
												ClearPedTasks(PlayerPedId())
												ESX.TriggerServerCallback('ExeLds:getInfectInfo', function(result)
													if result > 0 then
														exports['mythic_notify']:SendAlert('inform', 'Kişinin Covid-19 Test Sonucu Pozitif!', 2500, { ['background-color'] = '#66CC00', ['color'] = '#000000' })
													else
														exports['mythic_notify']:SendAlert('inform', 'Kişinin Covid-19 Test Sonucu Negatif!', 2500, { ['background-color'] = '#CC0000', ['color'] = '#FFFFFF' })
													end
												end, data2.current.value)										
											end
											end, function(data2, menu2)
											exports['mythic_notify']:SendAlert('inform', 'Covid Testi işleminden vazgeçtin', 3000, { ['background-color'] = '#CC0000', ['color'] = '#FFFFFF' })
											menu2.close()
										end
									)
                    end, GetPlayerServerId(players[i]))				
            end
        end
end)


RegisterNetEvent('ExeLds:covidVaccine')
AddEventHandler('ExeLds:covidVaccine', function()
	local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local elements = {}	
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		for i = 1, #players, 1 do
            if players[i] ~= 1 then 
                    ESX.TriggerServerCallback('ExeLds:GetCharacterNameServer', function(playerss)
                                if players[i] == PlayerId() then
									table.insert(
										elements,
										{
											label = playerss..' <span style="color:aqua;"> (Kendin)</span>',
											value = GetPlayerServerId(players[i])
										}
									)
								else
									table.insert(
										elements,
										{
											label = playerss,
											value = GetPlayerServerId(players[i])
										}
									)
								end
								ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'confirm',
										{
											title = 'Covid-19 Aşısı Yapılacak Kişi?',
											align = 'top-left',
											elements = elements
										},
										function(data2, menu2)																					
                                            if data2.current.value == 'kapat' then
												menu2.close()
											else	
												menu2.close()
												TriggerServerEvent("ExeLds:removeInventoryItem", 'covidtedavi', 1)		
												TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_PARKING_METER', 0, true)		
												exports['mythic_notify']:SendAlert('inform', 'Covid-19 Aşısı yapılıyor...', 3500, { ['background-color'] = '#0066CC', ['color'] = '#FFFFFF' })
												TriggerServerEvent('ExeLds:sendEmote', 'Covid-19 Aşısı yapılıyor')
												Citizen.Wait(4000)
												ClearPedTasks(PlayerPedId())
												TriggerServerEvent("ExeLds:covidVaccine", data2.current.value)
												exports['mythic_notify']:SendAlert('inform', 'Covid-19 Aşısı başarıyla yapıldı!', 2500, { ['background-color'] = '#66CC00', ['color'] = '#000000' })								
											end
											end, function(data2, menu2)
											exports['mythic_notify']:SendAlert('inform', 'Covid Aşısı işleminden vazgeçtin', 3000, { ['background-color'] = '#CC0000', ['color'] = '#FFFFFF' })
											menu2.close()
										end
									)
                    end, GetPlayerServerId(players[i]))
            end
        end
end)

local infectDistance = 3.0
local infected = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)		
		if not isMaskOn then
			ESX.TriggerServerCallback('ExeLds:getInfectInfo', function(result)
			infected = result
				if result > 0 then			
					local playerPed = PlayerPedId()
					local playerCoords = GetEntityCoords(playerPed)
					local players = ESX.Game.GetPlayersInArea(playerCoords, infectDistance)
					local closePlayers = {}
					for i = 1, #players, 1 do
						if players[i] ~= PlayerId() then
							table.insert(
								closePlayers,
								{
									id = GetPlayerServerId(players[i])
								}
							)
						end
					end
					TriggerServerEvent("ExeLds:infectPlayer", playerCoords, closePlayers, result)								
				else
					local randomBulasma = math.random(1,100)
					if randomBulasma >= 75 and randomBulasma <= 80 then
						local playerPed = PlayerPedId()
						local playerCoords = GetEntityCoords(playerPed)
						local players = ESX.Game.GetPlayersInArea(playerCoords, infectDistance)
						local closePlayers = {}
						for i = 1, #players, 1 do
							if players[i] ~= PlayerId() then
								table.insert(
									closePlayers,
									{
										id = GetPlayerServerId(players[i])
									}
								)
							end
						end
						TriggerServerEvent("ExeLds:infectPlayer", playerCoords, closePlayers, 10)	
					end
				end	
			end)	
		end
	end	
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(20000)								
		if infected >= 360 then
			Citizen.Wait(10000)
			ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 0.08)				
			Citizen.Wait(1500)
			if not IsPedSittingInAnyVehicle(PlayerPedId()) then
				SetPedToRagdoll(GetPlayerPed(-1), 3000, 3000, 0, 0, 0, 0)
				DoScreenFadeOut(250)				
				Citizen.Wait(2000)			
				DoScreenFadeIn(500)
			end				
		elseif infected >= 300 then
			Citizen.Wait(5000)
			ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 0.04)
			Citizen.Wait(1500)
			DoScreenFadeOut(250)
            Citizen.Wait(500)			
			DoScreenFadeIn(500)
		elseif infected >= 240 then
			Citizen.Wait(5000)
			ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 0.02)				
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)					
		if infected > 0 then
			TriggerServerEvent("ExeLds:getWorse")
			local playerPed = GetPlayerPed(-1)
			if infected >= 120 then					
				SetEntityMaxHealth(playerPed, 150)
				if GetEntityHealth(playerPed) > 150 then						
					SetEntityHealth(playerPed, 150)				
				end
				exports['mythic_notify']:SendAlert('error', 'Kendini halsiz hissediyorsun!', 3000)
			else
				SetEntityMaxHealth(playerPed, 200)
			end
		end	
	end	
end)

---------- Oto Emote Kısmı ---------------

local nbrDisplaying = 1
local color = {r = 255, g = 255, b = 255, alpha = 255} 
local font = 0 
local time = 7000

RegisterNetEvent('ExeLds:triggerDisplay')
AddEventHandler('ExeLds:triggerDisplay', function(text, source)
    local offset = 1 - (nbrDisplaying*0.14)  
    Display(GetPlayerFromServerId(source), text, offset)
end)	

function Display(mePlayer, text, offset)
    local displaying = true
    Citizen.CreateThread(function()
        Wait(time)
        displaying = false
    end)
    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = GetDistanceBetweenCoords(coordsMe['x'], coordsMe['y'], coordsMe['z'], coords['x'], coords['y'], coords['z'], true)
            if dist < 50 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(235, 140, 242, color.alpha)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        --SetTextDropShadow()
        --SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end
