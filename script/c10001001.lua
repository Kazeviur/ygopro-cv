--Crimson Butterfly, Brigitte
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ROYAL_PALADIN)
	aux.AddRace(c,RACE_SALAMANDER)
	--unit
	aux.EnableUnitAttribute(c)
	--twin drive
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--get effect
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_DRIVE_CHECK,nil,scard.op1,nil,scard.con1)
end
--get effect
function scard.cfilter(c)
	return c:IsGrade(3) and c:IsClan(CLAN_ROYAL_PALADIN)
end
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	return aux.VCCondition(e,tp,eg,ep,ev,re,r,rp) and Duel.GetDriveCheckGroup():IsExists(scard.cfilter,1,nil)
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,5000,RESET_PHASE+PHASE_DAMAGE)
end
