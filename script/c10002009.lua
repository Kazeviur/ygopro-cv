--Flame of Hope, Aermo
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_KAGERO)
	aux.AddRace(c,RACE_SALAMANDER)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--draw
	aux.AddAutoEffect(c,0,EVENT_DAMAGE_STEP_END,nil,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1,scard.cost1)
end
--draw
scard.con1=aux.AND(aux.AttackHitCondition(),aux.IsBoostingState)
scard.cost1=aux.DiscardCost(1)
scard.op1=aux.DuelOperation(Duel.Draw,PLAYER_SELF,1,REASON_EFFECT)
