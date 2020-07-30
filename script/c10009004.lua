--Eradicator, Thunder Boom Dragon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NARUKAMI)
	aux.AddRace(c,RACE_THUNDER_DRAGON)
	aux.AddSeries(c,SERIES_ERADICATOR)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
end
