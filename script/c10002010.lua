--Demonic Dragon Madonna, Joka
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_KAGERO)
	aux.AddRace(c,RACE_DRAGONMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--boost
	aux.EnableBoost(c)
	--get effect
	aux.AddAutoEffect(c,0,EVENT_TO_GRAVE,nil,scard.op1,nil,scard.con1)
end
--get effect
function scard.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_SZONE)
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
