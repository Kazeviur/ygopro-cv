--Gold Rutile
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NOVA_GRAPPLER)
	aux.AddRace(c,RACE_BATTLEROID)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--flip over
	aux.AddAutoEffect(c,0,EVENT_DAMAGE_STEP_END,scard.tg1,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1)
	--stand
	aux.AddSingleAutoEffect(c,1,EVENT_DAMAGE_STEP_END,scard.tg2,scard.op2,EFFECT_FLAG_CARD_TARGET,scard.con2,scard.cost1)
end
--flip over
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	return aux.VCCondition(e,tp,eg,ep,ev,re,r,rp) and aux.AttackHitCondition(Card.IsVanguard)(e,tp,eg,ep,ev,re,r,rp)
		and Duel.GetAttacker():IsRearGuard(tp)
end
scard.tg1=aux.TargetCardFunction(PLAYER_SELF,aux.DamageZoneFilter(Card.IsFacedown),LOCATION_REMOVED,0,1,1,HINTMSG_FLIPOVER)
scard.op1=aux.TargetCardsOperation(Duel.ChangePosition,POS_FACEUP)
--stand
scard.cost1=aux.CounterBlastCost(2)
scard.con2=aux.AND(aux.VCCondition,aux.SelfAttackHitCondition(Card.IsVanguard))
function scard.posfilter(c)
	return c:IsClan(CLAN_NOVA_GRAPPLER) and c:IsRearGuard() and c:IsAbleToStand()
end
scard.tg2=aux.TargetCardFunction(PLAYER_SELF,scard.posfilter,LOCATION_ONFIELD,0,1,1,HINTMSG_STAND)
scard.op2=aux.TargetCardsOperation(Duel.ChangePosition,POS_FACEUP_STAND)
