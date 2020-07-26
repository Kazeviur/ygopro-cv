--Blaster Blade
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ROYAL_PALADIN)
	aux.AddRace(c,RACE_HUMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
	--retire
	aux.AddSingleAutoEffect(c,0,EVENT_PLACED_VC,scard.tg1,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1,scard.cost1)
	--retire
	aux.AddSingleAutoEffect(c,1,EVENT_CUSTOM+EVENT_PLACED_RC,scard.tg2,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con2,scard.cost1)
end
--retire
scard.con1=aux.VCCondition
scard.cost1=aux.CounterBlastCost(2)
scard.tg1=aux.TargetCardFunction(PLAYER_SELF,Card.IsRearGuard,0,LOCATION_ONFIELD,1,1,HINTMSG_RETIRE)
scard.op1=aux.TargetCardsOperation(Duel.SendtoDrop,REASON_EFFECT)
--retire
scard.con2=aux.SelfVanguardCondition(Card.IsClan,CLAN_ROYAL_PALADIN)
function scard.tgfilter(c)
	return c:IsFaceup() and c:IsGradeAbove(2) and c:IsRearGuard()
end
scard.tg2=aux.TargetCardFunction(PLAYER_SELF,scard.tgfilter,0,LOCATION_ONFIELD,1,1,HINTMSG_RETIRE)
