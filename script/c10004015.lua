--Lozenge Magus
--Note: EVENT_BE_RIDE won't be raised if SetType is EFFECT_TYPE_TRIGGER
--UNTESTED OUTSIDE PUZZLES
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ORACLE_THINK_TANK)
	aux.AddRace(c,RACE_ELF)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (boost)
	aux.EnableBoost(c)
	--call
	local e1=aux.AddSingleAutoEffect(c,0,EVENT_CUSTOM+EVENT_BE_RIDE,nil,scard.op1,nil,scard.con1)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	--gain effect
	aux.AddSingleAutoEffect(c,1,EVENT_CUSTOM+EVENT_BOOST,nil,scard.op2)
end
--call
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetOverlayTarget()
	return tc:IsClan(CLAN_ORACLE_THINK_TANK)
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.Call(e:GetHandler(),tp)
end
--gain effect
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,Duel.GetAttacker(),3000,RESET_PHASE+PHASE_DAMAGE)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_END)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCountLimit(1)
	e1:SetOperation(scard.op3)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
--return
function scard.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SendtoDeck(e:GetHandler(),PLAYER_OWNER,SEQ_DECK_SHUFFLE,REASON_EFFECT)
end
--[[
	Note: This card's [AUTO] effect is identical to that of "Battleraizer".
]]
