--Sword Dancer Angel
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ORACLE_THINK_TANK)
	aux.AddRace(c,RACE_ANGEL)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (intercept)
	aux.EnableIntercept(c)
	--gain effect
	aux.AddAutoEffect(c,0,EVENT_DRAW,nil,scard.op1,nil,aux.EventPlayerCondition(PLAYER_SELF))
end
--gain effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,1000*ev,RESET_PHASE+PHASE_END)
end
--[[
	Rulings

	1. Question:When I draw two cards at once, does this ability gives this unit [Power]+2000?
	2. Answer:Yes, you get [Power]+2000.

	https://cardfight.fandom.com/wiki/Card_Rulings:Sword_Dancer_Angel
]]
