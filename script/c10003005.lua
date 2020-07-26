--Super Electromagnetic Lifeform, Storm
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NOVA_GRAPPLER)
	aux.AddRace(c,RACE_ALIEN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
	--flip over
	aux.AddSingleAutoEffect(c,0,EVENT_DAMAGE_STEP_END,scard.tg1,scard.op1,EFFECT_FLAG_CARD_TARGET,scard.con1)
end
--flip over
scard.con1=aux.AND(aux.SelfAttackHitCondition(Card.IsVanguard),aux.SelfVanguardCondition(Card.IsClan,CLAN_NOVA_GRAPPLER))
scard.tg1=aux.TargetCardFunction(PLAYER_SELF,aux.DamageZoneFilter(Card.IsFacedown),LOCATION_REMOVED,0,1,1,HINTMSG_FLIPOVER)
scard.op1=aux.TargetCardsOperation(Duel.ChangePosition,POS_FACEUP)
