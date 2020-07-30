--Future Liberator, Llew
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_GOLD_PALADIN)
	aux.AddRace(c,RACE_HUMAN)
	aux.AddSeries(c,SERIES_LIBERATOR)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--gain effect
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_BOOST,nil,scard.op1,nil,aux.AttackerCondition(scard.cfilter))
end
--gain effect
function scard.cfilter(c)
	return c:IsFaceup() and c:IsClan(CLAN_GOLD_PALADIN) and c:IsVanguard()
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.GetRearGuard(tp):FilterCount(Card.IsSeries,c,SERIES_LIBERATOR)>=3 then
		--gain power
		aux.AddTempEffectUpdatePower(c,Duel.GetAttacker(),4000,RESET_PHASE+PHASE_DAMAGE)
	end
end
