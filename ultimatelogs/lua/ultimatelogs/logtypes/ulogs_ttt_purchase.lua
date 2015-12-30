--[[
    
     _   _  _  _    _                    _           _                        
    | | | || || |  (_)                  | |         | |                       
    | | | || || |_  _  _ __ ___    __ _ | |_   ___  | |      ___    __ _  ___ 
    | | | || || __|| || '_ ` _ \  / _` || __| / _ \ | |     / _ \  / _` |/ __|
    | |_| || || |_ | || | | | | || (_| || |_ |  __/ | |____| (_) || (_| |\__ \
     \___/ |_| \__||_||_| |_| |_| \__,_| \__| \___| \_____/ \___/  \__, ||___/
                                                                    __/ |     
                                                                   |___/      
    
    
]]--





local INDEX = 19
local GM = 3

ULogs.AddLogType( INDEX, GM, ULogs.translation.Purchase, function( Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	
	local Informations = {}
	local Base = ULogs.RegisterBase( Player )
	local Data = {}
	Data[ 1 ] = Player:Name()
	Data[ 2 ] = {}
	table.Add( Data[ 2 ], Base )
	table.insert( Informations, Data )
	
	return Informations
	
end)

hook.Add( "TTTOrderedEquipment", "ULogs_TTTOrderedEquipment", function( Player, Equipment, IsItem )
	
	if !SERVER then return end
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	if !Equipment then Equipment = string.lower(ULogs.translation.UnknownItem) end
	
	ULogs.AddLog( INDEX, ULogs.PlayerInfo( Player ) .. " "..string.lower(ULogs.translation.Ordered).." '" .. tostring( Equipment ) .. "'",
		ULogs.Register( INDEX, Player ) )
	
end)




