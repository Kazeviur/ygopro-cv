--Crimson Butterfly, Brigitte
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ROYAL_PALADIN)
	aux.AddRace(c,RACE_SALAMANDER)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--gain effect
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_DRIVE_CHECK,nil,scard.op1,nil,scard.con1)
end
--gain effect
function scard.cfilter(c)
	return c:IsGrade(3) and c:IsClan(CLAN_ROYAL_PALADIN)
end
scard.con1=aux.AND(aux.VCCondition,aux.DriveCheckCondition(scard.cfilter))
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,5000,RESET_PHASE+PHASE_DAMAGE)
end
