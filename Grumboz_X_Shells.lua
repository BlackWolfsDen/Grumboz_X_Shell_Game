print("-+-+-+-+-+-+-+-+-+-")
-- the X shells game
-- from the Mad Scientist slp13at420 of EmuDevs.com
local npcid = 390002 -- dealer npc 	id.
local currency = 44209 -- custom currency id.
local cost = 1 -- how much currency per play.
local PShells = {};
local Shells = {{"Red"},{"Green"},{"Blue"},} -- its dynamic so add as many colors as you want. Default 3

-- DO NOT EDIT BELOW HERE --

local currency_name = GetItemLink(currency)

local function ShuffleShells(player, unit, guid)
	math.randomseed(tonumber(GetGameTime()*GetGameTime()))
	PShells[guid] = {marker = math.random(1, #Shells)}
end

local function ShellsInstructions(event, player, unit, guid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(3,""..#Shells.." shells will be shuffled around.", 0, 2)
	player:GossipMenuAddItem(3,"I will choose a random shell.", 0, 2)
	player:GossipMenuAddItem(3,"If you choose the same shell then you win.", 0, 2)
	player:GossipMenuAddItem(5,"back", 0, 1)
	player:GossipMenuAddItem(5,"good bye.", 0, 4)
	player:GossipSendMenu(1, unit)
end

local function ShellsOnHello(event, player, unit)
	player:GossipClearMenu()
	player:GossipMenuAddItem(1,"costs "..cost.." "..currency_name.." per play.", 0, 1)
	player:GossipMenuAddItem(6,"Play.", 0, 3)
	player:GossipMenuAddItem(3,"Instructions.", 0, 2)
	player:GossipMenuAddItem(5, "never mind.", 0, 4)
	player:GossipSendMenu(1, unit)
end

local function ShellsOnPlay(event, player, unit, guid)
	player:GossipClearMenu()
		for a=1, #Shells do
			player:GossipMenuAddItem(4,"I Pick the "..Shells[a][1].." Shell.", 0, 10+a)
		end
	player:GossipSendMenu(1, unit)
end

local function ShellsOnLoose(event, player, unit, guid)

local shell = PShells[guid].marker

	player:GossipClearMenu()
	player:GossipMenuAddItem(1,"Sorry you loose.", 0, 5)
	player:GossipMenuAddItem(1,"It was the "..Shells[shell][1].." shell.", 0, 5)
	player:GossipMenuAddItem(5,"again.", 0, 3)
	player:GossipMenuAddItem(5,"good bye.", 0, 4)
	player:GossipSendMenu(1, unit)
end

local function ShellsOnWin(event, player, unit, guid)

local shell = PShells[guid].marker

	player:GossipClearMenu()
	player:GossipMenuAddItem(6,"!! You Win !!", 0, 6)
	player:GossipMenuAddItem(6,"!! IT WAS the "..Shells[shell][1].." shell !!", 0, 6)
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

	if(player:GetItemCount(currency) > cost)then
		
		if(intid==3)then -- return game screen 
			player:RemoveItem(currency, cost)
			ShuffleShells(player, unit, guid)
			ShellsOnPlay(1, player, unit, guid)
		end
		
		if(intid==4)then
			player:GossipComplete()
		end
			
		if(intid==5)then
			ShellsOnLoose(1, player, unit, guid)
		end
		
		if(intid==6)then
			ShellsOnWin(1, player, unit, guid)
		end
		
		if(intid > 10)then

			if(PShells[guid].marker~=(intid - 10))then
				ShellsOnLoose(1, player, unit, guid)
			else
				player:AddItem(currency, (cost*2))
				ShellsOnWin(1, player, unit, guid)
			end
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
