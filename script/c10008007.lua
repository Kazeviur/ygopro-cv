--Zoom Down Eagle
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_GOLD_PALADIN)
	aux.AddRace(c,RACE_HIGH_BEAST)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
	--gain effect
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_INTERCEPT,nil,scard.op1)
end
--gain effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if aux.SelfVanguardCondition(Card.IsClan,CLAN_GOLD_PALADIN)(e,tp,eg,ep,ev,re,r,rp) then
		--gain shield
		aux.AddTempEffectUpdateShield(c,c,5000,RESET_PHASE+PHASE_DAMAGE)
	end
end
--[[
	Note: This card's [AUTO] effect is similar to that of "NGM Prototype".
]]
