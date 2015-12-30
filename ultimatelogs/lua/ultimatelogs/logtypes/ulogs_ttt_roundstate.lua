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





local INDEX = 20
local GM = 3

ULogs.AddLogType( INDEX, GM, ULogs.translation.RoundState, function() end)

hook.Add( "TTTPrepareRound", "ULogs_TTTPrepareRound", function()
	
	if !SERVER then return end
	
	ULogs.AddLog( INDEX, ULogs.translation.PreparingPhaseBegins, {} )
	
end)

hook.Add( "TTTBeginRound", "ULogs_TTTBeginRound", function()
	
	if !SERVER then return end
	
	ULogs.AddLog( INDEX, ULogs.translation.RoundBegins, {} )
	
end)

hook.Add( "TTTEndRound", "ULogs_TTTEndRound", function( Result )
	
	if !SERVER then return end
	if !Result then return end
	
	local Info = ULogs.translation.NobodyWon
	
	if Result == 2 then
		
		Info = ULogs.translation.TraitorsWon
		
	elseif Result == 3 then
		
		Info = ULogs.translation.InnocentsWon
		
	elseif Result == 4 then
		
		Info = ULogs.translation.TimelimitUp
		
	end
	
	ULogs.AddLog( INDEX, ULogs.translation.RoundEnded..". " .. Info, {} )
	
end)




