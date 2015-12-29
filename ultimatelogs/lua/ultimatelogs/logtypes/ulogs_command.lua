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





local INDEX = 3
local GM = 0

ULogs.AddLogType( INDEX, GM, ULogs.translation.Command, function( Cmd, Player )
	
	if !Cmd then return end
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	
	local Informations = {}
	local Base = ULogs.RegisterBase( Player )
	table.insert( Informations, { ULogs.translation.CopyCommand, Cmd } )
	local Data = {}
	Data[ 1 ] = Player:Name()
	Data[ 2 ] = {}
	table.Add( Data[ 2 ], Base )
	table.insert( Informations, Data )
	
	return Informations
	
end)

local OldConCommand = concommand.Run

function concommand.Run( Player, Cmd, Args )
	
	if SERVER and Player and Player:IsValid() and Player:IsPlayer() then
		
		if Cmd then
			
			if !table.HasValue( ULogs.config.IgnoreCommands, Cmd ) then
				
				ULogs.AddLog( INDEX, ULogs.PlayerInfo( Player ) .. " "..string.lower(ULogs.translation.Entered).." '" .. Cmd .. "'",
					ULogs.Register( INDEX, Cmd, Player ) )
				
			end
			
		end
		
	end
	
	return OldConCommand( Player, Cmd, Args )
	
end




