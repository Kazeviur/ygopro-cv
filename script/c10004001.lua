--Oracle Guardian, Apollon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ORACLE_THINK_TANK)
	aux.AddRace(c,RACE_BATTLEROID)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--draw, to deck
	aux.AddSingleAutoEffect(c,0,EVENT_DAMAGE_STEP_END,nil,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1,scard.cost1)
	--draw
	aux.AddSingleAutoEffect(c,1,EVENT_DAMAGE_STEP_END,nil,scard.op2,nil,scard.con2,scard.cost1)
end
--draw, to deck
scard.con1=aux.AND(aux.VCCondition,aux.SelfAttackHitCondition)
scard.cost1=aux.CounterBlastCost(2)
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Draw(tp,2,REASON_EFFECT)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,PLAYER_OWNER,SEQ_DECK_SHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
--draw
scard.con2=aux.AND(aux.RCCondition,aux.SelfAttackHitCondition)
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
