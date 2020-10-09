ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('covidtest', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('ExeLds:covidTest', source)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Bu eşyayı sadece doktorlar kullanabilir.', length = 6000, style = { ['background-color'] = '#CC0000', ['color'] = '#FFFFFF' } })
	end
end)

ESX.RegisterUsableItem('covidtedavi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('ExeLds:covidVaccine', source)
	else	
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Bu eşyayı sadece doktorlar kullanabilir.', length = 6000, style = { ['background-color'] = '#CC0000', ['color'] = '#FFFFFF' } })
	end	
end)

RegisterServerEvent('ExeLds:covidVaccine')
AddEventHandler('ExeLds:covidVaccine', function(targetSource)
	local xPlayer = ESX.GetPlayerFromId(targetSource)
	MySQL.Sync.execute('UPDATE users SET Corona = @Corona WHERE identifier = @identifier',
							{
								['@Corona'] = 0,
								['@identifier'] = xPlayer.identifier
							})
end)

ESX.RegisterServerCallback('ExeLds:GetCharacterNameServer', function(source, cb, target)
    local xTarget = ESX.GetPlayerFromId(target)

    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
        ['@identifier'] = xTarget.identifier
    })

    local firstname = result[1].firstname
    local lastname  = result[1].lastname

    cb(''.. firstname .. ' ' .. lastname ..'')
end)

RegisterServerEvent('ExeLds:removeInventoryItem')
AddEventHandler('ExeLds:removeInventoryItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem(itemName, count)
end)

RegisterServerEvent('ExeLds:infectPlayer')
AddEventHandler('ExeLds:infectPlayer', function(coords, closePlayers, value)
	for i = 1, #closePlayers do	
		local sans = math.random(1,100)
		if value < 60 then
			if sans > 55 and sans < 60 then
				local xPlayer = ESX.GetPlayerFromId(closePlayers[i].id)
				MySQL.Async.fetchAll('SELECT Corona FROM users WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier},
					function(result)
					if result[1].Corona == 0 then
						MySQL.Sync.execute('UPDATE users SET Corona = @Corona WHERE identifier = @identifier',
							{
								['@Corona'] = 1,
								['@identifier'] = xPlayer.identifier
							})
					end		
				end)		
			end
		elseif value < 120 then
			if sans > 50 and sans < 60 then
				local xPlayer = ESX.GetPlayerFromId(closePlayers[i].id)
				MySQL.Async.fetchAll('SELECT Corona FROM users WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier},
					function(result)
					if result[1].Corona == 0 then
						MySQL.Sync.execute('UPDATE users SET Corona = @Corona WHERE identifier = @identifier',
							{
								['@Corona'] = 1,
								['@identifier'] = xPlayer.identifier
							})
					end		
				end)		
			end
		elseif value < 180 then
			if sans > 45 and sans < 60 then
				local xPlayer = ESX.GetPlayerFromId(closePlayers[i].id)
				MySQL.Async.fetchAll('SELECT Corona FROM users WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier},
					function(result)
					if result[1].Corona == 0 then
						MySQL.Sync.execute('UPDATE users SET Corona = @Corona WHERE identifier = @identifier',
							{
								['@Corona'] = 1,
								['@identifier'] = xPlayer.identifier
							})
					end		
				end)		
			end	
		elseif value < 240 then
			if sans > 40 and sans < 60 then
				local xPlayer = ESX.GetPlayerFromId(closePlayers[i].id)
				MySQL.Async.fetchAll('SELECT Corona FROM users WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier},
					function(result)
					if result[1].Corona == 0 then
						MySQL.Sync.execute('UPDATE users SET Corona = @Corona WHERE identifier = @identifier',
							{
								['@Corona'] = 1,
								['@identifier'] = xPlayer.identifier
							})
					end		
				end)		
			end	
		elseif value < 300 then
			if sans > 35 and sans < 60 then
				local xPlayer = ESX.GetPlayerFromId(closePlayers[i].id)
				MySQL.Async.fetchAll('SELECT Corona FROM users WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier},
					function(result)
					if result[1].Corona == 0 then
						MySQL.Sync.execute('UPDATE users SET Corona = @Corona WHERE identifier = @identifier',
							{
								['@Corona'] = 1,
								['@identifier'] = xPlayer.identifier
							})
					end		
				end)		
			end	
		elseif value < 360 then
			if sans > 30 and sans < 60 then
				local xPlayer = ESX.GetPlayerFromId(closePlayers[i].id)
				MySQL.Async.fetchAll('SELECT Corona FROM users WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier},
					function(result)
					if result[1].Corona == 0 then
						MySQL.Sync.execute('UPDATE users SET Corona = @Corona WHERE identifier = @identifier',
							{
								['@Corona'] = 1,
								['@identifier'] = xPlayer.identifier
							})
					end		
				end)		
			end		
		elseif value >= 360 then
			if sans > 25 and sans < 60 then
				local xPlayer = ESX.GetPlayerFromId(closePlayers[i].id)
				MySQL.Async.fetchAll('SELECT Corona FROM users WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier},
					function(result)
					if result[1].Corona == 0 then
						MySQL.Sync.execute('UPDATE users SET Corona = @Corona WHERE identifier = @identifier',
							{
								['@Corona'] = 1,
								['@identifier'] = xPlayer.identifier
							})
					end		
				end)		
			end	
		end
	end
end)


RegisterServerEvent('ExeLds:getWorse')
AddEventHandler('ExeLds:getWorse', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Sync.execute('UPDATE users SET Corona = Corona + @Corona WHERE identifier = @identifier',
				{
					['@Corona'] = 1,
					['@identifier'] = xPlayer.identifier
				})
				
end)

ESX.RegisterServerCallback('ExeLds:getInfectInfo', function(source, cb, targetSource)
	local xPlayer
	if targetSource == nil then
		xPlayer = ESX.GetPlayerFromId(source)
	else
		xPlayer = ESX.GetPlayerFromId(targetSource)
	end	
	if xPlayer ~= nil then
		MySQL.Async.fetchAll('SELECT Corona FROM users WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier},
			function(result)
				cb(result[1].Corona)
		end)
	end
end)

RegisterServerEvent('ExeLds:sendEmote')
AddEventHandler('ExeLds:sendEmote', function(text)
	TriggerClientEvent('ExeLds:triggerDisplay', -1, text, source)
end)