local _, Addon = ...

local SmartColor = LibStub("AceAddon-3.0"):NewAddon(Addon, "WFI_SmartColor", "AceEvent-3.0")
_G.SmartColor = SmartColor

local filters = {}
local stacks = {}
local modules = {}

function SmartColor:OnInitialize()
	self:RegisterMessage("OKEN_MSG_SMARTCOLOR")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "Refresh")
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

function SmartColor:OKEN_MSG_SMARTCOLOR(_, msg)
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

local function removeEntryFromStack(guid, key)
	for idx, entry in ipairs(stacks[guid]) do
		local _, entryKey = unpack(entry)
		if entryKey == key then
			table.remove(stacks[guid], idx)
			return true
		end
	end
	return false
end

function SmartColor:Set(key, guid, color)
	if key ~= nil then
		for filter in pairs(filters) do
			if filter:SmartColorFilter(key) == false then
				return
			end
		end
		stacks[guid] = stacks[guid] or {}
		removeEntryFromStack(guid, key)
		table.insert(stacks[guid], { color, key })
	end
	for _, module in ipairs(modules) do
		module:Set(guid, color)
	end
end

function SmartColor:Unset(key, guid)
	local stack = stacks[guid]
	if stack and key ~= nil then
		removeEntryFromStack(guid, key)
	end
	if stack and #stack > 0 then
		local color = unpack(stack[#stack])
		for _, module in ipairs(modules) do module:Set(guid, color) end
	else
		for _, module in ipairs(modules) do module:Unset(guid) end
		stacks[guid] = nil
	end
end

function SmartColor:UnsetAll(key)
	if key ~= nil then
		local guids = {}
		for guid in pairs(stacks) do
			table.insert(guids, guid)
		end
		for _, guid in ipairs(guids) do
			self:Unset(key, guid)
		end
	else
		for _, module in ipairs(modules) do module:UnsetAll() end
		wipe(stacks)
	end
end

function SmartColor:Refresh()
	for _, module in ipairs(modules) do module:Refresh() end
end
