--Branbau Revenger
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_SHADOW_PALADIN)
	aux.AddRace(c,RACE_HIGH_BEAST)
	aux.AddSeries(c,SERIES_REVENGER)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--gain effect
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_BOOST,nil,scard.op1,nil,aux.AttackerCondition(scard.cfilter))
end
--gain effect
function scard.cfilter(c)
	return c:IsFaceup() and c:IsClan(CLAN_SHADOW_PALADIN) and c:IsVanguard()
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.GetRearGuardCount(tp)<Duel.GetRearGuardCount(1-tp) then
		--gain power
		aux.AddTempEffectUpdatePower(c,Duel.GetAttacker(),4000,RESET_PHASE+PHASE_DAMAGE)
	end
end
