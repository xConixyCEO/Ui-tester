-- =============================================
-- GALAXY UI v2.1 - Library Only
-- Modernized Singularity Engine with Galaxy Theme
-- =============================================

local GalaxyUI = (function()
	local GalaxyUI = {}
	GalaxyUI.__index = GalaxyUI
	
	-- Galaxy Theme (Purple/Blue nebula)
	GalaxyUI.Themes = {
		Galaxy = {
			Primary = Color3.fromRGB(147, 112, 219),    -- Purple
			Secondary = Color3.fromRGB(79, 195, 247),   -- Light Blue
			Accent = Color3.fromRGB(171, 71, 188),      -- Pinkish Purple
			Background = Color3.fromRGB(15, 12, 41),    -- Deep space blue
			Surface = Color3.fromRGB(25, 22, 46),       -- Darker surface
			Surface2 = Color3.fromRGB(35, 32, 56),      -- Section background
			Text = Color3.fromRGB(255, 255, 255),       -- White text
			TextSecondary = Color3.fromRGB(200, 200, 250), -- Light purple text
			Success = Color3.fromRGB(102, 187, 106),
			Warning = Color3.fromRGB(255, 152, 0),
			Error = Color3.fromRGB(244, 67, 54),
			GradientStart = Color3.fromRGB(102, 126, 234), -- Blue gradient
			GradientEnd = Color3.fromRGB(118, 75, 162),    -- Purple gradient
		}
	}
	
	local function CreateCorner(radius)
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, radius)
		return corner
	end
	
	local function CreateStroke(color, thickness)
		local stroke = Instance.new("UIStroke")
		stroke.Color = color
		stroke.Thickness = thickness
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Transparency = 0.5
		return stroke
	end
	
	local function CreateGradient(parent, color1, color2)
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, color1),
			ColorSequenceKeypoint.new(1, color2)
		})
		gradient.Rotation = 45
		gradient.Parent = parent
		return gradient
	end
	
	local function Tween(obj, goal, duration, callback)
		local tween = game:GetService("TweenService"):Create(obj, TweenInfo.new(
			duration or 0.3,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		), goal)
		tween:Play()
		if callback then tween.Completed:Connect(callback) end
		return tween
	end
	
	function GalaxyUI.new(options)
		local self = setmetatable({}, GalaxyUI)
		options = options or {}
		self.Theme = options.Theme or GalaxyUI.Themes.Galaxy
		self.ToggleKey = options.toggle_key or Enum.KeyCode.RightShift
		self.MinSize = options.min_size or Vector2.new(400, 300)
		self.CanResize = options.can_resize ~= false
		
		self.ScreenGui = Instance.new("ScreenGui")
		self.ScreenGui.Name = "GalaxyUI"
		self.ScreenGui.ResetOnSpawn = false
		self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		self.ScreenGui.Parent = game:GetService("CoreGui")
		
		self.Windows = Instance.new("Frame")
		self.Windows.Name = "Windows"
		self.Windows.BackgroundTransparency = 1
		self.Windows.Size = UDim2.new(1, 0, 1, 0)
		self.Windows.Parent = self.ScreenGui
		
		game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and input.KeyCode == self.ToggleKey then
				self.ScreenGui.Enabled = not self.ScreenGui.Enabled
			end
		end)
		
		return self
	end
	
	function GalaxyUI:AddWindow(title, options)
		options = options or {}
		local window = Instance.new("ImageLabel")
		window.Name = "Window"
		window.Active = true
		window.BackgroundTransparency = 1
		window.ClipsDescendants = true
		window.Selectable = true
		window.Size = UDim2.new(0, self.MinSize.X, 0, self.MinSize.Y)
		window.Image = "rbxassetid://2851926732"
		window.ImageColor3 = self.Theme.Background
		window.ScaleType = Enum.ScaleType.Slice
		window.SliceCenter = Rect.new(12, 12, 12, 12)
		window.Parent = self.Windows
		
		window:Add(CreateCorner(12))
		
		-- Galaxy gradient overlay
		local gradientOverlay = Instance.new("Frame")
		gradientOverlay.BackgroundTransparency = 0.92
		gradientOverlay.Size = UDim2.new(1, 0, 1, 0)
		gradientOverlay.Parent = window
		CreateGradient(gradientOverlay, self.Theme.GradientStart, self.Theme.GradientEnd)
		gradientOverlay:Add(CreateCorner(12))
		
		local shadow = Instance.new("ImageLabel")
		shadow.Name = "Shadow"
		shadow.Size = UDim2.new(1, 25, 1, 25)
		shadow.Position = UDim2.new(0, -12, 0, -12)
		shadow.BackgroundTransparency = 1
		shadow.Image = "rbxassetid://1316045217"
		shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		shadow.ImageTransparency = 0.8
		shadow.ZIndex = -1
		shadow.Parent = window
		
		-- Title Bar with gradient
		local bar = Instance.new("Frame")
		bar.Name = "Bar"
		bar.BorderSizePixel = 0
		bar.Position = UDim2.new(0, 0, 0, 0)
		bar.Size = UDim2.new(1, 0, 0, 45)
		bar.Parent = window
		CreateGradient(bar, self.Theme.GradientStart, self.Theme.GradientEnd)
		bar:Add(CreateCorner(12, 12, 0, 0))
		
		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "Title"
		titleLabel.BackgroundTransparency = 1
		titleLabel.Position = UDim2.new(0, 15, 0, 10)
		titleLabel.Size = UDim2.new(1, -60, 0, 25)
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.Text = tostring(title or "Galaxy Hub")
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.TextSize = 18
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.Parent = bar
		
		-- Toggle button
		local toggle = Instance.new("ImageButton")
		toggle.Name = "Toggle"
		toggle.BackgroundTransparency = 1
		toggle.Position = UDim2.new(0, 10, 0, 12)
		toggle.Size = UDim2.new(0, 20, 0, 20)
		toggle.Image = "rbxassetid://4731371541"
		toggle.ImageColor3 = Color3.fromRGB(255, 255, 255)
		toggle.Rotation = 90
		toggle.Parent = bar
		
		-- Resizer
		local resizer = Instance.new("Frame")
		resizer.Name = "Resizer"
		resizer.Active = true
		resizer.BackgroundTransparency = 1
		resizer.Position = UDim2.new(1, -20, 1, -20)
		resizer.Size = UDim2.new(0, 20, 0, 20)
		resizer.Parent = window
		
		-- Tab Selection (improved)
		local tabSelection = Instance.new("Frame")
		tabSelection.Name = "TabSelection"
		tabSelection.BackgroundTransparency = 1
		tabSelection.Position = UDim2.new(0, 15, 0, 55)
		tabSelection.Size = UDim2.new(1, -30, 0, 35)
		tabSelection.Visible = false
		tabSelection.Parent = window
		
		local tabButtons = Instance.new("Frame")
		tabButtons.BackgroundTransparency = 1
		tabButtons.Size = UDim2.new(1, 0, 1, 0)
		tabButtons.Parent = tabSelection
		
		local tabListLayout = Instance.new("UIListLayout")
		tabListLayout.FillDirection = Enum.FillDirection.Horizontal
		tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		tabListLayout.Padding = UDim.new(0, 8)
		tabListLayout.Parent = tabButtons
		
		-- Tabs Container
		local tabs = Instance.new("Frame")
		tabs.Name = "Tabs"
		tabs.BackgroundTransparency = 1
		tabs.Position = UDim2.new(0, 15, 0, 100)
		tabs.Size = UDim2.new(1, -30, 1, -115)
		tabs.Parent = window
		
		-- State
		local isOpen = true
		local windowData = {Window = window, Tabs = {}, CurrentTab = nil}
		
		-- Toggle functionality
		toggle.MouseButton1Click:Connect(function()
			tabs.Visible = not isOpen
			tabSelection.Visible = not isOpen and #windowData.Tabs > 0
			Tween(toggle, {Rotation = isOpen and 0 or 90}, 0.3)
			Tween(window, {Size = UDim2.new(0, window.AbsoluteSize.X, 0, isOpen and 45 or self.MinSize.Y)}, 0.3)
			isOpen = not isOpen
		end)
		
		-- Dragging
		local dragging, dragStart, startPos = false, Vector2.new(0, 0), UDim2.new(0, 0, 0, 0)
		bar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging, dragStart, startPos = true, Vector2.new(input.Position.X, input.Position.Y), window.Position
			end
		end)
		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
				window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
		game:GetService("UserInputService").InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
		end)
		
		-- Resizing
		local resizing, resizeStart, startSize = false, Vector2.new(0, 0), Vector2.new(0, 0)
		resizer.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and self.CanResize then
				resizing, resizeStart, startSize = true, Vector2.new(input.Position.X, input.Position.Y), window.AbsoluteSize
			end
		end)
		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = Vector2.new(input.Position.X, input.Position.Y) - resizeStart
				local newSize = startSize + delta
				window.Size = UDim2.new(0, math.max(newSize.X, self.MinSize.X), 0, math.max(newSize.Y, self.MinSize.Y))
			end
		end)
		game:GetService("UserInputService").InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
		end)
		
		-- Tab system
		function windowData:AddTab(tab_name)
			tab_name = tostring(tab_name or "New Tab")
			
			-- Create tab button with gradient
			local tabButton = Instance.new("TextButton")
			tabButton.Name = "TabButton"
			tabButton.BackgroundTransparency = 0
			tabButton.BorderSizePixel = 0
			tabButton.Size = UDim2.new(0, 110, 0, 28)
			tabButton.Font = Enum.Font.GothamBold
			tabButton.Text = tab_name
			tabButton.TextColor3 = self.Theme.TextSecondary
			tabButton.TextSize = 13
			tabButton.Parent = tabButtons
			tabButton:Add(CreateCorner(6))
			
			-- Glow effect for active tab
			local glow = Instance.new("Frame")
			glow.BackgroundTransparency = 0.8
			glow.Size = UDim2.new(1, 0, 1, 0)
			glow.Visible = false
			glow.Parent = tabButton
			CreateGradient(glow, self.Theme.GradientStart, self.Theme.GradientEnd)
			glow:Add(CreateCorner(6))
			
			-- Create tab content
			local tab = Instance.new("ScrollingFrame")
			tab.Name = "Tab"
			tab.BackgroundTransparency = 1
			tab.Size = UDim2.new(1, 0, 1, 0)
			tab.ScrollBarThickness = 4
			tab.ScrollBarImageColor3 = self.Theme.Primary
			tab.Visible = false
			tab.Parent = tabs
			
			local tabLayout = Instance.new("UIListLayout")
			tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tabLayout.Padding = UDim.new(0, 6)
			tabLayout.Parent = tab
			
			tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				tab.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
			end)
			
			local tabData = {Tab = tab, Button = tabButton, Window = self}
			
			function tabData:Show()
				for _, v in pairs(tabs:GetChildren() do if v:IsA("ScrollingFrame") then v.Visible = false end end
				for _, v in pairs(tabButtons:GetChildren() do if v:IsA("TextButton") then 
					Tween(v, {BackgroundColor3 = self.Theme.Surface2, TextColor3 = self.Theme.TextSecondary}, 0.2)
					v.Glow.Visible = false
				end end)
				tab.Visible = true
				Tween(tabButton, {BackgroundColor3 = self.Theme.Surface2, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
				glow.Visible = true
				windowData.CurrentTab = tabData
			end
			
			tabButton.MouseButton1Click:Connect(function() tabData:Show() end)
			if #windowData.Tabs == 0 then tabData:Show() tabSelection.Visible = true end
			table.insert(windowData.Tabs, tabData)
			
			-- Component functions
			function tabData:AddLabel(label_text)
				label_text = tostring(label_text or "New Label")
				local label = Instance.new("TextLabel")
				label.BackgroundTransparency = 1
				label.Size = UDim2.new(1, 0, 0, 20)
				label.Font = Enum.Font.GothamSemibold
				label.Text = label_text
				label.TextColor3 = self.Theme.Text
				label.TextSize = 14
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = tab
				return label
			end
			
			function tabData:AddButton(button_text, callback)
				button_text = tostring(button_text or "New Button")
				callback = typeof(callback) == "function" and callback or function() end
				local button = Instance.new("TextButton")
				button.BackgroundColor3 = self.Theme.Surface2
				button.BorderSizePixel = 0
				button.Size = UDim2.new(1, 0, 0, 35)
				button.Font = Enum.Font.GothamBold
				button.Text = button_text
				button.TextColor3 = self.Theme.Text
				button.TextSize = 13
				button.Parent = tab
				button:Add(CreateCorner(6))
				
				-- Button gradient overlay
				local btnGradient = Instance.new("Frame")
				btnGradient.BackgroundTransparency = 0.9
				btnGradient.Size = UDim2.new(1, 0, 1, 0)
				btnGradient.Parent = button
				CreateGradient(btnGradient, self.Theme.GradientStart, self.Theme.GradientEnd)
				btnGradient:Add(CreateCorner(6))
				
				button.MouseButton1Click:Connect(function()
					spawn(function()
						local ripple = Instance.new("Frame")
						ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						ripple.BackgroundTransparency = 0.8
						ripple.Size = UDim2.new(0, 0, 0, 0)
						ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
						ripple.AnchorPoint = Vector2.new(0.5, 0.5)
						ripple:Add(CreateCorner(50))
						ripple.Parent = button
						Tween(ripple, {Size = UDim2.new(1, 50, 1, 50), BackgroundTransparency = 1}, 0.5, function() ripple:Destroy() end)
					end)
					pcall(callback)
				end)
				
				button.MouseEnter:Connect(function() 
					Tween(button, {BackgroundColor3 = self.Theme.Surface, Size = UDim2.new(1, 2, 0, 37)}, 0.2) 
				end)
				button.MouseLeave:Connect(function() 
					Tween(button, {BackgroundColor3 = self.Theme.Surface2, Size = UDim2.new(1, 0, 0, 35)}, 0.2) 
				end)
				return button
			end
			
			function tabData:AddSwitch(switch_text, callback)
				local switchData, toggled = {}, false
				switch_text = tostring(switch_text or "New Switch")
				callback = typeof(callback) == "function" and callback or function() end
				local container = Instance.new("Frame")
				container.BackgroundTransparency = 1
				container.Size = UDim2.new(1, 0, 0, 35)
				container.Parent = tab
				local label = Instance.new("TextLabel")
				label.BackgroundTransparency = 1
				label.Position = UDim2.new(0, 10, 0, 7)
				label.Size = UDim2.new(1, -70, 0, 20)
				label.Font = Enum.Font.GothamSemibold
				label.Text = switch_text
				label.TextColor3 = self.Theme.Text
				label.TextSize = 13
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = container
				local switch = Instance.new("TextButton")
				switch.BackgroundColor3 = self.Theme.Surface2
				switch.BorderSizePixel = 0
				switch.Position = UDim2.new(1, -50, 0.5, -13)
				switch.Size = UDim2.new(0, 50, 0, 26)
				switch.Font = Enum.Font.GothamBold
				switch.Text = ""
				switch.TextColor3 = Color3.fromRGB(255, 255, 255)
				switch.TextSize = 16
				switch.Parent = container
				switch:Add(CreateCorner(13))
				local knob = Instance.new("Frame")
				knob.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
				knob.Position = UDim2.new(0, 2, 0.5, -10)
				knob.Size = UDim2.new(0, 22, 0, 22)
				knob.Parent = switch
				knob:Add(CreateCorner(11))
				local function UpdateSwitch()
					toggled = not toggled
					switch.Text = toggled and "✓" or ""
					Tween(switch, {BackgroundColor3 = toggled and self.Theme.Primary or self.Theme.Surface2}, 0.3)
					Tween(knob, {Position = toggled and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.3)
					pcall(callback, toggled)
				end
				switch.MouseButton1Click:Connect(UpdateSwitch)
				function switchData:Set(bool) toggled = not bool UpdateSwitch() end
				return switchData, switch
			end
			
			function tabData:AddSlider(slider_text, callback, slider_options)
				local sliderData = {}
				slider_text = tostring(slider_text or "New Slider")
				callback = typeof(callback) == "function" and callback or function() end
				slider_options = typeof(slider_options) == "table" and slider_options or {}
				slider_options = {["min"] = slider_options.min or 0, ["max"] = slider_options.max or 100, ["readonly"] = slider_options.readonly or false}
				local container = Instance.new("Frame")
				container.BackgroundTransparency = 1
				container.Size = UDim2.new(1, 0, 0, 50)
				container.Parent = tab
				local title = Instance.new("TextLabel")
				title.BackgroundTransparency = 1
				title.Position = UDim2.new(0, 10, 0, 0)
				title.Size = UDim2.new(0.6, 0, 0, 20)
				title.Font = Enum.Font.GothamSemibold
				title.Text = slider_text
				title.TextColor3 = self.Theme.Text
				title.TextSize = 13
				title.TextXAlignment = Enum.TextXAlignment.Left
				title.Parent = container
				local value = Instance.new("TextLabel")
				value.BackgroundTransparency = 1
				value.Position = UDim2.new(1, -60, 0, 0)
				value.Size = UDim2.new(0, 50, 0, 20)
				value.Font = Enum.Font.GothamBold
				value.Text = tostring(slider_options.min)
				value.TextColor3 = self.Theme.Secondary
				value.TextSize = 13
				value.TextXAlignment = Enum.TextXAlignment.Right
				value.Parent = container
				local track = Instance.new("Frame")
				track.BackgroundColor3 = self.Theme.Surface2
				track.BorderSizePixel = 0
				track.Position = UDim2.new(0, 10, 1, -15)
				track.Size = UDim2.new(1, -70, 0, 8)
				track.Parent = container
				track:Add(CreateCorner(4))
				local fill = Instance.new("Frame")
				fill.BackgroundColor3 = self.Theme.Secondary
				fill.BorderSizePixel = 0
				fill.Size = UDim2.new(0, 0, 1, 0)
				fill.Parent = track
				fill:Add(CreateCorner(4))
				local thumb = Instance.new("Frame")
				thumb.BackgroundColor3 = self.Theme.Secondary
				thumb.Position = UDim2.new(0, -8, 0.5, -8)
				thumb.Size = UDim2.new(0, 16, 0, 16)
				thumb.Parent = track
				thumb:Add(CreateCorner(8))
				thumb:Add(CreateStroke(self.Theme.Text, 2))
				local currentValue, dragging = slider_options.min, false
				local function UpdateSlider(posX)
					local relativePos = math.clamp((posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
					local newVal = math.floor(relativePos * (slider_options.max - slider_options.min) + slider_options.min)
					if newVal ~= currentValue then
						currentValue = newVal
						value.Text = tostring(newVal)
						Tween(fill, {Size = UDim2.new(relativePos, 0, 1, 0)}, 0.1)
						Tween(thumb, {Position = UDim2.new(relativePos, -8, 0.5, -8)}, 0.1)
						pcall(callback, newVal)
					end
				end
				track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 and not slider_options.readonly then dragging = true UpdateSlider(input.Position.X) end end)
				thumb.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 and not slider_options.readonly then dragging = true end end)
				game:GetService("UserInputService").InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(input.Position.X) end end)
				game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
				function sliderData:Set(new_value)
					local newVal = math.clamp(tonumber(new_value) or slider_options.min, slider_options.min, slider_options.max)
					local relativePos = (newVal - slider_options.min) / (slider_options.max - slider_options.min)
					currentValue = newVal
					value.Text = tostring(newVal)
					Tween(fill, {Size = UDim2.new(relativePos, 0, 1, 0)}, 0.3)
					Tween(thumb, {Position = UDim2.new(relativePos, -8, 0.5, -8)}, 0.3)
				end
				sliderData:Set(slider_options.min)
				return sliderData, container
			end
			
			function tabData:AddTextBox(textbox_text, callback, textbox_options)
				textbox_text = tostring(textbox_text or "New TextBox")
				callback = typeof(callback) == "function" and callback or function() end
				textbox_options = typeof(textbox_options) == "table" and textbox_options or {["clear"] = true}
				local container = Instance.new("Frame")
				container.BackgroundTransparency = 1
				container.Size = UDim2.new(1, 0, 0, 40)
				container.Parent = tab
				local textBox = Instance.new("TextBox")
				textBox.BackgroundColor3 = self.Theme.Surface2
				textBox.BorderSizePixel = 0
				textBox.Position = UDim2.new(0, 10, 0.5, -15)
				textBox.Size = UDim2.new(1, -20, 0, 30)
				textBox.Font = Enum.Font.GothamSemibold
				textBox.PlaceholderText = textbox_text
				textBox.Text = ""
				textBox.TextColor3 = self.Theme.Text
				textBox.TextSize = 13
				textBox.Parent = container
				textBox:Add(CreateCorner(6))
				textBox:Add(CreateStroke(self.Theme.Primary, 1))
				textBox.FocusLost:Connect(function(enterPressed) if enterPressed and #textBox.Text > 0 then pcall(callback, textBox.Text) if textbox_options.clear then textBox.Text = "" end end end)
				return textBox
			end
			
			function tabData:AddDropdown(dropdown_name, callback)
				local dropdownData, open = {}, false
				dropdown_name = tostring(dropdown_name or "New Dropdown")
				callback = typeof(callback) == "function" and callback or function() end
				local container = Instance.new("Frame")
				container.BackgroundTransparency = 1
				container.Size = UDim2.new(1, 0, 0, 35)
				container.Parent = tab
				local dropdown = Instance.new("TextButton")
				dropdown.BackgroundColor3 = self.Theme.Surface2
				dropdown.BorderSizePixel = 0
				dropdown.Position = UDim2.new(0, 10, 0, 0)
				dropdown.Size = UDim2.new(1, -20, 0, 30)
				dropdown.Font = Enum.Font.GothamSemibold
				dropdown.Text = "      " .. dropdown_name
				dropdown.TextColor3 = self.Theme.Text
				dropdown.TextSize = 13
				dropdown.TextXAlignment = Enum.TextXAlignment.Left
				dropdown.Parent = container
				dropdown:Add(CreateCorner(6))
				local indicator = Instance.new("ImageLabel")
				indicator.BackgroundTransparency = 1
				indicator.Position = UDim2.new(1, -25, 0.5, -10)
				indicator.Size = UDim2.new(0, 20, 0, 20)
				indicator.Image = "rbxassetid://4744658743"
				indicator.Rotation = -90
				indicator.Parent = dropdown
				local box = Instance.new("Frame")
				box.BackgroundColor3 = self.Theme.Surface2
				box.BorderSizePixel = 0
				box.Position = UDim2.new(0, 0, 0, 32)
				box.Size = UDim2.new(1, 0, 0, 0)
				box.Visible = false
				box.Parent = container
				box:Add(CreateCorner(6))
				local objects = Instance.new("ScrollingFrame")
				objects.BackgroundTransparency = 1
				objects.Size = UDim2.new(1, 0, 1, 0)
				objects.ScrollBarThickness = 4
				objects.ScrollBarImageColor3 = self.Theme.Primary
				objects.CanvasSize = UDim2.new(0, 0, 0, 0)
				objects.Parent = box
				local objectsLayout = Instance.new("UIListLayout")
				objectsLayout.SortOrder = Enum.SortOrder.LayoutOrder
				objectsLayout.Parent = objects
				dropdown.MouseButton1Click:Connect(function()
					open = not open
					Tween(indicator, {Rotation = open and 0 or -90}, 0.3)
					Tween(box, {Size = UDim2.new(1, 0, 0, open and math.min(#objects:GetChildren() * 35, 200) or 0)}, 0.3, function() box.Visible = open end)
				end)
				function dropdownData:Add(n)
					n = tostring(n or "New Item")
					local item = Instance.new("TextButton")
					item.BackgroundTransparency = 1
					item.Size = UDim2.new(1, 0, 0, 35)
					item.Font = Enum.Font.GothamSemibold
					item.Text = "      " .. n
					item.TextColor3 = self.Theme.Text
					item.TextSize = 13
					item.TextXAlignment = Enum.TextXAlignment.Left
					item.Parent = objects
					item.MouseButton1Click:Connect(function()
						dropdown.Text = "      [ " .. n .. " ]"
						open = false
						Tween(indicator, {Rotation = -90}, 0.3)
						Tween(box, {Size = UDim2.new(1, 0, 0, 0)}, 0.3, function() box.Visible = false end)
						pcall(callback, n)
					end)
					item.MouseEnter:Connect(function() Tween(item, {BackgroundColor3 = self.Theme.Primary}, 0.2) end)
					item.MouseLeave:Connect(function() Tween(item, {BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)}, 0.2) end)
					if open then Tween(box, {Size = UDim2.new(1, 0, 0, math.min(#objects:GetChildren() * 35, 200))}, 0.3) end
					return item
				end
				return dropdownData, dropdown
			end
			
			function tabData:AddKeybind(keybind_name, callback, keybind_options)
				local keybindData, binding = {}, false
				keybind_name = tostring(keybind_name or "New Keybind")
				callback = typeof(callback) == "function" and callback or function() end
				keybind_options = typeof(keybind_options) == "table" and keybind_options or {}
				keybind_options = {["standard"] = keybind_options.standard or Enum.KeyCode.RightShift}
				local container = Instance.new("Frame")
				container.BackgroundTransparency = 1
				container.Size = UDim2.new(1, 0, 0, 35)
				container.Parent = tab
				local title = Instance.new("TextLabel")
				title.BackgroundTransparency = 1
				title.Position = UDim2.new(0, 10, 0, 7)
				title.Size = UDim2.new(0.6, 0, 0, 20)
				title.Font = Enum.Font.GothamSemibold
				title.Text = "  " .. keybind_name
				title.TextColor3 = self.Theme.Text
				title.TextSize = 13
				title.TextXAlignment = Enum.TextXAlignment.Left
				title.Parent = container
				local input = Instance.new("TextButton")
				input.BackgroundColor3 = self.Theme.Surface2
				input.BorderSizePixel = 0
				input.Position = UDim2.new(1, -85, 0.5, -13)
				input.Size = UDim2.new(0, 80, 0, 26)
				input.Font = Enum.Font.GothamSemibold
				input.Text = "RShift"
				input.TextColor3 = self.Theme.Text
				input.TextSize = 12
				input.Parent = container
				input:Add(CreateCorner(6))
				input:Add(CreateStroke(self.Theme.Primary, 1))
				local currentKey = keybind_options.standard
				local shortkeys = {RightControl = 'RightCtrl', LeftControl = 'LeftCtrl', LeftShift = 'LShift', RightShift = 'RShift', MouseButton1 = "Mouse1", MouseButton2 = "Mouse2"}
				function keybindData:SetKeybind(Keybind)
					local key = shortkeys[Keybind.Name] or Keybind.Name
					input.Text = key
					currentKey = Keybind
				end
				keybindData:SetKeybind(keybind_options.standard)
				game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed) if not binding and input.KeyCode == currentKey and not gameProcessed then pcall(callback, currentKey) end end)
				input.MouseButton1Click:Connect(function() if binding then return end binding = true input.Text = "..." wait(0.1) local conn = game:GetService("UserInputService").InputBegan:Connect(function(input) if input.KeyCode ~= Enum.KeyCode.Unknown then keybindData:SetKeybind(input.KeyCode) conn:Disconnect() binding = false end end) wait(5) if binding then conn:Disconnect() keybindData:SetKeybind(currentKey) binding = false end end)
				return keybindData, container
			end
			
			function tabData:AddColorPicker(callback)
				local colorPickerData = {}
				callback = typeof(callback) == "function" and callback or function() end
				local container = Instance.new("Frame")
				container.BackgroundTransparency = 1
				container.Size = UDim2.new(1, 0, 0, 180)
				container.Parent = tab
				local colorPicker = Instance.new("ImageLabel")
				colorPicker.BackgroundTransparency = 1
				colorPicker.Size = UDim2.new(0, 180, 0, 110)
				colorPicker.Position = UDim2.new(0.5, -90, 0.5, -55)
				colorPicker.Image = "rbxassetid://2851929490"
				colorPicker.ImageColor3 = self.Theme.Surface2
				colorPicker.ScaleType = Enum.ScaleType.Slice
				colorPicker.SliceCenter = Rect.new(4, 4, 4, 4)
				colorPicker.Parent = container
				colorPicker:Add(CreateCorner(8))
				local palette = Instance.new("ImageLabel")
				palette.BackgroundTransparency = 1
				palette.Position = UDim2.new(0.05, 0, 0.05, 0)
				palette.Size = UDim2.new(0, 100, 0, 100)
				palette.Image = "rbxassetid://698052001"
				palette.ScaleType = Enum.ScaleType.Slice
				palette.SliceCenter = Rect.new(4, 4, 4, 4)
				palette.Parent = colorPicker
				local indicator = Instance.new("ImageLabel")
				indicator.BackgroundTransparency = 1
				indicator.Size = UDim2.new(0, 8, 0, 8)
				indicator.Image = "rbxassetid://2851926732"
				indicator.ImageColor3 = Color3.fromRGB(0, 0, 0)
				indicator.ScaleType = Enum.ScaleType.Slice
				indicator.SliceCenter = Rect.new(12, 12, 12, 12)
				indicator.ZIndex = 2
				indicator.Parent = palette
				local sample = Instance.new("ImageLabel")
				sample.BackgroundTransparency = 1
				sample.Position = UDim2.new(0.8, 0, 0.05, 0)
				sample.Size = UDim2.new(0, 30, 0, 30)
				sample.Image = "rbxassetid://2851929490"
				sample.ScaleType = Enum.ScaleType.Slice
				sample.SliceCenter = Rect.new(4, 4, 4, 4)
				sample.Parent = colorPicker
				local saturation = Instance.new("ImageLabel")
				saturation.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				saturation.Position = UDim2.new(0.65, 0, 0.05, 0)
				saturation.Size = UDim2.new(0, 15, 0, 100)
				saturation.Image = "rbxassetid://3641079629"
				saturation.Parent = colorPicker
				local satIndicator = Instance.new("Frame")
				satIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				satIndicator.BorderSizePixel = 0
				satIndicator.Size = UDim2.new(1, 0, 0, 2)
				satIndicator.ZIndex = 2
				satIndicator.Parent = saturation
				local h, s, v = 0, 1, 1
				local draggingPalette, draggingSat = false, false
				local function UpdateColor()
					local color = Color3.fromHSV(h, s, v)
					sample.BackgroundColor3 = color
					saturation.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
					pcall(callback, color)
				end
				UpdateColor()
				local function UpdatePalette(pos)
					local x = math.clamp(pos.X - palette.AbsolutePosition.X, 0, palette.AbsoluteSize.X) / palette.AbsoluteSize.X
					local y = math.clamp(pos.Y - palette.AbsolutePosition.Y, 0, palette.AbsoluteSize.Y) / palette.AbsoluteSize.Y
					h, s = x, 1 - y
					indicator.Position = UDim2.new(0, x * 100 - 4, 0, y * 100 - 4)
					UpdateColor()
				end
				local function UpdateSaturation(pos)
					local y = math.clamp(pos.Y - saturation.AbsolutePosition.Y, 0, saturation.AbsoluteSize.Y) / saturation.AbsoluteSize.Y
					v = 1 - y
					satIndicator.Position = UDim2.new(0, 0, 0, y * 100)
					UpdateColor()
				end
				palette.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingPalette = true UpdatePalette(input.Position) end end)
				saturation.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSat = true UpdateSaturation(input.Position) end end)
				game:GetService("UserInputService").InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then if draggingPalette then UpdatePalette(input.Position) end if draggingSat then UpdateSaturation(input.Position) end end end)
				game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingPalette = false draggingSat = false end end)
				function colorPickerData:Set(color)
					color = typeof(color) == "Color3" and color or Color3.new(1, 1, 1)
					h, s, v = Color3.toHSV(color)
					indicator.Position = UDim2.new(0, s * 100 - 4, 0, (1 - v) * 100 - 4)
					satIndicator.Position = UDim2.new(0, 0, 0, (1 - v) * 100)
					UpdateColor()
				end
				return colorPickerData, colorPicker
			end
			
			function tabData:AddConsole(console_options)
				local consoleData = {}
				console_options = typeof(console_options) == "table" and console_options or {["readonly"] = true,["full"] = false,}
				console_options = {["y"] = console_options.y or 200, ["source"] = console_options.source or "Logs", ["readonly"] = console_options.readonly == true, ["full"] = console_options.full == true}
				local console = Instance.new("ImageLabel")
				console.BackgroundTransparency = 1
				console.Size = console_options.full and UDim2.new(1, 0, 1, 0) or UDim2.new(1, 0, 0, console_options.y)
				console.Image = "rbxassetid://2851928141"
				console.ImageColor3 = self.Theme.Surface2
				console.ScaleType = Enum.ScaleType.Slice
				console.SliceCenter = Rect.new(8, 8, 8, 8)
				console.Parent = tab
				console:Add(CreateCorner(8))
				local scrollingFrame = Instance.new("ScrollingFrame")
				scrollingFrame.BackgroundTransparency = 1
				scrollingFrame.BorderSizePixel = 0
				scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
				scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
				scrollingFrame.ScrollBarThickness = 4
				scrollingFrame.ScrollBarImageColor3 = self.Theme.Primary
				scrollingFrame.Parent = console
				local source = Instance.new("TextBox")
				source.Name = "Source"
				source.BackgroundTransparency = 1
				source.Position = UDim2.new(0, 10, 0, 0)
				source.Size = UDim2.new(1, -20, 0, 10000)
				source.ClearTextOnFocus = false
				source.Font = Enum.Font.Code
				source.MultiLine = true
				source.PlaceholderColor3 = self.Theme.TextSecondary
				source.Text = ""
				source.TextColor3 = self.Theme.Text
				source.TextSize = 13
				source.TextXAlignment = Enum.TextXAlignment.Left
				source.TextYAlignment = Enum.TextYAlignment.Top
				source.TextEditable = not console_options.readonly
				source.Parent = scrollingFrame
				function consoleData:Set(code) source.Text = tostring(code) end
				function consoleData:Get() return source.Text end
				function consoleData:Log(msg) source.Text = source.Text .. "[*] " .. tostring(msg) .. "\n" scrollingFrame.CanvasPosition = Vector2.new(0, scrollingFrame.CanvasSize.Y.Offset) end
				source:GetPropertyChangedSignal("Text"):Connect(function() local lines = select(2, source.Text:gsub('\n', '\n')) + 1 scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, lines * 18) end)
				return consoleData, console
			end
			
			function tabData:AddFolder(folder_name)
				local folderData, open = {}
				folder_name = tostring(folder_name or "New Folder")
				local folder = Instance.new("Frame")
				folder.BackgroundTransparency = 1
				folder.Size = UDim2.new(1, 0, 0, 35)
				folder.Parent = tab
				local button = Instance.new("TextButton")
				button.BackgroundTransparency = 0
				button.BackgroundColor3 = self.Theme.Surface2
				button.BorderSizePixel = 0
				button.Size = UDim2.new(1, 0, 0, 35)
				button.Font = Enum.Font.GothamSemibold
				button.Text = "      " .. folder_name
				button.TextColor3 = self.Theme.Text
				button.TextSize = 14
				button.TextXAlignment = Enum.TextXAlignment.Left
				button.Parent = folder
				button:Add(CreateCorner(6))
				local toggle = Instance.new("ImageLabel")
				toggle.BackgroundTransparency = 1
				toggle.Position = UDim2.new(0, 10, 0.5, -10)
				toggle.Size = UDim2.new(0, 20, 0, 20)
				toggle.Image = "rbxassetid://4731371541"
				toggle.Rotation = 0
				toggle.Parent = button
				local objects = Instance.new("Frame")
				objects.BackgroundTransparency = 1
				objects.Position = UDim2.new(0, 10, 0, 40)
				objects.Size = UDim2.new(1, -10, 1, -40)
				objects.Visible = false
				objects.Parent = folder
				local objectsLayout = Instance.new("UIListLayout")
				objectsLayout.SortOrder = Enum.SortOrder.LayoutOrder
				objectsLayout.Padding = UDim.new(0, 4)
				objectsLayout.Parent = objects
				button.MouseButton1Click:Connect(function()
					open = not open
					objects.Visible = open
					Tween(toggle, {Rotation = open and 90 or 0}, 0.3)
					local height = open and (objectsLayout.AbsoluteContentSize.Y + 40) or 35
					Tween(folder, {Size = UDim2.new(1, 0, 0, height)}, 0.3)
				end)
				for i, v in pairs(tabData) do if type(v) == "function" and i ~= "AddFolder" and i ~= "Show" then folderData[i] = function(...) local args = {...} local result = v(tabData, unpack(args)) if typeof(result) == "table" then result[2].Parent = objects else result.Parent = objects end return result end end end
				return folderData, folder
			end
			
			function tabData:AddHorizontalAlignment()
				local haData = {}
				local container = Instance.new("Frame")
				container.BackgroundTransparency = 1
				container.Size = UDim2.new(1, 0, 0, 35)
				container.Parent = tab
				local layout = Instance.new("UIListLayout")
				layout.FillDirection = Enum.FillDirection.Horizontal
				layout.SortOrder = Enum.SortOrder.LayoutOrder
				layout.Padding = UDim.new(0, 10)
				layout.Parent = container
				function haData:AddButton(...) local button = self:AddButton(...) button.Parent = container return button end
				return haData, container
			end
			
			return tabData, tab
		end
		
		return windowData, window
	end
	
	function GalaxyUI:Notification(props)
		props = props or {}
		local notif = Instance.new("Frame")
		notif.Size = UDim2.new(0, 300, 0, 80)
		notif.Position = UDim2.new(1, 320, 0, 20)
		notif.BackgroundColor3 = self.Theme.Surface
		notif.Parent = self.ScreenGui
		notif:Add(CreateCorner(10))
		notif:Add(CreateStroke(self.Theme.Secondary, 2))
		local gradient = Instance.new("Frame")
		gradient.BackgroundTransparency = 0.9
		gradient.Size = UDim2.new(1, 0, 1, 0)
		gradient.Parent = notif
		CreateGradient(gradient, self.Theme.GradientStart, self.Theme.GradientEnd)
		gradient:Add(CreateCorner(10))
		local icon = Instance.new("TextLabel")
		icon.BackgroundTransparency = 1
		icon.Position = UDim2.new(0, 10, 0, 10)
		icon.Size = UDim2.new(0, 60, 0, 60)
		icon.Font = Enum.Font.GothamBold
		icon.Text = props.Icon or "ℹ️"
		icon.TextColor3 = self.Theme.Secondary
		icon.TextSize = 30
		icon.Parent = notif
		local title = Instance.new("TextLabel")
		title.BackgroundTransparency = 1
		title.Position = UDim2.new(0, 70, 0, 15)
		title.Size = UDim2.new(1, -80, 0, 20)
		title.Font = Enum.Font.GothamBold
		title.Text = props.Title or "Notification"
		title.TextColor3 = self.Theme.Text
		title.TextSize = 16
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = notif
		local message = Instance.new("TextLabel")
		message.BackgroundTransparency = 1
		message.Position = UDim2.new(0, 70, 0, 35)
		message.Size = UDim2.new(1, -80, 0, 40)
		message.Font = Enum.Font.Gotham
		message.Text = props.Message or "This is a notification!"
		message.TextColor3 = self.Theme.TextSecondary
		message.TextSize = 14
		message.TextXAlignment = Enum.TextXAlignment.Left
		message.TextWrapped = true
		message.Parent = notif
		Tween(notif, {Position = UDim2.new(1, -320, 0, 20)}, 0.5)
		spawn(function() wait(props.Duration or 3) Tween(notif, {Position = UDim2.new(1, 320, 0, 20)}, 0.5, function() notif:Destroy() end) end)
		return notif
	end
	
	return GalaxyUI
end)()

return GalaxyUI
