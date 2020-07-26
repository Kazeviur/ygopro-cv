--Mr. Invincible
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NOVA_GRAPPLER)
	aux.AddRace(c,RACE_ALIEN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--flip over
	local e1=aux.AddAutoEffect(c,0,EVENT_CUSTOM+EVENT_MAIN_PHASE_START,scard.tg1,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1,scard.cost1)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCountLimit(1)
	--stand
	aux.AddSingleAutoEffect(c,1,EVENT_DAMAGE_STEP_END,nil,scard.op2,EFFECT_FLAG_CARD_TARGET,scard.con2,scard.cost2)
end
--flip over
scard.con1=aux.AND(aux.VCCondition,aux.TurnPlayerCondition(PLAYER_SELF))
scard.cost1=aux.SoulChargeCost(1)
scard.tg1=aux.TargetCardFunction(PLAYER_SELF,aux.DamageZoneFilter(Card.IsFacedown),LOCATION_REMOVED,0,1,1,HINTMSG_FLIPOVER)
scard.op1=aux.TargetCardsOperation(Duel.ChangePosition,POS_FACEUP)
--stand
scard.con2=aux.SelfAttackHitCondition()
scard.cost2=aux.MergeCost(aux.SoulBlastCost(8),aux.CounterBlastCost(5))
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToStand,tp,LOCATION_ONFIELD,0,nil)
	Duel.ChangePosition(g,POS_FACEUP_STAND)
end
