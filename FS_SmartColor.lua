local _, Addon = ...

local SmartColor = LibStub("AceAddon-3.0"):NewAddon(Addon, "FS_SmartColor", "AceEvent-3.0")
_G.SmartColor = SmartColor

local filters = {}
local currentKeys = {}
local modules = {}

function SmartColor:OnInitialize()
	self:RegisterMessage("FS_MSG_SMARTCOLOR")
end

function SmartColor:RegisterFilter(filter)
	filters[filter] = true
end

function SmartColor:UnregisterFilter(filter)
	filters[filter] = nil
end

function SmartColor:RegisterModule(module)
	modules[#modules + 1] = module
end

function SmartColor:FS_MSG_SMARTCOLOR(_, msg)
	local action = msg.action
	local key = msg.key
	if action == "set" then
		self:Set(key, msg.guid, msg.color)
	elseif action == "unset" then
		self:Unset(key, msg.guid)
	elseif action == "unsetall" then
		self:UnsetAll(key)
	end
end

function SmartColor:Set(key, guid, color)
	if key ~= nil then
		for filter in pairs(filters) do
			if filter:SmartColorFilter(key) == false then
				return
			end
		end
	end
	currentKeys[guid] = key
	for _, module in ipairs(modules) do
		module:Set(guid, color)
	end
end

function SmartColor:Unset(key, guid)
	if currentKeys[guid] == nil or currentKeys[guid] == key then
		currentKeys[guid] = nil
		for _, module in ipairs(modules) do module:Unset(guid) end
	end
end

function SmartColor:UnsetAll(key)
	if key ~= nil then
		local removed = {}
		for guid, k in pairs(currentKeys) do
			if k == key then
				for _, module in ipairs(modules) do module:Unset(guid) end
				removed[#removed + 1] = guid
			end
		end
		for _, guid in ipairs(removed) do
			currentKeys[guid] = nil
		end
	else
		for _, module in ipairs(modules) do module:UnsetAll() end
		wipe(currentKeys)
	end
end
