--Luck Bird
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ORACLE_THINK_TANK)
	aux.AddRace(c,RACE_HIGH_BEAST)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--draw
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_PLACED_RC,nil,scard.op1,nil,scard.con1,scard.cost1)
end
--draw
scard.con1=aux.SelfVanguardCondition(Card.IsClan,CLAN_ORACLE_THINK_TANK)
scard.cost1=aux.SoulBlastCost(2)
scard.op1=aux.DuelOperation(Duel.Draw,PLAYER_SELF,1,REASON_EFFECT)
