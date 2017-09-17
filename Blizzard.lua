local _, SmartColor = ...
if not Grid then
	local Blizz = {}

	local colors = {}

	function Blizz:Set(guid, color)
		colors[guid] = color
		self:Refresh()
	end

	function Blizz:Unset(guid)
		colors[guid] = nil
		self:Refresh()
	end

	function Blizz:UnsetAll()
		wipe(colors)
		self:Refresh()
	end

	local BACKDROP = {
		bgFile = "Interface\\BUTTONS\\WHITE8X8", tile = true, tileSize = 8,
		edgeFile = "Interface\\BUTTONS\\WHITE8X8", edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	}

	local function refresh(frame)
		local unit = frame.unit
		if UnitExists(unit) then
			local color = colors[UnitGUID(unit)]
			local indicator = frame.SmartColorIndicator
			if not indicator then
				if not color then return end
				indicator = CreateFrame("Frame", nil, frame)
				indicator:SetBackdrop(BACKDROP)
				indicator:SetBackdropBorderColor(0, 0, 0, 1)
				indicator:SetWidth(15)
				indicator:SetHeight(15)
				indicator:SetPoint("TOPRIGHT", -5, -5)
				frame.SmartColorIndicator = indicator
			end
			if color then
				indicator:SetBackdropColor(color.r, color.g, color.b, color.a or 1)
				indicator:Show()
			else
				indicator:Hide()
			end
		end
	end

	function Blizz:Refresh()
		CompactRaidFrameContainer_ApplyToFrames(CompactRaidFrameContainer, "normal", refresh)
	end

	SmartColor:RegisterModule(Blizz)
end
