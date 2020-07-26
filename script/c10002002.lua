--Dragon Monk, Goku
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_KAGERO)
	aux.AddRace(c,RACE_WARBEAST)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--retire
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_DRIVE_CHECK,scard.tg1,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1)
end
--retire
function scard.cfilter(c)
	return c:IsGrade(3) and c:IsClan(CLAN_KAGERO)
end
scard.con1=aux.AND(aux.VCCondition,aux.DriveCheckCondition(scard.cfilter))
function scard.tgfilter(c)
	return c:IsFaceup() and c:IsGradeBelow(1) and c:IsRearGuard()
end
scard.tg1=aux.TargetCardFunction(PLAYER_SELF,scard.tgfilter,0,LOCATION_ONFIELD,1,1,HINTMSG_RETIRE)
scard.op1=aux.TargetCardsOperation(Duel.SendtoDrop,REASON_EFFECT)
