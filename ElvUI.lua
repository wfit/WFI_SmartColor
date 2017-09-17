local _, SmartColor = ...
if ElvUI then
	local Elv = {}

	local colors = {}

	function Elv:Set(guid, color)
		colors[guid] = color
		self:Refresh()
	end

	function Elv:Unset(guid)
		colors[guid] = nil
		self:Refresh()
	end

	function Elv:UnsetAll()
		wipe(colors)
		self:Refresh()
	end

	local BACKDROP = {
		bgFile = "Interface\\BUTTONS\\WHITE8X8",
		tile = true,
		tileSize = 8,
		edgeFile = "Interface\\BUTTONS\\WHITE8X8",
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	}

	local function refresh(frame)
		local unit = frame.unit
		local color = colors[UnitGUID(unit)]
		local indicator = frame.SmartColorIndicator
		if not indicator then
			if not color then return end
			indicator = CreateFrame("Frame", nil, frame)
			indicator:SetBackdrop(BACKDROP)
			indicator:SetBackdropBorderColor(0, 0, 0, 1)
			indicator:SetWidth(15)
			indicator:SetHeight(15)
			indicator:SetPoint("TOPRIGHT", -3, -3)
			indicator:SetFrameStrata("TOOLTIP")
			frame.SmartColorIndicator = indicator
		end
		if color then
			indicator:SetBackdropColor(color.r, color.g, color.b, color.a or 1)
			indicator:Show()
		else
			indicator:Hide()
		end
	end

	function Elv:Refresh()
		for i = 1, 6 do
			local stop = (i == 1) and 30 or 5
			for j = 1, stop do
				local frame = _G["ElvUF_RaidGroup" .. i .. "UnitButton" .. j]
				if frame and frame.unit and UnitExists(frame.unit) then
					refresh(frame)
				end
			end
		end
	end

	SmartColor:RegisterModule(Elv)
end
