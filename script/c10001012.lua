--Stardust Trumpeter
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ROYAL_PALADIN)
	aux.AddRace(c,RACE_ANGEL)
	--unit
	aux.EnableUnitAttribute(c)
	--boost
	aux.EnableBoost(c)
end
