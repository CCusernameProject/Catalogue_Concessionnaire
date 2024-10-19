ESX = nil
local PlayerData = {}

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

local isMenuOpen = false
local cooldown = false
local nomcategorie = "Défaut"
local derniervoituresorti = {}
local Temps = {}
local color = {}
local SelectedColor = {}
local SelectedLocal = {}
local PedSave = {}
local List1 = 1
local List2 = 1
local player = PlayerPedId()

local chargement = 0.0
local checkOkville = false
local checkOkmontage = false
local checkOkcircuit = false


local Style = {
	Line = Config.Color
}

local newsStyle = Style

local talk = RageUI.CreateMenu("Catalogue", "Catalogue")
local menu = RageUI.CreateSubMenu(talk, _U('name_of_menu'), _U('desc_of_menu'))
local vehicle = RageUI.CreateSubMenu(menu, _U('vehicle'), _U('vehicle_desc'))
local setting_menu = RageUI.CreateSubMenu(vehicle, _U('setting'), _U('setting_desc'))
local pay = RageUI.CreateSubMenu(setting_menu, _U('pay'), _U('pay'))
local time = RageUI.CreateSubMenu(pay, _U('time'), _U('time'))
local test_vehicule = RageUI.CreateSubMenu(time, _U('testvehicle'), _U('desc_testvehicle'))
menu.Closed = function()
    isMenuOpen = false
end
setting_menu.EnableMouse = true;
setting_menu.Closed = function()
	isMenuOpen = true
    if ontp == true then
        tpPlayer()
	    supprimervehiculeconcess()
    else if ontp == false then
	    supprimervehiculeconcess()
        end
    end
end

gaetan_conc = {
    catevehi = {},
	listecatevehi = {},
}

local Lieu = {
    action = {
        'Ville',
        'Montagne',
        'Piste',
    },
    list = 1
}
local Times = {
    action = {
        '15sec',
        '30sec',
        '1min',
        '1min30',
    },
    list = 1
}

function Keyboardput(TextEntry, ExampleText, MaxStringLength)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end




-- local TempColor = Config.Color
-- job_menu:SetRectangleBanner(TempColor[1], TempColor[2], TempColor[3], TempColor[4])

function open_menu()
    if not isMenuOpen then
        isMenuOpen = true
        RageUI.Visible(talk, true)
        while isMenuOpen do
            RageUI.IsVisible(talk, function()
                RageUI.Line(newsStyle)
                RageUI.Separator(_U('catalogue_actions'))
                RageUI.Line(newsStyle)
                if IsControlJustPressed(1, 177) and IsControlJustPressed(1, 194) then
                    isMenuOpen = false
                end
                RageUI.Button("Je souhaite voir les catégories", nil, {RightLabel = _U('arrow')}, true, {
                    onSelected = function()
                    end
                }, menu)
                RageUI.Separator("")
                RageUI.Button("Non, enfaite je ne veux rien", nil, {RightLabel = _U('arrow')}, true, {
                    onSelected = function()
                        isMenuOpen = false
                    end
                })
                RageUI.Line(newsStyle)
            end)

            RageUI.IsVisible(menu, function()
                RageUI.Line(newsStyle) 
                RageUI.Separator(_U('categories_access'))
                RageUI.Line(newsStyle)
                for i = 1, #gaetan_conc.catevehi, 1 do
                    RageUI.Button(_U('categories')..gaetan_conc.catevehi[i].label, _U('categories_desc'), {RightLabel = _U('arrow')}, true, {
                        onSelected = function()
                            nomcategorie = gaetan_conc.catevehi[i].label
                            categorievehi = gaetan_conc.catevehi[i].name
                            ESX.TriggerServerCallback('gaetan_concess:recupererlistevehicule', function(listevehi)
                                gaetan_conc.listecatevehi = listevehi
                            end, categorievehi)
                        end
                    }, vehicle)
                end
            end)
            RageUI.IsVisible(vehicle, function()
                RageUI.Line(newsStyle)
                RageUI.Checkbox("Spawn dans le vehicule", nil, tp, {}, {
                    onSelected = function(Checked)
                        tp = Checked
                        if Checked then
                            ontp = true
                        else if not Checked then
                                ontp = false
                            end
                        end
                    end
                })
                RageUI.Line(newsStyle)
                RageUI.Separator("↓ ~r~"..nomcategorie.."~w~ ↓")
                for i2 = 1, #gaetan_conc.listecatevehi, 1 do
                        RageUI.Button(gaetan_conc.listecatevehi[i2].name, _U('access_setting'), {RightLabel = gaetan_conc.listecatevehi[i2].price.._U('type_amount')}, true, {
                            onSelected = function()
                               nomvoiture = gaetan_conc.listecatevehi[i2].name
                               prixvoiture =  gaetan_conc.listecatevehi[i2].price
                               modelevoiture = gaetan_conc.listecatevehi[i2].model
                               supprimervehiculeconcess()
                               chargementvoiture(modelevoiture)
                               
                               ESX.Game.SpawnLocalVehicle(modelevoiture, Config.Spawn.Prevview.Pos1, Config.Spawn.Prevview.Header, function (vehicle)
                                if ontp == true then
                                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                    table.insert(derniervoituresorti, vehicle)
                                    FreezeEntityPosition(vehicle, true)
                                    SetModelAsNoLongerNeeded(modelevoiture)
                                    SetVehicleColours(derniervoituresorti[1], 5, 5)
                                else if ontp == false then
                                    table.insert(derniervoituresorti, vehicle)
                                    FreezeEntityPosition(vehicle, true)
                                    SetModelAsNoLongerNeeded(modelevoiture)
                                    SetVehicleColours(derniervoituresorti[1], 5, 5)
                                    end
                                end
                               end)
                           end
                        }, setting_menu)
                    end
                end)
                RageUI.IsVisible(setting_menu, function(vehicle)
                    RageUI.List(_U('color1'), {1}, List1, nil, {}, true, {
                        onListChange = function(Index)
							List1 = Index;
						end,
                    })
                    RageUI.ColourPanel("Couleur principale", RageUI.PanelColour.LsCustom,   Config.Couleur.Primaire[1],   Config.Couleur.Primaire[2], {
                        onColorChange = function(MinimumIndex, CurrentIndex)
                            Config.Couleur.Primaire[1] = MinimumIndex
                            Config.Couleur.Primaire[2] = CurrentIndex

                            SelectedColor.color = Config.Couleur.Primaire[2]
                            SetVehicleColours(derniervoituresorti[1], SelectedColor.color, SelectedColor.color2)
                        end
                    }, 2)
                    RageUI.ColourPanel("Couleur Secondaire", RageUI.PanelColour.LsCustom,   Config.Couleur.Secondaire[1],   Config.Couleur.Secondaire[2], {
                        onColorChange = function(MinimumIndex, CurrentIndex)
                            Config.Couleur.Secondaire[1] = MinimumIndex
                            Config.Couleur.Secondaire[2] = CurrentIndex
                            

                            SelectedColor.color2 = Config.Couleur.Secondaire[2]
                            SetVehicleColours(derniervoituresorti[1], SelectedColor.color, SelectedColor.color2)
                        end
                    }, 2)
                    RageUI.Button("Suivant", nil, {RightLabel = _U('arrow')}, true, {
                        onSelected = function()
                        end,
                    }, pay)
                    if (Config.activeVehicleStats == true) then
                        if (modelevoiture) then
                            local speed = GetVehicleModelMaxSpeed(modelevoiture)*3.6/220;
                            local accel = GetVehicleModelAcceleration(modelevoiture)*3.6/220;
                            local seats = GetVehicleModelNumberOfSeats(modelevoiture);
                            local braking = GetVehicleModelMaxBraking(modelevoiture)/2;
                            if (accel > 0.01) then accel = 0.01; end
                            if (speed > 1.0) then speed = 1.0; end
                            if (braking > 1.0) then braking = 1.0; end
                            
                            RageUI.Separator(_U('info_veh'))
                            if Config.vehicle.stats["maximum_vitesse"] then
                                RageUI.StatisticPanel(speed, "~r~Vitesse maximum", vehicle);
                            end
                            if Config.vehicle.stats["acceleration"] then
                                RageUI.StatisticPanel(accel*100, "~g~Accélération", vehicle);
                            end
                            if Config.vehicle.stats["freinage"] then
                                RageUI.StatisticPanel(braking, "~p~Freinage", vehicle);
                            end
                            if Config.vehicle.stats["nombre_places"] then
                                RageUI.BoutonPanel("~b~Nombre de places", seats, vehicle);
                            end
                        end
                    end
                end)
                RageUI.IsVisible(pay, function()
                    -- onbankv = false
                    -- oncashv = false

                    RageUI.Line(newsStyle)
                    RageUI.Checkbox("Payer caution en Cash", "Si vous cette case, vous paierez la caution en Cash", cashv, {}, {
                        onSelected = function(Checked)
                            cashv = Checked
                            if Checked then
                                oncashv = true
                            else if not Checked then
                                oncashv = false
                            end
                        end
                    end
                    })
                    RageUI.Checkbox("Payer caution en Chèque", "Si vous cette case, vous paierez la caution en Chèque", bankv, {}, {
                        onSelected = function(Checked)
                            bankv = Checked
                            if Checked then
                                onbankv = true
                            else if not Checked then
                                onbankv = false
                            end
                        end
                    end
                    })
                        
                    RageUI.Line(newsStyle)
                    if oncashv == true and onbankv == false then
                        RageUI.Button("Suivant", "Suivant", {RightLabel = _U('arrow')}, true, {
                            onSelected = function()
                            end
                        }, time)
                        RageUI.Line(newsStyle)
                    elseif oncashv == false and onbankv == true then
                        RageUI.Button("Suivant", "Suivant", {RightLabel = _U('arrow')}, true, {
                            onSelected = function()
                            end
                        }, time)
                        RageUI.Line(newsStyle)
                    elseif oncashv == true and onbankv == true then
                        RageUI.Button("Erreur", "Erreur Sélectionné un seul mode de paiement", {}, false, {
                            onSelected = function()
                            end
                        }, time)
                        RageUI.Line(newsStyle)
                    end
                end)
                
                RageUI.IsVisible(time, function()
                    RageUI.Line(newsStyle)
                    RageUI.List("Temps", Times.action, Times.list, nil, {}, true, {
                        onListChange = function(Index)
                            Times.list = Index;
                        end,
                        onSelected = function(Index)
                        if Index == 1 then
                            table.insert(Temps, 15)
                            RageUI.Button("Suivant", "Suivant", {RightLabel = _U('arrow')}, true, {
                                onSelected = function()
                                end
                            }, test_vehicule)
                        elseif Index == 2 then
                            table.insert(Temps, 30)
                            RageUI.Button("Suivant", "Suivant", {RightLabel = _U('arrow')}, true, {
                                onSelected = function()
                                end
                            }, test_vehicule)
                        elseif Index == 3 then
                            table.insert(Temps, 60)
                            RageUI.Button("Suivant", "Suivant", {RightLabel = _U('arrow')}, true, {
                                onSelected = function()
                                end
                            }, test_vehicule)
                        elseif Index == 4 then
                            table.insert(Temps, 90)
                            RageUI.Button("Suivant", "Suivant", {RightLabel = _U('arrow')}, true, {
                                    onSelected = function()
                                    end
                                }, test_vehicule)
                            end
                        end
                    })

                
                    RageUI.Line(newsStyle)
                end)

                RageUI.IsVisible(test_vehicule, function()
                    if IsControlJustPressed(1, 177) and IsControlJustPressed(1, 194) then
                        table.remove(Temps, 1)
                    end
                    RageUI.Line(newsStyle)
                    RageUI.Separator(_U('choose_location'))
                    RageUI.Line(newsStyle)
                    RageUI.List(_U('localisation'), Lieu.action, Lieu.list, nil, {}, true, {
                        onListChange = function(Index)
                            Lieu.list = Index;
                        end,
                        onSelected = function(Index)
                            if Index == 1 then
                                checkOkville = true
                            elseif Index == 2 then
                                checkOkmontage = true
                            elseif Index == 3 then
                                checkOkcircuit = true
                            end
                        end
                    })
                    RageUI.Line(newsStyle)


                    if checkOkville then
						RageUI.PercentagePanel(chargement, "Préparation de la voiture cour : "..math.floor(chargement*100).."%", "", "", {})
				 
							 if chargement < 1.0 then
								 chargement = chargement + 0.002
							 else 
								 chargement = 0
							 end
				
							 if chargement >= 1.0 then
								 RageUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
								 ville()
								 checkOkville = false
							 end
					end


                    if checkOkmontage then
						RageUI.PercentagePanel(chargement, "Préparation de la voiture cour : "..math.floor(chargement*100).."%", "", "", {})
				 
							 if chargement < 1.0 then
								 chargement = chargement + 0.002
							 else 
								 chargement = 0
							 end
				
							 if chargement >= 1.0 then
								 RageUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
								 montagne()
								 checkOkmontage = false
							 end
					end


                    if checkOkcircuit then
						RageUI.PercentagePanel(chargement, "Préparation de la voiture cour : "..math.floor(chargement*100).."%", "", "", {})
				 
							 if chargement < 1.0 then
								 chargement = chargement + 0.002
							 else 
								 chargement = 0
							 end
				
							 if chargement >= 1.0 then
								 RageUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
								 TriggerServerEvent('bank:retirer', amount)
								 circuit()
								 checkOkcircuit = false
							 end
					end


                end)
                Wait(0)
            end
        end
end


local colorByDistance = {
    [true] = {
        r = 0, 
        g = 255, 
        b = 0
    },
    
    [false] = {
        r = 255, 
        g = 0, 
        b = 0
    }
}

Citizen.CreateThread(function()
    while true do
        local interval = 1
        local pos = GetEntityCoords(PlayerPedId())
        local dest = vector3(Config.Spawn.Ped.Pos.x, Config.Spawn.Ped.Pos.y, Config.Spawn.Ped.Pos.z)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
        
        if distance > 1 then
            interval = 200
        else
            if distance < 1 then
                local text = _U('press_to_talk')
                Visual.Subtitle(text)
                if IsControlJustPressed(1, Config.Key_Open_Menu) then
                    ESX.TriggerServerCallback('gaetan_concess:recuperercategorievehicule', function(catevehi)
                        gaetan_conc.catevehi = catevehi
                    end)
                    isMenuOpen = false
                    open_menu()
                end
            end
        end
        Citizen.Wait(interval)
    end
end)


Citizen.CreateThread(function()
    local hash = GetHashKey(Config.Spawn.Ped.Type)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    local ped = CreatePed("PED_TYPE_CIVFEMALE", Config.Spawn.Ped.Type, Config.Spawn.Ped.Pos.x, Config.Spawn.Ped.Pos.y, Config.Spawn.Ped.Pos.z-1, Config.Spawn.Ped.Header, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
end)

function chargementvoiture(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName(_U('wait'))
		EndTextCommandBusyString(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end
		RemoveLoadingPrompt()
	end
end

function vehsupp()
	while #derniervoituresorti > 0 do
		local vehicle = derniervoituresorti[1]
        ESX.Game.DeleteVehicle(vehicle)
		table.remove(derniervoituresorti, 1)
	end
end

function supp()
    while # derniervoituresorti > 0 do
        local vehicle = derniervoituresorti[1]
        ESX.Game.DeleteVehicle(vehicle)
    end
end

function timer()
    local time = Temps[1]
    while (time > 0) do -- Whist we have time to wait
        Wait(1000) -- Wait a second
        time = time - 1
        Visual.Subtitle("Il vous reste ~r~"..time.." ~w~seconde(s)", 455555)
        if time == 0 then
            Visual.Subtitle("~g~Merci d'être venu essayer un véhicule !", 1500)
        end
    end
end

function ville()
    local player = PlayerPedId()
    local vehicle = derniervoituresorti[1]
    
    if IsPedInAnyVehicle(player, true) and ontp == true then
        isMenuOpen = false
        SetEntityCoords(GetVehiclePedIsUsing(player), Config.Spawn.TP.Town.x, Config.Spawn.TP.Town.y, Config.Spawn.TP.Town.z)
        SetEntityHeading(GetVehiclePedIsUsing(player), Config.Spawn.TP.HeaderTown)
        CreatePedInsideVehicle(vehicle, 9, modelsit, -2, false, false)
        FreezeEntityPosition(vehicle, false)
        pedintoveh()
        local Life = math.floor(GetVehicleEngineHealth(vehicle))
        TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Etat du véhicule', _U("lifebefore")..Life..' sur 1000', 'CHAR_CARSITE', nil)
        timer()
        Wait(500)
        returnmarker()
        repair()
    elseif ontp == false then
        isMenuOpen = false
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        Wait(5)
        SetEntityCoords(GetVehiclePedIsUsing(player), Config.Spawn.TP.Town.x, Config.Spawn.TP.Town.y, Config.Spawn.TP.Town.z)
        SetEntityHeading(GetVehiclePedIsUsing(player), Config.Spawn.TP.HeaderTown)
        local vehicle = derniervoituresorti[1]
        FreezeEntityPosition(vehicle, false)
        pedintoveh()
        local Life = math.floor(GetVehicleEngineHealth(vehicle))
        TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Etat du véhicule', _U("lifebefore")..Life..' sur 1000', 'CHAR_CARSITE', nil)
        timer()
        Wait(500)
        returnmarker2()
        repair()
    end
end

function montagne()
    local player = PlayerPedId()
    local vehicle = derniervoituresorti[1]
    
    if IsPedInAnyVehicle(player, true) and ontp == true then
        isMenuOpen = false
        SetEntityCoords(GetVehiclePedIsUsing(player), Config.Spawn.TP.Mountain.x, Config.Spawn.TP.Mountain.y, Config.Spawn.TP.Mountain.z)
        SetEntityHeading(GetVehiclePedIsUsing(player), Config.Spawn.TP.HeaderMountain)
        CreatePedInsideVehicle(vehicle, 9, modelsit, -2, false, false)
        FreezeEntityPosition(vehicle, false)
        pedintoveh()
        local Life = math.floor(GetVehicleEngineHealth(vehicle))
        TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Etat du véhicule', _U("lifebefore")..Life..' sur 1000', 'CHAR_CARSITE', nil)
        timer()
        Wait(500)
        returnmarker()
        repair()
    elseif ontp == false then
        isMenuOpen = false
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        Wait(5)
        SetEntityCoords(GetVehiclePedIsUsing(player), Config.Spawn.TP.Mountain.x, Config.Spawn.TP.Mountain.y, Config.Spawn.TP.Mountain.z)
        SetEntityHeading(GetVehiclePedIsUsing(player), Config.Spawn.TP.HeaderMountain)
        local vehicle = derniervoituresorti[1]
        FreezeEntityPosition(vehicle, false)
        pedintoveh()
        local Life = math.floor(GetVehicleEngineHealth(vehicle))
        TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Etat du véhicule', _U("lifebefore")..Life..' sur 1000', 'CHAR_CARSITE', nil)
        timer()
        Wait(500)
        returnmarker2()
        repair()
    end
end

function circuit()
    local player = PlayerPedId()
    local vehicle = derniervoituresorti[1]
    
    if IsPedInAnyVehicle(player, true) and ontp == true then
        isMenuOpen = false
        SetEntityCoords(GetVehiclePedIsUsing(player), Config.Spawn.TP.Drift.x, Config.Spawn.TP.Drift.y, Config.Spawn.TP.Drift.z)
        SetEntityHeading(GetVehiclePedIsUsing(player), Config.Spawn.TP.HeaderDrift)
        CreatePedInsideVehicle(vehicle, 9, modelsit, -2, false, false)
        FreezeEntityPosition(vehicle, false)
        pedintoveh()
        local Life = math.floor(GetVehicleEngineHealth(vehicle))
        TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Etat du véhicule', _U("lifebefore")..Life..' sur 1000', 'CHAR_CARSITE', nil)
        timer()
        Wait(500)
        returnmarker()
        repair()
    elseif ontp == false then
        isMenuOpen = false
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        Wait(5)
        SetEntityCoords(GetVehiclePedIsUsing(player), Config.Spawn.TP.Drift.x, Config.Spawn.TP.Drift.y, Config.Spawn.TP.Drift.z)
        SetEntityHeading(GetVehiclePedIsUsing(player), Config.Spawn.TP.HeaderDrift)
        local vehicle = derniervoituresorti[1]
        FreezeEntityPosition(vehicle, false)
        pedintoveh()
        local Life = math.floor(GetVehicleEngineHealth(vehicle))
        TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Etat du véhicule', _U("lifebefore")..Life..' sur 1000', 'CHAR_CARSITE', nil)
        timer()
        Wait(500)
        returnmarker2()
        repair()
    end
end

function returnmarker()
    local player = PlayerPedId()
    if IsPedInAnyVehicle(player, true) then
        local player = PlayerPedId()
        SetEntityCoords(GetVehiclePedIsUsing(player), Config.Spawn.Prevview.Pos1.x, Config.Spawn.Prevview.Pos1.y, Config.Spawn.Prevview.Pos1.z)
        SetEntityHeading(GetVehiclePedIsUsing(player), Config.Spawn.Prevview.Header)
        deletePedincar()
        isMenuOpen = true
        Wait(500)
        local vehicle = derniervoituresorti[1]
        FreezeEntityPosition(vehicle, true)
        bail()
    elseif IsPedInAnyVehicle(player, false) then
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        SetEntityCoords(GetVehiclePedIsUsing(player), Config.Spawn.Prevview.Pos1.x, Config.Spawn.Prevview.Pos1.y, Config.Spawn.Prevview.Pos1.z)
        SetEntityHeading(GetVehiclePedIsUsing(player), Config.Spawn.Prevview.Header)
        deletePedincar()
        isMenuOpen = true
        Wait(500)
        local vehicle = derniervoituresorti[1]
        FreezeEntityPosition(vehicle, true)
        bail()
    end
end

function returnmarker2()
    SetEntityCoords(GetVehiclePedIsUsing(player), Config.Spawn.Prevview.Pos1.x, Config.Spawn.Prevview.Pos1.y, Config.Spawn.Prevview.Pos1.z)
    SetEntityHeading(GetVehiclePedIsUsing(player), Config.Spawn.Prevview.Header)
    SetEntityCoords(player, Config.Marker.Pos.x, Config.Marker.Pos.y, Config.Marker.Pos.z)
    SetEntityHeading(player, Config.Marker.Header)
    deletePedincar()
    isMenuOpen = true
    Wait(500)
    local vehicle = derniervoituresorti[1]
    FreezeEntityPosition(vehicle, true)
    bail()
    Wait(1000)
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true)
end

function pedintoveh()
    local vehicle = derniervoituresorti[1]
    local hash = GetHashKey(Config.Spawn.Ped.Type)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    local ped = CreatePed("PED_TYPE_CIVFEMALE", Config.Spawn.Ped.Type, Config.Spawn.Ped.Pos.x, Config.Spawn.Ped.Pos.y, Config.Spawn.Ped.Pos.z-1, Config.Spawn.Ped.Header, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    TaskWarpPedIntoVehicle(ped, vehicle, -2)
    table.insert(PedSave, ped)
end

function deletePedincar()
    local pedsaved = PedSave[1]
    DeletePed(pedsaved)
    table.remove(PedSave, 1)
end

function repair()
    local vehicle = derniervoituresorti[1]
    if DoesEntityExist(vehicle) then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
    end
end

function bail()
    local vehicle = derniervoituresorti[1]
    local Life = math.floor(GetVehicleEngineHealth(vehicle))
    TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Etat du véhicule', _U("lifeafter")..Life..' sur 1000', 'CHAR_CARSITE', nil)
    caution()
end

function caution()
    local vehicle = derniervoituresorti[1]
    if GetVehicleEngineHealth(vehicle) > 900 then
        if oncashv == true and onbankv == false then
            TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', '~g~Félicitation', '~g~Vous n\'avez pas ou pas beaucoup endommagé le véhicule', 'CHAR_CARSITE', nil)
        elseif oncashv == false and onbankv == true then
            TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', '~g~Félicitation', '~g~Vous n\'avez pas ou pas beaucoup endommagé le véhicule', 'CHAR_CARSITE', nil)
        end
    elseif GetVehicleEngineHealth(vehicle) <= 900 and GetVehicleEngineHealth(vehicle) > 600 then
        price = Config.FirstPrice
        if oncashv == true and onbankv == false then
            TriggerServerEvent('gaetan_concess:removecash', price)
            TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Paiement effectué : ', 'Vous avez payé une facture d\'un montant de : ~r~3000€ ~w~pour cause de ~r~dégradation', 'CHAR_CARSITE', 9)
        elseif oncashv == false and onbankv == true then
            TriggerServerEvent('gaetan_concess:removebank', price)
            TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Paiement effectué : ', 'Vous avez payé une facture d\'un montant de : ~r~3000€ ~w~pour cause de ~r~dégradation', 'CHAR_CARSITE', 9)
        end
    elseif GetVehicleEngineHealth(vehicle) <= 600 and GetVehicleEngineHealth(vehicle) > 400 then
        price = Config.SecondPrice
        if oncashv == true and onbankv == false then
            TriggerServerEvent('gaetan_concess:removecash', price)
            TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~r~6000€ ~w~pour cause de ~r~dégradation', 'CHAR_CARSITE', 9)
        elseif oncashv == false and onbankv == true then   
            TriggerServerEvent('gaetan_concess:removebank', price)
            TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~r~6000€ ~w~pour cause de ~r~dégradation', 'CHAR_CARSITE', 9)
        end
    elseif GetVehicleEngineHealth(vehicle) <= 400 and GetVehicleEngineHealth(vehicle) > 200 then
        price = Config.ThridPrice
        if oncashv == true and onbankv == false then
            TriggerServerEvent('gaetan_concess:removecash', price)
            TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~r~9000€ ~w~pour cause de ~r~dégradation', 'CHAR_CARSITE', 9)
        elseif oncashv == false and onbankv == true then
            TriggerServerEvent('gaetan_concess:removebank', price)
            TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~r~9000€ ~w~pour cause de ~r~dégradation', 'CHAR_CARSITE', 9)
        end
    elseif GetVehicleEngineHealth(vehicle) <= 200 and GetVehicleEngineHealth(vehicle) > 0 then
        price = Config.FourPrice
        if oncashv == true and onbankv == false then
            TriggerServerEvent('gaetan_concess:removecash', price)
            TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~r~12000€ ~w~pour cause de ~r~dégradation', 'CHAR_CARSITE', 9)
        elseif oncashv == false and onbankv == true then
            TriggerServerEvent('gaetan_concess:removebank', price)
            TriggerEvent('esx:showAdvancedNotification', 'Concessionnaire', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~r~12000€ ~w~pour cause de ~r~dégradation', 'CHAR_CARSITE', 9)
        end
    end
end

function supprimervehiculeconcess()
	while #derniervoituresorti > 0 do
		local vehicle = derniervoituresorti[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(derniervoituresorti, 1)
	end
end

function tpPlayer()
    SetEntityCoords(GetPlayerPed(-1), Config.Marker.Pos.x, Config.Marker.Pos.y, Config.Marker.Pos.z-1)
end

Citizen.CreateThread(function()
    if IsControlJustPressed(1, 19 + 46) then
        plyPed = PlayerPedId()
        local waypointHandle = GetFirstBlipInfoId(8)

        if DoesBlipExist(waypointHandle) then
            Citizen.CreateThread(function()
                local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
                local foundGround, zCoords, zPos = false, -500.0, 0.0

                while not foundGround do
                    zCoords = zCoords + 10.0
                    RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
                    Citizen.Wait(0)
                    foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)

                    if not foundGround and zCoords >= 2000.0 then
                        foundGround = true
                    end
                end

                SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
                ESX.ShowNotification("Vous avez été TP")
                TriggerServerEvent("OTEXO:SendLogs", "Se TP sur le waypoint")
            end)
        else
            ESX.ShowNotification("Pas de marqueur sur la carte")
        end
    end
end)