ULogs.translation={}
if string.upper(ULogs.config.Language) == "EN" then
-- cl_ultimatelogs.lua
ULogs.translation.Copied="Copied"
ULogs.translation.DateTime="Date / Time"
ULogs.translation.ActionLog="Action / Log"
ULogs.translation.CopyLine="Copy line"
ULogs.translation.CopyDate="Copy date"
ULogs.translation.SearchDefaultText="Search ALL Logs ..."
ULogs.translation.ChoosePlayer="Choose Player"
ULogs.translation.SelectedPlayerInvalid="Selected player is invalid"
ULogs.translation.SearchFor="Search for"
ULogs.translation.Reset="Reset"
ULogs.translation.SetPageTo="Set page to"
ULogs.translation.Tools="Tools"
ULogs.translation.Set="Set"
ULogs.translation.Cancel="Cancel"
ULogs.translation.RemoveLogs="Remove Logs"
ULogs.translation.Options="Options"
ULogs.translation.Forum="Forum"
ULogs.translation.LogsReceptionUnable="Can't receive logs data : Timed out"
ULogs.translation.Delete="Delete"
ULogs.translation.Logs="Logs"
ULogs.translation.WantDelete="Do you want to delete"
ULogs.translation.Yes="Yes"
ULogs.translation.No="No"
ULogs.translation.DeleteOldestLogs="Delete the x oldest logs"
ULogs.translation.LogsToDelete="How many logs do you want to delete ?"
ULogs.translation.Show="Show"
-- ulogs_chat.lua
ULogs.translation.CopyMessage="Copy message"
ULogs.translation.Said="Said"
-- ulogs_commands.lua
ULogs.translation.Command="Command"
ULogs.translation.CopyCommand="Copy command"
ULogs.translation.Entered="Entered"
-- ulogs_connect.lua
ULogs.translation.ConnectMenu="(Dis)Connect"
ULogs.translation.Connected="Connected from the server"
ULogs.translation.Disconnected="Disconnected from the server"
-- ulogs_damage.lua
ULogs.translation.DamageKill="Damage/Kill"
ULogs.translation.Victim="Victim"
ULogs.translation.Attacker="Attacker"
ULogs.translation.Vehicle="A vehicle"
ULogs.translation.Something="Something"
ULogs.translation.FallDamage="Fall Damage"
ULogs.translation.World="The world"
ULogs.translation.Kill="[KILL]"
ULogs.translation.Killed="Killed"
ULogs.translation.With="With"
ULogs.translation.DamageUsing="Damage Using"
ULogs.translation.Hurt="[HURT]"
ULogs.translation.hurt="Hurt"
ULogs.translation.KilledHimself="Killed Himself"
-- ulogs_darkrp_name.lua
ULogs.translation.Name="Name"
ULogs.translation.ChangedName="Changed his name from"
-- ulogs_darkrp_purchase.lua
ULogs.translation.Purchase="Purchase"
ULogs.translation.Bought="Bought"
ULogs.translation.For="For"
ULogs.translation.Shipment="Shipment"
-- ulogs_murder_loot.lua
ULogs.translation.Loot="Loot"
ULogs.translation.PickedLoot="Picked up a loot"
-- ulogs_murder_roundstate.lua
ULogs.translation.RoundState="Round state"
ULogs.translation.RoundBegins="The round begins"
ULogs.translation.RoundEnded="The round ended"
-- ulogs_sbox_toolgun.lua
ULogs.translation.CopyTool="Copy tool"
ULogs.translation.Used="Used"
-- ulogs_team.lua
ULogs.translation.Team="Team"
ULogs.translation.ChangedTeam="Changed his team from"
ULogs.translation.To="To"
-- ulogs_ttt_body.lua
ULogs.translation.Body="Body"
ULogs.translation.FoundBody="Found the body of"
-- ulogs_ttt_dna.lua
ULogs.translation.DNA="DNA"
ULogs.translation.FoundDNA="Found the DNA of"
-- ulogs_ttt_purchase.lua
ULogs.translation.UnknownItem="Unknown item"
ULogs.translation.Ordered="Ordered"
-- ulogs_ttt_roundstate.lua
ULogs.translation.PreparingPhaseBegins="The preparing phase begins"
ULogs.translation.NobodyWon="Nobody has won"
ULogs.translation.TraitorsWon="The traitors have won"
ULogs.translation.InnocentsWon="The innocents have won"
ULogs.translation.TimelimitUp="The timelimit is up"
elseif string.upper(ULogs.config.Language) == "FR" then
-- cl_ultimatelogs.lua
ULogs.translation.Copied="Copié"
ULogs.translation.DateTime="Date / Heure"
ULogs.translation.ActionLog="Action / Journal"
ULogs.translation.CopyLine="Copier la ligne"
ULogs.translation.CopyDate="Copier la date"
ULogs.translation.SearchDefaultText="Chercher TOUS les Journaux ..."
ULogs.translation.ChoosePlayer="Choisir le joueur"
ULogs.translation.SelectedPlayerInvalid="Le joueur sélectionné est invalide"
ULogs.translation.SearchFor="Chercher pour"
ULogs.translation.Reset="RESET" -- Aurait pu utiliser <<Réinitialiser>> mais le boutton était trop petit pour cela.
ULogs.translation.SetPageTo="Aller vers la page"
ULogs.translation.Tools="Outils"
ULogs.translation.Set="Aller"
ULogs.translation.Cancel="Annuler"
ULogs.translation.RemoveLogs="Retirer les journaux"
ULogs.translation.Options="Options"
ULogs.translation.Forum="Forum"
ULogs.translation.LogsReceptionUnable="Les données des journaux n'ont pas pu être reçu : Délai d'attente dépassé"
ULogs.translation.Delete="Supprimer"
ULogs.translation.Logs="Journaux"
ULogs.translation.WantDelete="Voulez-vous supprimer"
ULogs.translation.Yes="Oui"
ULogs.translation.No="Non"
ULogs.translation.DeleteOldestLogs="Supprimer les vieux X journaux"
ULogs.translation.LogsToDelete="Combien de journaux voulez-vous supprimer ?"
ULogs.translation.Show="Montrer les" -- ULogs a besoin d'un système de localisation beaucoup plus avancé apparament.
-- ulogs_chat.lua
ULogs.translation.CopyMessage="Copier le message"
ULogs.translation.Said="Dit"
-- ulogs_commands.lua
ULogs.translation.Command="Commande"
ULogs.translation.CopyCommand="Copier la commande"
ULogs.translation.Entered="A entré"
-- ulogs_connect.lua
ULogs.translation.ConnectMenu="(Dé)Connexion"
ULogs.translation.Connected="s'est connecté sur le serveur"
ULogs.translation.Disconnected="s'est déconnecté du serveur"
-- ulogs_damage.lua
ULogs.translation.DamageKill="Dégât/Meurtre"
ULogs.translation.Victim="Victime"
ULogs.translation.Attacker="Attaquant"
ULogs.translation.Vehicle="Un véhicule"
ULogs.translation.Something="Quelque chose"
ULogs.translation.FallDamage="Dêgat de Chute"
ULogs.translation.World="Le monde"
ULogs.translation.Kill="[MEURTRE]"
ULogs.translation.Killed="A tué"
ULogs.translation.With="Avec"
ULogs.translation.DamageUsing="De Dêgats en Utilisant"
ULogs.translation.Hurt="[BLESSURE]"
ULogs.translation.hurt="Blessé"
ULogs.translation.KilledHimself="S'est tué lui-même"
-- ulogs_darkrp_name.lua
ULogs.translation.Name="Nom"
ULogs.translation.ChangedName="A changé son nom de"
-- ulogs_darkrp_purchase.lua
ULogs.translation.Purchase="Achats"
ULogs.translation.Bought="A acheté"
ULogs.translation.For="Pour"
ULogs.translation.Shipment="Des équipements"
-- ulogs_murder_loot.lua
ULogs.translation.Loot="Butin"
ULogs.translation.PickedLoot="A pris un butin"
-- ulogs_murder_roundstate.lua
ULogs.translation.RoundState="Rapport de manches"
ULogs.translation.RoundBegins="La manche commence"
ULogs.translation.RoundEnded="La manche est terminée"
-- ulogs_sbox_toolgun.lua
ULogs.translation.CopyTool="Copier l'outil"
ULogs.translation.Used="A utilisé un(e)"
-- ulogs_team.lua
ULogs.translation.Team="Équipe"
ULogs.translation.ChangedTeam="a changé son équipe de"
ULogs.translation.To="À"
-- ulogs_ttt_body.lua
ULogs.translation.Body="Corps"
ULogs.translation.FoundBody="A trouvé le corps de"
-- ulogs_ttt_dna.lua
ULogs.translation.DNA="ADN"
ULogs.translation.FoundDNA="A trouvé l'ADN de"
-- ulogs_ttt_purchase.lua
ULogs.translation.UnknownItem="Article inconnu(e)"
ULogs.translation.Ordered="A commandé un(e)"
-- ulogs_ttt_roundstate.lua
ULogs.translation.PreparingPhaseBegins="La phase de préparation commence"
ULogs.translation.NobodyWon="Personne n'a gagné"
ULogs.translation.TraitorsWon="Les traitres ont gagnés"
ULogs.translation.InnocentsWon="Les innocents ont gagnés"
ULogs.translation.TimelimitUp="Le temps est écoulé"
else
-- cl_ultimatelogs.lua
ULogs.translation.Copied="Copied"
ULogs.translation.DateTime="Date / Time"
ULogs.translation.ActionLog="Action / Log"
ULogs.translation.CopyLine="Copy line"
ULogs.translation.CopyDate="Copy date"
ULogs.translation.SearchDefaultText="Search ALL Logs ..."
ULogs.translation.ChoosePlayer="Choose Player"
ULogs.translation.SelectedPlayerInvalid="Selected player is invalid"
ULogs.translation.SearchFor="Search for"
ULogs.translation.Reset="Reset"
ULogs.translation.SetPageTo="Set page to"
ULogs.translation.Tools="Tools"
ULogs.translation.Set="Set"
ULogs.translation.Cancel="Cancel"
ULogs.translation.RemoveLogs="Remove Logs"
ULogs.translation.Options="Options"
ULogs.translation.Forum="Forum"
ULogs.translation.LogsReceptionUnable="Can't receive logs data : Timed out"
ULogs.translation.Delete="Delete"
ULogs.translation.Logs="Logs"
ULogs.translation.WantDelete="Do you want to delete"
ULogs.translation.Yes="Yes"
ULogs.translation.No="No"
ULogs.translation.DeleteOldestLogs="Delete the x oldest logs"
ULogs.translation.LogsToDelete="How many logs do you want to delete ?"
ULogs.translation.Show="Show"
-- ulogs_chat.lua
ULogs.translation.CopyMessage="Copy message"
ULogs.translation.Said="Said"
-- ulogs_commands.lua
ULogs.translation.Command="Command"
ULogs.translation.CopyCommand="Copy command"
ULogs.translation.Entered="Entered"
-- ulogs_connect.lua
ULogs.translation.ConnectMenu="(Dis)Connect"
ULogs.translation.Connected="Connected from the server"
ULogs.translation.Disconnected="Disconnected from the server"
-- ulogs_damage.lua
ULogs.translation.DamageKill="Damage/Kill"
ULogs.translation.Victim="Victim"
ULogs.translation.Attacker="Attacker"
ULogs.translation.Vehicle="A vehicle"
ULogs.translation.Something="Something"
ULogs.translation.FallDamage="Fall Damage"
ULogs.translation.World="The world"
ULogs.translation.Kill="[KILL]"
ULogs.translation.Killed="Killed"
ULogs.translation.With="With"
ULogs.translation.DamageUsing="Damage Using"
ULogs.translation.Hurt="[HURT]"
ULogs.translation.hurt="Hurt"
ULogs.translation.KilledHimself="Killed Himself"
-- ulogs_darkrp_name.lua
ULogs.translation.Name="Name"
ULogs.translation.ChangedName="Changed his name from"
-- ulogs_darkrp_purchase.lua
ULogs.translation.Purchase="Purchase"
ULogs.translation.Bought="Bought"
ULogs.translation.For="For"
ULogs.translation.Shipment="Shipment"
-- ulogs_murder_loot.lua
ULogs.translation.Loot="Loot"
ULogs.translation.PickedLoot="Picked up a loot"
-- ulogs_murder_roundstate.lua
ULogs.translation.RoundState="Round state"
ULogs.translation.RoundBegins="The round begins"
ULogs.translation.RoundEnded="The round ended"
-- ulogs_sbox_toolgun.lua
ULogs.translation.CopyTool="Copy tool"
ULogs.translation.Used="Used"
-- ulogs_team.lua
ULogs.translation.Team="Team"
ULogs.translation.ChangedTeam="Changed his team from"
ULogs.translation.To="To"
-- ulogs_ttt_body.lua
ULogs.translation.Body="Body"
ULogs.translation.FoundBody="Found the body of"
-- ulogs_ttt_dna.lua
ULogs.translation.DNA="DNA"
ULogs.translation.FoundDNA="Found the DNA of"
-- ulogs_ttt_purchase.lua
ULogs.translation.UnknownItem="Unknown item"
ULogs.translation.Ordered="Ordered"
-- ulogs_ttt_roundstate.lua
ULogs.translation.PreparingPhaseBegins="The preparing phase begins"
ULogs.translation.NobodyWon="Nobody has won"
ULogs.translation.TraitorsWon="The traitors have won"
ULogs.translation.InnocentsWon="The innocents have won"
ULogs.translation.TimelimitUp="The timelimit is up"
end
