Config = {}

Config.DrawDistance = 100.0
Config.Locale = 'fr'
Config.Key_Open_Menu = 51 -- The key is E


Config.Marker = {
	Type = 2,
	--Pos = {x = -3538.16, y = -8358.62, z = 15.31},
	Pos = {x = -64.33, y = 68.89, z = 71.83},
	Header = 122.48
}


Config.Color = {      
    255, 0, 0, 170    -- Configuration couleur du menu
}

Config.Couleur = {
	Primaire = {1, 1},
	Secondaire = {1, 1},
}

Config.activeVehicleStats = true
Config.PercentSur = 5
Config.SocietyName = 'society_concess'
Config.FirstPrice = 3000
Config.SecondPrice = 6000
Config.ThridPrice = 9000
Config.FourPrice = 12000

Config.Spawn = {
	Ped = {
		Pos = {x = -64.33, y = 68.89, z = 71.83},
		Header = 308.95,
		Type = "a_f_y_femaleagent"
	},
	Prevview = {
		--Pos1 = {x = -3534.32, y = -8364.82, z = 15.31},
		--Header = 60.59
		Pos1 = {x = -66.62, y = 72.28, z= 71.85},
		Header = 200.49
	},

	Colors = {
		-- "~r~Rouge" = Name of color. Rouge = Red in french !
		-- You can already change this to your language !
		-- And for finish you can add a Color you just need to copy and paste the line into Colors and change the name, change the value with the following value, and you can change color by your color choose
		{Name = "~r~Rouge ~s~", Value = 1, color = 27},
		{Name = "~b~Bleu ~s~", Value = 2, color = 140},
		{Name = "~g~Vert ~s~", Value = 3, color = 92},
		{Name = "~y~Jaune ~s~", Value = 4, color = 89},
		{Name = "Noir", Value = 5, color = 0},  
		{Name = "Blanc", Value = 6, color = 134},    
		{Name = "~p~Violet ~s~", Value = 7, color = 148},
		{Name = "~o~Orange ~s~", Value = 8, color = 138},
		{Name = "~HUD_COLOUR_PINK~ Rose~s~", Value = 9, color = 135},
		{Name = "~HUD_COLOUR_BLUEDARK~ Bleu Foncé ~s~", Value = 10, color = 75},
		{Name = "~HUD_COLOUR_MENU_GREY_LIGHT~ Gris ~s~", Value = 11, color = 26},
		{Name = "Original", Value = 12, color = 8},
	},
	TP = {
		-- Monaco --
		--{x = -3534.32, y = -8364.82, z = 15.31},
		-- 41.87,
        Town = {x = -70.06, y = 49.77, z = 71.99},
		HeaderTown = 55.51,
		Mountain = {x = -416.91, y = 4885.56, z = 191.11},
		HeaderMountain = 293.42,
		Drift = {x = 966.40, y = -3009.95, z = 5.90},
		HeaderDrift = 266.83,
	}
}

Config.vehicle = {

	stats = { --[[ Activer ou désactiver l'affichage des statistiques ]]
		["maximum_vitesse"] = true,
		["acceleration"] = true,
		["freinage"] = true,
		["nombre_places"] = true,
		["plaque"] = true,
		["moteur_etat"] = true,
		["carroserie_etat"] = true,
		["litres_essence"] = true
	},
}

Config.Percent2 = 100
Config.Percent = (Config.PercentSur / Config.Percent2) + 1 