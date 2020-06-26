--Wyvern Strike, Jarran
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_KAGERO)
	aux.AddRace(c,RACE_WINGED_DRAGON)
	--unit
	aux.EnableUnitAttribute(c)
	--boost
	aux.EnableBoost(c)
	--get effect
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_BOOST,nil,scard.op1,nil,scard.con1)
end
--get effect
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	return tc and tc:IsCode(CARD_WYVERN_STRIKE_TEJAS)
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,Duel.GetAttacker(),4000,RESET_PHASE+PHASE_DAMAGE)
end
