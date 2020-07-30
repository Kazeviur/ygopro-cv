--Illusionary Revenger, Mordred Phantom
--Note: EVENT_BE_RIDE won't be raised if SetType is EFFECT_TYPE_TRIGGER
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_SHADOW_PALADIN)
	aux.AddRace(c,RACE_ELF)
	aux.AddSeries(c,SERIES_REVENGER)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--gain effect, search (call)
	local e1=aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_BE_RIDE,nil,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1,scard.cost1)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	--gain effect
	aux.AddSingleAutoEffect(c,1,EVENT_ATTACK_ANNOUNCE,nil,scard.op2,nil,scard.con2)
	--keyword (lord)
	aux.EnableLord(c)
end
--gain effect, search (call)
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetSoulTarget()
	return tc:IsClan(CLAN_SHADOW_PALADIN) and aux.LimitBreakCondition(4)(e,tc:GetControler(),eg,ep,ev,re,r,rp)
end
scard.cost1=aux.CounterBlastCost(1)
function scard.callfilter(c)
	return c:IsGradeBelow(2) and c:IsClan(CLAN_SHADOW_PALADIN)
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cp=c:GetSoulTarget():GetControler()
	local tc=Duel.GetVanguard(cp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SetTargetCard(tc)
	Duel.HintSelection(Group.FromCards(tc))
	--gain power
	aux.AddTempEffectUpdatePower(c,tc,10000,RESET_PHASE+PHASE_END)
	Duel.Hint(HINT_SELECTMSG,cp,HINTMSG_CALL)
	local g=Duel.SelectMatchingCard(cp,scard.callfilter,cp,LOCATION_DECK,0,0,1,nil)
	if g:GetCount()>0 then
		Duel.Call(g,cp)
		--gain power
		aux.AddTempEffectUpdatePower(c,g:GetFirst(),5000,RESET_PHASE+PHASE_END)
	else
		Duel.ShuffleDeck(cp)
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
--[[
	Note: This card's second [AUTO] effect is identical to that of "Solitary Liberator, Gancelot".
]]
