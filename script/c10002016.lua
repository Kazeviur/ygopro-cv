--Demonic Dragon Mage, Rakshasa
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_KAGERO)
	aux.AddRace(c,RACE_DRAGONMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--gain effect
	aux.AddAutoEffect(c,0,EVENT_TO_GRAVE,nil,scard.op1,nil,scard.con1)
end
--gain effect
function scard.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	return aux.RCCondition(e,tp,eg,ep,ev,re,r,rp) and Duel.IsMainPhase(tp)
		and eg and eg:IsExists(scard.cfilter,1,nil,1-tp)
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,3000,RESET_PHASE+PHASE_END)
end
--[[
	Note: This card's [AUTO] effect is identical to that of "Demonic Dragon Madonna, Joka".
]]
