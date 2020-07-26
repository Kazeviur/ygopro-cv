--Charjgal
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_GOLD_PALADIN)
	aux.AddRace(c,RACE_HIGH_BEAST)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--gain effect
	aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_BOOST,nil,scard.op1,nil,scard.con1,scard.cost1)
end
--gain effect
scard.con1=aux.AttackerCondition(Card.IsCode,CARD_GREAT_SILVER_WOLF_GARMORE)
scard.cost1=aux.SoulBlastCost(1)
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,Duel.GetAttacker(),5000,RESET_PHASE+PHASE_DAMAGE)
end
