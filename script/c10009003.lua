--Discharging Dragon
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
	--gain effect
	aux.AddSingleAutoEffect(c,1,EVENT_ATTACK_ANNOUNCE,nil,scard.op2,nil,scard.con2)
end
--gain effect
scard.con1=aux.AND(aux.VCCondition,aux.LimitBreakCondition(4),aux.AttackTargetCondition(Card.IsVanguard))
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,5000,RESET_PHASE+PHASE_DAMAGE)
end
--gain effect
scard.con2=aux.AND(aux.RCCondition,aux.AttackTargetCondition(Card.IsVanguard))
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if aux.SelfVanguardCondition(Card.IsClan,CLAN_NARUKAMI)(e,tp,eg,ep,ev,re,r,rp) then
		--gain power
		aux.AddTempEffectUpdatePower(c,c,2000,RESET_PHASE+PHASE_DAMAGE)
	end
end
--[[
	Note:
	This card's first [AUTO] effect is identical to that of "Great Silver Wolf, Garmore".
	This card's second [AUTO] effect is similar to that of "Dignified Gold Dragon".
]]
