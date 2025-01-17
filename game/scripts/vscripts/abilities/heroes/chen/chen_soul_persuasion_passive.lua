chen_soul_persuasion_passive = class({})
----------------------------------------------------
function chen_soul_persuasion_passive:OnCreated()
	local ability = self:GetAbility()
	ability:DataInit()
	if not IsServer() then return end
	self.souls_limit = ability:GetSpecialValueFor("souls_limit")
	self.souls_per_kill = ability:GetSpecialValueFor("souls_per_kill")
	self.souls_per_second = ability:GetSpecialValueFor("souls_per_second")
	self.hasTalent = false
	self:CheckIntervalTime()
end
----------------------------------------------------
function chen_soul_persuasion_passive:CheckIntervalTime()
	self.souls_tick_rate = self:GetAbility():GetSpecialValueFor("souls_tick_rate")
	local talentForTickRate = self:GetParent():FindAbilityByName("special_chen_soul_persuasion_tickrate")
	if talentForTickRate and talentForTickRate:GetLevel() > 0 then
		self.hasTalent = true
		self.souls_tick_rate = self.souls_tick_rate + talentForTickRate:GetSpecialValueFor("value")
	end
	self:StartIntervalThink(self.souls_tick_rate)
end
----------------------------------------------------
function chen_soul_persuasion_passive:OnRefresh(params)
    self:OnCreated(params)
end
----------------------------------------------------
function chen_soul_persuasion_passive:IncreaseSoulsStacks(stacksIncrement)
	local currentStacks = self:GetStackCount()
	if currentStacks >= self.souls_limit then return end
	local newStackCount = currentStacks + stacksIncrement
	self:SetStackCount(self.souls_limit < newStackCount and self.souls_limit or newStackCount)
end
----------------------------------------------------
function chen_soul_persuasion_passive:OnIntervalThink()
	if not IsServer() then return end
	self:IncreaseSoulsStacks(self.souls_per_second)
	if not self.hasTalent then
		self:CheckIntervalTime()
	end
end
----------------------------------------------------
function chen_soul_persuasion_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_HERO_KILLED,
	}
	return funcs
end
----------------------------------------------------
function chen_soul_persuasion_passive:OnHeroKilled(params)
	if not IsServer() then return end
	local parent = self:GetParent()
	local killerID = params.attacker:GetPlayerOwnerID()
	
	if killerID and killerID == parent:GetPlayerOwnerID() then
		self:IncreaseSoulsStacks(self.souls_per_kill)
	end
end
----------------------------------------------------
