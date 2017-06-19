local GridStatusSmartColor = Grid:GetModule("GridStatus"):NewModule("GridStatusSmartColor")
GSSC = GridStatusSmartColor

GridStatusSmartColor.defaultDB = {
	smart_color = {
		text = "SmartColor™",
		enable = true,
		color = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 },
		priority = 90,
	}
}

local filters = {}
local currentKeys = {}

function GridStatusSmartColor:PostInitialize()
	self:RegisterStatus("smart_color", "SmartColor™", nil, true)
end

function GridStatusSmartColor:OnStatusEnable(status)
	if status == "smart_color" then
		self:RegisterMessage("FS_MSG_GSSC")
	end
end

function GridStatusSmartColor:OnStatusDisable(status)
	if status == "smart_color" then
		self:UnregisterMessaget("FS_MSG_GSSC")
		self:UnsetAll()
	end
end

function GridStatusSmartColor:RegisterFilter(filter)
	filters[filter] = true
end

function GridStatusSmartColor:UnregisterFilter(filter)
	filters[filter] = nil
end

function GridStatusSmartColor:FS_MSG_GSSC(_, msg)
	local action = msg.action
	local key = msg.key
	if action == "set" then
		if key ~= nil then
			for filter in pairs(filters) do
				if filter:SmartColorFilter(key) == false then
					return
				end
			end
		end
		self:Set(key, msg.guid, msg.color)
	elseif action == "unset" then
		self:Unset(key, msg.guid)
	elseif action == "unsetall" then
		self:UnsetAll(key)
	end
end

function GridStatusSmartColor:Set(key, guid, color)
	currentKeys[guid] = key
	self.core:SendStatusGained(guid, "smart_color", self.db.profile.smart_color.priority, nil, color)
end

function GridStatusSmartColor:Unset(key, guid)
	if currentKeys[guid] == nil or currentKeys[guid] == key then
		currentKeys[guid] = nil
		self.core:SendStatusLost(guid, "smart_color")
	end
end

function GridStatusSmartColor:UnsetAll(key)
	if key ~= nil then
		local removed = {}
		for guid, k in pairs(currentKeys) do
			if k == key then
				self.core:SendStatusLost(guid, "smart_color")
				removed[#removed + 1] = guid
			end
		end
		for _, guid in ipairs(removed) do
			currentKeys[guid] = nil
		end
	else
		self.core:SendStatusLostAllUnits("smart_color")
		wipe(currentKeys)
	end
end
