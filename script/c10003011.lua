--Battering Minotaur
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NOVA_GRAPPLER)
	aux.AddRace(c,RACE_WARBEAST)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--gain effect
	aux.AddSingleAutoEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,scard.op1,nil,nil,aux.CounterBlastCost(1))
end
--gain effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,3000,RESET_PHASE+PHASE_DAMAGE)
end
--[[
	Note: This card's [AUTO] effect is identical to that of "Knight of Conviction, Bors".
]]
