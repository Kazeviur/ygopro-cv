--Oracle Guardian, Wiseman
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ORACLE_THINK_TANK)
	aux.AddRace(c,RACE_BATTLEROID)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
end
