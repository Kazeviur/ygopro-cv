--Eradicator, Vowing Sword Dragon
--Note: EVENT_BE_RIDE won't be raised if SetType is EFFECT_TYPE_TRIGGER
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NARUKAMI)
	aux.AddRace(c,RACE_THUNDER_DRAGON)
	aux.AddSeries(c,SERIES_ERADICATOR)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--retire, gain effect
	local e1=aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_BE_RIDE,nil,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	--gain effect
	aux.AddSingleAutoEffect(c,1,EVENT_ATTACK_ANNOUNCE,nil,scard.op2,nil,aux.VCCondition)
	--keyword (lord)
	aux.EnableLord(c)
end
--retire, gain effect
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetSoulTarget()
	return tc:IsClan(CLAN_NARUKAMI) and aux.LimitBreakCondition(4)(e,tc:GetControler(),eg,ep,ev,re,r,rp)
end
function scard.retfilter(c,e)
	return c:IsFaceup() and c:IsRearGuard() and c:IsFrontRow() and c:IsCanBeEffectTarget(e)
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cp=c:GetSoulTarget():GetControler()
	local tc=Duel.GetVanguard(cp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.Hint(HINT_SELECTMSG,cp,HINTMSG_RETIRE)
	local g=Duel.SelectMatchingCard(cp,scard.retfilter,cp,0,LOCATION_ONFIELD,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.SetTargetCard(g)
		Duel.HintSelection(g)
		Duel.SendtoDrop(g,REASON_EFFECT)
	end
	if tc:IsCanBeEffectTarget(e) then
		Duel.SetTargetCard(tc)
		Duel.HintSelection(Group.FromCards(tc))
		--gain power
		aux.AddTempEffectUpdatePower(c,tc,10000,RESET_PHASE+PHASE_END)
	end
end
--gain effect
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.GetDamageCount(1-tp)>=3 then
		--gain power
		aux.AddTempEffectUpdatePower(c,c,2000,RESET_PHASE+PHASE_DAMAGE)
	end
end
