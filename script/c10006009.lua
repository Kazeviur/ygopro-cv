--Lizard Soldier, Riki
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_NARUKAMI)
	aux.AddRace(c,RACE_DRAGONMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--gain effect
	aux.AddActivatedEffect(c,0,LOCATION_ONFIELD,nil,aux.CounterBlastCost(1),scard.op1)
end
--gain effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,1000,RESET_PHASE+PHASE_END)
end
--[[
	Note: This card's [ACT] effect is identical to that of "Oasis Girl".
]]
