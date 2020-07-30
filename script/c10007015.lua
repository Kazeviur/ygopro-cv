--Battleship Intelligence
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_AQUA_FORCE)
	aux.AddRace(c,RACE_WORKEROID)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
end
