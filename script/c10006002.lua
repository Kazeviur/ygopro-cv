--Djinn of the Lightning Flash
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NARUKAMI)
	aux.AddRace(c,RACE_DEMON)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--cannot select battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(aux.TargetBoolFunction(Card.IsRearGuard))
	c:RegisterEffect(e1)
	--gain effect
	aux.AddSingleAutoEffect(c,1,EVENT_ATTACK_ANNOUNCE,nil,scard.op1,nil,aux.VCCondition)
	--gain effect
	aux.AddSingleAutoEffect(c,2,EVENT_ATTACK_ANNOUNCE,nil,scard.op2,nil,aux.RCCondition)
end
--gain effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,4000,RESET_PHASE+PHASE_DAMAGE)
end
--gain effect
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if aux.SelfVanguardCondition(Card.IsClan,CLAN_NARUKAMI)(e,tp,eg,ep,ev,re,r,rp) then
		--gain power
		aux.AddTempEffectUpdatePower(c,c,2000,RESET_PHASE+PHASE_DAMAGE)
	end
end
