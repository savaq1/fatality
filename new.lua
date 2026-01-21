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
local espEnabled = false
local espBoxes = {}
local espHealthBars = {}
local espNames = {}
local espTracers = {}
local espTeamCheck = false

local selfColor = Color3.fromRGB(0, 255, 0)
local enemyVisibleColor = Color3.fromRGB(0, 255, 0)
local enemyHiddenColor = Color3.fromRGB(0, 150, 255)
local teamColor = Color3.fromRGB(255, 255, 0)

-- МАТЕРИАЛЫ --
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
                local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    -- Цвет
                    local espColor
                    local isVisible = isPlayerVisible(player)
                    
                    if player.Team == localPlayer.Team and espTeamCheck then
                        espColor = teamColor
                    elseif player == localPlayer then
                        espColor = selfColor
                    else
                        espColor = isVisible and enemyVisibleColor or enemyHiddenColor
                    end
                    
                    -- БОКС --
                    if not espBoxes[player] then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "ESPBox_" .. player.Name
                        box.Adornee = head
                        box.AlwaysOnTop = true
                        box.ZIndex = 5
                        box.Size = Vector3.new(4, 5, 1)
                        box.Transparency = 0.3
                        box.Color3 = espColor
                        box.Parent = workspace
                        espBoxes[player] = box
                    else
                        espBoxes[player].Color3 = espColor
                        espBoxes[player].Adornee = head
                    end
                    
                    -- HP BAR --
                    if not espHealthBars[player] then
                        local gui = Instance.new("ScreenGui")
                        gui.Name = "ESPHealth_" .. player.Name
                        gui.Parent = game.CoreGui
                        
                        local bar = Instance.new("Frame")
                        bar.Name = "HealthBar"
                        bar.Size = UDim2.new(0, 50, 0, 6)
                        bar.Position = UDim2.new(0, headPos.X - 25, 0, headPos.Y - 40)
                        bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        bar.BorderSizePixel = 1
                        bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        bar.Parent = gui
                        
                        local fill = Instance.new("Frame")
                        fill.Name = "HealthFill"
                        fill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
                        fill.Position = UDim2.new(0, 0, 0, 0)
                        fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        fill.BorderSizePixel = 0
                        fill.Parent = bar
                        
                        espHealthBars[player] = {Gui = gui, Bar = bar, Fill = fill}
                    else
                        local data = espHealthBars[player]
                        local headPosUpdate = camera:WorldToViewportPoint(head.Position)
                        
                        if data.Bar then
                            data.Bar.Position = UDim2.new(0, headPosUpdate.X - 25, 0, headPosUpdate.Y - 40)
                            
                            if data.Fill then
                                local hpPercent = humanoid.Health / humanoid.MaxHealth
                                data.Fill.Size = UDim2.new(hpPercent, 0, 1, 0)
                                
                                if hpPercent > 0.6 then
                                    data.Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                                elseif hpPercent > 0.3 then
                                    data.Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                                else
                                    data.Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                                end
                            end
                        end
                    end
                    
                    -- ИМЯ --
                    if not espNames[player] then
                        local gui = Instance.new("ScreenGui")
                        gui.Name = "ESPName_" .. player.Name
                        gui.Parent = game.CoreGui
                        
                        local label = Instance.new("TextLabel")
                        label.Name = "PlayerName"
                        label.Text = player.Name
                        label.Size = UDim2.new(0, 100, 0, 20)
                        label.Position = UDim2.new(0, headPos.X - 50, 0, headPos.Y - 55)
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
                        local headPosUpdate = camera:WorldToViewportPoint(head.Position)
                        
                        if data.Label then
                            data.Label.Position = UDim2.new(0, headPosUpdate.X - 50, 0, headPosUpdate.Y - 55)
                            data.Label.TextColor3 = espColor
                        end
                    end
                else
                    -- Скрываем если не на экране
                    if espBoxes[player] then
                        espBoxes[player].Adornee = nil
                    end
                    if espHealthBars[player] then
                        espHealthBars[player].Bar.Visible = false
                    end
                    if espNames[player] then
                        espNames[player].Label.Visible = false
                    end
                end
            end
        end
    end
end

-- ОЧИСТКА ESP --
local function clearESP()
    for _, box in pairs(espBoxes) do
        box:Destroy()
    end
    espBoxes = {}
    
    for _, data in pairs(espHealthBars) do
        data.Gui:Destroy()
    end
    espHealthBars = {}
    
    for _, data in pairs(espNames) do
        data.Gui:Destroy()
    end
    espNames = {}
end

-- МАТЕРИАЛЫ --
local function applyMaterials()
    if not materialEnabled then return end
    
    local localPlayer = game.Players.LocalPlayer
    
    -- К себе
    if localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material[selectedMaterial]
                part.Color = materialColor
                part.Transparency = materialTransparency
            end
        end
    end
    
    -- К другим
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

-- NOCLIP ФУНКЦИИ --
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

-- ЭКРАННЫЕ КНОПКИ --
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

-- ВКЛАДКА RAGE --
local RageSection = RageTab:AddSection('Rage Functions', "left")

RageSection:AddButton('Активировать', function()
    Notification:Notify("info","Rage", "Активировано")
end)

RageSection:AddSlider('Скорость', 1, 10, 5, function(val)
    print("Rage скорость:", val)
end)

-- ВКЛАДКА MISC (ЗДЕСЬ NOCLIP) --
local MiscNoclipSection = MiscTab:AddSection('Noclip Settings', "left")

MiscNoclipSection:AddToggle('Noclip', false, function(val)
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
    materialEnabled = false
    Notification:Notify("warning","Сброс", "Все функции отключены")
end)

SettingsMain:AddLabel("Управление:")
SettingsMain:AddLabel("Noclip: " .. tostring(noclipKey.Name))
SettingsMain:AddLabel("Кнопки: G H J K L")

-- ОСНОВНОЙ ЦИКЛ ESP --
game:GetService("RunService").Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- ОЧИСТКА ПРИ ВЫХОДЕ --
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

-- АВТОЗАПУСК --
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if noclipActive then
        task.wait(1)
        enableNoclip()
    end
    
    if materialEnabled then
        task.wait(1)
        applyMaterials()
    end
end)

-- ЗАПУСК --
task.wait(1)
Notification:Notify("success","NEVERLOSE v4", "Загружен!")
print("✅ NeverLose UI готов к работе")