-- =============================================
-- ENHANCED GALAXY UI v3.0
-- Modern design with sections & better styling
-- =============================================

local GalaxyUI = {}
GalaxyUI.__index = GalaxyUI

-- Updated Theme to match the image
GalaxyUI.Themes = {
    Galaxy = {
        Primary = Color3.fromRGB(147, 112, 219),
        Secondary = Color3.fromRGB(118, 75, 162),
        Accent = Color3.fromRGB(79, 195, 247),
        Background = Color3.fromRGB(15, 12, 41),
        Surface = Color3.fromRGB(25, 22, 46),
        Surface2 = Color3.fromRGB(35, 32, 56),
        Surface3 = Color3.fromRGB(45, 42, 66),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 220),
        TextMuted = Color3.fromRGB(140, 140, 180),
        Success = Color3.fromRGB(102, 187, 106),
        Warning = Color3.fromRGB(255, 152, 0),
        Error = Color3.fromRGB(244, 67, 54),
        GradientStart = Color3.fromRGB(147, 112, 219),
        GradientEnd = Color3.fromRGB(118, 75, 162),
    }
}

-- Utility Functions
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
    stroke.Transparency = 0.6
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
        duration or 0.25,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), goal)
    tween:Play()
    if callback then tween.Completed:Connect(callback) end
    return tween
end

-- Main Library
function GalaxyUI.new(options)
    local self = setmetatable({}, GalaxyUI)
    options = options or {}
    self.Theme = options.Theme or GalaxyUI.Themes.Galaxy
    self.ToggleKey = options.toggle_key or Enum.KeyCode.RightShift
    self.MinSize = options.min_size or Vector2.new(450, 350)
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
    
    -- Toggle visibility
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == self.ToggleKey then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        end
    end)
    
    return self
end

function GalaxyUI:AddWindow(title, options)
    options = options or {}
    local window = Instance.new("Frame")
    window.Name = "Window"
    window.Active = true
    window.BackgroundColor3 = self.Theme.Background
    window.ClipsDescendants = true
    window.Size = UDim2.new(0, self.MinSize.X, 0, self.MinSize.Y)
    window.Parent = self.Windows
    
    window:Add(CreateCorner(12))
    window:Add(CreateStroke(self.Theme.Surface2, 1))
    
    -- Gradient overlay
    local gradientOverlay = Instance.new("Frame")
    gradientOverlay.BackgroundTransparency = 0.95
    gradientOverlay.Size = UDim2.new(1, 0, 1, 0)
    gradientOverlay.Active = false
    gradientOverlay.Parent = window
    CreateGradient(gradientOverlay, self.Theme.GradientStart, self.Theme.GradientEnd)
    gradientOverlay:Add(CreateCorner(12))
    
    -- Shadow
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
    
    -- Title Bar
    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.BorderSizePixel = 0
    bar.Size = UDim2.new(1, 0, 0, 50)
    bar.Parent = window
    CreateGradient(bar, self.Theme.GradientStart, self.Theme.GradientEnd)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 12)
    titleLabel.Size = UDim2.new(1, -60, 0, 25)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = tostring(title or "Galaxy Hub")
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = bar
    
    -- Toggle Button (Collapsible)
    local toggle = Instance.new("ImageButton")
    toggle.Name = "Toggle"
    toggle.BackgroundTransparency = 1
    toggle.Position = UDim2.new(0, 10, 0, 15)
    toggle.Size = UDim2.new(0, 20, 0, 20)
    toggle.Image = "rbxassetid://4731371541" -- Arrow icon
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
    
    -- Tab Selection
    local tabSelection = Instance.new("Frame")
    tabSelection.Name = "TabSelection"
    tabSelection.BackgroundTransparency = 1
    tabSelection.Position = UDim2.new(0, 15, 0, 55)
    tabSelection.Size = UDim2.new(1, -30, 0, 40)
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
    
    -- Content Area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 0, 0, 95)
    content.Size = UDim2.new(1, 0, 1, -100)
    content.Parent = window
    
    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.Padding = UDim.new(0, 8)
    scrollLayout.Parent = content
    
    -- Bottom Stats/Console
    local console = Instance.new("Frame")
    console.Name = "Console"
    console.BackgroundColor3 = self.Theme.Surface2
    console.BorderSizePixel = 0
    console.Position = UDim2.new(0, 0, 1, -25)
    console.Size = UDim2.new(1, 0, 0, 25)
    console.Parent = window
    console:Add(CreateCorner(0, 0, 12, 12))
    
    local consoleText = Instance.new("TextLabel")
    consoleText.BackgroundTransparency = 1
    consoleText.Position = UDim2.new(0, 15, 0, 0)
    consoleText.Size = UDim2.new(1, -30, 1, 0)
    consoleText.Font = Enum.Font.GothamSemibold
    consoleText.Text = "Status: Ready"
    consoleText.TextColor3 = self.Theme.TextSecondary
    consoleText.TextSize = 12
    consoleText.TextXAlignment = Enum.TextXAlignment.Left
    consoleText.Parent = console
    
    -- State
    local isOpen = true
    local windowData = {
        Window = window,
        Tabs = {},
        CurrentTab = nil,
        Content = content,
        Console = consoleText
    }
    
    -- Toggle Window
    toggle.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Tween(toggle, {Rotation = isOpen and 90 or 0}, 0.3)
        Tween(window, {Size = UDim2.new(0, window.AbsoluteSize.X, 0, isOpen and self.MinSize.Y or 50)}, 0.3)
    end)
    
    -- Dragging
    local dragState = {dragging = false}
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragState.dragging = true
            dragState.startPos = window.Position
            dragState.lastMousePos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragState.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragState.lastMousePos
            window.Position = UDim2.new(
                dragState.startPos.X.Scale, dragState.startPos.X.Offset + delta.X,
                dragState.startPos.Y.Scale, dragState.startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragState.dragging = false
        end
    end)
    
    -- Resizing
    local resizeState = {resizing = false}
    resizer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self.CanResize then
            resizeState.resizing = true
            resizeState.startSize = window.AbsoluteSize
            resizeState.startPos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if resizeState.resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - resizeState.startPos
            local newSize = resizeState.startSize + delta
            window.Size = UDim2.new(0, math.max(newSize.X, self.MinSize.X), 0, math.max(newSize.Y, self.MinSize.Y))
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizeState.resizing = false
        end
    end)
    
    -- Tab System
    function windowData:AddTab(tab_name)
        tab_name = tostring(tab_name or "New Tab")
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "TabButton"
        tabButton.BackgroundColor3 = self.Theme.Surface3
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(0, 120, 0, 32)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Text = tab_name
        tabButton.TextColor3 = self.Theme.TextSecondary
        tabButton.TextSize = 14
        tabButton.Parent = tabButtons
        tabButton:Add(CreateCorner(8))
        
        local glow = Instance.new("Frame")
        glow.Name = "Glow"
        glow.BackgroundTransparency = 0.8
        glow.Size = UDim2.new(1, 0, 1, 0)
        glow.Visible = false
        glow.Parent = tabButton
        CreateGradient(glow, self.Theme.GradientStart, self.Theme.GradientEnd)
        glow:Add(CreateCorner(8))
        
        local tab = Instance.new("ScrollingFrame")
        tab.Name = "Tab"
        tab.BackgroundTransparency = 1
        tab.Size = UDim2.new(1, 0, 1, 0)
        tab.ScrollBarThickness = 4
        tab.ScrollBarImageColor3 = self.Theme.Primary
        tab.ScrollBarImageTransparency = 0.5
        tab.Visible = false
        tab.Parent = content
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 6)
        tabLayout.Parent = tab
        
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 15)
        end)
        
        local tabData = {
            Tab = tab,
            Button = tabButton,
            Window = self,
            Theme = self.Theme
        }
        
        function tabData:Show()
            for _, v in pairs(content:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(tabButtons:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v, {BackgroundColor3 = self.Theme.Surface3, TextColor3 = self.Theme.TextSecondary}, 0.2)
                    v.Glow.Visible = false
                end
            end
            tab.Visible = true
            Tween(tabButton, {BackgroundColor3 = self.Theme.Surface3, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            glow.Visible = true
            windowData.CurrentTab = tabData
            tabSelection.Visible = true
        end
        
        tabButton.MouseButton1Click:Connect(function() tabData:Show() end)
        if #windowData.Tabs == 0 then tabData:Show() end
        table.insert(windowData.Tabs, tabData)
        
        -- Section (Collapsible Group)
        function tabData:AddSection(section_name, icon)
            section_name = tostring(section_name or "New Section")
            local sectionData = {Expanded = true}
            
            local header = Instance.new("TextButton")
            header.Name = "SectionHeader"
            header.BackgroundColor3 = self.Theme.Surface2
            header.BorderSizePixel = 0
            header.Size = UDim2.new(1, 0, 0, 38)
            header.Font = Enum.Font.GothamBold
            header.Text = section_name
            header.TextColor3 = self.Theme.Text
            header.TextSize = 14
            header.TextXAlignment = Enum.TextXAlignment.Left
            header.Parent = tab
            header:Add(CreateCorner(8))
            
            -- Icon
            if icon then
                local iconLabel = Instance.new("TextLabel")
                iconLabel.BackgroundTransparency = 1
                iconLabel.Position = UDim2.new(0, 10, 0, 7)
                iconLabel.Size = UDim2.new(0, 24, 0, 24)
                iconLabel.Font = Enum.Font.GothamBold
                iconLabel.Text = icon
                iconLabel.TextColor3 = self.Theme.Primary
                iconLabel.TextSize = 16
                iconLabel.TextXAlignment = Enum.TextXAlignment.Center
                iconLabel.Parent = header
            end
            
            local arrow = Instance.new("ImageLabel")
            arrow.Name = "Arrow"
            arrow.BackgroundTransparency = 1
            arrow.Position = UDim2.new(1, -28, 0, 9)
            arrow.Size = UDim2.new(0, 20, 0, 20)
            arrow.Image = "rbxassetid://4731371541"
            arrow.ImageColor3 = self.Theme.TextSecondary
            arrow.Rotation = 90
            arrow.Parent = header
            
            local container = Instance.new("Frame")
            container.Name = "SectionContent"
            container.BackgroundTransparency = 1
            container.Size = UDim2.new(1, 0, 0, 0)
            container.ClipsDescendants = true
            container.Parent = tab
            
            local layout = Instance.new("UIListLayout")
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 6)
            layout.Parent = container
            
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if sectionData.Expanded then
                    container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 10)
                end
            end)
            
            function sectionData:Toggle()
                sectionData.Expanded = not sectionData.Expanded
                Tween(arrow, {Rotation = sectionData.Expanded and 90 or 0}, 0.3)
                Tween(container, {Size = UDim2.new(1, 0, 0, sectionData.Expanded and layout.AbsoluteContentSize.Y + 10 or 0)}, 0.3)
            end
            
            header.MouseButton1Click:Connect(function() sectionData:Toggle() end)
            
            function sectionData:AddButton(button_text, description, callback)
                button_text = tostring(button_text or "Button")
                callback = typeof(callback) == "function" and callback or function() end
                description = tostring(description or "")
                
                local button = Instance.new("TextButton")
                button.BackgroundColor3 = self.Theme.Surface3
                button.BorderSizePixel = 0
                button.Size = UDim2.new(1, 0, 0, description ~= "" and 45 or 35)
                button.Font = Enum.Font.GothamBold
                button.Text = button_text
                button.TextColor3 = self.Theme.Text
                button.TextSize = 13
                button.Parent = container
                button:Add(CreateCorner(6))
                
                -- Sub-text
                if description ~= "" then
                    local descLabel = Instance.new("TextLabel")
                    descLabel.BackgroundTransparency = 1
                    descLabel.Position = UDim2.new(0, 0, 0, 18)
                    descLabel.Size = UDim2.new(1, 0, 0, 25)
                    descLabel.Font = Enum.Font.Gotham
                    descLabel.Text = description
                    descLabel.TextColor3 = self.Theme.TextMuted
                    descLabel.TextSize = 11
                    descLabel.TextXAlignment = Enum.TextXAlignment.Center
                    descLabel.Parent = button
                end
                
                -- Button effects
                button.MouseEnter:Connect(function() 
                    Tween(button, {BackgroundColor3 = self.Theme.Surface, Size = UDim2.new(1, 2, 0, description ~= "" and 47 or 37)}, 0.2) 
                end)
                button.MouseLeave:Connect(function() 
                    Tween(button, {BackgroundColor3 = self.Theme.Surface3, Size = UDim2.new(1, 0, 0, description ~= "" and 45 or 35)}, 0.2) 
                end)
                
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
                
                return button
            end
            
            function sectionData:AddSwitch(switch_text, description, callback)
                local switchData = {toggled = false}
                switch_text = tostring(switch_text or "Switch")
                description = tostring(description or "")
                callback = typeof(callback) == "function" and callback or function() end
                
                local container = Instance.new("Frame")
                container.BackgroundTransparency = 1
                container.Size = UDim2.new(1, 0, 0, 45)
                container.Parent = self.Container or container.Parent
                
                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.Position = UDim2.new(0, 10, 0, 5)
                label.Size = UDim2.new(1, -70, 0, 18)
                label.Font = Enum.Font.GothamSemibold
                label.Text = switch_text
                label.TextColor3 = self.Theme.Text
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = container
                
                if description ~= "" then
                    local descLabel = Instance.new("TextLabel")
                    descLabel.BackgroundTransparency = 1
                    descLabel.Position = UDim2.new(0, 10, 0, 22)
                    descLabel.Size = UDim2.new(1, -70, 0, 18)
                    descLabel.Font = Enum.Font.Gotham
                    descLabel.Text = description
                    descLabel.TextColor3 = self.Theme.TextMuted
                    descLabel.TextSize = 11
                    descLabel.TextXAlignment = Enum.TextXAlignment.Left
                    descLabel.Parent = container
                end
                
                local switch = Instance.new("TextButton")
                switch.BackgroundColor3 = self.Theme.Surface2
                switch.BorderSizePixel = 0
                switch.Position = UDim2.new(1, -55, 0.5, -13)
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
                    switchData.toggled = not switchData.toggled
                    switch.Text = switchData.toggled and "✓" or ""
                    Tween(switch, {BackgroundColor3 = switchData.toggled and self.Theme.Primary or self.Theme.Surface2}, 0.3)
                    Tween(knob, {Position = switchData.toggled and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.3)
                    pcall(callback, switchData.toggled)
                end
                
                switch.MouseButton1Click:Connect(UpdateSwitch)
                
                function switchData:Set(bool)
                    if switchData.toggled ~= bool then UpdateSwitch() end
                end
                
                container.Parent = container.Parent or tab
                return switchData, container
            end
            
            return sectionData, container
        end
        
        -- Legacy direct element addition
        function tabData:AddLabel(label_text)
            label_text = tostring(label_text or "Label")
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
            return tabData:AddSection("Temp"):AddButton(button_text, "", callback)
        end
        
        function tabData:AddSwitch(switch_text, callback)
            return tabData:AddSection("Temp"):AddSwitch(switch_text, "", callback)
        end
        
        return tabData, tab
    end
    
    function windowData:SetConsole(text)
        consoleText.Text = "Status: " .. tostring(text)
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
    spawn(function()
        wait(props.Duration or 3)
        Tween(notif, {Position = UDim2.new(1, 320, 0, 20)}, 0.5, function() notif:Destroy() end)
    end)
    
    return notif
end

return GalaxyUI
