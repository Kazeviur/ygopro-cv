--Knight of Superior Skills, Beaumains
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_GOLD_PALADIN)
	aux.AddRace(c,RACE_HUMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
end
