--Dark Cat
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ORACLE_THINK_TANK)
	aux.AddRace(c,RACE_HIGH_BEAST)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--draw
	aux.AddSingleAutoEffect(c,0,EVENT_PLACED_VC,nil,scard.op1,nil,aux.VCCondition)
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_PLACED_RC,nil,scard.op1)
end
--draw
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	if not aux.SelfVanguardCondition(Card.IsClan,CLAN_ORACLE_THINK_TANK)(e,tp,eg,ep,ev,re,r,rp) then return end
	if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,YESNOMSG_DRAW) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if Duel.IsPlayerCanDraw(1-tp,1) and Duel.SelectYesNo(1-tp,YESNOMSG_DRAW) then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
