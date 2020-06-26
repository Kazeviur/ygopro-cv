--Knight of Rose, Morgana
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ROYAL_PALADIN)
	aux.AddRace(c,RACE_HUMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--boost
	aux.EnableBoost(c)
	--get effect
	aux.AddSingleAutoEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,scard.op1,EFFECT_FLAG_CARD_TARGET,nil,aux.DiscardCost(1))
end
--get effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,4000,RESET_PHASE+PHASE_END)
end
