--Dragonic Overlord
--BUG: Won't reduce power in puzzles
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_KAGERO)
	aux.AddRace(c,RACE_FLAME_DRAGON)
	--unit
	aux.EnableUnitAttribute(c)
	--twin drive
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--reduce power
	aux.AddContinuousUpdatePower(c,LOCATION_MZONE+LOCATION_SZONE,-2000,scard.con1)
	--get effect
	aux.AddActivatedEffect(c,0,LOCATION_MZONE+LOCATION_SZONE,nil,aux.CounterBlastCost(3),scard.op1)
end
--reduce power
function scard.cfilter(c)
	return c:IsFaceup() and c:IsClan(CLAN_KAGERO)
end
function scard.con1(e)
	return not Duel.IsExistingMatchingCard(scard.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_SZONE,0,1,e:GetHandler())
end
--get effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--gain power
	aux.AddTempEffectUpdatePower(c,c,5000,RESET_PHASE+PHASE_END)
	--stand
	local e1=aux.AddSingleAutoEffect(c,1,EVENT_DAMAGE_STEP_END,nil,scard.op2)
	e1:SetTarget(aux.HintTarget)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
end
--stand
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.ChangePosition(c,POS_FACEUP_STAND)
end
