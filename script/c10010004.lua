--Darkness Revenger, Rugos
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_SHADOW_PALADIN)
	aux.AddRace(c,RACE_HUMAN)
	aux.AddSeries(c,SERIES_REVENGER)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
end
