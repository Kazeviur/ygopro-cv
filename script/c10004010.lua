--Battle Sister, Maple
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ORACLE_THINK_TANK)
	aux.AddRace(c,RACE_ELF)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--gain effect
	aux.AddSingleAutoEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,scard.op1)
end
--gain effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=4 then
		--gain power
		aux.AddTempEffectUpdatePower(c,c,3000,RESET_PHASE+PHASE_DAMAGE)
	end
end
