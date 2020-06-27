--Dragon Monk, Gojo
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_KAGERO)
	aux.AddRace(c,RACE_GILLMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--draw
	aux.AddActivatedEffect(c,0,LOCATION_MZONE+LOCATION_SZONE,nil,scard.cost1,scard.op1,EFFECT_FLAG_CARD_TARGET)
end
--draw
scard.cost1=aux.MergeCost(aux.SelfRestCost,aux.DiscardCost(1))
scard.op1=aux.DuelOperation(Duel.Draw,PLAYER_SELF,1,REASON_EFFECT)
