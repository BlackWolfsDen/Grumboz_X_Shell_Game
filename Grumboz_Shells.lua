print("-+-+-+-+-+-+-+-+-+-")
-- the X shells game
-- from the Mad Scientist slp13at420 of EmuDevs.com
local npcid = 390002 -- dealer npc 	id.
local currency = 44209 -- custom currency id.
local cost = 1 -- how much of currency per play.
local PShells = {};
local Shells = {};
local Shells = {{"Red"},{"Green"},{"Blue"},{"Yellow"},{"Brown"},} -- its dynamic so add as many colors as you want.

-- DO NOT EDIT BELOW HERE --

local function GetItemNameById(id)
local err = "ERROR GetItemById() name value is nil(Item "..id.." May not exist in database)"
local search = WorldDBQuery("SELECT `name` FROM `item_template` WHERE `entry` = '"..id.."';");

	if(search)then
		local itemname = search:GetString(0)
		return(itemname)
	else
		error(err)
	end
end

local currency_name = GetItemNameById(currency)

local function ShuffleShells(player, unit, guid)

	math.randomseed(tonumber(GetGameTime()*GetGameTime()))
	PShells[guid] = 0;
	local shell = math.random(1, #Shells)
	PShells[guid] = shell
end

local function ShellsInstructions(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,""..#Shells.." shells will be shuffled around.", 0, 2)
	player:GossipMenuAddItem(10,"1 shell will contain a marker under it.", 0, 2)
	player:GossipMenuAddItem(10,"Find the shell with the marker to win.", 0, 2)
	player:GossipMenuAddItem(5,"back", 0, 1)
	player:GossipMenuAddItem(5,"good bye.", 0, 4)
	player:GossipSendMenu(1, unit)
end

local function ShellsOnHello(event, player, unit)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"costs "..cost.." "..currency_name.." per card.", 0, 1)
	player:GossipMenuAddItem(10,"Play.", 0, 3)
	player:GossipMenuAddItem(10,"Instructions.", 0, 2)
	player:GossipMenuAddItem(5, "never mind.", 0, 4)
	player:GossipSendMenu(1, unit)
end

local function ShellsOnPlay(event, player, unit, guid)
	player:GossipClearMenu()
		for a=1, #Shells do
			player:GossipMenuAddItem(10,"I Pick the "..Shells[a][1].." Shell.", 0, 7+a)
		end
	player:GossipSendMenu(1, unit)
end

local function ShellsOnLoose(event, player, unit, guid)

local shell = PShells[guid]

	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"Sorry you loose.", 0, 5)
	player:GossipMenuAddItem(10,"It was under the "..Shells[shell][1].." shell.", 0, 5)
	player:GossipMenuAddItem(5,"again.", 0, 3)
	player:GossipMenuAddItem(5,"good bye.", 0, 4)
	player:GossipSendMenu(1, unit)
end

local function ShellsOnWin(event, player, unit, guid)

local shell = PShells[guid]

	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"!!You Win!!", 0, 6)
	player:GossipMenuAddItem(10,"!!It WAS under the "..Shells[shell][1].." shell!!", 0, 6)
	player:GossipMenuAddItem(5,"again.", 0, 3)
	player:GossipMenuAddItem(5,"good bye.", 0, 4)
	player:GossipSendMenu(1, unit)
end

local function ShellsOnSelect(event, player, unit, sender, intid, code)

local guid = player:GetGUIDLow()

	if(intid==1)then
		ShellsOnHello(1, player, unit)
	end
	if(intid==2)then -- goto/return instructions
		ShellsInstructions(1, player, unit, guid)
	end

	if(player:GetItemCount(currency)>=cost)then
		
		if(intid==3)then -- return game screen 
			player:RemoveItem(currency, cost)
			ShuffleShells(player, unit, guid)
			ShellsOnPlay(1, player, unit, guid)
		end
		
		if(intid==4)then
			player:GossipComplete()
		end
		
		if(intid > 7)then
			if(PShells[guid]~=(intid - 7))then
				ShellsOnLoose(1, player, unit, guid)
			else
				player:AddItem(currency, (cost*2))
				ShellsOnWin(1, player, unit, guid)
			end
		end
			
		if(intid==5)then
			ShellsOnLoose(1, player, unit, guid)
		end
		
		if(intid==6)then
			ShellsOnWin(1, player, unit, guid)
		end
	else
		player:SendBroadcastMessage("|cffFF0000move along now son, you creeping me out seee.|r we only deal to players with "..currency_name.."'s.")
		player:GossipComplete()
	end
end

RegisterCreatureGossipEvent(npcid, 1, ShellsOnHello)
RegisterCreatureGossipEvent(npcid, 2, ShellsOnSelect)

print("-Grumbo'z "..#Shells.." Shells-")
print("-+-+-+-+-+-+-+-+-+-")
