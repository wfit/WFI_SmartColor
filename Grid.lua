local _, SmartColor = ...
if Grid then
	local GridStatusSmartColor = Grid:GetModule("GridStatus"):NewModule("GridStatusSmartColor")

	GridStatusSmartColor.defaultDB = {
		smart_color = {
			text = "SmartColor™",
			enable = true,
			color = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 },
			priority = 90,
		}
	}

	function GridStatusSmartColor:PostInitialize()
		self:RegisterStatus("smart_color", "SmartColor™", nil, true)
	end

	function GridStatusSmartColor:OnStatusEnable(status)
		if status == "smart_color" then
		end
	end

	function GridStatusSmartColor:OnStatusDisable(status)
		if status == "smart_color" then
			self:UnsetAll()
		end
	end

	function GridStatusSmartColor:Set(guid, color)
		self.core:SendStatusGained(guid, "smart_color", self.db.profile.smart_color.priority, nil, color)
	end

	function GridStatusSmartColor:Unset(guid)
		self.core:SendStatusLost(guid, "smart_color")
	end

	function GridStatusSmartColor:UnsetAll()
		self.core:SendStatusLostAllUnits("smart_color")
	end

	function GridStatusSmartColor:Refresh()
	end

	SmartColor:RegisterModule(GridStatusSmartColor)
end
