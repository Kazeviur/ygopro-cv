--Overwritten Duel functions
--select a card
--Note: Overwritten to notify a player if there are no cards to select
local duel_select_matching_card=Duel.SelectMatchingCard
function Duel.SelectMatchingCard(sel_player,f,player,s,o,min,max,ex,...)
	if not Duel.IsExistingMatchingCard(f,player,s,o,1,ex,...) then
		Duel.Hint(HINT_MESSAGE,sel_player,ERROR_NOTARGETS)
	end
	return duel_select_matching_card(sel_player,f,player,s,o,min,max,ex,...)
end
--target a card
--Note: Overwritten to notify a player if there are no cards to select
local duel_select_target=Duel.SelectTarget
function Duel.SelectTarget(sel_player,f,player,s,o,min,max,ex,...)
	if not Duel.IsExistingTarget(f,player,s,o,1,ex,...) then
		Duel.Hint(HINT_MESSAGE,sel_player,ERROR_NOTARGETS)
	end
	return duel_select_target(sel_player,f,player,s,o,min,max,ex,...)
end
--change the position of a card
--Note: Overwritten to change the position of a banished card
local duel_change_position=Duel.ChangePosition
function Duel.ChangePosition(targets,pos)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local res=0
	for tc in aux.Next(targets) do
		--workaround to change the position of a banished card
		if tc:IsLocation(LOCATION_REMOVED) then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,PLAYER_OWNER,REASON_RULE)
			Duel.Remove(tc,pos,REASON_DAMAGE+REASON_RULE)
		elseif tc:IsLocation(LOCATION_SZONE) then
			if pos==POS_FACEUP_REST then
				--workaround to [Rest] a card in LOCATION_SZONE
				tc:RegisterFlagEffect(EFFECT_REST_MODE,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,DESC_REST)
			elseif pos==POS_FACEUP_STAND then
				--workaround to [Stand] a card in LOCATION_SZONE
				tc:ResetFlagEffect(EFFECT_REST_MODE)
			end
			Duel.HintSelection(Group.FromCards(tc))
		end
		res=res+1
		--Note: Remove the following if YGOPro allows a card to tap itself for EFFECT_ATTACK_COST
		if tc:IsAttacker() then
			tc:RegisterFlagEffect(10000001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE,0,1)
		end
	end
	res=res+duel_change_position(targets,pos)
	return res
end
--move a card to the field
--Note: Overwritten to move a card to LOCATION_SZONE in [Rest]
local duel_move_to_field=Duel.MoveToField
function Duel.MoveToField(c,move_player,target_player,dest,pos,enabled,zone)
	if not zone then
		if dest==LOCATION_MZONE then zone=ZONE_RC_FRONT
		elseif dest==LOCATION_SZONE then zone=ZONE_RC_BACK end
	end
	local npos=(dest==LOCATION_SZONE and POS_FACEUP or pos)
	local res=false
	if duel_move_to_field(c,move_player,target_player,dest,npos,enabled,zone) then res=true end
	--workaround to [Rest] a card in LOCATION_SZONE
	if dest==LOCATION_SZONE and pos==POS_FACEUP_REST then
		c:RegisterFlagEffect(EFFECT_REST_MODE,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,DESC_REST)
	end
	return res
end
--swap two cards on the field
--Note: Overwritten to swap a card in LOCATION_MZONE with a card in LOCATION_SZONE and vice versa
local duel_swap_sequence=Duel.SwapSequence
function Duel.SwapSequence(c1,c2)
	local cp1=c1:GetControler()
	local cp2=c2:GetControler()
	local pos1=(c1:IsPosition(POS_FACEUP_STAND) and POS_FACEUP_STAND) or (c1:IsPosition(POS_FACEUP_REST) and POS_FACEUP_REST)
	local pos2=(c2:IsPosition(POS_FACEUP_STAND) and POS_FACEUP_STAND) or (c2:IsPosition(POS_FACEUP_REST) and POS_FACEUP_REST)
	local seq1=c1:GetSequence()
	local seq2=c2:GetSequence()
	local zone1=bit.lshift(0x1,seq1)
	local zone2=bit.lshift(0x1,seq2)
	local rest1=false
	local rest2=false
	if c1:IsLocation(LOCATION_MZONE) and c1:IsPosition(POS_FACEUP_REST) then rest1=true end
	if c2:IsLocation(LOCATION_MZONE) and c2:IsPosition(POS_FACEUP_REST) then rest2=true end
	--move c2
	Duel.MoveSequence(c1,0)
	if c2:IsLocation(LOCATION_MZONE) then
		Duel.MoveToField(c2,cp1,cp2,LOCATION_SZONE,pos2,true,zone1)
	elseif c2:IsLocation(LOCATION_SZONE) then
		Duel.MoveToField(c2,cp1,cp2,LOCATION_MZONE,pos2,true,zone1)
	end
	--move c1
	Duel.MoveSequence(c2,0)
	if c1:IsLocation(LOCATION_MZONE) then
		Duel.MoveToField(c1,cp1,cp2,LOCATION_SZONE,pos1,true,zone2)
	elseif c1:IsLocation(LOCATION_SZONE) then
		Duel.MoveToField(c1,cp1,cp2,LOCATION_MZONE,pos1,true,zone2)
	end
	return duel_swap_sequence(c1,c2)
end
--New Duel functions
--check if it is the main phase
function Duel.IsMainPhase(player)
	--player: the turn player
	if Duel.GetCurrentPhase()~=PHASE_MAIN1 then return false end
	if player then return Duel.GetTurnPlayer()==player end
	return true
end
--get a player's vanguard
function Duel.GetVanguard(player)
	return Duel.GetFirstMatchingCard(Card.IsSequence,player,LOCATION_MZONE,0,nil,2)
end
--get a player's rear-guard cards
function Duel.GetRearGuard(player)
	local f=function(c)
		return c:IsFaceup() and c:IsRearGuard()
	end
	return Duel.GetMatchingGroup(f,player,LOCATION_ONFIELD,0,nil)
end
--get the number of rear-guards a player has 
function Duel.GetRearGuardCount(player)
	local g=Duel.GetRearGuard(player)
	return g:GetCount()
end
--get the guardians
--Note: returns Card if player~=nil, otherwise returns Group
function Duel.GetGuardian(player)
	local f=function(c)
		return c:IsSequence(5) or c:IsSequence(6)
	end
	if player then
		return Duel.GetFirstMatchingCard(f,player,LOCATION_MZONE,0,nil)
	else
		return Duel.GetMatchingGroup(f,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	end
end
--get the amount of damage a player has
function Duel.GetDamageCount(player)
	return Duel.GetMatchingGroupCount(aux.DamageZoneFilter(),player,LOCATION_REMOVED,0,nil)
end
--ride a card
function Duel.Ride(targets,player)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local res=0
	for tc in aux.Next(targets) do
		--retain soul
		local vc=Duel.GetVanguard(player)
		local g=vc:GetSoul()
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
		Duel.Overlay(tc,vc)
		res=res+Duel.SpecialSummon(tc,0,player,player,false,false,POS_FACEUP_STAND,ZONE_VC)
		--raise event for "When another card rides this unit"
		Duel.RaiseSingleEvent(vc,EVENT_CUSTOM+EVENT_BE_RIDE,Effect.GlobalEffect(),0,0,0,0)
	end
	return res
end
--check if a player has an unoccupied rear-guard circle in the front row
function Duel.CheckFrontCircles(player)
	local f=function(c)
		return c:IsSequence(1) or c:IsSequence(3)
	end
	return Duel.GetMatchingGroupCount(f,player,LOCATION_MZONE,0,nil)<2
end
--check if a player has an unoccupied rear-guard circle in the back row
function Duel.CheckBackCircles(player)
	local f=function(c)
		return c:IsSequenceAbove(1) and c:IsSequenceBelow(3)
	end
	return Duel.GetMatchingGroupCount(f,player,LOCATION_SZONE,0,nil)<3
end
--call a card
function Duel.Call(targets,call_player,pos,dest,zone)
	--targets: the card to call
	--call_player: the player who calls the card
	--pos: POS_FACEUP_STAND to call in [Stand] or POS_FACEUP_REST to call in [Rest]
	--dest: LOCATION_MZONE to call on front rear-guard circle or LOCATION_SZONE to call on back rear-guard circle
	--zone: the circle to call the card on
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	pos=pos or POS_FACEUP_STAND
	dest=dest or LOCATION_ONFIELD
	local res=0
	for tc in aux.Next(targets) do
		--if tc:IsAbleToCall() then
		if dest==LOCATION_ONFIELD then
			--choose to call on front or back rear-guard circle
			local opt=Duel.SelectOption(call_player,OPTION_CALLFRONT,OPTION_CALLBACK)
			dest=(opt==0 and LOCATION_MZONE) or (opt==1 and LOCATION_SZONE)
		end
		--retire card
		local g=Duel.GetMatchingGroup(Card.IsRearGuard,call_player,dest,0,nil)
		if (dest==LOCATION_MZONE and not Duel.CheckFrontCircles(call_player) and zone==nil)
			or (dest==LOCATION_SZONE and not Duel.CheckBackCircles(call_player))
			or (Duel.IsMainPhase() and g:GetCount()>0 and Duel.SelectYesNo(call_player,YESNOMSG_RETIRE)) then
			Duel.Hint(HINT_SELECTMSG,call_player,HINTMSG_RETIRE)
			local sg=g:Select(call_player,1,1,nil)
			Duel.SendtoDrop(sg,REASON_RULE)
		end
		--call card
		if Duel.MoveToField(tc,call_player,call_player,dest,pos,true,zone) then
			res=res+1
		end
		--raise event for "When this unit is placed on (RC)"
		Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+EVENT_PLACED_RC,Effect.GlobalEffect(),0,0,0,0)
	end
	return res
end
--send a card to the trigger zone
function Duel.SendtoTrigger(targets)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local res=0
	for tc in aux.Next(targets) do
		--workaround to banish a banished card
		if tc:IsLocation(LOCATION_REMOVED) then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,PLAYER_OWNER,REASON_RULE)
			Duel.ConfirmCards(1-tc:GetControler(),tc)
		end
		res=res+Duel.Remove(tc,POS_FACEUP,REASON_TRIGGER+REASON_RULE)
		--raise event for trigger unit
		Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+EVENT_TRIGGER_UNIT,Effect.GlobalEffect(),0,0,0,0)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+EVENT_TRIGGER_UNIT,Effect.GlobalEffect(),0,0,0,0)
	end
	return res
end
--send a card to the damage zone
function Duel.SendtoDamage(targets)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local res=0
	for tc in aux.Next(targets) do
		--workaround to banish a banished card
		if tc:IsLocation(LOCATION_REMOVED) then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,PLAYER_OWNER,REASON_RULE)
			Duel.ConfirmCards(1-tc:GetControler(),tc)
		end
		res=res+Duel.Remove(tc,POS_FACEUP,REASON_DAMAGE+REASON_RULE)
	end
	return res
end
--get the cards the attacking card's drive check revealed
function Duel.GetDriveCheckGroup()
	local cp=Duel.GetAttacker():GetControler()
	return Duel.GetMatchingGroup(Card.IsStatus,cp,LOCATION_ALL,0,nil,STATUS_DRIVE_CHECK)
end
--make a card lose an effect
function Duel.LoseEffect(targets,code,reset_flag,desc,reset_count)
	--code: the code of the effect to lose
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	reset_count=reset_count or 1
	for tc in aux.Next(targets) do
		tc:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD+reset_flag,EFFECT_FLAG_CLIENT_HINT,reset_count,code,desc)
	end
end
--Renamed Duel functions
--send a card to the drop zone
Duel.SendtoDrop=Duel.SendtoGrave
