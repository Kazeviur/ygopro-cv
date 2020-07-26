--Thunder Break Dragon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NARUKAMI)
	aux.AddRace(c,RACE_THUNDER_DRAGON)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--gain effect
	aux.AddSingleAutoEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,scard.op1,nil,scard.con1)
	--retire
	aux.AddSingleAutoEffect(c,1,EVENT_PLACED_VC,scard.tg1,scard.op2,EFFECT_FLAG_CARD_TARGET,nil,aux.CounterBlastCost(2))
end
--gain effect
scard.con1=aux.AND(aux.LimitBreakCondition(4),aux.AttackTargetCondition(Card.IsVanguard))
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,5000,RESET_PHASE+PHASE_DAMAGE)
end
--retire
function scard.tgfilter(c)
	return c:IsFaceup() and c:IsGradeBelow(2) and c:IsRearGuard()
end
scard.tg1=aux.TargetCardFunction(PLAYER_SELF,scard.tgfilter,0,LOCATION_ONFIELD,1,1,HINTMSG_RETIRE)
scard.op2=aux.TargetCardsOperation(Duel.SendtoDrop,REASON_EFFECT)
--[[
	Note: This card's first [AUTO] effect is identical to that of "Great Silver Wolf, Garmore".
]]
