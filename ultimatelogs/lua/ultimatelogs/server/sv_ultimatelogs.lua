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





ULogs = ULogs or {}

util.AddNetworkString( "ULogs_OpenMenu" )
util.AddNetworkString( "ULogs_Notify" )
util.AddNetworkString( "ULogs_Request" )
util.AddNetworkString( "ULogs_SendLogs" )
util.AddNetworkString( "ULogs_Delete" )
util.AddNetworkString( "ULogs_DeleteOldest" )





----------------------------------------------------------------------------------
--
-- Functions
--
----------------------------------------------------------------------------------



ULogs.Query = function( Query, CallBack ) -- Query function
	
	if !Query then return end
	local Error = sql.LastError()
	local Result = sql.Query( Query )
	
	if sql.LastError() and sql.LastError() != Error then
		
		Error = sql.LastError()
		error( Error .. " ( " .. Query .. " ) " )
		
		return
		
	end
	
	if type( CallBack ) == "function" then CallBack( Result ) end
	
	return Result
	
end

ULogs.SQLStr = function( Str )
	
	return sql.SQLStr( Str )
	
end

ULogs.GetDate = function()
	
	return tostring( os.date( "%d/%m/%Y" ) ) .. " - " .. tostring( os.date( "%I:%M:%S %p" ) )
	
end

ULogs.IsIP = function( Str )
	
	if !Str then return end
	Str = Str:lower()
	
	if string.match( Str, "ip" ) then return true end
	
	return false
	
end

ULogs.Register = function( Category, ... )
	
	if Category and ULogs.LogTypes[ Category ] and ULogs.LogTypes[ Category ].Register then
		
		return ULogs.LogTypes[ Category ].Register( ... )
		
	end
	
	return nil
	
end

ULogs.RegisterBase  = function( Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	
	local Data = {}
	
	if type( Player.SteamName ) == "function" then
		
		table.insert( Data, { "Name : " .. Player:Name(), Player:Name() } )
		table.insert( Data, { "SteamName : " .. Player:SteamName(), Player:SteamName() } )
		
	else
		
		table.insert( Data, { "Name : " .. Player:Name(), Player:Name() } )
		
	end
	
	if type( Player.GetBystanderName ) == "function" then
		
		table.insert( Data, { "Murder Name : " .. Player:GetBystanderName(), Player:GetBystanderName() } )
		
	end
	
	table.insert( Data, { "SteamID : " .. Player:SteamID(), Player:SteamID() } )
	table.insert( Data, { "IP : " .. Player:IPAddress(), Player:IPAddress() } )
	
	if type( Player.GetRoleString ) == "function" then
		
		table.insert( Data, { "TTT Role : " .. Player:GetRoleString(), Player:GetRoleString() } )
		
	elseif type( Player.GetMurderer ) == "function" then
		
		local Info = "bystander"
		if Player:GetMurderer() then Info = "murderer" end
		
		table.insert( Data, { "Murder Role : " .. Info, Info } )
		
	elseif type( Player.SetPlayerClass ) == "function" then
		
		local Info = Player:GetNWString( "Class", "unknown" )
		table.insert( Data, { "PH Role : " .. Info, Info } )
		
	else
		
		table.insert( Data, { "Team : " .. team.GetName( Player:Team() ), team.GetName( Player:Team() ) } )
		
	end
	
	return Data
	
end

ULogs.PlayerInfo = function( Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	
	local Info = team.GetName( Player:Team() )
	
	if type( Player.GetRoleString ) == "function" then
		
		Info = Player:GetRoleString()
		
	elseif type( Player.GetMurderer ) == "function" then
		
		Info = "bystander"
		if Player:GetMurderer() then Info = "murderer" end
		
	elseif type( Player.SetPlayerClass ) == "function" then
		
		Info = Player:GetNWString( "Class", "unknown" )
		
	end
	
	return Player:Name() .. "(" .. Info .. ")"
	
end

ULogs.CheckLimit = function( CallBack )
	
	ULogs.Query( "SELECT COUNT(*) AS id FROM " .. ULogs.config.TableName, function( data )
		
		if data and data[ 1 ] and data[ 1 ].id then
			
			local lines = tonumber( math.floor( data[ 1 ].id ) )
			
			if lines > ULogs.config.Limit then
				
				ULogs.Query( "DELETE FROM " .. ULogs.config.TableName .. " WHERE id IN( SELECT id FROM " .. ULogs.config.TableName .. " ORDER BY id ASC LIMIT 1)", function()
					
					CallBack()
					return
					
				end)
				
			else
				
				CallBack()
				
			end
			
		end
		
		end)
	
end

ULogs.AddLog = function( Category, Message, Informations, Date )
	
	if !Category then return end
	if Category == 1 then return end
	if !ULogs.LogTypes[ Category ] then return end
	if !Message then return end
	if !Informations then Informations = {} end
	if !Date then Date = ULogs.GetDate() end
	
	Category = tonumber( Category )
	Message = tostring( Message )
	if type( Informations ) != "table" then Informations = {} end
	Date = tostring( Date )
	
	if table.HasValue( ULogs.config.Block, Category ) then return end
	
	Informations = util.TableToJSON( Informations )
	
	ULogs.CheckLimit( function()
		
		ULogs.Query( "INSERT INTO " .. ULogs.config.TableName .. " (date, category, message, informations) VALUES("
			.. ULogs.SQLStr( Date ) .. ", " .. ULogs.SQLStr( Category ) .. ", "
			.. ULogs.SQLStr( Message ) .. ", " .. ULogs.SQLStr( Informations ) .. ")" )
	end)
	
	if ULogs.config.SaveToData then
		
		if not file.IsDir( "ulogs", "DATA" ) then
			
			file.CreateDir( "ulogs" )
			
		end
		
		if !ULogs.File then
			
			ULogs.File = "ulogs/" .. os.date( "%d_%m_%Y-%I_%M-%p" ) .. ".txt"
			file.Write( ULogs.File, ULogs.GetDate() .. "\t" .. Message )
			
			return
			
		end
		
		file.Append( ULogs.File, "\n" .. ULogs.GetDate() .. "\t" .. Message )
		
	end
	
end





----------------------------------------------------------------------------------
--
-- Player Functions
--
----------------------------------------------------------------------------------



ULogs.Notify = function( Player, Str )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	if !Str then return end
	
	net.Start( "ULogs_Notify" )
		net.WriteString( Str )
	net.Send( Player )
	
end

ULogs.CanSee = function( Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return false end
	
	if ULogs.config.OnlyUseCustom then -- If OnlyUseCustom
		
		if ULogs.config.CanSeeCustom( Player ) then return true end
		
		return false
	
	elseif ulx == nil then -- Or if ULX is not installed
		
		if ULogs_CAMI_PlayerAllowed(Player,"ULogs.CanSee") then return true end -- Check using CAMI
		
		return false
	
	end
	
	for k, v in pairs( ULogs.config.CanSee ) do
		
		if Player:IsUserGroup( v ) then
			
			return true
			
		end
		
	end
	
	return false
	
end

ULogs.CanSeeIP = function( Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return false end
	
	if ULogs.config.OnlyUseCustom then -- If OnlyUseCustom
		
		if ULogs.config.SeeIPCustom( Player ) then return true end
		
		return false
	
	elseif ulx == nil then -- Or if ULX is not installed
		
		if ULogs_CAMI_PlayerAllowed(Player,"ULogs.SeeIP") then return true end -- Check using CAMI
		
		return false
	
	end
	
	for k, v in pairs( ULogs.config.SeeIP ) do
		
		if Player:IsUserGroup( v ) then
			
			return true
			
		end
		
	end
	
	return false
	
end

ULogs.CanDelete = function( Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return false end
	
	if ULogs.config.OnlyUseCustom then -- If OnlyUseCustom
		
		if ULogs.config.DeleteCustom( Player ) then return true end
		
		return false
	
	elseif ulx == nil then -- Or if ULX is not installed
		
		if ULogs_CAMI_PlayerAllowed(Player,"ULogs.Delete") then return true end -- Check using CAMI
		
		return false
	
	end
	
	for k, v in pairs( ULogs.config.Delete ) do
		
		if Player:IsUserGroup( v ) then
			
			return true
			
		end
		
	end
	
	return false
	
end

ULogs.OpenMenu = function( Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	if !ULogs.CanSee( Player ) then
		
		ULogs.Notify( Player, "You are not allowed to open the logs menu !" )
		return
		
	end
	
	net.Start( "ULogs_OpenMenu" )
		net.WriteBool( ULogs.CanDelete( Player ) )
	net.Send( Player )
	
end

ULogs.SendLogs = function( Player, Log, Pages )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	if !ULogs.CanSee( Player ) then return end
	if !Log then return end
	if !Pages then Pages = 1 end
	
	net.Start( "ULogs_SendLogs" )
		net.WriteString( tostring( Pages ) )
		net.WriteString( tostring( #Log ) )
		for k, v in pairs( Log ) do
			net.WriteTable( v )
		end
	net.Send( Player )
	
end



----------------------------------------------------------------------------------
--
-- Hooks
--
----------------------------------------------------------------------------------



hook.Add( "PreGamemodeLoaded", "ULogs_PreGamemodeLoaded", function() -- Create table if not exists
	
	ULogs.Query( [[
		
		CREATE TABLE IF NOT EXISTS ]] .. ULogs.config.TableName .. [[(
			id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
			date TEXT NOT NULL,
			category VARCHAR(10) NOT NULL,
			message TEXT NOT NULL,
			informations TEXT NOT NULL
		);
		
	]] )
	
end)

hook.Add( "PlayerSay", "ULogs_OpenPlayerSay", function( Player, Str ) -- Logs menu chat command
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	
	if string.sub( string.lower( Str ), 1, string.len( ULogs.config.ChatCommand ) ) == ULogs.config.ChatCommand then
		
		ULogs.OpenMenu( Player )
		return false
		
	end
	
end)





----------------------------------------------------------------------------------
--
-- Net
--
----------------------------------------------------------------------------------



net.Receive( "ULogs_Request", function( _, Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	if !ULogs.CanSee( Player ) then return end
	
	local Mode = tonumber( net.ReadString() )
	local Category = tonumber( net.ReadString() )
	local Page = math.floor( tonumber( net.ReadString() ) )
	local Option = tostring( net.ReadString() )
	
	if !ULogs.LogTypes[ Mode ] then return end
	if Page <= 0 then Page = 1 end
	
	local Lines = ULogs.config.Lines
	local Offset = ( Page - 1 ) * Lines
	local Pages = 1
	local Query = ""
	local QueryCount = ""
	
	if Mode == 1 then
		
		local CategorySearch = " WHERE category = " .. Category
		if Category == 1 then CategorySearch = "" end
		Query = "SELECT * FROM " .. ULogs.config.TableName .. CategorySearch .. " ORDER BY id DESC LIMIT " .. Offset .. ", " .. Lines
		QueryCount = "SELECT COUNT(*) AS id FROM " .. ULogs.config.TableName .. CategorySearch
	
	elseif Mode == 2 then
		
		local CategorySearch = " AND category = " .. Category
		if Category == 1 then CategorySearch = "" end
		Query = "SELECT * FROM " .. ULogs.config.TableName .. " WHERE date LIKE " .. ULogs.SQLStr( "%" .. Option .. "%" ) .. " OR message LIKE "
			.. ULogs.SQLStr( "%" .. Option .. "%" ) .. CategorySearch .. " ORDER BY id DESC LIMIT " .. Offset .. ", " .. Lines
		QueryCount = "SELECT COUNT(*) AS id FROM " .. ULogs.config.TableName .. " WHERE date LIKE " .. ULogs.SQLStr( "%" .. Option .. "%" )
			.. " OR message LIKE " .. ULogs.SQLStr( "%" .. Option .. "%" ) .. CategorySearch
		
	elseif Mode == 3 then
		
		local CategorySearch = " AND category = " .. Category
		if Category == 1 then CategorySearch = "" end
		Query = "SELECT * FROM " .. ULogs.config.TableName .. " WHERE informations LIKE " .. ULogs.SQLStr( "%" .. Option .. "%" ) .. CategorySearch
			.. " ORDER BY id DESC LIMIT " .. Offset .. ", " .. Lines
		QueryCount = "SELECT COUNT(*) AS id FROM " .. ULogs.config.TableName .. " WHERE informations LIKE " .. ULogs.SQLStr( "%" .. Option .. "%" )
			.. CategorySearch
		
	end
	
	ULogs.Query( Query, function( data )
		
		local Log = {}
		
		if !data then
			
			ULogs.SendLogs( Player, { { ULogs.GetDate(), "No data" } } )
			
		else
			
			for k, v in pairs( data ) do
				
				v.informations = util.JSONToTable( v.informations )
				
				if !ULogs.CanSeeIP( Player ) then
					
					for x, p in pairs( v.informations ) do
						
						if type( p[ 2 ] ) != "table" then continue end
						
						for l, b in pairs( p[ 2 ] ) do
							
							if type( b[ 2 ] ) == "table" then continue end
							
							if ULogs.IsIP( b[ 1 ] ) then
								
								v.informations[ x ][ 2 ][ l ][ 1 ] = "IP : XXX.XXX.XXX.XXX (restricted)"
								v.informations[ x ][ 2 ][ l ][ 2 ] = "XXX.XXX.XXX.XXX"
								
							end
							
						end
						
					end
					
				end
				
				table.insert( Log, { v.date, v.message, v.informations } )
				
			end
			
			ULogs.Query( QueryCount, function( data2 )
				
				if data2 and data2[ 1 ] and data2[ 1 ].id then
					Pages = math.ceil( data2[ 1 ].id / Lines )
				end
				
				ULogs.SendLogs( Player, Log, Pages )
				
			end)
			
		end
		
	end)
	
end)

net.Receive( "ULogs_Delete", function( _, Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	if !ULogs.CanSee( Player ) then return end
	if !ULogs.CanDelete( Player ) then return end
	
	local Category = math.floor( tonumber( net.ReadString() ) )
	
	if !ULogs.LogTypes[ Category ] then return end
	
	local Query = " WHERE category = " .. ULogs.SQLStr( Category )
	
	if Category <= 1 then
		
		Query = ""
		
	end
	
	ULogs.Query( "DELETE FROM " .. ULogs.config.TableName .. Query, function()
		
		ULogs.Notify( Player, "Successfully deleted logs !" )
		
	end)
	
end)

net.Receive( "ULogs_DeleteOldest", function( _, Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	if !ULogs.CanSee( Player ) then return end
	if !ULogs.CanDelete( Player ) then return end
	
	local Number = math.floor( tonumber( net.ReadString() ) )
	
	ULogs.Query( "DELETE FROM " .. ULogs.config.TableName .. " WHERE id IN( SELECT id FROM " .. ULogs.config.TableName .. " ORDER BY id ASC LIMIT " .. Number .. ")", function()
		
		ULogs.Notify( Player, "Successfully deleted logs !" )
		
	end)
	
end)





----------------------------------------------------------------------------------
--
-- ConCommands
--
----------------------------------------------------------------------------------



concommand.Add( ULogs.config.ConCommand, function( Player ) -- Logs menu console command
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	
	ULogs.OpenMenu( Player )
	
end)





--------------------------------------------------------------------------------------------------------------------
-- CAMI implementation by Gedo789 - V1
-- Purposes: Register ULogs privileges to CAMI and keep a copy of players who got rights for using ULogs privileges.
--           Update the cache if a player has changed in CAMI.
--           CAMI is a interface for compatibility with multiples admin mods which support CAMI.
--------------------------------------------------------------------------------------------------------------------



CAMI.RegisterPrivilege({Name="ULogs.CanSee",MinAccess="admin"}) -- Register a CAMI privilege for ULogs.CanSee
CAMI.RegisterPrivilege({Name="ULogs.SeeIP",MinAccess="superadmin"}) -- Register a CAMI privilege for ULogs.SeeIP
CAMI.RegisterPrivilege({Name="ULogs.Delete",MinAccess="superadmin"}) -- Register a CAMI privilege for ULogs.Delete
ULogs.CAMI={} -- Create a table for CAMI.
ULogs.CAMI.PlayersPrivileges={} -- Create a table for see which players are allowed to X.
ULogs.CAMI.PlayersPrivileges.CanSee={} -- Get players with access to ULogs.CanSee privilege.
ULogs.CAMI.PlayersPrivileges.SeeIP={} -- Get players with access to ULogs.SeeIP.
ULogs.CAMI.PlayersPrivileges.Delete={} -- Get players with access to ULogs.Delete.
function ULogs_CAMI_UpdateCache(cache,ply,allowed,cached) -- Will be implemented
if cache == ("ULogs.CanSee" or "ULogs.SeeIP" or "ULogs.Delete") then
ULogs.CAMI.Cached=false -- Cache will be implemented too
if cache == "ULogs.CanSee" then
	if table.HasValue(ULogs.CAMI.PlayersPrivileges.CanSee,ply) and !allowed then
		table.RemoveByValue(ULogs.CAMI.PlayersPrivileges.CanSee,ply)
	elseif !table.HasValue(ULogs.CAMI.PlayersPrivileges.CanSee,ply) and allowed then
		ULogs.CAMI.PlayersPrivileges.CanSee[#ULogs.CAMI.PlayersPrivileges.CanSee+1]=ply
	end
elseif cache == "ULogs.SeeIP" then
	if table.HasValue(ULogs.CAMI.PlayersPrivileges.SeeIP,ply) and !allowed then
		table.RemoveByValue(ULogs.CAMI.PlayersPrivileges.SeeIP,ply)
	elseif !table.HasValue(ULogs.CAMI.PlayersPrivileges.SeeIP,ply) and allowed then
		ULogs.CAMI.PlayersPrivileges.SeeIP[#ULogs.CAMI.PlayersPrivileges.SeeIP+1]=ply
	end
elseif cache == "ULogs.Delete" then
	if table.HasValue(ULogs.CAMI.PlayersPrivileges.Delete,ply) and !allowed then
		table.RemoveByValue(ULogs.CAMI.PlayersPrivileges.Delete,ply)
	elseif !table.HasValue(ULogs.CAMI.PlayersPrivileges.Delete,ply) and allowed then
		ULogs.CAMI.PlayersPrivileges.Delete[#ULogs.CAMI.PlayersPrivileges.Delete+1]=ply
	end
end
if (cached == true) then ULogs.CAMI.Cached=true end
else
return
end
end
CAMI.GetPlayersWithAccess("ULogs.CanSee",function(players) ULogs.CAMI.PlayersPrivileges.CanSee=players end) -- Cache CAMI's callbacks
CAMI.GetPlayersWithAccess("ULogs.SeeIP",function(players) ULogs.CAMI.PlayersPrivileges.SeeIP=players end)
CAMI.GetPlayersWithAccess("ULogs.Delete",function(players) ULogs.CAMI.PlayersPrivileges.Delete=players ULogs.CAMI.Cached=true end) -- Done
timer.Create("ULogs.CAMI.UpdateCache",10,0,function()
CAMI.GetPlayersWithAccess("ULogs.CanSee",function(players) ULogs.CAMI.PlayersPrivileges.CanSee=players end)
CAMI.GetPlayersWithAccess("ULogs.SeeIP",function(players) ULogs.CAMI.PlayersPrivileges.SeeIP=players end)
CAMI.GetPlayersWithAccess("ULogs.Delete",function(players) ULogs.CAMI.PlayersPrivileges.Delete=players ULogs.CAMI.Cached=true end)
end)




