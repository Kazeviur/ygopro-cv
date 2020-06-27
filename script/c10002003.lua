--Demonic Dragon Berserker, Yaksha
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_KAGERO)
	aux.AddRace(c,RACE_DRAGONMAN)
	--unit
	aux.EnableUnitAttribute(c)
	--skill icon (twin drive)
	aux.EnableEffectCustom(c,EFFECT_TWIN_DRIVE)
	--ride
	local e1=aux.AddAutoEffect(c,0,EVENT_TO_GRAVE,scard.tg1,scard.op1,nil,scard.con1)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
end
--ride
function scard.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_SZONE)
end
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetVanguard(tp)
	return Duel.IsMainPhase(tp) and eg and eg:IsExists(scard.cfilter,1,nil,1-tp)
		and tc:IsFaceup() and tc:IsGrade(2)
end
function scard.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRide(e,0,tp,false,false) end
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Ride(c,tp)
end
