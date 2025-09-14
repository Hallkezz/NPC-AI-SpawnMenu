---------------
--By Hallkezz--
---------------

-----------------------------------------------------------------------------------
--Script
class 'NPCAISpawnMenu'

function NPCAISpawnMenu:__init()
    Network:Subscribe("SpawnNPC", self, self.SpawnNPC)
    Network:Subscribe("RemoveAllNPCs", function() Events:Fire("RemoveAllNPCs") end)
end

function NPCAISpawnMenu:SpawnNPC(args)
    Events:Fire("SpawnNPC", {
        target = args.target,
        model = args.model,
        pos = args.pos,
        weapon = args.weapon
    })
end

local npcaispawnmenu = NPCAISpawnMenu()
-----------------------------------------------------------------------------------
--Script Version
--v1.0--

--Release Date
--13.09.25--
-----------------------------------------------------------------------------------