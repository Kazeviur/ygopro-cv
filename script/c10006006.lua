--Djinn of the Lightning Flare
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NARUKAMI)
	aux.AddRace(c,RACE_DEMON)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
	--cannot select battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(aux.TargetBoolFunction(Card.IsRearGuard))
	c:RegisterEffect(e1)
	--gain effect
	aux.AddSingleAutoEffect(c,1,EVENT_ATTACK_ANNOUNCE,nil,scard.op1,nil,scard.con1)
	--gain effect
	aux.AddSingleAutoEffect(c,2,EVENT_ATTACK_ANNOUNCE,nil,scard.op2,nil,scard.con2)
end
--gain effect
scard.con1=aux.VCCondition
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,4000,RESET_PHASE+PHASE_DAMAGE)
end
--gain effect
scard.con2=aux.AND(aux.RCCondition,aux.SelfVanguardCondition(Card.IsClan,CLAN_NARUKAMI))
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,2000,RESET_PHASE+PHASE_DAMAGE)
end
--[[
	Note: This card's effects are identical to that of "Djinn of the Lightning Flash".
]]
