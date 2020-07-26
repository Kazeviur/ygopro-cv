--Goddess of Flower Divination, Sakuya
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ORACLE_THINK_TANK)
	aux.AddRace(c,RACE_NOBLE)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--gain power
	aux.AddContinuousUpdatePower(c,LOCATION_ONFIELD,4000,scard.con1)
	--return
	aux.AddSingleAutoEffect(c,1,EVENT_PLACED_VC,nil,scard.op1)
end
--gain power
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	return aux.VCCondition(e,tp,eg,ep,ev,re,r,rp)
		and Duel.GetTurnPlayer()==p and Duel.GetFieldGroupCount(p,LOCATION_HAND,0)>=4
end
--return
function scard.thfilter(c)
	return c:IsFaceup() and c:IsClan(CLAN_ORACLE_THINK_TANK) and c:IsRearGuard() and c:IsAbleToHand()
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.thfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
end
