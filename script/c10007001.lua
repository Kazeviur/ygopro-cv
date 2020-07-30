--Navalgazer Dragon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_AQUA_FORCE)
	aux.AddRace(c,RACE_TEAR_DRAGON)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--gain effect
	aux.AddActivatedEffect(c,0,LOCATION_ONFIELD,scard.con1,aux.CounterBlastCost(2),scard.op1)
	--gain effect
	aux.AddSingleAutoEffect(c,1,EVENT_ATTACK_ANNOUNCE,nil,scard.op3,nil,aux.VCCondition)
end
--gain effect
scard.con1=aux.AND(aux.VCCondition,aux.LimitBreakCondition(4))
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,3000,RESET_PHASE+PHASE_END)
	--stand
	local e1=aux.AddSingleAutoEffect(c,2,EVENT_DAMAGE_STEP_END,scard.tg1,scard.op2,EFFECT_FLAG_CARD_TARGET,scard.con2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
end
--stand
function scard.con2(e,tp,eg,ep,ev,re,r,rp)
	return aux.VCCondition(e,tp,eg,ep,ev,re,r,rp) and aux.SelfAttackHitCondition(Card.IsVanguard)(e,tp,eg,ep,ev,re,r,rp)
		and Duel.GetBattledCount(tp)>=3
end
function scard.posfilter(c)
	return c:IsClan(CLAN_AQUA_FORCE) and c:IsRearGuard() and c:IsAbleToStand()
end
scard.tg1=aux.TargetCardFunction(PLAYER_SELF,scard.posfilter,LOCATION_ONFIELD,0,0,2,HINTMSG_STAND)
scard.op2=aux.TargetCardsOperation(Duel.ChangePosition,POS_FACEUP_STAND)
--gain effect
function scard.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.GetBattledCount(tp)>=2 then
		--gain power
		aux.AddTempEffectUpdatePower(c,c,3000,RESET_PHASE+PHASE_DAMAGE)
	end
end
