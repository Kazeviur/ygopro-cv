Rule={}
--register rules
function Rule.RegisterRules(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_ALL)
	e1:SetCountLimit(1)
	e1:SetOperation(Rule.ApplyRules)
	c:RegisterEffect(e1)
end
function Rule.ApplyRules(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(PLAYER_ONE,10000000)>0 then return end
	Duel.RegisterFlagEffect(PLAYER_ONE,10000000,0,0,0)
	--remove rules
	Rule.remove_rules(PLAYER_ONE)
	Rule.remove_rules(PLAYER_TWO)
	--shuffle deck
	Rule.shuffle_deck(PLAYER_ONE)
	Rule.shuffle_deck(PLAYER_TWO)
	--check deck size
	local b1=Duel.GetFieldGroupCount(PLAYER_ONE,LOCATION_DECK,0)~=50
	local b2=Duel.GetFieldGroupCount(PLAYER_TWO,LOCATION_DECK,0)~=50
	--check for trigger units
	local b3=Duel.GetMatchingGroupCount(Card.IsType,PLAYER_ONE,LOCATION_DECK,0,nil,TYPE_TRIGGER_UNIT)~=16
	local b4=Duel.GetMatchingGroupCount(Card.IsType,PLAYER_TWO,LOCATION_DECK,0,nil,TYPE_TRIGGER_UNIT)~=16
	--check for [heal] trigger units
	local b5=Duel.GetMatchingGroupCount(Card.IsType,PLAYER_ONE,LOCATION_DECK,0,nil,TRIGGER_HEAL)>4
	local b6=Duel.GetMatchingGroupCount(Card.IsType,PLAYER_TWO,LOCATION_DECK,0,nil,TRIGGER_HEAL)>4
	if b1 then Duel.Hint(HINT_MESSAGE,PLAYER_ONE,ERROR_DECKCOUNT) end
	if b2 then Duel.Hint(HINT_MESSAGE,PLAYER_TWO,ERROR_DECKCOUNT) end
	if b3 then Duel.Hint(HINT_MESSAGE,PLAYER_ONE,ERROR_TRIGGERCOUNT) end
	if b4 then Duel.Hint(HINT_MESSAGE,PLAYER_TWO,ERROR_TRIGGERCOUNT) end
	if b5 then Duel.Hint(HINT_MESSAGE,PLAYER_ONE,ERROR_HEALCOUNT) end
	if b6 then Duel.Hint(HINT_MESSAGE,PLAYER_TWO,ERROR_HEALCOUNT) end
	if (b1 and b2) or (b3 and b4) or (b5 and b6) then
		Duel.Win(PLAYER_NONE,WIN_REASON_INVALID)
		return
	elseif b1 or b3 or b5 then
		Duel.Win(PLAYER_TWO,WIN_REASON_INVALID)
		return
	elseif b2 or b4 or b6 then
		Duel.Win(PLAYER_ONE,WIN_REASON_INVALID)
		return
	end
	--set lp
	Duel.SetLP(PLAYER_ONE,6)
	Duel.SetLP(PLAYER_TWO,6)
	--call vanguard
	Rule.call_vanguard(PLAYER_ONE)
	Rule.call_vanguard(PLAYER_TWO)
	--draw starting hand
	Duel.Draw(PLAYER_ONE,5,REASON_RULE)
	Duel.Draw(PLAYER_TWO,5,REASON_RULE)
	--redraw
	Rule.redraw(PLAYER_ONE)
	Rule.redraw(PLAYER_TWO)
	--stand up vanguard
	local g=Duel.GetMatchingGroup(Card.IsVanguard,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_OPSELECTED,PLAYER_TWO,DESC_STAND_UP)
	Duel.ChangePosition(g,POS_FACEUP_STAND)
	--stand phase
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetDescription(DESC_STAND_PHASE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STAND_PHASE)
	e1:SetCondition(Rule.StandCondition)
	e1:SetOperation(Rule.StandOperation)
	Duel.RegisterEffect(e1,0)
	--ride phase
	local e2=Effect.GlobalEffect()
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetDescription(DESC_RIDE_PHASE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_RIDE)
	e2:SetCountLimit(1)
	e2:SetOperation(Rule.RideOperation)
	Duel.RegisterEffect(e2,0)
	--tap to attack workaround
	local e3=Effect.GlobalEffect()
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetOperation(Rule.AttackTapOperation)
	Duel.RegisterEffect(e3,0)
	--guard step
	local e4=Effect.GlobalEffect()
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetOperation(Rule.GuardOperation)
	Duel.RegisterEffect(e4,0)
	--drive step
	local e5=Effect.GlobalEffect()
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BATTLE_CONFIRM)
	e5:SetOperation(Rule.DriveOperation)
	Duel.RegisterEffect(e5,0)
	--inflict damage
	local e6=Effect.GlobalEffect()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BATTLED)
	e6:SetCondition(Rule.DamageCondition)
	e6:SetOperation(Rule.DamageOperation)
	Duel.RegisterEffect(e6,0)
	--damage check
	local e7=Effect.GlobalEffect()
	e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_DAMAGE)
	e7:SetOperation(Rule.DamageCheckOperation)
	Duel.RegisterEffect(e7,0)
	--trigger check
	local e8=Effect.GlobalEffect()
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_ADJUST)
	e8:SetOperation(Rule.TriggerCheckOperation)
	Duel.RegisterEffect(e8,0)
	--win game
	local e9=Effect.GlobalEffect()
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetOperation(Rule.WinOperation)
	Duel.RegisterEffect(e9,0)
	--override yugioh rules
	--set lp
	Rule.set_lp()
	--draw first turn
	Rule.draw_first_turn()
	--cannot summon
	Rule.cannot_summon()
	--cannot mset
	Rule.cannot_mset()
	--cannot sset
	Rule.cannot_sset()
	--infinite hand
	Rule.infinite_hand()
	--infinite attacks
	Rule.infinite_attacks()
	--cannot conduct main phase 2
	Rule.cannot_main_phase2()
	--cannot change position
	Rule.cannot_change_position()
	--cannot direct attack
	Rule.cannot_direct_attack()
	--no battle damage
	Rule.avoid_battle_damage()
	--indestructible
	Rule.indestructible()
	--set def equal to atk
	Rule.def_equal_atk()
	--destroy equal/less def
	Rule.destroy_equal_less_def()
	--cannot replay
	Rule.cannot_replay()
end
--remove rules
function Rule.remove_rules(tp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ALL,0,nil,10000000)
	if g:GetCount()==0 then return end
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(g,PLAYER_OWNER,SEQ_DECK_UNEXIST,REASON_RULE)
end
--shuffle deck
function Rule.shuffle_deck(tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,PLAYER_OWNER,SEQ_DECK_SHUFFLE,REASON_RULE)
	Duel.ShuffleDeck(tp)
end
--call vanguard
function Rule.call_vanguard(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOVCIRCLE)
	local g=Duel.SelectMatchingCard(tp,Card.IsGrade,tp,LOCATION_DECK,0,1,1,nil,0)
	if g:GetCount()==0 then return end
	Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_MZONE,POS_FACEDOWN_STAND,true,ZONE_VC)
end
--redraw
function Rule.redraw(tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EXCHANGE)
	local sg=g:Select(tp,0,g:GetCount(),nil)
	if sg:GetCount()==0 then return end
	Duel.SendtoDeck(sg,PLAYER_OWNER,SEQ_DECK_BOTTOM,REASON_RULE)
	Duel.BreakEffect()
	Duel.Draw(tp,sg:GetCount(),REASON_RULE)
	Duel.ShuffleDeck(tp)
end
--stand phase
function Rule.StandCondition(e)
	return Duel.IsExistingMatchingCard(Card.IsAbleToStand,Duel.GetTurnPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function Rule.StandOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToStand,Duel.GetTurnPlayer(),LOCATION_ONFIELD,0,nil)
	Duel.ChangePosition(g,POS_FACEUP_STAND)
end
--ride phase
function Rule.RideFilter(c,e,tp,grade)
	return (c:IsGrade(grade) or c:IsGrade(grade+1)) and c:IsAbleToRide(e,0,tp,false,false)
end
function Rule.RideOperation(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local tc=Duel.GetVanguard(turnp)
	local grade=tc:GetGrade()
	local g=Duel.GetMatchingGroup(Rule.RideFilter,turnp,LOCATION_HAND,0,nil,e,turnp,grade)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_RIDE)
		local sg=g:Select(turnp,0,1,nil)
		if sg:GetCount()>0 then
			Duel.Ride(sg,turnp)
		end
	end
	--raise event for "At the beginning of the main phase"
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+EVENT_MAIN_PHASE_START,e,0,0,0,0)
end
--tap to attack workaround
function Rule.AttackTapOperation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsRelateToBattle() then
		Duel.ChangePosition(a,POS_FACEUP_REST)
	end
	--Note: Remove the following if YGOPro allows a card to tap itself for EFFECT_ATTACK_COST
	if a:GetFlagEffect(10000001)>1 then
		Duel.ChangePosition(a,POS_FACEUP_STAND)
	end
end
--guard step
function Rule.GuardOperation(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local g=Duel.GetMatchingGroup(aux.TRUE--[[Card.IsAbleToCall]],1-turnp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_OPSELECTED,turnp,DESC_GUARD_STEP)
		Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_TOGCIRCLE)
		local sg=g:Select(1-turnp,0,1,nil)
		if sg:GetCount()>0 then
			Duel.Call(sg,1-turnp,POS_FACEUP_REST,LOCATION_MZONE,bit.lshift(0x1,5))
		end
	end
	--damage step (check guardians)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetOperation(Rule.DamageStepOperation)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	--retire guardians
	local e2=e1:Clone()
	e2:SetOperation(Rule.RetireOperation)
	Duel.RegisterEffect(e2,tp)
end
--damage step (check guardians)
function Rule.DamageStepOperation(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local tc1=Duel.GetGuardian(turnp)
	local tc2=Duel.GetGuardian(1-turnp)
	if tc1 then
		--add shield (attacker)
		Rule.add_shield(Duel.GetAttacker(),tc1:GetShield())
	end
	if tc2 then
		--add shield (attack target)
		Rule.add_shield(Duel.GetAttackTarget(),tc2:GetShield())
	end
end
function Rule.add_shield(c,val)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_POWER)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end
--retire guardians
function Rule.RetireOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetGuardian()
	Duel.SendtoDrop(g,REASON_RULE)
end
--drive step
function Rule.DriveOperation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local ct=a:GetDriveCount()
	if not a or ct<=0 then return end
	local cp=a:GetControler()
	for i=1,ct do
		Duel.ConfirmDecktop(cp,1)
		local g=Duel.GetDecktopGroup(cp,1)
		Duel.DisableShuffleCheck()
		Duel.SendtoTrigger(g)
		local tc=g:GetFirst()
		if not tc then break end
		--add drive check status
		tc:SetStatus(STATUS_DRIVE_CHECK,true)
		--remove drive check status
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DAMAGE_STEP_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(tc)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			e:GetLabelObject():SetStatus(STATUS_DRIVE_CHECK,false)
		end)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,0)
		--raise event for "When this unit's drive check reveals"
		Duel.RaiseSingleEvent(a,EVENT_CUSTOM+EVENT_DRIVE_CHECK,e,0,0,0,0)
	end
end
--inflict damage
function Rule.DamageCondition(e)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a and d and d:IsFaceup() and d:IsVanguard() and d:IsRelateToBattle() and a:GetPower()>=d:GetPower()
end
function Rule.DamageOperation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local dam=a:GetCriticalCount()
	Duel.Damage(1-a:GetControler(),dam,REASON_RULE)
end
--damage check
function Rule.DamageCheckOperation(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		Duel.ConfirmDecktop(ep,1)
		local g=Duel.GetDecktopGroup(ep,1)
		Duel.DisableShuffleCheck()
		Duel.SendtoTrigger(g)
	end
end
--trigger check
function Rule.TriggerCheckOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TriggerZoneFilter(),0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if g:GetCount()==0 then return end
	for c in aux.Next(g) do
		if c:GetFlagEffect(10000002)==0 then
			if Duel.CheckEvent(EVENT_CUSTOM+EVENT_TRIGGER_UNIT) and c:IsStatus(STATUS_CHAINING) then
				--trigger resolution
				local e1=Effect.GlobalEffect()
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAIN_SOLVED)
				e1:SetProperty(EFFECT_FLAG_DELAY)
				e1:SetCountLimit(1)
				e1:SetLabelObject(c)
				e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					Rule.move_trigger_unit(e:GetLabelObject())
				end)
				e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
				Duel.RegisterEffect(e1,0)
			else
				if c:IsLocation(LOCATION_REMOVED) then Duel.HintSelection(Group.FromCards(c)) end
				Rule.move_trigger_unit(c)
			end
			c:RegisterFlagEffect(10000002,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE,0,1)
		end
	end
end
function Rule.move_trigger_unit(c)
	if c:IsStatus(STATUS_DRIVE_CHECK) and c:IsAbleToHand() then
		Duel.SendtoHand(c,PLAYER_OWNER,REASON_RULE)
		Duel.ConfirmCards(1-c:GetControler(),c)
	else
		Duel.SendtoDamage(c)
	end
end
--win game
function Rule.WinOperation(e,tp,eg,ep,ev,re,r,rp)
	local win={}
	win[0]=Duel.GetFieldGroupCount(PLAYER_ONE,LOCATION_DECK,0)==0
	win[1]=Duel.GetFieldGroupCount(PLAYER_TWO,LOCATION_DECK,0)==0
	if win[0] and win[1] then
		Duel.Win(PLAYER_NONE,WIN_REASON_DECKOUT)
	elseif win[0] then
		Duel.Win(PLAYER_TWO,WIN_REASON_DECKOUT)
	elseif win[1] then
		Duel.Win(PLAYER_ONE,WIN_REASON_DECKOUT)
	end
end
--override yugioh rules
--set lp
function Rule.set_lp(tp)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(Rule.SetLPOperation)
	Duel.RegisterEffect(e1,0)
end
function Rule.SetLPOperation(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetDamageCount(PLAYER_ONE)
	local ct2=Duel.GetDamageCount(PLAYER_TWO)
	if Duel.GetLP(PLAYER_ONE)~=6-ct1 then Duel.SetLP(PLAYER_ONE,6-ct1) end
	if Duel.GetLP(PLAYER_TWO)~=6-ct2 then Duel.SetLP(PLAYER_TWO,6-ct2) end
end
--draw first turn
function Rule.draw_first_turn()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_DRAW)
	e1:SetCountLimit(1)
	e1:SetCondition(Rule.DrawCondition)
	e1:SetOperation(Rule.DrawOperation)
	Duel.RegisterEffect(e1,0)
end
function Rule.DrawCondition(e)
	return Duel.GetTurnCount()==1
end
function Rule.DrawOperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(Duel.GetTurnPlayer(),1,REASON_RULE)
end
--cannot summon
function Rule.cannot_summon()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)
end
--cannot mset
function Rule.cannot_mset()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)
end
--cannot sset
function Rule.cannot_sset()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_HAND))
	Duel.RegisterEffect(e1,0)
end
--infinite hand
function Rule.infinite_hand()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetTargetRange(1,1)
	e1:SetValue(MAX_NUMBER)
	Duel.RegisterEffect(e1,0)
end
--infinite attacks
function Rule.infinite_attacks()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetValue(MAX_NUMBER)
	Duel.RegisterEffect(e1,0)
end
--cannot conduct main phase 2
function Rule.cannot_main_phase2()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_M2)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)
end
--cannot change position
function Rule.cannot_change_position()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.RegisterEffect(e1,0)
end
--cannot direct attack
function Rule.cannot_direct_attack()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.RegisterEffect(e1,0)
end
--no battle damage
function Rule.avoid_battle_damage()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,0)
end
--indestructible
function Rule.indestructible()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTIBLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsVanguard))
	e1:SetValue(1)
	Duel.RegisterEffect(e1,0)
	local e2=e1:Clone()
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(aux.TargetBoolFunction(aux.AND(Card.IsRearGuard,Card.IsAttacker)))
	Duel.RegisterEffect(e2,0)
end
--set def equal to atk
function Rule.def_equal_atk()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsGuardian)))
	e1:SetValue(function(e,c)
		return c:GetPower()
	end)
	Duel.RegisterEffect(e1,0)
end
--destroy equal/less def
function Rule.destroy_equal_less_def()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetOperation(Rule.DestroyOperation)
	Duel.RegisterEffect(e1,0)
end
function Rule.DestroyOperation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a or not a:IsLocation(LOCATION_ONFIELD)
		or not d or not d:IsLocation(LOCATION_ONFIELD) or not d:IsDefensePos() then return end
	local ef1=a:IsHasEffect(EFFECT_INDESTRUCTIBLE) or a:IsHasEffect(EFFECT_INDESTRUCTIBLE_BATTLE)
	local ef2=d:IsHasEffect(EFFECT_INDESTRUCTIBLE) or d:IsHasEffect(EFFECT_INDESTRUCTIBLE_BATTLE)
	local g=Group.CreateGroup()
	if a:GetAttack()<d:GetDefense() then
		if not ef1 and a:IsRelateToBattle() then g:AddCard(a) end
	elseif a:GetAttack()==d:GetDefense() then
		if not ef1 and a:IsRelateToBattle() then g:AddCard(a) end
		if not ef2 and d:IsRelateToBattle() then g:AddCard(d) end
	end
	Duel.Destroy(g,REASON_BATTLE+REASON_RULE)
end
--cannot replay
function Rule.cannot_replay()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD) and Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		--[[if not d or not d:IsLocation(LOCATION_MZONE) then
			Duel.ChangePosition(a,POS_FACEUP_REST)
			return
		end]]
		Duel.ChangeAttackTarget(d)
	end)
	Duel.RegisterEffect(e1,0)
end
