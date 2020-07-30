--Battle Siren, Cynthia
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_AQUA_FORCE)
	aux.AddRace(c,RACE_MERMAID)
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
--[[
	Note: This card's [AUTO] effect is identical to that of "Flame of Hope, Aermo".
]]
