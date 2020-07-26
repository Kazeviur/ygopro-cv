--Sleygal Double Edge
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_GOLD_PALADIN)
	aux.AddRace(c,RACE_HIGH_BEAST)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--gain effect
	aux.AddActivatedEffect(c,0,LOCATION_ONFIELD,nil,aux.CounterBlastCost(1),scard.op1)
end
--gain effect
function scard.cfilter(c)
	return c:IsFaceup() and c:IsClan(CLAN_GOLD_PALADIN) and c:IsRearGuard()
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.GetMatchingGroupCount(scard.cfilter,tp,LOCATION_ONFIELD,0,c)>=4 then
		--gain power
		aux.AddTempEffectUpdatePower(c,c,2000,RESET_PHASE+PHASE_END)
	end
end
