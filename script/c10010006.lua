--Blaster Dark Revenger
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_SHADOW_PALADIN)
	aux.AddRace(c,RACE_HUMAN)
	aux.AddSeries(c,SERIES_REVENGER)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
	--retire
	aux.AddSingleAutoEffect(c,0,EVENT_PLACED_VC,scard.tg1,scard.op1,EFFECT_FLAG_CARD_TARGET,aux.AND(aux.VCCondition,scard.con1),scard.cost1)
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_PLACED_RC,scard.tg1,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1,scard.cost1)
end
--retire
scard.con1=aux.SelfVanguardCondition(Card.IsSeries,SERIES_REVENGER)
scard.cost1=aux.CounterBlastCost(2)
function scard.retfilter(c)
	return c:IsFaceup() and c:IsRearGuard() and c:IsFrontRow()
end
scard.tg1=aux.TargetCardFunction(PLAYER_SELF,scard.retfilter,0,LOCATION_ONFIELD,1,1,HINTMSG_RETIRE)
scard.op1=aux.TargetCardsOperation(Duel.SendtoDrop,REASON_EFFECT)
--[[
	Note: This card's [AUTO] effect is similar to that of "Blaster Blade Liberator".
]]
