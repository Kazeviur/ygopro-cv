--Covenant Knight, Randolf
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ROYAL_PALADIN)
	aux.AddRace(c,RACE_HUMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--intercept
	aux.EnableIntercept(c)
	--get effect
	aux.AddSingleAutoEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,scard.op1)
end
--get effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if not c:IsRelateToEffect(e) or c:IsFacedown() or ct2>=ct1 then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,3000,RESET_PHASE+PHASE_DAMAGE)
end
