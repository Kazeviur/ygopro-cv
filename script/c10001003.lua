--Solitary Knight, Gancelot
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ROYAL_PALADIN)
	aux.AddRace(c,RACE_ELF)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--gain effect
	aux.AddActivatedEffect(c,0,LOCATION_ONFIELD,aux.VCCondition,aux.CounterBlastCost(2),scard.op1)
	--search (to hand)
	aux.AddActivatedEffect(c,1,LOCATION_HAND,nil,aux.SelfToDeckCost(SEQ_DECK_TOP),scard.op2)
end
--gain effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if c:GetSoul():IsExists(Card.IsCode,1,nil,CARD_BLASTER_BLADE) then
		--gain power
		aux.AddTempEffectUpdatePower(c,c,5000,RESET_PHASE+PHASE_END)
		--gain critical
		aux.AddTempEffectCustom(c,c,2,EFFECT_UPDATE_CRITICAL,1,RESET_PHASE+PHASE_END)
	end
end
--search (to hand)
function scard.thfilter(c)
	return c:IsCode(CARD_BLASTER_BLADE) and c:IsAbleToHand()
end
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,scard.thfilter,tp,LOCATION_DECK,0,0,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		Duel.ShuffleDeck(tp)
	end
end
