local Fatality = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/Fatality/refs/heads/main/src/source.luau"))();
local Notification = Fatality:CreateNotifier();

Fatality:Loader({
	Name = "FATALITY",
	Duration = 4
});

Notification:Notify({
	Title = "FATALITY",
	Content = "Hello, "..game.Players.LocalPlayer.DisplayName..' Welcome back!',
	Icon = "clipboard"
})

local Window = Fatality.new({
	Name = "FATALITY",
	Expire = "never",
});

local Rage = Window:AddMenu({
	Name = "RAGE",
	Icon = "skull"
})

local Legit = Window:AddMenu({
	Name = "LEGIT",
	Icon = "target"
})

local Visual = Window:AddMenu({
	Name = "VISUAL",
	Icon = "eye"
})

local Misc = Window:AddMenu({
	Name = "MISC",
	Icon = "settings"
})

local Skins = Window:AddMenu({
	Name = "SKINS",
	Icon = "palette"
})

local Lua = Window:AddMenu({
	Name = "LUA",
	Icon = "code"
})

do
	local Weapon = Rage:AddSection({
		Position = 'left',
		Name = "WEAPON"
	});
	
	local Extra = Rage:AddSection({
		Position = 'center',
		Name = "EXTREA"
	});
	
	local General = Rage:AddSection({
		Position = 'right',
		Name = "GENERAL"
	});
	
	Weapon:AddSlider({
		Name = "Hit-chance",
		Default = 61
	})
	
	Weapon:AddSlider({
		Name = "Pointscale",
		Type = "%",
		Default = 0
	})
	
	Weapon:AddSlider({
		Name = "Min-damage",
		Type = "%",
		Default = 85
	})
	
	Weapon:AddDropdown({
		Name = "Hitboxes",
		Values = {"Head",'Neck','Arms','Legs'}
	})
	
	Weapon:AddDropdown({
		Name = "Multipoint",
		Values = {"Head",'Neck','Arms','Legs'}
	})
	
	Weapon:AddDropdown({
		Name = "Target selection",
		Values = {"Damage"},
		Default = "Damage"
	})
	
	local Autostop = Extra:AddToggle({
		Name = "Autostop",
		Option = true;
	});
	
	Autostop.Option:AddToggle({
		Name = "Something"
	})
	
	Autostop.Option:AddToggle({
		Name = "Something"
	})
	
	Autostop.Option:AddToggle({
		Name = "Something"
	})
	
	Autostop.Option:AddToggle({
		Name = "Something"
	})
	
	Extra:AddToggle({
		Name = "Autoscope",
	});
	
	Extra:AddToggle({
		Name = "Ignore limbs on moving",
	});
	
	Extra:AddToggle({
		Name = "Autorevolver",
	});
	
	General:AddToggle({
		Name = "Aimbot",
		Risky = true
	})
	
	General:AddToggle({
		Name = "Slient aim",
		Risky = false
	})
	
	General:AddSlider({
		Name = "Maximum fov",
		Type = " deg",
		Default = 0
	})
	
	General:AddToggle({
		Name = "Autofire",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Delay shot",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Duck peek assist",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Force bodyaim",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Force shoot",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Headshot only",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Knife bot",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Zeus bot",
		Risky = false
	})
	
	local NoSpread = General:AddToggle({
		Name = "Nospread",
		Risky = false,
		Option = true
	})
	
	NoSpread.Option:AddToggle({
		Name = "Something"
	})

	NoSpread.Option:AddToggle({
		Name = "Something"
	})

	NoSpread.Option:AddToggle({
		Name = "Something"
	})

	NoSpread.Option:AddToggle({
		Name = "Something"
	})
	
	local Doubletap = General:AddToggle({
		Name = "Doubletap",
		Risky = true,
		Option = true
	})

	Doubletap.Option:AddToggle({
		Name = "Something"
	})

	Doubletap.Option:AddToggle({
		Name = "Something"
	})

	Doubletap.Option:AddToggle({
		Name = "Something"
	})

	Doubletap.Option:AddToggle({
		Name = "Something"
	})
	
	General:AddButton({
		Name = "Notification",
		Callback = function()
			Notification:Notify({
				Title = "Notification",
				Content = "Testing Notification",
				Duration = math.random(3,7),
				Icon = "info"
			})
		end,
	})
end

do
	local Aim = Legit:AddSection({
		Position = 'left',
		Name = "AIM"
	});
	
	local Rcs = Legit:AddSection({
		Position = 'left',
		Name = "RCS"
	});

	local Trigger = Legit:AddSection({
		Position = 'center',
		Name = "TRIGGER"
	});
	
	local Backtrack = Legit:AddSection({
		Position = 'center',
		Name = "BACKTRACK"
	});

	local General = Legit:AddSection({
		Position = 'right',
		Name = "GENERAL"
	});
	
	Aim:AddToggle({
		Name = "Aim assist"
	})
	
	Aim:AddDropdown({
		Name = "Mode",
		Default = "Adaptive",
		Values = {"Adaptive","value 1",'Value 2'}
	})
	
	Aim:AddDropdown({
		Name = "Hitboxes",
		Multi = true,
		Default = {
			["Head"] = true
		},
		Values = {
			"Head",
			'Neck',
			'Arms',
			'Legs'
		}
	})
	
	Aim:AddSlider({
		Name = "Multipoint"
	})
	
	Aim:AddSlider({
		Name = "Aim fov",
		Round = 1,
		Default = 0.1,
		Type = " deg"
	})
	
	Aim:AddSlider({
		Name = "Aim speed",
		Default = 1,
		Type = "%"
	})
	
	Aim:AddSlider({
		Name = "Min-damage",
		Default = 61,
	})
	

	Aim:AddToggle({
		Name = "Only in scpoe"
	})
	

	Aim:AddToggle({
		Name = "Autostop"
	})
	
	Rcs:AddToggle({
		Name = "Recoil control"
	})
	
	Rcs:AddSlider({
		Name = "Speed",
		Default = 1,
		Type = "%"
	})
	

	Rcs:AddToggle({
		Name = "Re-center"
	})
	

	Rcs:AddSlider({
		Name = "Start bullet",
		Default = 1,
	})
	
	Trigger:AddToggle({
		Name = "Triggerbot"
	})
	
	Trigger:AddSlider({
		Name = "Hit-chance",
		Default = 100,
		Type = "%"
	})
	
	Trigger:AddToggle({
		Name = "Use seed when available"
	})
	
	Trigger:AddSlider({
		Name = "Min-damage",
		Default = 0,
		Type = "%"
	})
	
	Trigger:AddSlider({
		Name = "Reaction time",
		Default = 0,
		Type = "ms"
	})
	
	Trigger:AddToggle({
		Name = "Wait for aim assist hitgroup"
	})
	
	Trigger:AddToggle({
		Name = "Only in Scope"
	})
	
	Backtrack:AddSlider({
		Name = "Backtrack",
		Default = 0,
		Type = "%"
	})
	
	General:AddToggle({
		Name = "Enabled"
	})
	
	General:AddDropdown({
		Name = "Disablers",
		Values = {"d1",'d2'}
	})
	
	General:AddToggle({
		Name = "Visualize fov",
		Option = true
	}).Option:AddColorPicker({
		Name = "Color",
		Default = Color3.fromRGB(255, 34, 75)
	})
	
	General:AddToggle({
		Name = "Autorevolver"
	})
end

do
	local Misc = Visual:AddSection({
		Name = "MISC",
		Position = 'left'
	})
	
	local Model = Visual:AddSection({
		Name = "MODEL",
		Position = 'center'
	})
	
	Misc:AddToggle({
		Name = "Thirdperson",
		Option = true
	}).Option:AddSlider({
		Name = "Distance"
	});
	
	Misc:AddToggle({
		Name = "Overhead override",
		Option = true
	}).Option:AddDropdown({
		Name = "Override"
	});
	
	Misc:AddToggle({
		Name = "Fov override",
		Option = true
	}).Option:AddToggle({
		Name = "Something"
	})
	
	Misc:AddToggle({
		Name = "Viewmodel override",
		Option = true
	}).Option:AddToggle({
		Name = "Something"
	})
	
	Misc:AddDropdown({
		Name = "Remove scope"
	})
	
	local pc = Misc:AddToggle({
		Name = "Penetration crosshair",
		Option = true
	}).Option;
	
	pc:AddColorPicker({
		Name = "Walls",
		Default = Color3.fromRGB(111, 255, 0)
	})
	
	pc:AddColorPicker({
		Name = "Can't walls",
		Default = Color3.fromRGB(255, 0, 4)
	})
	
	Misc:AddToggle({
		Name = "Force crosshair",
		Option = true
	}).Option:AddToggle({
		Name = "Something"
	})
	
	Misc:AddDropdown({
		Name = "Spread"
	})
	
	Misc:AddToggle({
		Name = "Bullet tracer",
		Option = true
	}).Option:AddColorPicker({
		Name = "Color",
		Default = Color3.fromRGB(255, 41, 116)
	})
	
	Model:AddDropdown({
		Name = "Visible",
		Default = "Disabled",
		Values = {"Disabled",'Something'}
	})
	
	Model:AddDropdown({
		Name = "Invisible",
		Default = "Disabled",
		Values = {"Disabled",'Something'}
	})
	
	Model:AddDropdown({
		Name = "Arms",
		Default = "Disabled",
		Values = {"Disabled",'Something'}
	})
	
	Model:AddDropdown({
		Name = "Viewmodel",
		Default = "Disabled",
		Values = {"Disabled",'Something'}
	})
	
	Model:AddDropdown({
		Name = "Attachments",
		Default = "Disabled",
		Values = {"Disabled",'Something'}
	})
	
	Model:AddToggle({
		Name = 'Glow',
		Option = true
		
	}).Option:AddColorPicker({
		Name = "Color"
	})
	
	Model:AddKeybind({
		Name = "Toggle"
	})

end

-- ========== VISUALS / ESP IMPLEMENTATION ==========
-- Добавляет раздел ESP в меню Visual и реализует Drawing-based ESP с fallback на BillboardGui.
do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Camera = workspace.CurrentCamera
	local LocalPlayer = Players.LocalPlayer
	local UserInputService = game:GetService("UserInputService")

	-- internal states (по умолчанию выключены)
	local ESP = {
		Enabled = false,
		Boxes = true,
		Names = true,
		Health = true,
		Distance = false,
		Tracers = false,
		Chams = true,
		TeamCheck = true,
		Color = Color3.fromRGB(255, 0, 0),
		-- chams specific settings
		ChamsSettings = {
			EnemiesEnabled = true,
			TeammatesEnabled = true,
			EnemyColor = Color3.fromRGB(255, 0, 0),
			TeamColor = Color3.fromRGB(0, 200, 255),
			EnemyMaterial = "Neon",
			TeamMaterial = "ForceField",
			FillTransparency = 0.5,
			OutlineColor = Color3.new(0,0,0),
			OverrideMaterial = false, -- change actual part materials
			UseHighlight = true -- create Highlight instances
		}
	}

	-- UI: добавляем секцию ESP и переключатели, которые устанавливают внутренние флаги
	local EspSection = Visual:AddSection({
		Name = "ESP",
		Position = 'right'
	})

	-- Если API AddToggle поддерживает Callback, используем его
	EspSection:AddToggle({ Name = "Enabled", Option = true, Callback = function(v) ESP.Enabled = v end })
	EspSection:AddToggle({ Name = "Boxes", Option = true, Callback = function(v) ESP.Boxes = v end })
	EspSection:AddToggle({ Name = "Names", Option = true, Callback = function(v) ESP.Names = v end })
	EspSection:AddToggle({ Name = "Health", Option = true, Callback = function(v) ESP.Health = v end })
	EspSection:AddToggle({ Name = "Distance", Option = false, Callback = function(v) ESP.Distance = v end })
	EspSection:AddToggle({ Name = "Tracers", Option = false, Callback = function(v) ESP.Tracers = v end })
	EspSection:AddToggle({ Name = "Chams", Option = true, Callback = function(v) ESP.Chams = v end })
	EspSection:AddToggle({ Name = "Team check", Option = true, Callback = function(v) ESP.TeamCheck = v end })
	EspSection:AddColorPicker({ Name = "Global Color", Default = ESP.Color, Callback = function(c) ESP.Color = c end })

	-- Chams sub-section (simple)
	local ChamsSub = EspSection:AddToggle({
		Name = "Chams Options",
		Option = true,
	}) -- Option used as container
	-- inside option we try to add controls; if API doesn't support nested properly, pcall to avoid error
	pcall(function()
		ChamsSub.Option:AddToggle({ Name = "Enemies", Option = true, Callback = function(v) ESP.ChamsSettings.EnemiesEnabled = v end })
		ChamsSub.Option:AddColorPicker({ Name = "Enemy Color", Default = ESP.ChamsSettings.EnemyColor, Callback = function(c) ESP.ChamsSettings.EnemyColor = c end })
		ChamsSub.Option:AddDropdown({ Name = "Enemy Material", Default = ESP.ChamsSettings.EnemyMaterial, Values = {"Neon","ForceField","SmoothPlastic","Glass","Plastic"}, Callback = function(val) ESP.ChamsSettings.EnemyMaterial = val end })
		ChamsSub.Option:AddToggle({ Name = "Teammates", Option = true, Callback = function(v) ESP.ChamsSettings.TeammatesEnabled = v end })
		ChamsSub.Option:AddColorPicker({ Name = "Team Color", Default = ESP.ChamsSettings.TeamColor, Callback = function(c) ESP.ChamsSettings.TeamColor = c end })
		ChamsSub.Option:AddDropdown({ Name = "Team Material", Default = ESP.ChamsSettings.TeamMaterial, Values = {"Neon","ForceField","SmoothPlastic","Glass","Plastic"}, Callback = function(val) ESP.ChamsSettings.TeamMaterial = val end })
		ChamsSub.Option:AddToggle({ Name = "Override part Material", Option = false, Callback = function(v) ESP.ChamsSettings.OverrideMaterial = v end })
		ChamsSub.Option:AddToggle({ Name = "Use Highlight", Option = true, Callback = function(v) ESP.ChamsSettings.UseHighlight = v end })
	end)

	-- Drawing availability check
	local DrawingAvailable = pcall(function() return Drawing.new end)

	-- storage for drawings / highlights / original materials
	local espObjects = {}
	local highlights = {} -- map player -> {highlightFolder = Instance or nil, changedParts = {part -> {Material,Color,Transparency}}}

	local function isAlive(char)
		if not char then return false end
		local h = char:FindFirstChildOfClass("Humanoid")
		return h and h.Health > 0
	end

	local function getRoot(char)
		return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	end

	local function makeDrawingForPlayer(plr)
		local data = {}
		if DrawingAvailable then
			data.box = Drawing.new("Square")
			data.box.Color = ESP.Color
			data.box.Filled = false
			data.box.Thickness = 1.5
			data.name = Drawing.new("Text")
			data.name.Center = true
			data.name.Size = 14
			data.name.Color = ESP.Color
			data.health = Drawing.new("Text")
			data.health.Size = 12
			data.tracer = Drawing.new("Line")
			data.tracer.Color = ESP.Color
			data.tracer.Thickness = 1.5
		else
			-- fallback: BillboardGui
			data.billboard = Instance.new("BillboardGui")
			data.billboard.Name = "FatalityESP"
			data.billboard.Size = UDim2.new(0, 200, 0, 50)
			data.billboard.AlwaysOnTop = true
			local frame = Instance.new("Frame", data.billboard)
			frame.BackgroundTransparency = 1
			frame.Size = UDim2.new(1,0,1,0)
			local label = Instance.new("TextLabel", frame)
			label.Size = UDim2.new(1,0,1,0)
			label.BackgroundTransparency = 1
			label.TextColor3 = ESP.Color
			label.TextStrokeTransparency = 0.6
			label.TextScaled = true
			data.billboardFrame = frame
			data.billboardLabel = label
		end
		return data
	end

	local function removeDrawingForPlayer(plr)
		local d = espObjects[plr]
		if not d then return end
		-- remove Drawing objects or instances
		for k,v in pairs(d) do
			if typeof(v) == "Instance" then
				if v.Parent then v:Destroy() end
			else
				pcall(function() if v.Visible ~= nil then v.Visible = false end end)
				pcall(function() if v.Remove then v:Remove() end end)
			end
		end
		espObjects[plr] = nil
	end

	-- Helpers for material enum mapping
	local MaterialMap = {
		Neon = Enum.Material.Neon,
		ForceField = Enum.Material.ForceField,
		SmoothPlastic = Enum.Material.SmoothPlastic,
		Glass = Enum.Material.Glass,
		Plastic = Enum.Material.Plastic
	}

	-- Apply chams: either by Highlight instances or by changing part.Material (store original)
	local function applyChams(plr)
		local char = plr.Character
		if not char then return end
		-- cleanup previous if exists
		removeChams(plr)

		-- determine relation
		local isTeamMate = (plr.Team == LocalPlayer.Team)
		local cfg = isTeamMate and ESP.ChamsSettings.TeamColor and ESP.ChamsSettings or ESP.ChamsSettings
		-- actually pick proper values
		local enabled = isTeamMate and ESP.ChamsSettings.TeammatesEnabled or ESP.ChamsSettings.EnemiesEnabled
		if not enabled then return end

		local color = isTeamMate and ESP.ChamsSettings.TeamColor or ESP.ChamsSettings.EnemyColor
		local materialName = isTeamMate and ESP.ChamsSettings.TeamMaterial or ESP.ChamsSettings.EnemyMaterial
		local matEnum = MaterialMap[materialName] or Enum.Material.Neon

		local group = Instance.new("Folder")
		group.Name = "FatalityChams"
		group.Parent = char

		local changed = {}

		for _,part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				-- Highlight
				if ESP.ChamsSettings.UseHighlight then
					local h = Instance.new("Highlight")
					h.Name = "FatalityHighlight"
					h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					h.FillColor = color
					h.OutlineColor = ESP.ChamsSettings.OutlineColor or Color3.new(0,0,0)
					h.FillTransparency = ESP.ChamsSettings.FillTransparency or 0.5
					h.Adornee = part
					h.Parent = group
				end

				-- Material override
				if ESP.ChamsSettings.OverrideMaterial then
					-- store original
					changed[part] = {Material = part.Material, Color = part.Color, Transparency = part.Transparency}
					-- apply
					pcall(function()
						part.Material = matEnum
						-- color for Neon works, for others may vary
						part.Color = color
						part.Transparency = math.clamp(ESP.ChamsSettings.FillTransparency or 0, 0, 1)
					end)
				end
			end
		end

		highlights[plr] = {folder = group, changedParts = changed}
	end

	local function removeChams(plr)
		local h = highlights[plr]
		if h then
			-- restore materials
			if h.changedParts then
				for part,orig in pairs(h.changedParts) do
					if part and part.Parent then
						pcall(function()
							part.Material = orig.Material
							part.Color = orig.Color
							part.Transparency = orig.Transparency
						end)
					end
				end
			end
			-- destroy folder (also removes Highlight children)
			if h.folder and h.folder.Parent then
				pcall(function() h.folder:Destroy() end)
			end
			highlights[plr] = nil
		end
	end

	-- Update/create objects when player/character appears
	local function ensureObjects(plr)
		if espObjects[plr] then return espObjects[plr] end
		local o = makeDrawingForPlayer(plr)
		espObjects[plr] = o
		-- if BillboardGui fallback, attach to HumanoidRootPart when available
		if o.billboard then
			local char = plr.Character
			local root = getRoot(char)
			if root then
				pcall(function()
					o.billboard.Adornee = root
					o.billboard.Parent = root
					o.billboardFrame.Size = UDim2.new(1,0,1,0)
					o.billboardLabel.Text = plr.Name
				end)
			end
		end
		return o
	end

	-- Clean on player removing
	Players.PlayerRemoving:Connect(function(plr)
		removeDrawingForPlayer(plr)
		removeChams(plr)
	end)

	-- Main render loop
	RunService.RenderStepped:Connect(function()
		-- update color immediately from settings
		for plr,d in pairs(espObjects) do
			if d.box and d.box.Color then d.box.Color = ESP.Color end
			if d.name and d.name.Color then d.name.Color = ESP.Color end
			if d.tracer and d.tracer.Color then d.tracer.Color = ESP.Color end
		end

		if not ESP.Enabled then
			-- hide drawings but keep allocated objects
			for plr,data in pairs(espObjects) do
				if DrawingAvailable then
					for _,v in pairs(data) do
						pcall(function() v.Visible = false end)
					end
				else
					-- billboard: hide
					if data.billboard and data.billboard.Parent then
						data.billboard.Enabled = false
					end
				end
			end
			-- remove chams if disabled
			for plr,_ in pairs(highlights) do
				-- only remove if chams are off globally
				if not ESP.Chams then removeChams(plr) end
			end
			return
		end

		for _,plr in pairs(Players:GetPlayers()) do
			if plr == LocalPlayer then
				-- skip local player (we don't ESP ourselves here)
			else
				-- team check
				if ESP.TeamCheck and plr.Team == LocalPlayer.Team then
					-- if team check enabled and same team, still allow if configured
					-- if both teams chams disabled, skip entirely
					if not ESP.ChamsSettings.TeammatesEnabled and not ESP.ChamsSettings.EnemiesEnabled then
						removeDrawingForPlayer(plr)
						removeChams(plr)
						goto continue
					end
				end

				local char = plr.Character
				if not isAlive(char) then
					removeDrawingForPlayer(plr)
					removeChams(plr)
					goto continue
				end

				local root = getRoot(char)
				if not root then
					removeDrawingForPlayer(plr)
					removeChams(plr)
					goto continue
				end

				local pos, onScreen2 = Camera:WorldToViewportPoint(root.Position)
				-- onScreen2 indicates inside frustum
				if not onScreen2 then
					-- optionally hide but still manage chams
				end

				local data = ensureObjects(plr)

				-- Basic box calculation: project head and foot
				local head = char:FindFirstChild("Head")
				local headPos = head and Camera:WorldToViewportPoint(head.Position) or pos
				local footPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))

				local height = math.abs(headPos.Y - footPos.Y)
				local width = height / 2

				if DrawingAvailable then
					-- set visibility based on toggles
					data.box.Visible = ESP.Boxes and onScreen2
					data.box.Size = Vector2.new(width, height)
					data.box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
					data.box.Color = ESP.Color

					data.name.Visible = ESP.Names and onScreen2
					data.name.Position = Vector2.new(pos.X, pos.Y - height/2 - 16)
					data.name.Text = plr.Name
					data.name.Color = ESP.Color

					data.health.Visible = ESP.Health and onScreen2
					local humanoid = char:FindFirstChildOfClass("Humanoid")
					if humanoid then
						data.health.Text = string.format("HP: %d", math.floor(humanoid.Health))
					else
						data.health.Text = ""
					end
					data.health.Position = Vector2.new(pos.X, pos.Y + height/2 + 2)

					data.tracer.Visible = ESP.Tracers and onScreen2
					data.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y) -- bottom center
					data.tracer.To = Vector2.new(pos.X, pos.Y)
					data.tracer.Color = ESP.Color
				else
					-- BillboardGui fallback
					if data.billboard then
						data.billboard.Enabled = onScreen2
						if data.billboardLabel then
							local humanoid = char:FindFirstChildOfClass("Humanoid")
							local hp = humanoid and math.floor(humanoid.Health) or 0
							data.billboardLabel.Text = plr.Name .. (ESP.Health and (" | HP:"..hp) or "")
							data.billboardLabel.TextColor3 = ESP.Color
						end
					end
				end

				-- Chams handling: apply/remove based on per-player settings
				if ESP.Chams then
					-- team filtering if TeamCheck true -- still apply if teammate chams enabled
					local teammate = (plr.Team == LocalPlayer.Team)
					if teammate and ESP.ChamsSettings.TeammatesEnabled then
						applyChams(plr)
					elseif (not teammate) and ESP.ChamsSettings.EnemiesEnabled then
						applyChams(plr)
					else
						removeChams(plr)
					end
				else
					removeChams(plr)
				end
			end
			::continue::
		end
	end)
end

-- ========== MISC: Watermark, BHop и другие мелочи ==========
do
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local HttpService = game:GetService("HttpService")

	local miscSection = Misc:AddSection({ Name = "MISC", Position = "right" })

	-- Settings
	local MiscState = {
		Watermark = true,
		BHop = false,
		BHopHold = false, -- if true: hold space to bhop (user preference)
		WatermarkText = "FATALITY",
		WatermarkColor = Color3.fromRGB(255,255,255),
		BHopInterval = 0.001
	}

	-- UI
	miscSection:AddToggle({ Name = "Watermark", Option = true, Callback = function(v) MiscState.Watermark = v end })
	miscSection:AddColorPicker({ Name = "Watermark Color", Default = MiscState.WatermarkColor, Callback = function(c) MiscState.WatermarkColor = c end })
	miscSection:AddToggle({ Name = "Bunny Hop", Option = false, Callback = function(v) MiscState.BHop = v end })
	miscSection:AddToggle({ Name = "BHop Hold Space", Option = false, Callback = function(v) MiscState.BHopHold = v end })

	-- Watermark implementation: Drawing or ScreenGui fallback
	local DrawingAvailable = pcall(function() return Drawing.new end)
	local watermark = {draw = nil, gui = nil}

	if DrawingAvailable then
		pcall(function()
			local txt = Drawing.new("Text")
			txt.Position = Vector2.new(8, 8)
			txt.Size = 18
			txt.Color = MiscState.WatermarkColor
			txt.Font = 2
			txt.Outline = true
			txt.Visible = MiscState.Watermark
			txt.Text = MiscState.WatermarkText.." | "..LocalPlayer.Name
			watermark.draw = txt
		end)
	else
		-- ScreenGui fallback
		local screen = Instance.new("ScreenGui")
		screen.Name = "FatalityWatermark"
		screen.ResetOnSpawn = false
		screen.Parent = LocalPlayer:WaitForChild("PlayerGui")
		local label = Instance.new("TextLabel", screen)
		label.BackgroundTransparency = 1
		label.Position = UDim2.new(0,8,0,8)
		label.Size = UDim2.new(0,200,0,24)
		label.TextColor3 = MiscState.WatermarkColor
		label.Text = MiscState.WatermarkText.." | "..LocalPlayer.Name
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Font = Enum.Font.SourceSansSemibold
		label.TextSize = 16
		label.Visible = MiscState.Watermark
		watermark.gui = {screen = screen, label = label}
	end

	-- update loop
	RunService.RenderStepped:Connect(function(dt)
		-- watermark
		if watermark.draw then
			pcall(function()
				watermark.draw.Visible = MiscState.Watermark
				watermark.draw.Text = MiscState.WatermarkText.." | "..LocalPlayer.Name.." | "..tostring(math.floor(1/dt)).." FPS"
				watermark.draw.Color = MiscState.WatermarkColor
			end)
		elseif watermark.gui then
			pcall(function()
				watermark.gui.label.Visible = MiscState.Watermark
				watermark.gui.label.Text = MiscState.WatermarkText.." | "..LocalPlayer.Name.." | "..tostring(math.floor(1/dt)).." FPS"
				watermark.gui.label.TextColor3 = MiscState.WatermarkColor
			end)
		end
	end)

	-- BHop: simple implementation - will set Humanoid.Jump when on ground and space pressed
	local UserInput = game:GetService("UserInputService")
	local lastJump = 0
	RunService.Heartbeat:Connect(function()
		if not MiscState.BHop then return end
		local char = LocalPlayer.Character
		if not char then return end
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end
		-- check space pressed
		local spaceDown = UserInput:IsKeyDown(Enum.KeyCode.Space)
		if MiscState.BHopHold and not spaceDown then return end
		-- ensure enough time between jumps
		if tick() - lastJump < MiscState.BHopInterval then return end
		-- simple ground check
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local ray = Ray.new(root.Position, Vector3.new(0, -4, 0))
		local hit = workspace:FindPartOnRayWithIgnoreList(ray, {char})
		if hit then
			-- jump
			pcall(function()
				humanoid.Jump = true
				lastJump = tick()
			end)
		end
	end)
end

-- ========== LUA SYSTEM: загрузка скриптов из папки fatalitylua, инжект/анинжект и показ функций ==========
do
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local RunService = game:GetService("RunService")

	local luaSectionLeft = Lua:AddSection({ Name = "SCRIPTS", Position = "left" })
	local luaSectionRight = Lua:AddSection({ Name = "FUNCTIONS", Position = "right" })

	-- Filesystem helpers (executors like Synapse provide isfolder/listfiles/readfile)
	local fs = {
		isfolder = isfolder or false,
		listfiles = listfiles or false,
		isfile = isfile or false,
		readfile = readfile or false
	}

	-- safe wrappers
	local function safe_listfiles(dir)
		local ok, res = pcall(function() return listfiles(dir) end)
		if ok and type(res) == "table" then return res end
		return {}
	end
	local function safe_readfile(path)
		local ok, res = pcall(function() return readfile(path) end)
		if ok and type(res) == "string" then return res end
		return nil
	end
	local function safe_isfolder(dir)
		local ok,res = pcall(function() return isfolder(dir) end)
		return ok and res
	end
	local function safe_isfile(path)
		local ok,res = pcall(function() return isfile(path) end)
		return ok and res
	end

	-- storage for scripts metadata
	local luaScripts = {} -- key = filename, value = {path, injected, ret, addedGlobals = {}, functions = {}}

	-- UI elements (fallbacks if Fatality API doesn't support specific widgets)
	local filesDropdown = nil

	local function refreshFileList()
		-- try to list files in "fatalitylua"
		local files = {}
		-- try listfiles("fatalitylua")
		local listed = safe_listfiles("fatalitylua")
		for _,p in ipairs(listed) do
			-- some executors return full path; take basename
			local name = tostring(p):match("[^/\\]+$")
			if name then
				files[#files+1] = name
				luaScripts[name] = luaScripts[name] or { path = p, injected = false, ret = nil, addedGlobals = {}, functions = {} }
			end
		end
		-- if dropdown API exists, update it
		pcall(function()
			if filesDropdown and filesDropdown.Update then
				filesDropdown:Update(files)
			else
				-- try to create a dropdown
				filesDropdown = luaSectionLeft:AddDropdown({ Name = "Files", Values = files, Default = files[1], Callback = function(v)
					selectedFile = v
					-- display functions for selected
					local meta = luaScripts[v]
					if meta then
						local funcs = {}
						for k,_ in pairs(meta.functions or {}) do table.insert(funcs, k) end
						-- show as notification or update right UI
						Notification:Notify({
							Title = "Lua Functions",
							Content = v .. " -> " .. ( #funcs>0 and table.concat(funcs, ", ") or "no functions" ),
							Duration = 4,
							Icon = "code"
						})
						-- update right-screen GUI
						pcall(function() if functionsLabel then functionsLabel.Text = v.."\n"..( #funcs>0 and table.concat(funcs, "\n") or "no functions") end end)
					end
				end })
			end
		end)
		-- also create simple buttons
		pcall(function()
			luaSectionLeft:AddButton({ Name = "Refresh list", Callback = function()
				refreshFileList()
				Notification:Notify({ Title = "Lua", Content = "List refreshed", Duration = 2, Icon = "refresh" })
			end })
			luaSectionLeft:AddButton({ Name = "Inject selected", Callback = function()
				-- get currently selected from dropdown element if present
				local sel = nil
				pcall(function() sel = filesDropdown and filesDropdown.Value end)
				sel = sel or files[1]
				if not sel then Notification:Notify({ Title = "Lua", Content = "No file selected", Duration = 2 }) return end
				local meta = luaScripts[sel]
				if not meta then Notification:Notify({ Title = "Lua", Content = "File not found in list", Duration = 2 }) return end
				if meta.injected then Notification:Notify({ Title = "Lua", Content = sel.." already injected", Duration = 2 }) return end
				-- read file
				local content = safe_readfile(meta.path)
				if not content then Notification:Notify({ Title = "Lua", Content = "readfile failed: "..tostring(meta.path), Duration = 3 }) return end
				-- snapshot _G
				local before = {}
				for k,_ in pairs(_G) do before[k] = true end
				-- execute
				local ok, ret = pcall(function()
					local f,err = loadstring(content)
					if not f then error(err) end
					-- run in protected environment (but allow globals)
					return f()
				end)
				if not ok then
					Notification:Notify({ Title = "Lua", Content = "Execution error: "..tostring(ret), Duration = 5, Icon = "error" })
					return
				end
				meta.injected = true
				meta.ret = ret
				-- detect added globals
				meta.addedGlobals = {}
				for k,_ in pairs(_G) do
					if not before[k] then meta.addedGlobals[k] = _G[k] end
				end
				-- detect returned table functions
				meta.functions = {}
				if type(ret) == "table" then
					for k,v in pairs(ret) do
						if type(v) == "function" then meta.functions[k] = true end
					end
				end
				Notification:Notify({ Title = "Lua", Content = sel.." injected", Duration = 3, Icon = "rocket" })
			end })
			luaSectionLeft:AddButton({ Name = "Uninject selected", Callback = function()
				local sel = nil
				pcall(function() sel = filesDropdown and filesDropdown.Value end)
				sel = sel or files[1]
				if not sel then Notification:Notify({ Title = "Lua", Content = "No file selected", Duration = 2 }) return end
				local meta = luaScripts[sel]
				if not meta or not meta.injected then Notification:Notify({ Title = "Lua", Content = "Not injected", Duration = 2 }) return end
				-- try call cleanup in returned table
				local cleaned = false
				if type(meta.ret) == "table" then
					for _,name in ipairs({"unload","uninject","cleanup","destroy"}) do
						if type(meta.ret[name]) == "function" then
							pcall(function() meta.ret[name]() end)
							cleaned = true
						end
					end
				end
				-- attempt to remove globals added
				for k,_ in pairs(meta.addedGlobals or {}) do
					pcall(function() _G[k] = nil end)
				end
				meta.injected = false
				meta.ret = nil
				meta.functions = {}
				meta.addedGlobals = {}
				Notification:Notify({ Title = "Lua", Content = sel.." uninjected"..(cleaned and " (cleanup called)" or ""), Duration = 3 })
			end })
		end)
	end

	-- small GUI to show functions on the right (ScreenGui fallback)
	local functionsLabel = nil
	pcall(function()
		local screen = Instance.new("ScreenGui")
		screen.Name = "FatalityLuaFunctions"
		screen.ResetOnSpawn = false
		screen.Parent = LocalPlayer:WaitForChild("PlayerGui")
		local frame = Instance.new("Frame", screen)
		frame.AnchorPoint = Vector2.new(1,0)
		frame.Position = UDim2.new(1, -8, 0, 8)
		frame.Size = UDim2.new(0, 260, 0, 200)
		frame.BackgroundTransparency = 0.5
		frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(1, -8, 1, -8)
		label.Position = UDim2.new(0,4,0,4)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(220,220,220)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.TextWrapped = true
		label.Text = "Lua functions:\n"
		functionsLabel = label
	end)

	-- initial refresh
	refreshFileList()
end

-- Конец файла
