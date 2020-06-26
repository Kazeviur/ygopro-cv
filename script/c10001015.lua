--Weapons Dealer, Govannon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddClan(c,CLAN_ROYAL_PALADIN)
	aux.AddRace(c,RACE_GNOME)
	--unit
	aux.EnableUnitAttribute(c)
	--boost
	aux.EnableBoost(c)
end
