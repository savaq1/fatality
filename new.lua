local NEVERLOSE = loadstring(game:HttpGet("https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NEVERLOSE-UI-Nightly/main/source.lua"))()

-- Change Theme --
NEVERLOSE:Theme("dark")
------------------

local Window = NEVERLOSE:AddWindow("NEVERLOSE","Cheat Menu v4")
local Notification = NEVERLOSE:Notification()
Notification.MaxNotifications = 6

Window:AddTabLabel('Home')

-- ВКЛАДКИ --
local VisualTab = Window:AddTab('Visual','eye')
local RageTab = Window:AddTab('Rage','target')
local MiscTab = Window:AddTab('Misc','settings')
local SettingsTab = Window:AddTab('Settings','mouse')

-- ESP ПЕРЕМЕННЫЕ --
local espSelfEnabled = false
local espEnemiesEnabled = false
local espTeamEnabled = false

local espBoxes = {}
local espHealthBars = {}
local espNames = {}
local espTracers = {}  -- Если нужно, но не используем пока

local selfColor = Color3.fromRGB(0, 255, 0)
local enemyVisibleColor = Color3.fromRGB(0, 255, 0)
local enemyHiddenColor = Color3.fromRGB(0, 150, 255)
local teamColor = Color3.fromRGB(255, 255, 0)

-- ЧАМСЫ (WALLHACK) ПЕРЕМЕННЫЕ --
local chamsEnabled = false
local chamsSelfEnabled = false
local chamsEnemiesEnabled = false
local chamsTeamEnabled = false

local chamsMaterial = "Neon"
local chamsColorSelf = Color3.fromRGB(0, 255, 0)
local chamsColorEnemies = Color3.fromRGB(255, 0, 0)
local chamsColorTeam = Color3.fromRGB(255, 255, 0)
local chamsTransparency = 0.5

-- МАТЕРИАЛЫ (старые, но интегрируем с чамсами) --
local materials = {
    "Plastic", "Wood", "Slate", "Concrete", "CorrodedMetal", "DiamondPlate",
    "Foil", "Grass", "Ice", "Marble", "Granite", "Brick", "Pebble", "Sand",
    "Fabric", "SmoothPlastic", "Metal", "WoodPlanks", "Cobblestone",
    "Neon", "Glass", "ForceField"
}

local selectedMaterial = "Neon"
local materialColor = Color3.fromRGB(255, 0, 255)
local materialTransparency = 0.5
local materialEnabled = false

-- NOCLIP --
local noclipActive = false
local noclipConnection = nil
local noclipTimer = 0
local noclipRestartTime = 60
local noclipKey = Enum.KeyCode.N

-- ФУНКЦИЯ ПРОВЕРКИ ВИДИМОСТИ --
local function isPlayerVisible(player)
    if not player.Character then return false end
    
    local localPlayer = game.Players.LocalPlayer
    local localCharacter = localPlayer.Character
    if not localCharacter then return false end
    
    local camera = workspace.CurrentCamera
    local rayOrigin = camera.CFrame.Position
    
    local targetHead = player.Character:FindFirstChild("Head")
    if not targetHead then return false end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localCharacter, player.Character}
    
    local rayDirection = (targetHead.Position - rayOrigin).Unit
    local distance = (targetHead.Position - rayOrigin).Magnitude
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection * distance, raycastParams)
    
    return raycastResult == nil
end

-- ФУНКЦИЯ ОБНОВЛЕНИЯ ESP (исправленная, с отдельными опциями) --
local function updateESP()
    local localPlayer = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    -- Очищаем старые элементы для игроков вне экрана или отключенных
    for player, _ in pairs(espBoxes) do
        if not player.Parent or not player.Character then
            if espBoxes[player] then espBoxes[player]:Destroy() end
            if espHealthBars[player] then espHealthBars[player].Gui:Destroy() end
            if espNames[player] then espNames[player].Gui:Destroy() end
            espBoxes[player] = nil
            espHealthBars[player] = nil
            espNames[player] = nil
        end
    end
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local head = character:FindFirstChild("Head")
            
            if humanoid and head and humanoid.Health > 0 then
                local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local shouldShow = false
                    local espColor = Color3.fromRGB(255, 255, 255)  -- Дефолт
                    
                    -- Определяем, показывать ли
                    if player == localPlayer and espSelfEnabled then
                        shouldShow = true
                        espColor = selfColor
                    elseif player.Team == localPlayer.Team and espTeamEnabled then
                        shouldShow = true
                        espColor = teamColor
                    elseif player.Team ~= localPlayer.Team and espEnemiesEnabled then
                        shouldShow = true
                        local isVisible = isPlayerVisible(player)
                        espColor = isVisible and enemyVisibleColor or enemyHiddenColor
                    end
                    
                    if shouldShow then
                        -- БОКС --
                        if not espBoxes[player] then
                            local box = Instance.new("BoxHandleAdornment")
                            box.Name = "ESPBox_" .. player.Name
                            box.Adornee = character  -- Исправлено: на весь character, не только head
                            box.Size = Vector3.new(4, 6, 0)  -- Улучшено для полного бокса
                            box.Transparency = 0.7
                            box.Color3 = espColor
                            box.AlwaysOnTop = true
                            box.ZIndex = 10
                            box.Parent = camera  -- Лучше в camera для стабильности
                            espBoxes[player] = box
                        else
                            espBoxes[player].Color3 = espColor
                            espBoxes[player].Adornee = character
                        end
                        
                        -- HP BAR (исправлено позиционирование) --
                        if not espHealthBars[player] then
                            local gui = Instance.new("ScreenGui")
                            gui.Name = "ESPHealth_" .. player.Name
                            gui.Parent = game.CoreGui
                            gui.ResetOnSpawn = false
                            
                            local bar = Instance.new("Frame")
                            bar.Name = "HealthBar"
                            bar.Size = UDim2.new(0, 4, 0, 50)
                            bar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            bar.BorderSizePixel = 0
                            bar.Parent = gui
                            
                            local fill = Instance.new("Frame")
                            fill.Name = "HealthFill"
                            fill.Size = UDim2.new(1, 0, humanoid.Health / humanoid.MaxHealth, 0)
                            fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                            fill.BorderSizePixel = 0
                            fill.Parent = bar
                            
                            espHealthBars[player] = {Gui = gui, Bar = bar, Fill = fill}
                        else
                            local data = espHealthBars[player]
                            data.Bar.Position = UDim2.new(0, headPos.X - 10, 0, headPos.Y - 25)
                            local hpPercent = humanoid.Health / humanoid.MaxHealth
                            data.Fill.Size = UDim2.new(1, 0, hpPercent, 0)
                            if hpPercent > 0.6 then
                                data.Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                            elseif hpPercent > 0.3 then
                                data.Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                            else
                                data.Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                            end
                        end
                        
                        -- ИМЯ --
                        if not espNames[player] then
                            local gui = Instance.new("ScreenGui")
                            gui.Name = "ESPName_" .. player.Name
                            gui.Parent = game.CoreGui
                            gui.ResetOnSpawn = false
                            
                            local label = Instance.new("TextLabel")
                            label.Name = "PlayerName"
                            label.Text = player.Name
                            label.Size = UDim2.new(0, 100, 0, 20)
                            label.Position = UDim2.new(0, headPos.X - 50, 0, headPos.Y - 60)
                            label.TextColor3 = espColor
                            label.BackgroundTransparency = 1
                            label.TextSize = 14
                            label.Font = Enum.Font.SourceSansBold
                            label.TextStrokeTransparency = 0
                            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            label.Parent = gui
                            
                            espNames[player] = {Gui = gui, Label = label}
                        else
                            local data = espNames[player]
                            data.Label.Position = UDim2.new(0, headPos.X - 50, 0, headPos.Y - 60)
                            data.Label.TextColor3 = espColor
                        end
                    else
                        -- Скрываем если не нужно показывать
                        if espBoxes[player] then espBoxes[player].Adornee = nil end
                        if espHealthBars[player] then espHealthBars[player].Gui.Enabled = false end
                        if espNames[player] then espNames[player].Gui.Enabled = false end
                    end
                else
                    -- Не на экране
                    if espBoxes[player] then espBoxes[player].Adornee = nil end
                    if espHealthBars[player] then espHealthBars[player].Gui.Enabled = false end
                    if espNames[player] then espNames[player].Gui.Enabled = false end
                end
            end
        end
    end
end

-- ОЧИСТКА ESP --
local function clearESP()
    for player, box in pairs(espBoxes) do
        if box then box:Destroy() end
    end
    espBoxes = {}
    
    for player, data in pairs(espHealthBars) do
        if data.Gui then data.Gui:Destroy() end
    end
    espHealthBars = {}
    
    for player, data in pairs(espNames) do
        if data.Gui then data.Gui:Destroy() end
    end
    espNames = {}
end

-- ЧАМСЫ ФУНКЦИЯ (новая, для видимости сквозь стены) --
local function updateChams()
    if not chamsEnabled then return end
    
    local localPlayer = game.Players.LocalPlayer
    
    -- Применяем к себе
    if localPlayer.Character and chamsSelfEnabled then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then  -- Исключаем root для стабильности
                part.Material = Enum.Material[chamsMaterial]
                part.Color = chamsColorSelf
                part.Transparency = chamsTransparency
                part.CanCollide = false  -- Для чамсов
            end
        end
    end
    
    -- Применяем к другим
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local shouldApply = false
            local chamsColor = Color3.fromRGB(255, 255, 255)
            
            if player.Team == localPlayer.Team and chamsTeamEnabled then
                shouldApply = true
                chamsColor = chamsColorTeam
            elseif player.Team ~= localPlayer.Team and chamsEnemiesEnabled then
                shouldApply = true
                chamsColor = chamsColorEnemies
            end
            
            if shouldApply then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Material = Enum.Material[chamsMaterial]
                        part.Color = chamsColor
                        part.Transparency = chamsTransparency
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end

-- МАТЕРИАЛЫ (старые, теперь интегрированы с чамсами, но оставляем как опцию) --
local function applyMaterials()
    if not materialEnabled then return end
    
    local localPlayer = game.Players.LocalPlayer
    
    if localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material[selectedMaterial]
                part.Color = materialColor
                part.Transparency = materialTransparency
            end
        end
    end
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material[selectedMaterial]
                    part.Color = materialColor
                    part.Transparency = materialTransparency
                end
            end
        end
    end
end

-- NOCLIP ФУНКЦИИ (исправленные) --
local function enableNoclip()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        noclipActive = true
        
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if noclipActive and character and character.Parent then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        Notification:Notify("success","Noclip","Активирован")
    end
end

local function disableNoclip()
    noclipActive = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    Notification:Notify("info","Noclip","Деактивирован")
end

-- ГОРЯЧАЯ КЛАВИША NOCLIP --
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == noclipKey then
        if noclipActive then
            disableNoclip()
        else
            enableNoclip()
        end
    end
end)

-- ТАЙМЕР ПЕРЕЗАПУСКА --
game:GetService("RunService").Heartbeat:Connect(function(delta)
    if noclipActive then
        noclipTimer = noclipTimer + delta
        if noclipTimer >= noclipRestartTime then
            noclipTimer = 0
            disableNoclip()
            task.wait(0.1)
            enableNoclip()
        end
    end
end)

-- ЭКРАННЫЕ КНОПКИ (оставляем как есть) --
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NeverloseButtons"
screenGui.Parent = game.CoreGui
screenGui.ResetOnSpawn = false

local buttons = {}
local buttonKeys = {"G", "H", "J", "K", "L"}

for i, key in ipairs(buttonKeys) do
    local button = Instance.new("TextButton")
    button.Name = key
    button.Text = key
    button.Size = UDim2.new(0, 45, 0, 45)
    button.Position = UDim2.new(0, 10, 0, 100 + (i-1) * 55)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(80, 80, 90)
    button.Parent = screenGui
    
    button.MouseButton1Click:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
        task.wait(0.2)
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Notification:Notify("info","Кнопка " .. key, "Нажата")
    end)
    
    table.insert(buttons, button)
end

-- ВКЛАДКА VISUAL - ESP --
local VisualESPSection = VisualTab:AddSection('ESP Settings', "left")

VisualESPSection:AddToggle('ESP на себе', false, function(val)
    espSelfEnabled = val
    if val then
        Notification:Notify("success","ESP Self","Активирован")
    end
    updateESP()  -- Обновляем сразу
end)

VisualESPSection:AddToggle('ESP на врагах', false, function(val)
    espEnemiesEnabled = val
    if val then
        Notification:Notify("success","ESP Enemies","Активирован")
    end
    updateESP()
end)

VisualESPSection:AddToggle('ESP на тиммейтах', false, function(val)
    espTeamEnabled = val
    if val then
        Notification:Notify("success","ESP Team","Активирован")
    end
    updateESP()
end)

local VisualColorsSection = VisualTab:AddSection('ESP Colors', "right")

VisualColorsSection:AddColorPicker('Цвет себя', selfColor, function(val)
    selfColor = val
    updateESP()
end)

VisualColorsSection:AddColorPicker('Видимые враги', enemyVisibleColor, function(val)
    enemyVisibleColor = val
    updateESP()
end)

VisualColorsSection:AddColorPicker('Скрытые враги', enemyHiddenColor, function(val)
    enemyHiddenColor = val
    updateESP()
end)

VisualColorsSection:AddColorPicker('Цвет тиммейтов', teamColor, function(val)
    teamColor = val
    updateESP()
end)

VisualColorsSection:AddSlider('Прозрачность боксов', 0, 100, 70, function(val)
    local transparency = val / 100
    for _, box in pairs(espBoxes) do
        if box then box.Transparency = transparency end
    end
end)

-- ВКЛАДКА VISUAL - ЧАМСЫ --
local VisualChamsSection = VisualTab:AddSection('Chams (Wallhack)', "left")

VisualChamsSection:AddToggle('Включить чамсы', false, function(val)
    chamsEnabled = val
    if val then
        Notification:Notify("success","Chams","Активированы")
    else
        Notification:Notify("info","Chams","Деактивированы")
    end
    updateChams()
end)

VisualChamsSection:AddToggle('Чамсы на себе', false, function(val)
    chamsSelfEnabled = val
    updateChams()
end)

VisualChamsSection:AddToggle('Чамсы на врагах', false, function(val)
    chamsEnemiesEnabled = val
    updateChams()
end)

VisualChamsSection:AddToggle('Чамсы на тиммейтах', false, function(val)
    chamsTeamEnabled = val
    updateChams()
end)

VisualChamsSection:AddDropdown('Материал чамсов', materials, 20, function(val)
    chamsMaterial = val
    updateChams()
end)

VisualChamsSection:AddColorPicker('Цвет чамсов себя', chamsColorSelf, function(val)
    chamsColorSelf = val
    updateChams()
end)

VisualChamsSection:AddColorPicker('Цвет чамсов врагов', chamsColorEnemies, function(val)
    chamsColorEnemies = val
    updateChams()
end)

VisualChamsSection:AddColorPicker('Цвет чамсов тиммейтов', chamsColorTeam, function(val)
    chamsColorTeam = val
    updateChams()
end)

VisualChamsSection:AddSlider('Прозрачность чамсов', 0, 100, 50, function(val)
    chamsTransparency = val / 100
    updateChams()
end)

-- ВКЛАДКА VISUAL - МАТЕРИАЛЫ (старые) --
local VisualMaterialsSection = VisualTab:AddSection('Materials', "right")

VisualMaterialsSection:AddToggle('Включить материалы', false, function(val)
    materialEnabled = val
    if val then
        applyMaterials()
        Notification:Notify("success","Материалы","Активированы")
    else
        Notification:Notify("info","Материалы","Деактивированы")
    end
end)

VisualMaterialsSection:AddDropdown('Материал', materials, 20, function(val)
    selectedMaterial = val
    if materialEnabled then
        applyMaterials()
    end
end)

VisualMaterialsSection:AddColorPicker('Цвет', materialColor, function(val)
    materialColor = val
    if materialEnabled then
        applyMaterials()
    end
end)

VisualMaterialsSection:AddSlider('Прозрачность', 0, 100, 50, function(val)
    materialTransparency = val/100
    if materialEnabled then
        applyMaterials()
    end
end)

-- ВКЛАДКА RAGE (оставляем как есть) --
local RageSection = RageTab:AddSection('Rage Functions', "left")

RageSection:AddButton('Активировать', function()
    Notification:Notify("info","Rage", "Активировано")
end)

RageSection:AddSlider('Скорость', 1, 10, 5, function(val)
    print("Rage скорость:", val)
end)

-- ВКЛАДКА MISC (исправленный Noclip, теперь отображается) --
local MiscNoclipSection = MiscTab:AddSection('Noclip Settings', "left")

MiscNoclipSection:AddToggle('Noclip (вкл/выкл)', false, function(val)
    if val then
        enableNoclip()
    else
        disableNoclip()
    end
end)

MiscNoclipSection:AddSlider('Перезапуск (сек)', 10, 300, 60, function(val)
    noclipRestartTime = val
end)

MiscNoclipSection:AddKeybind('Горячая клавиша', noclipKey, function(val)
    noclipKey = val
end)

-- Добавляем лейбл для статуса noclip
MiscNoclipSection:AddLabel("Статус Noclip: " .. (noclipActive and "Активен" or "Неактивен"))

local MiscButtonsSection = MiscTab:AddSection('Экранные кнопки', "right")

MiscButtonsSection:AddToggle('Показать кнопки', true, function(val)
    screenGui.Enabled = val
end)

MiscButtonsSection:AddButton('Тест кнопок', function()
    for _, btn in pairs(buttons) do
        btn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
    task.wait(0.5)
    for _, btn in pairs(buttons) do
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end
end)

-- ВКЛАДКА SETTINGS --
local SettingsMain = SettingsTab:AddSection('Настройки', "left")

SettingsMain:AddButton('Сбросить всё', function()
    disableNoclip()
    clearESP()
    chamsEnabled = false
    materialEnabled = false
    espSelfEnabled = false
    espEnemiesEnabled = false
    espTeamEnabled = false
    chamsSelfEnabled = false
    chamsEnemiesEnabled = false
    chamsTeamEnabled = false
    Notification:Notify("warning","Сброс", "Все функции отключены")
end)

SettingsMain:AddLabel("Управление:")
SettingsMain:AddLabel("Noclip: " .. tostring(noclipKey.Name))
SettingsMain:AddLabel("Кнопки: G H J K L")

-- ОСНОВНОЙ ЦИКЛ ESP И ЧАМСОВ --
game:GetService("RunService").RenderStepped:Connect(function()  -- Исправлено на RenderStepped для плавности
    if espSelfEnabled or espEnemiesEnabled or espTeamEnabled then
        updateESP()
    end
    if chamsEnabled then
        updateChams()
    end
end)

-- ОЧИСТКА ПРИ ВЫХОДЕ ИГРОКА --
game.Players.PlayerRemoving:Connect(function(player)
    if espBoxes[player] then
        espBoxes[player]:Destroy()
        espBoxes[player] = nil
    end
    if espHealthBars[player] then
        espHealthBars[player].Gui:Destroy()
        espHealthBars[player] = nil
    end
    if espNames[player] then
        espNames[player].Gui:Destroy()
        espNames[player] = nil
    end
end)

-- АВТОЗАПУСК ПРИ РЕСПАВНЕ --
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if noclipActive then
        enableNoclip()
    end
    if materialEnabled then
        applyMaterials()
    end
    if chamsEnabled then
        updateChams()
    end
end)

-- ЗАПУСК --
task.wait(1)
Notification:Notify("success","NEVERLOSE v4 Fixed", "Загружен с исправлениями ESP, Chams и Noclip!")
print("✅ NeverLose UI v4 Fixed готов к работе")