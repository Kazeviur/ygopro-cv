--Thunderstorm Dragoon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NARUKAMI)
	aux.AddRace(c,RACE_HUMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
end
