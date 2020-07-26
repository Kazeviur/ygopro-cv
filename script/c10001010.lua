--Starlight Unicorn
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ROYAL_PALADIN)
	aux.AddRace(c,RACE_HIGH_BEAST)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--gain effect (gain power)
	local targ_func=aux.TargetCardFunction(PLAYER_SELF,scard.effilter,LOCATION_ONFIELD,0,1,1,HINTMSG_GAINPOWER,c)
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_PLACED_RC,targ_func,scard.op1,EFFECT_FLAG_CARD_TARGET)
end
--gain effect (gain power)
function scard.effilter(c)
	return c:IsFaceup() and c:IsClan(CLAN_ROYAL_PALADIN)
end
scard.op1=aux.TargetUpdatePowerOperation(2000,RESET_PHASE+PHASE_END)
