--Sacred Guardian Beast, Nemean Lion
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_GOLD_PALADIN)
	aux.AddRace(c,RACE_HIGH_BEAST)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
	--gain effect
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_INTERCEPT,nil,scard.op1,nil,scard.con1)
end
--gain effect
scard.con1=aux.SelfVanguardCondition(Card.IsClan,CLAN_GOLD_PALADIN)
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain shield
	aux.AddTempEffectUpdateShield(c,c,5000,RESET_PHASE+PHASE_DAMAGE)
end
--[[
	Note: This card's [AUTO] effect is similar to that of "NGM Prototype".
]]
