--Solitary Liberator, Gancelot
--Note: EVENT_BE_RIDE won't be raised if SetType is EFFECT_TYPE_TRIGGER
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_GOLD_PALADIN)
	aux.AddRace(c,RACE_ELF)
	aux.AddSeries(c,SERIES_LIBERATOR)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--gain effect
	local e1=aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_BE_RIDE,nil,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	--gain effect
	aux.AddSingleAutoEffect(c,1,EVENT_ATTACK_ANNOUNCE,nil,scard.op2,nil,scard.con2)
	--keyword (lord)
	aux.EnableLord(c)
end
--gain effect
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetSoulTarget()
	return tc:IsClan(CLAN_GOLD_PALADIN) and aux.LimitBreakCondition(4)(e,tc:GetControler(),eg,ep,ev,re,r,rp)
end
function scard.effilter(c,e)
	return c:IsFaceup() and c:IsClan(CLAN_GOLD_PALADIN) and c:IsRearGuard() and c:IsCanBeEffectTarget(e)
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cp=c:GetSoulTarget():GetControler()
	local tc1=Duel.GetVanguard(cp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SetTargetCard(tc1)
	Duel.HintSelection(Group.FromCards(tc1))
	--gain power
	aux.AddTempEffectUpdatePower(c,tc1,10000,RESET_PHASE+PHASE_END)
	Duel.Hint(HINT_SELECTMSG,cp,HINTMSG_GAINPOWER)
	local g=Duel.SelectMatchingCard(cp,scard.effilter,cp,LOCATION_ONFIELD,0,0,3,nil,e)
	if g:GetCount()==0 then return end
	Duel.SetTargetCard(g)
	Duel.HintSelection(g)
	for tc2 in aux.Next(g) do
		--gain power
		aux.AddTempEffectUpdatePower(c,tc2,5000,RESET_PHASE+PHASE_END)
	end
end
--gain effect
scard.con2=aux.AND(aux.VCCondition,aux.AttackTargetCondition(Card.IsVanguard))
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,2000,RESET_PHASE+PHASE_DAMAGE)
end
