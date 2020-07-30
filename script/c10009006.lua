--Assassin Sword Eradicator, Susei
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NARUKAMI)
	aux.AddRace(c,RACE_HUMAN)
	aux.AddSeries(c,SERIES_ERADICATOR)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
	--retire
	aux.AddSingleAutoEffect(c,0,EVENT_DAMAGE_STEP_END,scard.tg1,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1,scard.cost1)
end
--retire
scard.con1=aux.AND(aux.SelfAttackHitCondition(Card.IsVanguard),aux.SelfVanguardCondition(Card.IsSeries,SERIES_ERADICATOR))
scard.cost1=aux.CounterBlastCost(2)
function scard.retfilter(c)
	return c:IsFaceup() and c:IsRearGuard() and c:IsFrontRow()
end
scard.tg1=aux.TargetCardFunction(PLAYER_SELF,scard.retfilter,0,LOCATION_ONFIELD,1,1,HINTMSG_RETIRE)
scard.op1=aux.TargetCardsOperation(Duel.SendtoDrop,REASON_EFFECT)
