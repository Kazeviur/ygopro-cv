--Great Silver Wolf, Garmore
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_GOLD_PALADIN)
	aux.AddRace(c,RACE_HUMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--gain effect
	aux.AddSingleAutoEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,scard.op1,nil,scard.con1)
	--search (call)
	aux.AddSingleAutoEffect(c,1,EVENT_PLACED_VC,nil,scard.op2,nil,nil,aux.CounterBlastCost(2))
end
--gain effect
scard.con1=aux.AND(aux.VCCondition,aux.LimitBreakCondition(4),aux.AttackTargetCondition(Card.IsVanguard))
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,5000,RESET_PHASE+PHASE_DAMAGE)
end
--search (call)
function scard.callfilter(c)
	return c:IsGradeBelow(2) and c:IsClan(CLAN_GOLD_PALADIN)
end
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
	local g=Duel.SelectMatchingCard(tp,scard.callfilter,tp,LOCATION_DECK,0,0,1,nil)
	if g:GetCount()>0 then
		Duel.Call(g,tp)
	else
		Duel.ShuffleDeck(tp)
	end
end
