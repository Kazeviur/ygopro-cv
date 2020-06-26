--Embodiment of Armor, Bahr
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_KAGERO)
	aux.AddRace(c,RACE_DEMON)
	--unit
	aux.EnableUnitAttribute(c)
	--boost
	aux.EnableBoost(c)
end
