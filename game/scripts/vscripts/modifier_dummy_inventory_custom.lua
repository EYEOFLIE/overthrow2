modifier_dummy_inventory_custom = class({})

function modifier_dummy_inventory_custom:OnCreated()
	if not IsServer() then return end
	self:ApplyVerticalMotionController()
	self.newPoint = self:GetParent():GetAbsOrigin()+Vector(0,0,-5000)
end

function modifier_dummy_inventory_custom:IsHidden()
	return false
end

function modifier_dummy_inventory_custom:CheckState()
	local state = {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
	}
	return state
end

function modifier_dummy_inventory_custom:GetModifierInvisibilityLevel()
	return 4
end

function modifier_dummy_inventory_custom:UpdateVerticalMotion(me, dt)
	if not IsServer() then return end
	me:SetAbsOrigin(self.newPoint)
end
