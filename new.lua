local NEVERLOSE = loadstring(game:HttpGet("https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NEVERLOSE-UI-Nightly/main/source.lua"))()

-- Change Theme --
NEVERLOSE:Theme("dark") -- [ dark , nightly , original ]
------------------

local Window = NEVERLOSE:AddWindow("NEVERLOSE","Cheat Menu v2")
local Notification = NEVERLOSE:Notification()

Notification.MaxNotifications = 6

Window:AddTabLabel('Home')

-- СОЗДАЁМ ВСЕ ВКЛАДКИ --
local VisualTab = Window:AddTab('Visual','eye')
local RageTab = Window:AddTab('Rage','target')
local MiscTab = Window:AddTab('Misc','settings')
local SettingsTab = Window:AddTab('Settings','mouse')

-- ПЕРЕМЕННЫЕ ДЛЯ ESP --
local espEnabled = false
local espBoxes = {}
local espHealthBars = {}
local espNames = {}
local espTracers = {}
local espTeamCheck = false

local selfColor = Color3.fromRGB(0, 255, 0)  -- Зелёный для себя
local enemyVisibleColor = Color3.fromRGB(0, 255, 0)  -- Зелёный для видимых врагов
local enemyHiddenColor = Color3.fromRGB(0, 150, 255)  -- Голубой для невидимых врагов
local teamColor = Color3.fromRGB(255, 255, 0)  -- Жёлтый для тиммейтов

-- ПЕРЕМЕННЫЕ ДЛЯ МАТЕРИАЛОВ --
local materials = {
    "Plastic", "Wood", "Slate", "Concrete", "CorrodedMetal", "DiamondPlate",
    "Foil", "Grass", "Ice", "Marble", "Granite", "Brick", "Pebble", "Sand",
    "Fabric", "SmoothPlastic", "Metal", "WoodPlanks", "Cobblestone",
    "Neon", "Glass", "ForceField", "Air", "Water", "Rock", "Snow"
}

local selectedMaterial = "Neon"
local materialColor = Color3.fromRGB(255, 0, 255)
local materialTransparency = 0.5
local materialEnabled = false

-- ПЕРЕМЕННЫЕ ДЛЯ NOCLIP --
local noclipActive = false
local noclipConnection = nil
local noclipTimer = 0
local noclipRestartTime = 60
local noclipKey = Enum.KeyCode.N

-- ФУНКЦИЯ ДЛЯ ПРОВЕРКИ ВИДИМОСТИ --
local function isPlayerVisible(player)
    if not player.Character then return false end
    
    local localPlayer = game.Players.LocalPlayer
    local localCharacter = localPlayer.Character
    if not localCharacter then return false end
    
    local localHead = localCharacter:FindFirstChild("Head")
    local targetHead = player.Character:FindFirstChild("Head")
    
    if not localHead or not targetHead then return false end
    
    -- Используем Camera вместо Head для лучшей точности
    local camera = workspace.CurrentCamera
    local rayOrigin = camera.CFrame.Position
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localCharacter, player.Character, camera}
    
    local rayDirection = (targetHead.Position - rayOrigin).Unit
    local distance = (targetHead.Position - rayOrigin).Magnitude
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection * distance, raycastParams)
    
    return raycastResult == nil
end

-- ФУНКЦИЯ ОБНОВЛЕНИЯ ESP --
local function updateESP()
    if not espEnabled then return end
    
    local localPlayer = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local head = character:FindFirstChild("Head")
            
            if humanoid and head and humanoid.Health > 0 then
                -- Проверяем, находится ли игрок на экране
                local headPosition, onScreen = camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    -- Определяем цвет
                    local espColor
                    local isVisible = isPlayerVisible(player)
                    
                    if player.Team == localPlayer.Team and espTeamCheck then
                        espColor = teamColor
                    elseif player == localPlayer then
                        espColor = selfColor
                    else
                        if isVisible then
                            espColor = enemyVisibleColor
                        else
                            espColor = enemyHiddenColor
                        end
                    end
                    
                    -- СОЗДАЁМ БОКС (ЧАМСЫ) --
                    if not espBoxes[player] then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "ESPBox_" .. player.Name
                        box.Adornee = character
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Size = Vector3.new(4, 6, 1)
                        box.Transparency = 0.3
                        box.Color3 = espColor
                        box.Parent = workspace
                        
                        espBoxes[player] = box
                    else
                        espBoxes[player].Color3 = espColor
                        espBoxes[player].Adornee = character
                        espBoxes[player].Visible = true
                    end
                    
                    -- СОЗДАЁМ ИНДИКАТОР HP --
                    if not espHealthBars[player] then
                        -- Создаём ScreenGui для HP баров
                        local screenGui = Instance.new("ScreenGui")
                        screenGui.Name = "ESPHealth_" .. player.Name
                        screenGui.Parent = game.CoreGui
                        screenGui.ResetOnSpawn = false
                        
                        local healthBar = Instance.new("Frame")
                        healthBar.Name = "HealthBar"
                        healthBar.Size = UDim2.new(0, 50, 0, 6)
                        healthBar.Position = UDim2.new(0, headPosition.X - 25, 0, headPosition.Y - 40)
                        healthBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        healthBar.BorderSizePixel = 1
                        healthBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        healthBar.Parent = screenGui
                        
                        local healthFill = Instance.new("Frame")
                        healthFill.Name = "HealthFill"
                        healthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
                        healthFill.Position = UDim2.new(0, 0, 0, 0)
                        healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        healthFill.BorderSizePixel = 0
                        healthFill.Parent = healthBar
                        
                        espHealthBars[player] = {ScreenGui = screenGui, Bar = healthBar, Fill = healthFill}
                    else
                        local healthData = espHealthBars[player]
                        local headPositionUpdate = camera:WorldToViewportPoint(head.Position)
                        
                        if healthData.Bar then
                            healthData.Bar.Position = UDim2.new(0, headPositionUpdate.X - 25, 0, headPositionUpdate.Y - 40)
                            
                            if healthData.Fill then
                                local healthPercent = humanoid.Health / humanoid.MaxHealth
                                healthData.Fill.Size = UDim2.new(healthPercent, 0, 1, 0)
                                
                                -- Меняем цвет в зависимости от HP
                                if healthPercent > 0.6 then
                                    healthData.Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                                elseif healthPercent > 0.3 then
                                    healthData.Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                                else
                                    healthData.Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                                end
                            end
                        end
                    end
                    
                    -- СОЗДАЁМ ИМЯ ИГРОКА --
                    if not espNames[player] then
                        local screenGui = Instance.new("ScreenGui")
                        screenGui.Name = "ESPName_" .. player.Name
                        screenGui.Parent = game.CoreGui
                        screenGui.ResetOnSpawn = false
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Name = "PlayerName"
                        nameLabel.Text = player.Name
                        nameLabel.Size = UDim2.new(0, 100, 0, 20)
                        nameLabel.Position = UDim2.new(0, headPosition.X - 50, 0, headPosition.Y - 60)
                        nameLabel.TextColor3 = espColor
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextSize = 14
                        nameLabel.Font = Enum.Font.SourceSansBold
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        nameLabel.Parent = screenGui
                        
                        espNames[player] = {ScreenGui = screenGui, Label = nameLabel}
                    else
                        local nameData = espNames[player]
                        local headPositionUpdate = camera:WorldToViewportPoint(head.Position)
                        
                        if nameData.Label then
                            nameData.Label.Position = UDim2.new(0, headPositionUpdate.X - 50, 0, headPositionUpdate.Y - 60)
                            nameData.Label.TextColor3 = espColor
                        end
                    end
                    
                    -- СОЗДАЁМ ТРЕЙСЕРЫ (ЛИНИИ К ИГРОКАМ) --
                    if not espTracers[player] then
                        local screenGui = Instance.new("ScreenGui")
                        screenGui.Name = "ESPTracer_" .. player.Name
                        screenGui.Parent = game.CoreGui
                        screenGui.ResetOnSpawn = false
                        
                        local tracer = Instance.new("Frame")
                        tracer.Name = "Tracer"
                        tracer.BackgroundColor3 = espColor
                        tracer.BorderSizePixel = 0
                        tracer.Parent = screenGui
                        
                        espTracers[player] = {ScreenGui = screenGui, Line = tracer}
                    else
                        local tracerData = espTracers[player]
                        local headPositionUpdate = camera:WorldToViewportPoint(head.Position)
                        
                        if tracerData.Line then
                            local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            
                            tracerData.Line.Size = UDim2.new(0, 2, 0, (Vector2.new(headPositionUpdate.X, headPositionUpdate.Y) - screenCenter).Magnitude)
                            tracerData.Line.Position = UDim2.new(0, screenCenter.X - 1, 0, screenCenter.Y)
                            tracerData.Line.Rotation = math.deg(math.atan2(headPositionUpdate.Y - screenCenter.Y, headPositionUpdate.X - screenCenter.X)) + 90
                            tracerData.Line.BackgroundColor3 = espColor
                        end
                    end
                else
                    -- Если игрок не на экране, скрываем ESP
                    if espBoxes[player] then
                        espBoxes[player].Visible = false
                    end
                    if espHealthBars[player] then
                        espHealthBars[player].Bar.Visible = false
                    end
                    if espNames[player] then
                        espNames[player].Label.Visible = false
                    end
                    if espTracers[player] then
                        espTracers[player].Line.Visible = false
                    end
                end
            end
        end
    end
end

-- ФУНКЦИЯ ОЧИСТКИ ESP --
local function clearESP()
    for player, box in pairs(espBoxes) do
        box:Destroy()
    end
    espBoxes = {}
    
    for player, healthData in pairs(espHealthBars) do
        if healthData.ScreenGui then
            healthData.ScreenGui:Destroy()
        end
    end
    espHealthBars = {}
    
    for player, nameData in pairs(espNames) do
        if nameData.ScreenGui then
            nameData.ScreenGui:Destroy()
        end
    end
    espNames = {}
    
    for player, tracerData in pairs(espTracers) do
        if tracerData.ScreenGui then
            tracerData.ScreenGui:Destroy()
        end
    end
    espTracers = {}
end

-- ФУНКЦИЯ ПРИМЕНЕНИЯ МАТЕРИАЛОВ --
local function applyMaterials()
    if not materialEnabled then return end
    
    local localPlayer = game.Players.LocalPlayer
    
    -- Применяем к себе
    if localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material[selectedMaterial]
                part.Color = materialColor
                part.Transparency = materialTransparency
            end
        end
    end
    
    -- Применяем к другим игрокам
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

-- ФУНКЦИИ NOCLIP --
local function enableNoclip()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        noclipActive = true
        
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if noclipActive and character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        Notification:Notify("success","Noclip","Активирован (перезапуск каждые " .. noclipRestartTime .. " сек)")
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

-- ТАЙМЕР ПЕРЕЗАПУСКА NOCLIP --
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

-- ГОРЯЧИЕ КЛАВИШИ ДЛЯ NOCLIP --
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == noclipKey then
        if noclipActive then
            disableNoclip()
        else
            enableNoclip()
        end
    end
end)

-- ЭКРАННЫЕ КНОПКИ --
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NeverloseButtons"
screenGui.Parent = game.CoreGui
screenGui.ResetOnSpawn = false

local buttons = {}
local buttonKeys = {"G", "H", "J", "K", "L"}

local function createScreenButton(key, position)
    local button = Instance.new("TextButton")
    button.Name = key
    button.Text = key
    button.Size = UDim2.new(0, 45, 0, 45)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(80, 80, 90)
    button.Parent = screenGui
    
    button.MouseButton1Click:Connect(function()
        -- Визуальная обратная связь
        local originalColor = button.BackgroundColor3
        button.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
        
        -- Эмуляция действия
        if key == "G" then
            Notification:Notify("info","Кнопка G", "Активирована функция 1")
        elseif key == "H" then
            Notification:Notify("info","Кнопка H", "Активирована функция 2")
        elseif key == "J" then
            Notification:Notify("info","Кнопка J", "Активирована функция 3")
        elseif key == "K" then
            Notification:Notify("info","Кнопка K", "Активирована функция 4")
        elseif key == "L" then
            Notification:Notify("info","Кнопка L", "Активирована функция 5")
        end
        
        task.wait(0.2)
        button.BackgroundColor3 = originalColor
    end)
    
    table.insert(buttons, button)
end

-- Создаём кнопки в столбик
for i, key in ipairs(buttonKeys) do
    createScreenButton(key, UDim2.new(0, 10, 0, 100 + (i-1) * 55))
end

-- ВКЛАДКА VISUAL --
local VisualESPSection = VisualTab:AddSection('ESP Settings', "left")

VisualESPSection:AddToggle('Включить ESP', false, function(val)
    espEnabled = val
    if val then
        Notification:Notify("success","ESP","Активирован")
    else
        clearESP()
        Notification:Notify("info","ESP","Деактивирован")
    end
end)

VisualESPSection:AddToggle('Показывать Box', true, function(val)
    for _, box in pairs(espBoxes) do
        box.Visible = val
    end
end)

VisualESPSection:AddToggle('Показывать HP Bar', true, function(val)
    for _, healthData in pairs(espHealthBars) do
        if healthData.Bar then
            healthData.Bar.Visible = val
        end
    end
end)

VisualESPSection:AddToggle('Показывать имена', true, function(val)
    for _, nameData in pairs(espNames) do
        if nameData.Label then
            nameData.Label.Visible = val
        end
    end
end)

VisualESPSection:AddToggle('Показывать трейсеры', false, function(val)
    for _, tracerData in pairs(espTracers) do
        if tracerData.Line then
            tracerData.Line.Visible = val
        end
    end
end)

VisualESPSection:AddToggle('Показывать тиммейтов', false, function(val)
    espTeamCheck = val
end)

local VisualColorsSection = VisualTab:AddSection('ESP Colors', "right")

VisualColorsSection:AddColorPicker('Цвет себя', selfColor, function(val)
    selfColor = val
end)

VisualColorsSection:AddColorPicker('Видимые враги', enemyVisibleColor, function(val)
    enemyVisibleColor = val
end)

VisualColorsSection:AddColorPicker('Скрытые враги', enemyHiddenColor, function(val)
    enemyHiddenColor = val
end)

VisualColorsSection:AddColorPicker('Тиммейты', teamColor, function(val)
    teamColor = val
end)

VisualColorsSection:AddSlider('Прозрачность боксов', 0, 100, 30, function(val)
    for _, box in pairs(espBoxes) do
        box.Transparency = val/100
    end
end)

-- ВКЛАДКА VISUAL - МАТЕРИАЛЫ --
local VisualMaterialsSection = VisualTab:AddSection('Materials', "left")

VisualMaterialsSection:AddToggle('Включить материалы', false, function(val)
    materialEnabled = val
    if val then
        applyMaterials()
        Notification:Notify("success","Материалы","Активированы")
    else
        Notification:Notify("info","Материалы","Деактивированы")
    end
end)

VisualMaterialsSection:AddDropdown('Выбрать материал', materials, 20, function(val)  -- 20 = Neon
    selectedMaterial = val
    if materialEnabled then
        applyMaterials()
    end
end)

VisualMaterialsSection:AddColorPicker('Цвет материалов', materialColor, function(val)
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

VisualMaterialsSection:AddButton('Применить материалы', function()
    applyMaterials()
    Notification:Notify("info","Материалы","Применены")
end)

-- ВКЛАДКА RAGE --
local RageMainSection = RageTab:AddSection('Rage Functions', "left")

RageMainSection:AddButton('Тестовая функция 1', function()
    Notification:Notify("info","Rage", "Функция 1 активирована")
end)

RageMainSection:AddButton('Тестовая функция 2', function()
    Notification:Notify("info","Rage", "Функция 2 активирована")
end)

RageMainSection:AddSlider('Параметр 1', 0, 100, 50, function(val)
    print("Rage параметр 1:", val)
end)

RageMainSection:AddSlider('Параметр 2', 0, 100, 50, function(val)
    print("Rage параметр 2:", val)
end)

-- ВКЛАДКА MISC --
local MiscNoclipSection = MiscTab:AddSection('Noclip', "left")

MiscNoclipSection:AddToggle('Noclip', false, function(val)
    if val then
        enableNoclip()
    else
        disableNoclip()
    end
end)

MiscNoclipSection:AddSlider('Время перезапуска (сек)', 10, 300, 60, function(val)
    noclipRestartTime = val
end)

MiscNoclipSection:AddKeybind('Горячая клавиша', noclipKey, function(val)
    noclipKey = val
end)

local MiscButtonsSection = MiscTab:AddSection('Экранные кнопки', "right")

MiscButtonsSection:AddToggle('Показывать кнопки', true, function(val)
    screenGui.Enabled = val
end)

MiscButtonsSection:AddButton('Тест кнопок', function()
    for _, button in pairs(buttons) do
        local originalColor = button.BackgroundColor3
        button.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(0.1)
        button.BackgroundColor3 = originalColor
    end
end)

MiscButtonsSection:AddButton('Перезапустить ESP', function()
    clearESP()
    if espEnabled then
        Notification:Notify("info","ESP","Перезапущен")
    end
end)

-- ВКЛАДКА SETTINGS --
local SettingsMainSection = SettingsTab:AddSection('Основные настройки', "left")

SettingsMainSection:AddButton('Сохранить настройки', function()
    local settings = {
        espEnabled = espEnabled,
        noclipActive = noclipActive,
        materialEnabled = materialEnabled,
        espTeamCheck = espTeamCheck,
        noclipRestartTime = noclipRestartTime
    }
    
    Notification:Notify("success","Настройки","Сохранены")
end)

SettingsMainSection:AddButton('Загрузить настройки', function()
    Notification:Notify("info","Настройки","Загружены (симуляция)")
end)

SettingsMainSection:AddButton('Сбросить всё', function()
    disableNoclip()
    clearESP()
    materialEnabled = false
    Notification:Notify("warning","Сброс","Все функции отключены")
end)

local SettingsInfoSection = SettingsTab:AddSection('Информация', "right")

SettingsInfoSection:AddLabel("Управление:")
SettingsInfoSection:AddLabel("Noclip: " .. tostring(noclipKey.Name))
SettingsInfoSection:AddLabel("Экранные кнопки: G, H, J, K, L")
SettingsInfoSection:AddLabel("")
SettingsInfoSection:AddLabel("ESP работает на Heartbeat")
SettingsInfoSection:AddLabel("ROJECT mode v2")

-- ОСНОВНОЙ ЦИКЛ ДЛЯ ESP --
local espLoop = game:GetService("RunService").Heartbeat:Connect(function(delta)
    if espEnabled then
        updateESP()
    end
end)

-- ОБРАБОТКА ВЫХОДА ИГРОКОВ --
game.Players.PlayerRemoving:Connect(function(player)
    if espBoxes[player] then
        espBoxes[player]:Destroy()
        espBoxes[player] = nil
    end
    if espHealthBars[player] then
        if espHealthBars[player].ScreenGui then
            espHealthBars[player].ScreenGui:Destroy()
        end
        espHealthBars[player] = nil
    end
    if espNames[player] then
        if espNames[player].ScreenGui then
            espNames[player].ScreenGui:Destroy()
        end
        espNames[player] = nil
    end
    if espTracers[player] then
        if espTracers[player].ScreenGui then
            espTracers[player].ScreenGui:Destroy()
        end
        espTracers[player] = nil
    end
end)

-- АВТОЗАПУСК ПРИ РЕСПАВНЕ --
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
    if noclipActive then
        task.wait(1)
        enableNoclip()
    end
    
    if materialEnabled then
        task.wait(1)
        applyMaterials()
    end
    
    -- Пересоздаём экранные кнопки
    if not screenGui or not screenGui.Parent then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "NeverloseButtons"
        screenGui.Parent = game.CoreGui
        screenGui.ResetOnSpawn = false
        
        buttons = {}
        for i, key in ipairs(buttonKeys) do
            createScreenButton(key, UDim2.new(0, 10, 0, 100 + (i-1) * 55))
        end
    end
end)

-- УВЕДОМЛЕНИЕ ПРИ ЗАПУСКЕ --
task.wait(2)
Notification:Notify("success","NEVERLOSE v2", "Скрипт загружен!")
Notification:Notify("info","Управление", "Noclip: " .. tostring(noclipKey.Name) .. "\nКнопки: G, H, J, K, L")