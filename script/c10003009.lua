--Screamin' and Dancin' Announcer, Shout
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NOVA_GRAPPLER)
	aux.AddRace(c,RACE_ALIEN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--draw
	aux.AddActivatedEffect(c,0,LOCATION_ONFIELD,nil,scard.cost1,scard.op1,EFFECT_FLAG_CARD_TARGET)
end
--draw
scard.cost1=aux.MergeCost(aux.SelfRestCost,aux.DiscardCost(1))
scard.op1=aux.DuelOperation(Duel.Draw,PLAYER_SELF,1,REASON_EFFECT)
--[[
	Note: This card's [ACT] effect is identical to that of "Dragon Monk, Gojo".
]]
