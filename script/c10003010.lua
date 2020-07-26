--Queen of Heart
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NOVA_GRAPPLER)
	aux.AddRace(c,RACE_BATTLEROID)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--gain effect
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_BOOST,nil,scard.op1,nil,scard.con1)
end
--gain effect
scard.con1=aux.AttackerCondition(Card.IsCode,CARD_KING_OF_SWORD)
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,Duel.GetAttacker(),4000,RESET_PHASE+PHASE_DAMAGE)
end
--[[
	Note: This card's [AUTO] effect is similar to that of "Wingal".
]]
