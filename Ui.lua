-- GalaxyUI Library - Save this as Ui.lua
local GalaxyUI = {}
GalaxyUI.__index = GalaxyUI

GalaxyUI.Themes = {
	Galaxy = {
		Primary = Color3.fromRGB(147, 112, 219),
		Secondary = Color3.fromRGB(79, 195, 247),
		Accent = Color3.fromRGB(171, 71, 188),
		Background = Color3.fromRGB(15, 12, 41),
		Surface = Color3.fromRGB(25, 22, 46),
		Surface2 = Color3.fromRGB(35, 32, 56),
		Text = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(200, 200, 250),
		Success = Color3.fromRGB(102, 187, 106),
		Warning = Color3.fromRGB(255, 152, 0),
		Error = Color3.fromRGB(244, 67, 54),
		GradientStart = Color3.fromRGB(102, 126, 234),
		GradientEnd = Color3.fromRGB(118, 75, 162),
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
	
	local toggle = Instance.new("ImageButton")
	toggle.Name = "Toggle"
	toggle.BackgroundTransparency = 1
	toggle.Position = UDim2.new(0, 10, 0, 12)
	toggle.Size = UDim2.new(0, 20, 0, 20)
	toggle.Image = "rbxassetid://4731371541"
	toggle.ImageColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Rotation = 90
	toggle.Parent = bar
	
	local resizer = Instance.new("Frame")
	resizer.Name = "Resizer"
	resizer.Active = true
	resizer.BackgroundTransparency = 1
	resizer.Position = UDim2.new(1, -20, 1, -20)
	resizer.Size = UDim2.new(0, 20, 0, 20)
	resizer.Parent = window
	
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
	
	local tabs = Instance.new("Frame")
	tabs.Name = "Tabs"
	tabs.BackgroundTransparency = 1
	tabs.Position = UDim2.new(0, 15, 0, 100)
	tabs.Size = UDim2.new(1, -30, 1, -115)
	tabs.Parent = window
	
	local isOpen = true
	local windowData = {Window = window, Tabs = {}, CurrentTab = nil}
	
	toggle.MouseButton1Click:Connect(function()
		tabs.Visible = not isOpen
		tabSelection.Visible = not isOpen and #windowData.Tabs > 0
		Tween(toggle, {Rotation = isOpen and 0 or 90}, 0.3)
		Tween(window, {Size = UDim2.new(0, window.AbsoluteSize.X, 0, isOpen and 45 or self.MinSize.Y)}, 0.3)
		isOpen = not isOpen
	end)
	
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
	
	function windowData:AddTab(tab_name)
		tab_name = tostring(tab_name or "New Tab")
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
		
		local glow = Instance.new("Frame")
		glow.BackgroundTransparency = 0.8
		glow.Size = UDim2.new(1, 0, 1, 0)
		glow.Visible = false
		glow.Parent = tabButton
		CreateGradient(glow, self.Theme.GradientStart, self.Theme.GradientEnd)
		glow:Add(CreateCorner(6))
		
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
