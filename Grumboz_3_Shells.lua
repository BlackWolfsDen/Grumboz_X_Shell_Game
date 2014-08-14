print("+-+-+-+-+-+-+-+-+")
-- the 3 shells game
-- from the Mad Scientist slp13at420 of EmuDevs.com
local npcid = 390002
local cost = 1
local currency = 44209
local PShells = {};
local Shells = {};
local Shells = {{"Red"},{"Green"},{"Blue"}}

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
	PShells[guid] = 0;
	local shell = math.random(1,3)
	PShells[guid] = shell
end

local function ShellsInstructions(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(0,"3 shells will be shuffled around.", 0, 2)
	player:GossipMenuAddItem(0,"1 shell will contain a marker under it.", 0, 2)
	player:GossipMenuAddItem(0,"Find the shell with the mark to win.", 0, 2)
	player:GossipMenuAddItem(10,"back", 0, 1)
	player:GossipMenuAddItem(10,"good bye.", 0, 4)
	player:GossipSendMenu(1, unit)
end

local function ShellsOnHello(event, player, unit)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"costs "..bet.." "..currency_name.." per card.", 0, 1)
	player:GossipMenuAddItem(10,"Play.", 0, 3)
	player:GossipMenuAddItem(10,"Instructions.", 0, 2)
	player:GossipMenuAddItem(5, "never mind.", 0, 4)
	player:GossipSendMenu(1, unit)
end

local function ShellsOnPlay(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"I Pick the Red Shell.", 0, 5)
	player:GossipMenuAddItem(10,"I Pick the Green Shell.", 0, 6)
	player:GossipMenuAddItem(10,"I Pick the Blue Shell.", 0, 7)
	player:GossipSendMenu(1, unit)
end

local function ShellsOnLoose(event, player, unit, guid)
local shell = PShells[guid]
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"Sorry you loose.", 0, 8)
	player:GossipMenuAddItem(10,"It was the "..Shells[shell][1].." shell.", 0, 8)
	player:GossipMenuAddItem(10,"again.", 0, 3)
	player:GossipMenuAddItem(10,"good bye.", 0, 4)
	player:GossipSendMenu(1, unit)
end

local function ShellsOnWin(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(10,"!!You Win!!", 0, 9)
	player:GossipMenuAddItem(10,"again.", 0, 3)
	player:GossipMenuAddItem(10,"good bye.", 0, 4)
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
	if(intid==3)then -- return game screen 
		player:RemoveItem(currency, cost)
		ShuffleShells(player, unit, guid)
		ShellsOnPlay(1, player, unit, guid)
	end
	if(intid==4)then
		player:GossipComplete()
	end
	if((intid==5)or(intid==6)or(intid==7))then
		if(PShells[guid]~=(intid - 4))then
			ShellsOnLoose(1, player, unit, guid)
		else
			player:AddItem(currency, (cost*2))
			ShellsOnWin(1, player, unit, guid)
		end
	end
	if(intid==8)then
		ShellsOnLoose(1, player, unit, guid)
	end
	if(intid==9)then
		ShellsOnWin(1, player, unit, guid)
	end
end

RegisterCreatureGossipEvent(npcid, 1, ShellsOnHello)
RegisterCreatureGossipEvent(npcid, 2, ShellsOnSelect)

print("Grumbo'z 3 Shells")
print("+-+-+-+-+-+-+-+-+")
