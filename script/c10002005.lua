--Berserk Dragon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_KAGERO)
	aux.AddRace(c,RACE_FLAME_DRAGON)
	--unit
	aux.EnableUnitAttribute(c)
	--intercept
	aux.EnableIntercept(c)
	--retire
	aux.AddSingleAutoEffect(c,0,EVENT_PLACED_VC,scard.tg1,scard.op1,EFFECT_FLAG_CARD_TARGET,aux.AND(aux.VCCondition,scard.con1),scard.cost1)
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_PLACED_RC,scard.tg1,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1,scard.cost1)
end
--retire
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetVanguard(tp)
	return tc:IsFaceup() and tc:IsClan(CLAN_KAGERO)
end
scard.cost1=aux.CounterBlastCost(2)
function scard.tgfilter(c)
	return c:IsFaceup() and c:IsGradeBelow(2) and c:IsRearGuard()
end
scard.tg1=aux.TargetCardFunction(PLAYER_SELF,scard.tgfilter,0,LOCATION_MZONE+LOCATION_SZONE,1,1,HINTMSG_RETIRE)
scard.op1=aux.TargetCardsOperation(Duel.SendtoDrop,REASON_EFFECT)
