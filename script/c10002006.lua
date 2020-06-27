--Wyvern Strike, Tejas
--Not fully implemented: Cannot attack units in LOCATION_SZONE
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_KAGERO)
	aux.AddRace(c,RACE_WINGED_DRAGON)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
end
