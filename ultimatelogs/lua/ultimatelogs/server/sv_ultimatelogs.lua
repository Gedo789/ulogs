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



ULogs.Initialize = function()
	MySQLite.initialize( ULogs.MySQLite_config )
	--ULogs.MySQLite_config = nil -- Because it will never be used after here
end
ULogs.Initialize()

ULogs.QueryError = function( String, Query )
	error("[ULogs] Query error : " .. String .. " on query : '" .. Query .. "'")
end

ULogs.Query = function( Query, CallBack ) -- Query function
	
	if !Query then return end
	if type(Query) != "string" then return end
	
	MySQLite.query(Query, CallBack, ULogs.QueryError)
	
end

ULogs.GetDate = function()
	
	return tostring( os.date( "%d/%m/%Y" ) ) .. " - " .. tostring( os.date( "%I:%M:%S %p" ) )
	
end

ULogs.IsIP = function( Str ) -- Bad function for the moment to check if a string contains a ip
	
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
		
		table.insert( Data, { ULogs.translation.Name.." : " .. Player:Name(), Player:Name() } )
		table.insert( Data, { "SteamName : " .. Player:SteamName(), Player:SteamName() } )
		
	else
		
		table.insert( Data, { ULogs.translation.Name.." : " .. Player:Name(), Player:Name() } )
		
	end
	
	if type( Player.GetBystanderName ) == "function" then
		
		table.insert( Data, { ULogs.translation.MurderName.." : " .. Player:GetBystanderName(), Player:GetBystanderName() } )
		
	end
	
	table.insert( Data, { "SteamID : " .. Player:SteamID(), Player:SteamID() } )
	table.insert( Data, { "IP : " .. Player:IPAddress(), Player:IPAddress() } )
	
	if type( Player.GetRoleString ) == "function" then
		
		table.insert( Data, { ULogs.translation.TTTRole.." : " .. Player:GetRoleString(), Player:GetRoleString() } )
		
	elseif type( Player.GetMurderer ) == "function" then
		
		local Info = ULogs.translation.bystander
		if Player:GetMurderer() then Info = ULogs.translation.Murderer end
		
		table.insert( Data, { ULogs.translation.MurderRole.." : " .. Info, Info } )
		
	elseif type( Player.SetPlayerClass ) == "function" then
		
		local Info = Player:GetNWString( "Class", "unknown" )
		table.insert( Data, { ULogs.translation.PHRole.." : " .. Info, Info } )
		
	else
		
		table.insert( Data, { ULogs.translation.Team.." : " .. team.GetName( Player:Team() ), team.GetName( Player:Team() ) } )
		
	end
	
	return Data
	
end

ULogs.PlayerInfo = function( Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	
	local Info = team.GetName( Player:Team() )
	
	if type( Player.GetRoleString ) == "function" then
		
		Info = Player:GetRoleString()
		
	elseif type( Player.GetMurderer ) == "function" then
		
		Info = ULogs.translation.bystander
		if Player:GetMurderer() then Info = ULogs.translation.Murderer end
		
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
			.. MySQLite.SQLStr( Date ) .. ", " .. MySQLite.SQLStr( Category ) .. ", "
			.. MySQLite.SQLStr( Message ) .. ", " .. MySQLite.SQLStr( Informations ) .. ")" )
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



ULogs.Notify = function( Player, Str ) -- Because I don't want to use MetaTable
	
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
		
		ULogs.Notify( Player, ULogs.translation.Notify.OpenMenuNotAllowed )
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



hook.Add( "DatabaseInitialized", "ULogs_DatabaseInitialized", function()
	
	local AUTOINCREMENT = MySQLite.isMySQL() and "AUTO_INCREMENT" or "AUTOINCREMENT" -- Thanks FPtje
	
	ULogs.Query( [[
		
		CREATE TABLE IF NOT EXISTS ]] .. ULogs.config.TableName .. [[(
			id INTEGER NOT NULL PRIMARY KEY ]] .. AUTOINCREMENT .. [[,
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
		Query = "SELECT * FROM " .. ULogs.config.TableName .. " WHERE date LIKE " .. MySQLite.SQLStr( "%" .. Option .. "%" ) .. " OR message LIKE "
			.. MySQLite.SQLStr( "%" .. Option .. "%" ) .. CategorySearch .. " ORDER BY id DESC LIMIT " .. Offset .. ", " .. Lines
		QueryCount = "SELECT COUNT(*) AS id FROM " .. ULogs.config.TableName .. " WHERE date LIKE " .. MySQLite.SQLStr( "%" .. Option .. "%" )
			.. " OR message LIKE " .. MySQLite.SQLStr( "%" .. Option .. "%" ) .. CategorySearch
		
	elseif Mode == 3 then
		
		local CategorySearch = " AND category = " .. Category
		if Category == 1 then CategorySearch = "" end
		Query = "SELECT * FROM " .. ULogs.config.TableName .. " WHERE informations LIKE " .. MySQLite.SQLStr( "%" .. Option .. "%" ) .. CategorySearch
			.. " ORDER BY id DESC LIMIT " .. Offset .. ", " .. Lines
		QueryCount = "SELECT COUNT(*) AS id FROM " .. ULogs.config.TableName .. " WHERE informations LIKE " .. MySQLite.SQLStr( "%" .. Option .. "%" )
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
								
								v.informations[ x ][ 2 ][ l ][ 1 ] = ULogs.translation.RestrictedIP
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
	
	local Query = " WHERE category = " .. MySQLite.SQLStr( Category )
	
	if Category <= 1 then
		
		Query = ""
		
	end
	
	ULogs.Query( "DELETE FROM " .. ULogs.config.TableName .. Query, function()
		
		ULogs.Notify( Player, ULogs.translation.Notify.DeletedSuccessfully )
		
	end)
	
end)

net.Receive( "ULogs_DeleteOldest", function( _, Player )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	if !ULogs.CanSee( Player ) then return end
	if !ULogs.CanDelete( Player ) then return end
	
	local Number = math.floor( tonumber( net.ReadString() ) )
	
	ULogs.Query( "DELETE FROM " .. ULogs.config.TableName .. " WHERE id IN( SELECT id FROM " .. ULogs.config.TableName .. " ORDER BY id ASC LIMIT " .. Number .. ")", function()
		
		ULogs.Notify( Player, ULogs.translation.Notify.DeletedSuccessfully )
		
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
--           Update the cache if a player has changed in CAMI. Wait a return from CAMI.
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
ULogs.CAMI.Cached=false -- Is every CAMI's callbacks cached?
function ULogs_CAMI_PlayerAllowed(ply,privilege)
if privilege == ("ULogs.CanSee" or "ULogs.SeeIP" or "ULogs.Delete") then
if privilege == "ULogs.CanSee" then if table.HasValue(ULogs.CAMI.PlayersPrivileges.CanSee,ply) then return true end end
if privilege == "ULogs.SeeIP" then if table.HasValue(ULogs.CAMI.PlayersPrivileges.SeeIP,ply) then return true end end
if privilege == "ULogs.Delete" then if table.HasValue(ULogs.CAMI.PlayersPrivileges.Delete,ply) then return true end end
return false
else
return
end
end
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




