Auxiliary={}
aux=Auxiliary

--
function Auxiliary.Stringid(code,id)
	return code*16+id
end
--
function Auxiliary.Next(g)
	local first=true
	return	function()
				if first then first=false return g:GetFirst()
				else return g:GetNext() end
			end
end
--
function Auxiliary.NULL()
end
--
function Auxiliary.TRUE()
	return true
end
--
function Auxiliary.FALSE()
	return false
end
--
function Auxiliary.AND(...)
	local function_list={...}
	return	function(...)
				local res=false
				for i,f in ipairs(function_list) do
					res=f(...)
					if not res then return res end
				end
				return res
			end
end
--
function Auxiliary.OR(...)
	local function_list={...}
	return	function(...)
				local res=false
				for i,f in ipairs(function_list) do
					res=f(...)
					if res then return res end
				end
				return res
			end
end
--
function Auxiliary.NOT(f)
	return	function(...)
				return not f(...)
			end
end
--
function Auxiliary.BeginPuzzle(effect)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TURN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(Auxiliary.PuzzleOp)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_DP)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,0)
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_SKIP_SP)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,0)
end
function Auxiliary.PuzzleOp(e,tp)
	Duel.SetLP(0,0)
end
--
function Auxiliary.TargetEqualFunction(f,value,...)
	local ext_params={...}
	return	function(effect,target)
				return f(target,table.unpack(ext_params))==value
			end
end
--
function Auxiliary.TargetBoolFunction(f,...)
	local ext_params={...}
	return	function(effect,target)
				return f(target,table.unpack(ext_params))
			end
end
--
function Auxiliary.FilterEqualFunction(f,value,...)
	local ext_params={...}
	return	function(target)
				return f(target,table.unpack(ext_params))==value
			end
end
--
function Auxiliary.FilterBoolFunction(f,...)
	local ext_params={...}
	return	function(target)
				return f(target,table.unpack(ext_params))
			end
end
--get a card script's name and id
function Auxiliary.GetID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local sid=tonumber(string.sub(str,2))
	return scard,sid
end
--add a setcode to a card
--required to register a card's clan and race
function Auxiliary.AddSetcode(c,setname)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetValue(setname)
	c:RegisterEffect(e1)
	local m=_G["c"..c:GetOriginalCode()]
	if not m.overlay_setcode_check then
		m.overlay_setcode_check=true
		--fix for soul cards not getting a setcode
		local e2=Effect.GlobalEffect()
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetTargetRange(LOCATION_SOUL,LOCATION_SOUL)
		e2:SetLabel(c:GetCode())
		e2:SetTarget(function(e,c)
			return c:GetCode()==e:GetLabel()
		end)
		e2:SetValue(setname)
		Duel.RegisterEffect(e2,0)
	end
end
--register a card's clan(s)
--required for Card.IsClan
function Auxiliary.AddClan(c,...)
	if c.clan==nil then
		local mt=getmetatable(c)
		mt.clan={}
		for _,clanname in ipairs{...} do
			table.insert(mt.clan,clanname)
		end
	else
		for _,clanname in ipairs{...} do
			table.insert(c.clan,clanname)
		end
	end
end
--register a card's race(s)
--required for Card.IsRace
function Auxiliary.AddRace(c,...)
	if c.race==nil then
		local mt=getmetatable(c)
		mt.race={}
		for _,racename in ipairs{...} do
			table.insert(mt.race,racename)
		end
	else
		for _,racename in ipairs{...} do
			table.insert(c.race,racename)
		end
	end
end
--register a card's series
--required for Card.IsSeries
function Auxiliary.AddSeries(c,...)
	if c.series==nil then
		local mt=getmetatable(c)
		mt.series={}
		for _,seriesname in ipairs{...} do
			table.insert(mt.series,seriesname)
		end
	else
		for _,seriesname in ipairs{...} do
			table.insert(c.series,seriesname)
		end
	end
end
--combine two or more cost functions
function Auxiliary.MergeCost(...)
	local func_list={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					for _,f in pairs(func_list) do
						if f and not f(e,tp,eg,ep,ev,re,r,rp,0) then return false end
					end
					return true
				end
				for _,f in pairs(func_list) do
					if f then f(e,tp,eg,ep,ev,re,r,rp,1) end
				end
			end
end

--unit
function Auxiliary.EnableUnitAttribute(c)
	--register card info
	Auxiliary.RegisterCardInfo(c)
	--call procedure
	Auxiliary.AddCallProcedure(c)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DESC_MOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(Auxiliary.RCCondition)
	e1:SetTarget(Auxiliary.MoveTarget)
	e1:SetOperation(Auxiliary.MoveOperation)
	c:RegisterEffect(e1)
	--trigger unit
	if c:IsType(TYPE_TRIGGER_UNIT) then
		Auxiliary.EnableTriggerUnit(c)
	end
end
--register card info
function Auxiliary.RegisterCardInfo(c)
	if not ClanList then ClanList={} end
	if not RaceList then RaceList={} end
	if not SeriesList then SeriesList={} end
	local m=_G["c"..c:GetCode()]
	--register clan
	if m and m.clan then
		for _,clanname in ipairs(m.clan) do
			Auxiliary.AddSetcode(c,clanname)
			table.insert(ClanList,clanname)
		end
	end
	--register race
	if m and m.race then
		for _,racename in ipairs(m.race) do
			Auxiliary.AddSetcode(c,racename)
			table.insert(RaceList,racename)
		end
	end
	--register series
	if m and m.series then
		for _,seriesname in ipairs(m.series) do
			Auxiliary.AddSetcode(c,seriesname)
			table.insert(SeriesList,seriesname)
		end
	end
	--display critical
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetOperation(Auxiliary.DisplayCriticalOp)
	c:RegisterEffect(e1)
end
--display critical
function Auxiliary.DisplayCriticalOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=c:GetCriticalCount()
	local code=300+count
	if c:GetFlagEffect(code)==0 then
		c:RegisterFlagEffect(code,0,EFFECT_FLAG_CLIENT_HINT,1,0,code)
	end
	local reset_code=300
	while reset_code>=300 and reset_code<=310 do
		if reset_code~=code then
			c:ResetFlagEffect(reset_code)
		end
		reset_code=reset_code+1
	end
end
--call procedure
function Auxiliary.AddCallProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DESC_CALL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(Auxiliary.CallTarget)
	e1:SetOperation(Auxiliary.CallOperation)
	c:RegisterEffect(e1)
end
function Auxiliary.CallTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetVanguard(tp)
	if chk==0 then return c:IsGradeBelow(tc:GetGrade()) --[[and c:IsAbleToCall()]] end
	Duel.SetChainLimit(aux.FALSE)
end
function Auxiliary.CallOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Call(c,tp)
end
--move
function Auxiliary.MoveFilter(c,g)
	return g:IsContains(c) and not c:IsVanguard()
end
function Auxiliary.MoveTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetColumnGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(Auxiliary.MoveFilter,tp,LOCATION_ONFIELD,0,1,nil,g) end
	Duel.SetChainLimit(aux.FALSE)
end
function Auxiliary.MoveOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOCIRCLE)
	local sg=Duel.SelectMatchingCard(tp,Auxiliary.MoveFilter,tp,LOCATION_ONFIELD,0,1,1,Duel.GetVanguard(tp),g)
	if sg:GetCount()>0 then
		Duel.SwapSequence(c,sg:GetFirst())
	end
end
--trigger unit
function Auxiliary.EnableTriggerUnit(c)
	local e1=Effect.CreateEffect(c)
	if c:IsType(TRIGGER_CRITICAL) then
		e1:SetDescription(DESC_CRITICAL_TRIGGER)
	elseif c:IsType(TRIGGER_HEAL) then
		e1:SetDescription(DESC_HEAL_TRIGGER)
	elseif c:IsType(TRIGGER_DRAW) then
		e1:SetDescription(DESC_DRAW_TRIGGER)
	elseif c:IsType(TRIGGER_STAND) then
		e1:SetDescription(DESC_STAND_TRIGGER)
	end
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CUSTOM+EVENT_TRIGGER_UNIT)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	if c:IsType(TRIGGER_HEAL) then
		e1:SetCondition(aux.AND(Auxiliary.TriggerUnitCondition,Auxiliary.HealTriggerCondition))
	else
		e1:SetCondition(Auxiliary.TriggerUnitCondition)
	end
	e1:SetTarget(Auxiliary.TriggerUnitTarget)
	if c:IsType(TRIGGER_CRITICAL) then
		e1:SetOperation(Auxiliary.CriticalTriggerOperation)
	elseif c:IsType(TRIGGER_HEAL) then
		e1:SetOperation(Auxiliary.HealTriggerOperation)
	elseif c:IsType(TRIGGER_DRAW) then
		e1:SetOperation(Auxiliary.DrawTriggerOperation)
	elseif c:IsType(TRIGGER_STAND) then
		e1:SetOperation(Auxiliary.StandTriggerOperation)
	end
	c:RegisterEffect(e1)
end
function Auxiliary.TriggerUnitFilter(c,clan)
	return c:IsFaceup() and c:IsClan(clan)
end
function Auxiliary.TriggerUnitCondition(e,tp,eg,ep,ev,re,r,rp)
	local clan=e:GetHandler():GetClan()
	return Duel.IsExistingMatchingCard(Auxiliary.TriggerUnitFilter,tp,LOCATION_ONFIELD,0,1,nil,clan)
end
function Auxiliary.TriggerUnitTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_GAINPOWER)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,nil)
end
--"Critical Trigger"
--e.g. "Bringer of Good Luck, Epona" (TD01/013)
function Auxiliary.CriticalTriggerOperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e)) then return end
	--gain power
	Auxiliary.AddTempEffectUpdatePower(e:GetHandler(),tc,5000,RESET_PHASE+PHASE_END)
	--gain critical
	aux.AddTempEffectCustom(e:GetHandler(),tc,EFFECT_UPDATE_CRITICAL,1,RESET_PHASE+PHASE_END)
end
--"Heal Trigger"
--e.g. "Yggdrasil Maiden, Elaine" (TD01/014)
function Auxiliary.HealTriggerCondition(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(Auxiliary.DamageZoneFilter(Card.IsAbleToDrop),tp,LOCATION_REMOVED,0,nil)
	local ct2=Duel.GetMatchingGroupCount(Auxiliary.DamageZoneFilter(Card.IsAbleToDrop),tp,0,LOCATION_REMOVED,nil)
	return ct1>=ct2
end
function Auxiliary.HealTriggerFilter(c,e)
	return c:IsAbleToDrop() and c:IsCanBeEffectTarget(e)
end
function Auxiliary.HealTriggerOperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e)) then return end
	--gain power
	Auxiliary.AddTempEffectUpdatePower(e:GetHandler(),tc,5000,RESET_PHASE+PHASE_END)
	--drop
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DROP)
	local g=Duel.SelectMatchingCard(tp,Auxiliary.DamageZoneFilter(Auxiliary.HealTriggerFilter),tp,LOCATION_REMOVED,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.SetTargetCard(g)
		Duel.SendtoDrop(g,REASON_EFFECT)
	end
end
--"Draw Trigger"
--e.g. "Weapons Dealer, Govannon" (TD01/015)
function Auxiliary.DrawTriggerOperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e)) then return end
	--gain power
	Auxiliary.AddTempEffectUpdatePower(e:GetHandler(),tc,5000,RESET_PHASE+PHASE_END)
	--draw
	Duel.Draw(tp,1,REASON_EFFECT)
end
--"Stand Trigger"
--e.g. "Flogal" (TD01/016)
function Auxiliary.StandTriggerFilter(c,e)
	return c:IsAbleToStand() and c:IsCanBeEffectTarget(e)
end
function Auxiliary.StandTriggerOperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e)) then return end
	--gain power
	Auxiliary.AddTempEffectUpdatePower(e:GetHandler(),tc,5000,RESET_PHASE+PHASE_END)
	--stand
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_STAND)
	local g=Duel.SelectMatchingCard(tp,Auxiliary.StandTriggerFilter,tp,LOCATION_ONFIELD,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.SetTargetCard(g)
		Duel.ChangePosition(g,POS_FACEUP_STAND)
	end
end

--add an effect to a card
--code: EFFECT_TWIN_DRIVE for "Twin Drive!!" (e.g. "Crimson Butterfly, Brigitte" TD01/001)
function Auxiliary.EnableEffectCustom(c,code,con_func,s_range,o_range,targ_func,val)
	--s_range: the location of your card to provide the effect to
	--o_range: the location of your opponent's card to provide the effect to
	local e1=Effect.CreateEffect(c)
	if s_range or o_range then
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetTargetRange(s_range,o_range)
		if targ_func then e1:SetTarget(targ_func) end
	else
		e1:SetType(EFFECT_TYPE_SINGLE)
	end
	e1:SetCode(code)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	if con_func then e1:SetCondition(con_func) end
	if val then e1:SetValue(val) end
	c:RegisterEffect(e1)
	return e1
end
--add a temporary effect to a card
--code: EFFECT_UPDATE_CRITICAL for "[Critical]+N" (e.g. "Solitary Knight, Gancelot" TD01/003)
function Auxiliary.AddTempEffectCustom(c,tc,code,val,reset_flag,reset_count)
	--c: the card that adds the effect
	--tc: the card to add the effect to
	reset_flag=reset_flag or 0
	if tc==c then reset_flag=reset_flag+RESET_DISABLE end
	reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(code)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset_flag,reset_count)
	tc:RegisterEffect(e1)
	return e1
end
--EFFECT_TYPE_SINGLE Automatic [AUTO] effects
--code: EVENT_DRIVE_CHECK for "[AUTO]:When this unit's drive check reveals" (e.g. "Crimson Butterfly, Brigitte" TD01/001)
--code: EVENT_ATTACK_ANNOUNCE for "[AUTO]:When this unit attacks" (e.g. "Knight of Conviction, Bors" TD01/002)
--code: EVENT_PLACED_VC for "[AUTO]:When this unit is placed on (VC)" (e.g. "Blaster Blade" TD01/005)
--code: EVENT_BOOST for "[AUTO]:When this unit boosts a card" (e.g. "Wingal" TD01/009)
--code: EVENT_PLACED_RC for "[AUTO]:When this unit is placed on (RC)" (e.g. "Starlight Unicorn" TD01/010)
--code: EVENT_DAMAGE_STEP_END for "[AUTO]:When this unit's attack hits" (e.g. "Dragonic Overlord" TD02/001)
--code: EVENT_INTERCEPT for "[AUTO]:When this unit intercepts" (e.g. "NGM Prototype" TD03/006)
--code: EVENT_BE_RIDE for "[AUTO]:When another unit rides this unit" (e.g. "Battleraizer" TD03/015)
function Auxiliary.AddSingleAutoEffect(c,desc_id,code,targ_func,op_func,prop,con_func,cost_func)
	targ_func=targ_func or Auxiliary.HintTarget
	prop=prop or 0
	local typ=cost_func and EFFECT_TYPE_TRIGGER_O or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(code)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+prop)
	e1:SetRange(LOCATION_ONFIELD)
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	e1:SetTarget(targ_func)
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	return e1
end
--EFFECT_TYPE_FIELD Automatic [AUTO] effects
--code: EVENT_DAMAGE_STEP_END for "[AUTO]:When an attack hits" (e.g. "Flame of Hope, Aermo" TD02/009)
--code: EVENT_TO_GRAVE for "[AUTO]:When a card is put into the drop zone" (e.g. "Demonic Dragon Madonna, Joka" TD02/010)
--code: EVENT_TO_GRAVE for "[AUTO]:When a rear-guard is retired" (e.g. "Demonic Dragon Mage, Rakshasa" TD02/016)
--code: EVENT_MAIN_PHASE_START for "[AUTO]:At the beginning of your main phase" (e.g. "Mr. Invincible" TD03/003)
--code: EVENT_DRAW for "[AUTO]:When you draw a card" (e.g. "Sword Dancer Angel" TD04/006)
function Auxiliary.AddAutoEffect(c,desc_id,code,targ_func,op_func,prop,con_func,cost_func)
	targ_func=targ_func or Auxiliary.HintTarget
	prop=prop or 0
	local typ=cost_func and EFFECT_TYPE_TRIGGER_O or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(code)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+prop)
	e1:SetRange(LOCATION_ONFIELD)
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	e1:SetTarget(targ_func)
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	return e1
end
--Activated [ACT] effects
--e.g. "Solitary Knight, Gancelot" (TD01/003)
function Auxiliary.AddActivatedEffect(c,desc_id,range,con_func,cost_func,op_func,prop,targ_func)
	targ_func=targ_func or Auxiliary.HintTarget
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_IGNITION)
	if prop then e1:SetProperty(prop) end
	e1:SetRange(range)
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	e1:SetTarget(targ_func)
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	return e1
end
--[CONT]:"This unit gets [Power]+/-N000"
--e.g. "Dragonic Overlord" (TD02/001)
function Auxiliary.AddContinuousUpdatePower(c,range,val,con_func,s_range,o_range,targ_func)
	local e1=Effect.CreateEffect(c)
	if s_range or o_range then
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(s_range,o_range)
		if targ_func then e1:SetTarget(targ_func) end
	else
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	end
	e1:SetCode(EFFECT_UPDATE_POWER)
	e1:SetRange(range)
	if con_func then e1:SetCondition(con_func) end
	e1:SetValue(val)
	c:RegisterEffect(e1)
	return e1
end
--e.g. "Crimson Butterfly, Brigitte" (TD01/001)
function Auxiliary.AddTempEffectUpdatePower(c,tc,val,reset_flag,reset_count)
	reset_flag=reset_flag or 0
	if tc==c then reset_flag=reset_flag+RESET_DISABLE end
	reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_POWER)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset_flag,reset_count)
	tc:RegisterEffect(e1)
	return e1
end
--e.g. "NGM Prototype" (TD03/006)
function Auxiliary.AddTempEffectUpdateShield(c,tc,val,reset_flag,reset_count)
	reset_flag=reset_flag or 0
	if tc==c then reset_flag=reset_flag+RESET_DISABLE end
	reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_SHIELD)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset_flag,reset_count)
	tc:RegisterEffect(e1)
	return e1
end
--"Intercept"
--e.g. "Knight of Silence, Gallatin" (TD01/001)
function Auxiliary.EnableIntercept(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DESC_INTERCEPT)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(Auxiliary.InterceptCondition)
	e1:SetTarget(Auxiliary.InterceptTarget)
	e1:SetOperation(Auxiliary.InterceptOperation)
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,EFFECT_INTERCEPT)
end
function Auxiliary.InterceptCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsHasEffect(EFFECT_INTERCEPT) and c:IsRearGuard() and c:IsFrontRow()
		and Duel.GetAttackTarget()~=c and Duel.GetTurnPlayer()~=tp
end
function Auxiliary.InterceptTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.GetGuardian(tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function Auxiliary.InterceptOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.MoveSequence(c,5)
	Duel.ChangePosition(c,POS_FACEUP_REST)
	--raise event for "When this unit intercepts"
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+EVENT_INTERCEPT,e,0,0,0,0)
end
--"Boost"
--e.g. "Little Sage, Marron" (TD01/008)
function Auxiliary.EnableBoost(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DESC_BOOST)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(Auxiliary.BoostCondition)
	e1:SetCost(Auxiliary.SelfRestCost)
	e1:SetTarget(Auxiliary.HintTarget)
	e1:SetOperation(Auxiliary.BoostOperation)
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,EFFECT_BOOST)
end
function Auxiliary.BoostCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	return c:IsHasEffect(EFFECT_BOOST) and c:IsBackRow()
		and g:IsContains(Duel.GetAttacker()) and eg:GetFirst():GetControler()~=tp
end
function Auxiliary.BoostOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--add power
	Auxiliary.AddTempEffectUpdatePower(c,Duel.GetAttacker(),c:GetPower(),RESET_PHASE+PHASE_DAMAGE)
	--raise event for "When this unit boosts a card"
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+EVENT_BOOST,e,0,0,0,0)
	--add boosting status
	c:SetStatus(STATUS_BOOSTING,true)
	--remove boosting status
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetLabelObject(c)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		e:GetLabelObject():SetStatus(STATUS_BOOSTING,false)
	end)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,0)
end
function Auxiliary.IsBoostingState(e)
	return e:GetHandler():IsStatus(STATUS_BOOSTING)
end
--"Lord"
--e.g. "Solitary Liberator, Gancelot" (TD08/001)
function Auxiliary.EnableLord(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetCondition(Auxiliary.LordCondition)
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,EFFECT_LORD)
end
function Auxiliary.LordFilter(c,clan)
	return not c:IsFaceup() or not c:IsClan(clan)
end
function Auxiliary.LordCondition(e)
	local c=e:GetHandler()
	return c:IsHasEffect(EFFECT_LORD)
		and Duel.IsExistingMatchingCard(Auxiliary.LordFilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,c:GetClan())
end

--condition to check who the turn player is
function Auxiliary.TurnPlayerCondition(p)
	return	function(e)
				local tp=e:GetHandlerPlayer()
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				return Duel.GetTurnPlayer()==player
			end
end
--condition to check who the event player is
function Auxiliary.EventPlayerCondition(p)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				return ep==player
			end
end
--condition for "(VC)"
--e.g. "Crimson Butterfly, Brigitte" (TD01/001)
function Auxiliary.VCCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsVanguard()
end
--condition for "(RC)"
--e.g. "Demonic Dragon Madonna, Joka" (TD02/010)
function Auxiliary.RCCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRearGuard()
end
--condition for "When this unit's drive check reveals"
--e.g. "Crimson Butterfly, Brigitte" (TD01/001)
function Auxiliary.DriveCheckCondition(f,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return Duel.GetDriveCheckGroup():IsExists(f,1,nil,table.unpack(ext_params))
			end
end
--condition to check your vanguard
--e.g. "Blaster Blade" (TD01/005)
function Auxiliary.SelfVanguardCondition(f,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local tc=Duel.GetVanguard(e:GetHandlerPlayer())
				return tc and tc:IsFaceup() and (not f or f(tc,table.unpack(ext_params)))
			end
end
--condition to check the attacking card
--e.g. "Wingal" (TD01/009)
function Auxiliary.AttackerCondition(f,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local a=Duel.GetAttacker()
				return a and (not f or f(a,table.unpack(ext_params)))
			end
end
--condition to check the attacked card
--e.g. "Great Silver Wolf, Garmore" (TD05/001)
function Auxiliary.AttackTargetCondition(f,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local d=Duel.GetAttackTarget()
				return d and (not f or f(d,table.unpack(ext_params)))
			end
end
--condition for "When this unit's attack hits" + EVENT_DAMAGE_STEP_END
--e.g. "Dragonic Overlord" (TD02/001)
function Auxiliary.SelfAttackHitCondition(f,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local a=Duel.GetAttacker()
				local d=Duel.GetAttackTarget()
				if not e:GetHandler():IsAttacker() then return false end
				return a and d and a:GetPower()>=d:GetPower() and (not f or f(d,table.unpack(ext_params)))
			end
end
--condition for "When an attack hits" + EVENT_DAMAGE_STEP_END
--e.g. "Flame of Hope, Aermo" (TD02/009)
function Auxiliary.AttackHitCondition(f,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local a=Duel.GetAttacker()
				local d=Duel.GetAttackTarget()
				return a and d and a:GetPower()>=d:GetPower() and (not f or f(d,table.unpack(ext_params)))
			end
end
--condition for "Limit Break N (This ability is active if you have N or more damage)"
--e.g. "Great Silver Wolf, Garmore" (TD05/001)
function Auxiliary.LimitBreakCondition(ct)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return Duel.GetDamageCount(tp)>=ct
			end
end
--cost for "[Counter Blast (N)]"
--e.g. "Knight of Conviction, Bors" (TD01/002)
function Auxiliary.CounterBlastCost(ct)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local f=Auxiliary.DamageZoneFilter(Card.IsFaceup)
				if chk==0 then return Duel.IsExistingMatchingCard(f,tp,LOCATION_REMOVED,0,ct,nil) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FLIPOVER)
				local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_REMOVED,0,ct,ct,nil)
				Duel.ChangePosition(g,POS_FACEDOWN)
			end
end
--cost for "[Reveal this card to your opponent, and put it on top of your deck]"
--e.g. "Solitary Knight, Gancelot" (TD01/003)
function Auxiliary.SelfToDeckCost(seq)
	--seq: where to send the card (SEQ_DECK)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then return c:IsAbleToDeckAsCost() end
				if c:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,c) end
				Duel.SendtoDeck(c,PLAYER_OWNER,seq,REASON_COST)
			end
end
--cost for "[[Rest] this unit]"
--e.g. "Boost", "Dragon Monk, Gojo" (TD02/008)
function Auxiliary.SelfRestCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRest() end
	Duel.ChangePosition(c,POS_FACEUP_REST)
end
--cost for "[Choose a card from your hand, and discard it]"
--e.g. "Knight of Rose, Morgana" (TD01/011)
function Auxiliary.DiscardCost(min,max,f,...)
	--min,max: the number of cards to discard (nil to discard all cards)
	--f: filter function if the card is specified
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local minc=min or 1
				local maxc=max or minc
				local filt_func=function(c,f,ext_params)
					return c:IsDiscardable() and (not f or f(c,table.unpack(ext_params)))
				end
				local c=e:GetHandler()
				if chk==0 then
					if e:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
						return Duel.IsExistingTarget(filt_func,tp,LOCATION_HAND,0,minc,c,f,ext_params)
					else
						return Duel.IsExistingMatchingCard(filt_func,tp,LOCATION_HAND,0,minc,c,f,ext_params)
					end
				end
				if min then
					if e:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
						local g=Duel.SelectTarget(tp,filt_func,tp,LOCATION_HAND,0,minc,maxc,c,f,ext_params)
						Duel.SendtoDrop(g,REASON_COST+REASON_DISCARD)
					else
						Duel.DiscardHand(tp,filt_func,minc,maxc,REASON_COST+REASON_DISCARD,c,f,ext_params)
					end
				else
					local g=Duel.GetMatchingGroup(filt_func,tp,LOCATION_HAND,0,c,f,ext_params)
					Duel.SendtoDrop(g,REASON_COST+REASON_DISCARD)
				end
			end
end
--cost for "[Soul Charge (N)]"
--e.g. "Mr. Invincible" (TD03/003)
function Auxiliary.SoulChargeCost(ct)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local g=Duel.GetDecktopGroup(tp,ct)
				if chk==0 then return g:GetCount()>0 end
				Duel.Overlay(e:GetHandler(),g)
			end
end
--cost for "[Soul Blast (N)]"
--e.g. "Mr. Invincible" (TD03/003)
function Auxiliary.SoulBlastCost(ct)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local g=Duel.GetVanguard(tp):GetSoul()
				if chk==0 then return g:IsExists(Card.IsAbleToDrop,ct,nil) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DROP)
				local sg=g:Select(tp,ct,ct,nil)
				Duel.SendtoDrop(sg,REASON_COST)
			end
end
--target for Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
function Auxiliary.HintTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if e:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		if chkc then return false end
	end
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
--target for effects that target cards
--e.g. "Starlight Unicorn" (TD01/010)
function Auxiliary.TargetCardFunction(p,f,s,o,min,max,desc,ex,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				max=max or min
				local c=e:GetHandler()
				local exg=Group.CreateGroup()
				if type(ex)=="Card" then exg:AddCard(ex)
				elseif type(ex)=="Group" then exg:Merge(ex)
				elseif type(ex)=="function" then
					exg=ex(e,tp,eg,ep,ev,re,r,rp)
				end
				if chkc then
					if min>1 then return false end
					if not chkc:IsLocation(s+o) then return false end
					if s==0 and o>0 and chkc:IsControler(tp) then return false end
					if o==0 and s>0 and chkc:IsControler(1-tp) then return false end
					if f and not f(chkc,e,tp,eg,ep,ev,re,r,rp) then return false end
					if exg:GetCount()>0 and exg:IsContains(chkc) then return false end
					return true
				end
				if chk==0 then return true end
				Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
				Duel.Hint(HINT_SELECTMSG,player,desc)
				Duel.SelectTarget(player,f,tp,s,o,min,max,exg,e,tp,eg,ep,ev,re,r,rp,table.unpack(ext_params))
			end
end
--operation for effects that target cards
--f: Duel.SendtoDrop to retire cards (e.g. "Blaster Blade" TD01/005)
--f: Duel.ChangePosition to change positions (e.g. "Gold Rutile" TD03/001)
function Auxiliary.TargetCardsOperation(f,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
				if g:GetCount()>0 then
					f(g,table.unpack(ext_params))
				end
			end
end
--operation for effects that target cards to increase/decrease their power
--e.g. "Starlight Unicorn" (TD01/010)
function Auxiliary.TargetUpdatePowerOperation(val,reset_flag,reset_count)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
				if g:GetCount()==0 then return end
				for tc in aux.Next(g) do
					Auxiliary.AddTempEffectUpdatePower(e:GetHandler(),tc,val,reset_flag,reset_count)
				end
			end
end
--operation for effects that let a player (PLAYER_SELF or PLAYER_OPPO) do something
--f: Duel.Draw to let a player draw cards (e.g. "Dragon Monk, Gojo" TD02/008)
function Auxiliary.DuelOperation(f,p,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				f(player,table.unpack(ext_params))
			end
end
--filter for a card in the trigger zone
function Auxiliary.TriggerZoneFilter(f)
	return	function(target,...)
				return target:IsLocation(LOCATION_REMOVED) and target:IsReason(REASON_TRIGGER)
					and (not f or f(target,...))
			end
end
--filter for a card in the damage zone
function Auxiliary.DamageZoneFilter(f)
	return	function(target,...)
				return target:IsLocation(LOCATION_REMOVED) and target:IsReason(REASON_DAMAGE)
					and (not f or f(target,...))
			end
end
--
function loadutility(file)
	local f=loadfile("expansions/script/"..file)
	if f==nil then
		dofile("script/"..file)
	else
		f()
	end
end
loadutility("bit.lua")
loadutility("card.lua")
loadutility("duel.lua")
loadutility("group.lua")
loadutility("lua.lua")
loadutility("rule.lua")
--[[
	References

	Abilities
	* Some automatic abilities have the text ???AUTO???zone???:When (event), if (requirement)???.  These abilities will trigger if
	the event happens, even if the requirement is not met.
]]
