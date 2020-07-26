--Knight of Elegant Skills, Gareth
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_GOLD_PALADIN)
	aux.AddRace(c,RACE_HUMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
end
