-- Mini_lib — библиотека меню (11 элементов)
-- Кастомизация в стиле CSS, без print
-- Slider / Checkbox / Button / TextInput — без встроенного имени
-- Слайдер без ползунка (квадратика) — тянется за дорожку
-- Закругления: theme.radius (глобально) или opts.radius (по элементу)
-- Слои: AddLayer / SetLayer / GetLayer

local Mini_lib = {}
Mini_lib.__index = Mini_lib

-- тема по умолчанию
local DEFAULT_THEME = {
    radius          = 0,  -- закругления (0 = без)

    -- окно
    windowBg        = Color3.fromRGB(30, 30, 35),
    windowBorder    = Color3.fromRGB(80, 80, 90),
    windowBorderW   = 1.5,
    titleBarBg      = Color3.fromRGB(40, 40, 48),
    titleText       = Color3.fromRGB(230, 230, 230),
    titleFont       = Enum.Font.GothamBold,
    titleSize       = 14,

    -- текст
    textColor       = Color3.fromRGB(220, 220, 220),
    textFont        = Enum.Font.Gotham,
    textSize        = 13,
    subTextColor    = Color3.fromRGB(150, 150, 160),
    subTextFont     = Enum.Font.Gotham,
    subTextSize     = 12,

    -- filler
    fillerBg        = Color3.fromRGB(50, 50, 60),

    -- button
    buttonBg        = Color3.fromRGB(60, 60, 75),
    buttonHover     = Color3.fromRGB(80, 80, 100),
    buttonPressed   = Color3.fromRGB(45, 45, 60),
    buttonDisabled  = Color3.fromRGB(40, 40, 45),
    buttonBorder    = Color3.fromRGB(90, 90, 110),
    buttonBorderW   = 1,

    -- key
    keyBg           = Color3.fromRGB(45, 45, 55),
    keyHover        = Color3.fromRGB(60, 60, 75),
    keyPressed      = Color3.fromRGB(90, 140, 90),
    keyBorder       = Color3.fromRGB(100, 100, 120),
    keyBorderW      = 1,
    keyText         = Color3.fromRGB(200, 200, 200),
    keyFont         = Enum.Font.GothamBold,
    keySize         = 13,

    -- slider (без knob)
    sliderTrack      = Color3.fromRGB(60, 60, 70),
    sliderFill       = Color3.fromRGB(100, 160, 255),
    sliderValueText  = Color3.fromRGB(150, 200, 255),
    sliderTrackH     = 6,

    -- checkbox
    checkboxOff       = Color3.fromRGB(50, 50, 60),
    checkboxOn        = Color3.fromRGB(100, 255, 150),
    checkboxOffHover  = Color3.fromRGB(65, 65, 80),
    checkboxOnHover   = Color3.fromRGB(130, 255, 170),
    checkboxGlow      = Color3.fromRGB(100, 255, 150),
    checkboxGlowW     = 2,
    checkboxSize      = 16,

    -- text input
    inputBg           = Color3.fromRGB(45, 45, 55),
    inputFocusBg      = Color3.fromRGB(55, 55, 70),
    inputBorder       = Color3.fromRGB(80, 80, 100),
    inputBorderW      = 1,
    inputFocusBorder  = Color3.fromRGB(100, 160, 255),
    inputFocusBorderW = 1.5,
    inputText         = Color3.fromRGB(230, 230, 230),
    inputPlaceholder  = Color3.fromRGB(120, 120, 135),
    inputFont         = Enum.Font.Gotham,
    inputTextSize     = 13,
    inputPaddingX     = 8,

    -- кнопки окна
    minBtnBg        = Color3.fromRGB(70, 70, 85),
    minBtnHover     = Color3.fromRGB(90, 90, 110),
    minBtnText      = Color3.fromRGB(230, 230, 230),
    closeBtnBg      = Color3.fromRGB(120, 50, 50),
    closeBtnHover   = Color3.fromRGB(160, 60, 60),
    closeBtnText    = Color3.fromRGB(255, 230, 230),
}

-- слияние темы
local function merge(base, override)
    local out = {}
    for k, v in pairs(base) do out[k] = v end
    if override then
        for k, v in pairs(override) do out[k] = v end
    end
    return out
end

-- создание gui
local function makeGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "Mini_libGui"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = game:GetService("CoreGui")
    return gui
end

-- применить закругление если radius > 0
local function applyCorner(instance, radius)
    if radius and radius > 0 then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius)
        c.Parent = instance
        return c
    end
    return nil
end

-- border + titlebar + drag area
local function createBorder(parent, size, pos, theme, movable)
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = size
    border.Position = pos
    border.BackgroundColor3 = theme.windowBg
    border.BorderSizePixel = 0
    border.ClipsDescendants = true
    border.Parent = parent

    applyCorner(border, theme.radius)

    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.windowBorder
    stroke.Thickness = theme.windowBorderW
    stroke.Parent = border

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = theme.titleBarBg
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 2
    titleBar.Parent = border

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Mini_lib"
    title.TextColor3 = theme.titleText
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = theme.titleFont
    title.TextSize = theme.titleSize
    title.ZIndex = 3
    title.Parent = titleBar

    local dragArea = Instance.new("TextButton")
    dragArea.Name = "DragArea"
    dragArea.Size = UDim2.new(1, -60, 1, 0)
    dragArea.Position = UDim2.new(0, 0, 0, 0)
    dragArea.BackgroundTransparency = 1
    dragArea.Text = ""
    dragArea.AutoButtonColor = false
    dragArea.Visible = movable ~= false
    dragArea.ZIndex = 1
    dragArea.Parent = titleBar

    local dragging = false
    local dragStart, startPos

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = border.Position
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and dragArea.Visible
           and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            border.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    border.DragArea = dragArea
    return border, titleBar
end

-- filler
local function createFiller(parent, size, pos, color, opts, theme)
    opts = opts or {}
    local filler = Instance.new("Frame")
    filler.Name = "Filler"
    filler.Size = size
    filler.Position = pos
    filler.BackgroundColor3 = color or theme.fillerBg
    filler.BorderSizePixel = 0
    filler.Parent = parent
    applyCorner(filler, opts.radius or theme.radius)
    return filler
end

-- label
local function createLabel(parent, text, size, pos, opts, theme)
    opts = opts or {}
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = size
    label.Position = pos
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextColor3 = opts.color or theme.textColor
    label.Font = opts.font or theme.textFont
    label.TextSize = opts.size or theme.textSize
    label.TextXAlignment = opts.align or Enum.TextXAlignment.Left
    label.TextYAlignment = opts.valign or Enum.TextYAlignment.Center
    if opts.wrap then label.TextWrapped = true end
    label.Parent = parent
    return label
end

-- button (без текста)
local function createButton(parent, size, pos, opts, theme)
    opts = opts or {}
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = opts.bg or theme.buttonBg
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = parent
    applyCorner(btn, opts.radius or theme.radius)

    local stroke = Instance.new("UIStroke")
    stroke.Color = opts.border or theme.buttonBorder
    stroke.Thickness = opts.borderW or theme.buttonBorderW
    stroke.Parent = btn

    local enabled = opts.enabled ~= false
    local isDown = false

    local function baseColor()
        if not enabled then return opts.disabled or theme.buttonDisabled end
        return opts.bg or theme.buttonBg
    end

    local function render()
        if isDown and enabled then
            btn.BackgroundColor3 = opts.pressed or theme.buttonPressed
        else
            btn.BackgroundColor3 = baseColor()
        end
    end

    btn.MouseEnter:Connect(function()
        if enabled then btn.BackgroundColor3 = opts.hover or theme.buttonHover end
    end)
    btn.MouseLeave:Connect(function()
        isDown = false
        render()
    end)
    btn.MouseButton1Down:Connect(function()
        if enabled then isDown = true; render() end
    end)
    btn.MouseButton1Up:Connect(function()
        isDown = false
        render()
    end)
    btn.MouseButton1Click:Connect(function()
        if enabled and opts.onClick then opts.onClick() end
    end)

    local methods = {}
    function methods:SetEnabled(v) enabled = v; render() end
    function methods:SetColor(c) opts.bg = c; render() end
    function methods:Destroy() btn:Destroy() end
    return btn, methods
end

-- key
local function createKey(parent, size, pos, opts, theme)
    opts = opts or {}
    local letter = opts.key or "E"
    local key = Instance.new("TextButton")
    key.Name = "Key_" .. letter
    key.Size = size
    key.Position = pos
    key.BackgroundColor3 = opts.bg or theme.keyBg
    key.BorderSizePixel = 0
    key.Text = opts.label or letter
    key.TextColor3 = opts.textColor or theme.keyText
    key.Font = opts.font or theme.keyFont
    key.TextSize = opts.textSize or theme.keySize
    key.AutoButtonColor = false
    key.Parent = parent
    applyCorner(key, opts.radius or theme.radius)

    local stroke = Instance.new("UIStroke")
    stroke.Color = opts.border or theme.keyBorder
    stroke.Thickness = opts.borderW or theme.keyBorderW
    stroke.Parent = key

    local function pressVisual()
        key.BackgroundColor3 = opts.pressed or theme.keyPressed
        task.delay(0.15, function()
            key.BackgroundColor3 = opts.bg or theme.keyBg
        end)
    end

    key.MouseEnter:Connect(function() key.BackgroundColor3 = opts.hover or theme.keyHover end)
    key.MouseLeave:Connect(function() key.BackgroundColor3 = opts.bg or theme.keyBg end)
    key.MouseButton1Click:Connect(function()
        pressVisual()
        if opts.onClick then opts.onClick() end
    end)

    local uis = game:GetService("UserInputService")
    local conn
    conn = uis.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode[letter] then
            pressVisual()
            if opts.onClick then opts.onClick() end
        end
    end)

    key.Destroying:Connect(function()
        if conn then conn:Disconnect() end
    end)

    return key
end

-- slider (без ползунка, тянется за дорожку)
local function createSlider(parent, size, pos, opts, theme)
    opts = opts or {}
    local minVal = opts.min or 0
    local maxVal = opts.max or 100
    local step = opts.step or 1
    local showValue = opts.showValue ~= false

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider"
    sliderFrame.Size = size
    sliderFrame.Position = pos
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent

    local valueLabel
    if showValue then
        valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 40, 0, 16)
        valueLabel.Position = UDim2.new(1, -40, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(opts.default or minVal)
        valueLabel.TextColor3 = opts.valueColor or theme.sliderValueText
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Font = opts.valueFont or theme.subTextFont
        valueLabel.TextSize = opts.valueSize or theme.subTextSize
        valueLabel.Parent = sliderFrame
    end

    local trackH = opts.trackH or theme.sliderTrackH
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, trackH)
    track.Position = UDim2.new(0, 0, 0.5, -trackH / 2)
    track.BackgroundColor3 = opts.trackColor or theme.sliderTrack
    track.BorderSizePixel = 0
    track.Parent = sliderFrame

    local trackRadius = opts.radius or theme.radius
    if trackRadius and trackRadius > 0 then
        applyCorner(track, trackRadius)
        track.ClipsDescendants = true
    end

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = opts.fillColor or theme.sliderFill
    fill.BorderSizePixel = 0
    fill.Parent = track

    local dragging = false

    local function quantize(v)
        v = math.clamp(v, minVal, maxVal)
        local steps = math.floor((v - minVal) / step + 0.5)
        return minVal + steps * step
    end

    local function setValue(v)
        local val = quantize(v)
        local alpha = (val - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        if valueLabel then valueLabel.Text = tostring(val) end
        if opts.onChange then opts.onChange(val) end
    end

    local function updateFromInput(input)
        local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
        setValue(minVal + rel * (maxVal - minVal))
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateFromInput(input)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromInput(input)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    setValue(opts.default or minVal)

    local methods = {}
    function methods:SetValue(v) setValue(v) end
    function methods:SetFillColor(c) fill.BackgroundColor3 = c end
    function methods:SetTrackColor(c) track.BackgroundColor3 = c end
    function methods:Destroy() sliderFrame:Destroy() end
    return sliderFrame, methods
end

-- checkbox (без текста, со свечением)
local function createCheckbox(parent, size, pos, opts, theme)
    opts = opts or {}
    local boxSize = opts.size or theme.checkboxSize

    local container = Instance.new("TextButton")
    container.Name = "Checkbox"
    container.Size = size
    container.Position = pos
    container.BackgroundTransparency = 1
    container.Text = ""
    container.AutoButtonColor = false
    container.Parent = parent

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, boxSize, 0, boxSize)
    box.Position = UDim2.new(0, 0, 0.5, -boxSize / 2)
    box.BackgroundColor3 = opts.offColor or theme.checkboxOff
    box.BorderSizePixel = 0
    box.Parent = container
    applyCorner(box, opts.radius or theme.radius)

    local glow = Instance.new("UIStroke")
    glow.Color = opts.glowColor or theme.checkboxGlow
    glow.Thickness = opts.glowW or theme.checkboxGlowW
    glow.Transparency = 1
    glow.Parent = box

    local checked = opts.default or false
    local hovered = false

    local function render()
        if checked then
            box.BackgroundColor3 = hovered and (opts.onHover or theme.checkboxOnHover)
                or (opts.onColor or theme.checkboxOn)
            glow.Transparency = 0
        else
            box.BackgroundColor3 = hovered and (opts.offHover or theme.checkboxOffHover)
                or (opts.offColor or theme.checkboxOff)
            glow.Transparency = 1
        end
    end

    container.MouseEnter:Connect(function() hovered = true; render() end)
    container.MouseLeave:Connect(function() hovered = false; render() end)
    container.MouseButton1Click:Connect(function()
        checked = not checked
        render()
        if opts.onChange then opts.onChange(checked) end
    end)

    render()

    local methods = {}
    function methods:SetChecked(v)
        checked = v; render()
        if opts.onChange then opts.onChange(checked) end
    end
    function methods:GetChecked() return checked end
    function methods:SetOnColor(c) opts.onColor = c; render() end
    function methods:SetOffColor(c) opts.offColor = c; render() end
    function methods:SetGlowColor(c) glow.Color = c end
    function methods:Destroy() container:Destroy() end
    return container, methods
end

-- picture
local function createPicture(parent, imageId, size, pos, opts)
    opts = opts or {}
    local img = Instance.new("ImageLabel")
    img.Name = "Picture"
    img.Size = size
    img.Position = pos
    img.BackgroundTransparency = opts.bgTransparency or 1
    img.BackgroundColor3 = opts.bg or Color3.fromRGB(255, 255, 255)
    img.Image = imageId
    img.ImageColor3 = opts.tint or Color3.fromRGB(255, 255, 255)
    img.ScaleType = opts.scaleType or Enum.ScaleType.Fit
    img.Parent = parent
    if opts.radius then applyCorner(img, opts.radius) end
    return img
end

-- minimize + close
local function addWindowControls(menu, titleBar, border, gui, theme)
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "Minimize"
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -52, 0.5, -11)
    minBtn.BackgroundColor3 = theme.minBtnBg
    minBtn.BorderSizePixel = 0
    minBtn.Text = "—"
    minBtn.TextColor3 = theme.minBtnText
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 3
    minBtn.Parent = titleBar
    applyCorner(minBtn, theme.radius)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -26, 0.5, -11)
    closeBtn.BackgroundColor3 = theme.closeBtnBg
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = theme.closeBtnText
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 3
    closeBtn.Parent = titleBar
    applyCorner(closeBtn, theme.radius)

    local minimized = false
    local originalSize = border.Size
    local minimizedLayer = nil

    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            minimizedLayer = menu.CurrentLayerName
            for _, layer in pairs(menu.Layers) do
                layer.Visible = false
            end
            originalSize = border.Size
            border.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 30)
        else
            if minimizedLayer then
                menu:SetLayer(minimizedLayer)
            end
            border.Size = originalSize
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    minBtn.MouseEnter:Connect(function() minBtn.BackgroundColor3 = theme.minBtnHover end)
    minBtn.MouseLeave:Connect(function() minBtn.BackgroundColor3 = theme.minBtnBg end)
    closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = theme.closeBtnHover end)
    closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = theme.closeBtnBg end)
end

-- text input
local function createTextInput(parent, size, pos, opts, theme)
    opts = opts or {}

    local box = Instance.new("TextBox")
    box.Name = "TextInput"
    box.Size = size
    box.Position = pos
    box.BackgroundColor3 = opts.bg or theme.inputBg
    box.BorderSizePixel = 0
    box.Text = opts.text or ""
    box.PlaceholderText = opts.placeholder or ""
    box.PlaceholderColor3 = opts.placeholderColor or theme.inputPlaceholder
    box.TextColor3 = opts.textColor or theme.inputText
    box.Font = opts.font or theme.inputFont
    box.TextSize = opts.textSize or theme.inputTextSize
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.MultiLine = false
    box.AutoButtonColor = false
    box.Parent = parent
    applyCorner(box, opts.radius or theme.radius)

    local paddingX = opts.paddingX or theme.inputPaddingX
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, paddingX)
    padding.PaddingRight = UDim.new(0, paddingX)
    padding.Parent = box

    local stroke = Instance.new("UIStroke")
    stroke.Color = opts.border or theme.inputBorder
    stroke.Thickness = opts.borderW or theme.inputBorderW
    stroke.Parent = box

    local maxLen = opts.maxLength
    if maxLen then box:GetPropertyChangedSignal("Text"):Connect(function()
        if #box.Text > maxLen then
            box.Text = box.Text:sub(1, maxLen)
        end
    end) end

    if opts.numbersOnly then
        box:GetPropertyChangedSignal("Text"):Connect(function()
            local filtered = box.Text:gsub("[^%d%-]", "")
            if filtered ~= box.Text then box.Text = filtered end
        end)
    end

    box.Focused:Connect(function()
        box.BackgroundColor3 = opts.focusBg or theme.inputFocusBg
        stroke.Color = opts.focusBorder or theme.inputFocusBorder
        stroke.Thickness = opts.focusBorderW or theme.inputFocusBorderW
        if opts.onFocus then opts.onFocus() end
    end)

    box.FocusLost:Connect(function(enterPressed)
        box.BackgroundColor3 = opts.bg or theme.inputBg
        stroke.Color = opts.border or theme.inputBorder
        stroke.Thickness = opts.borderW or theme.inputBorderW
        if opts.onFocusLost then opts.onFocusLost(box.Text, enterPressed) end
    end)

    box:GetPropertyChangedSignal("Text"):Connect(function()
        if opts.onChange then opts.onChange(box.Text) end
    end)

    local methods = {}
    function methods:GetText() return box.Text end
    function methods:SetText(t) box.Text = t end
    function methods:SetPlaceholder(t) box.PlaceholderText = t end
    function methods:SetBg(c) opts.bg = c; if not box:IsFocused() then box.BackgroundColor3 = c end end
    function methods:SetFocusBg(c) opts.focusBg = c end
    function methods:SetBorderColor(c) opts.border = c; if not box:IsFocused() then stroke.Color = c end end
    function methods:SetFocusBorderColor(c) opts.focusBorder = c end
    function methods:Destroy() box:Destroy() end
    return box, methods
end

-- api

function Mini_lib.new(title, size, pos, themeOverride, movable)
    local self = setmetatable({}, Mini_lib)
    self.Theme = merge(DEFAULT_THEME, themeOverride)
    self.Gui = makeGui()
    self.Layers = {}
    self._layerOrder = {}
    self.CurrentLayer = nil
    self.CurrentLayerName = nil

    self.Border, self.TitleBar = createBorder(
        self.Gui,
        size or UDim2.new(0, 320, 0, 440),
        pos or UDim2.new(0, 50, 0, 50),
        self.Theme,
        movable
    )
    self.TitleBar.Title.Text = title or "Mini_lib"

    -- дефолтный слой
    self:AddLayer("Main")

    addWindowControls(self, self.TitleBar, self.Border, self.Gui, self.Theme)
    return self
end

function Mini_lib:SetTheme(themeOverride)
    self.Theme = merge(self.Theme, themeOverride)
end

function Mini_lib:SetMovable(v)
    if self.Border and self.Border.DragArea then
        self.Border.DragArea.Visible = v and true or false
    end
end

-- слои

function Mini_lib:AddLayer(name)
    name = name or ("Layer" .. (#self._layerOrder + 1))
    if self.Layers[name] then return self.Layers[name] end

    local frame = Instance.new("Frame")
    frame.Name = "Layer_" .. name
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = (#self._layerOrder == 0)
    frame.ZIndex = 1
    frame.Parent = self.Border

    self.Layers[name] = frame
    table.insert(self._layerOrder, name)

    if self.CurrentLayer == nil then
        self.CurrentLayer = frame
        self.CurrentLayerName = name
    end
    return frame
end

function Mini_lib:SetLayer(name)
    local target = self.Layers[name]
    if not target then return false end
    for layerName, frame in pairs(self.Layers) do
        frame.Visible = (layerName == name)
    end
    self.CurrentLayer = target
    self.CurrentLayerName = name
    return true
end

function Mini_lib:GetLayer(name)
    return self.Layers[name]
end

-- получить родителя с учётом opts.layer

local function resolveParent(self, opts)
    opts = opts or {}
    if opts.layer then
        if not self.Layers[opts.layer] then
            self:AddLayer(opts.layer)
        end
        return self.Layers[opts.layer]
    end
    return self.CurrentLayer
end

-- элементы

function Mini_lib:Filler(size, pos, color, opts)
    opts = opts or {}
    return createFiller(resolveParent(self, opts), size, pos, color, opts, self.Theme)
end

function Mini_lib:Label(text, size, pos, opts)
    opts = opts or {}
    return createLabel(resolveParent(self, opts), text, size, pos, opts, self.Theme)
end

function Mini_lib:Button(size, pos, opts)
    opts = opts or {}
    return createButton(resolveParent(self, opts), size, pos, opts, self.Theme)
end

function Mini_lib:Key(size, pos, opts)
    opts = opts or {}
    return createKey(resolveParent(self, opts), size, pos, opts, self.Theme)
end

function Mini_lib:Slider(size, pos, opts)
    opts = opts or {}
    return createSlider(resolveParent(self, opts), size, pos, opts, self.Theme)
end

function Mini_lib:Checkbox(size, pos, opts)
    opts = opts or {}
    return createCheckbox(resolveParent(self, opts), size, pos, opts, self.Theme)
end

function Mini_lib:Picture(imageId, size, pos, opts)
    opts = opts or {}
    return createPicture(resolveParent(self, opts), imageId, size, pos, opts)
end

function Mini_lib:TextInput(size, pos, opts)
    opts = opts or {}
    return createTextInput(resolveParent(self, opts), size, pos, opts, self.Theme)
end

function Mini_lib:Destroy()
    if self.Gui then self.Gui:Destroy() end
end

return Mini_lib
