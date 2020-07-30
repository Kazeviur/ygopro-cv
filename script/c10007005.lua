--Marine General of the Restless Tides, Algos
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_AQUA_FORCE)
	aux.AddRace(c,RACE_AQUAROID)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
	--draw
	aux.AddSingleAutoEffect(c,0,EVENT_DAMAGE_STEP_END,nil,scard.op1,nil,aux.SelfAttackHitCondition(Card.IsVanguard))
end
--draw
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if aux.SelfVanguardCondition(Card.IsClan,CLAN_AQUA_FORCE)(e,tp,eg,ep,ev,re,r,rp) and Duel.GetBattledCount(tp)>=4 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
