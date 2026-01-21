-- // Сервисы // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager") -- Для эмуляции клавиш
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // Загрузка UI // --
local NEVERLOSE = loadstring(game:HttpGet("https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NEVERLOSE-UI-Nightly/main/source.lua"))()

-- // Настройки UI // --
NEVERLOSE:Theme("nightly") -- Темы: dark, nightly, original
local Window = NEVERLOSE:AddWindow("NEVERLOSE", "ARCANUM REMAKE")
local Notification = NEVERLOSE:Notification()
Notification.MaxNotifications = 6

-- // Переменные для функций // --
local Settings = {
    Rage = {
        Enabled = false,
        FOV = 180,
        TeamCheck = true,
        Target = nil
    },
    Visuals = {
        ESP = false,
        Chams = false,
        TeamCheck = true
    },
    Misc = {
        Bhop = false,
        FakeDuck = false,
        Noclip = false
    }
}

-- // Вспомогательные функции (Логика Arcanum) // --

-- 1. Ragebot Logic (Поиск цели)
local function GetClosestPlayer()
    local ClosestDist = Settings.Rage.FOV
    local Target = nil

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            -- Проверка команды
            if Settings.Rage.TeamCheck and v.Team == LocalPlayer.Team then continue end

            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if OnScreen then
                local MousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                local Distance = (MousePos - Vector2.new(ScreenPos.X, ScreenPos.Y)).Magnitude

                if Distance < ClosestDist then
                    ClosestDist = Distance
                    Target = v.Character.HumanoidRootPart
                end
            end
        end
    end
    return Target
end

-- 2. Visuals (Chams/ESP)
local function UpdateVisuals()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            -- Удаляем старые подсветки, если выключено
            if v.Character:FindFirstChild("NeverloseHighlight") then
                if not Settings.Visuals.Chams then
                    v.Character.NeverloseHighlight:Destroy()
                end
            end

            if Settings.Visuals.Chams then
                if Settings.Visuals.TeamCheck and v.Team == LocalPlayer.Team then 
                    if v.Character:FindFirstChild("NeverloseHighlight") then v.Character.NeverloseHighlight:Destroy() end
                    continue 
                end

                if not v.Character:FindFirstChild("NeverloseHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "NeverloseHighlight"
                    hl.FillColor = Color3.fromRGB(168, 247, 50) -- Цвет из Arcanum (Accent)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    hl.Parent = v.Character
                end
            end
        end
    end
end

-- 3. Noclip Logic
RunService.Stepped:Connect(function()
    if Settings.Misc.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- 4. Ragebot Loop
RunService.RenderStepped:Connect(function()
    -- Ragebot
    if Settings.Rage.Enabled then
        Settings.Rage.Target = GetClosestPlayer()
        if Settings.Rage.Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Settings.Rage.Target.Position)
        end
    end

    -- Visuals Update Loop
    UpdateVisuals()

    -- Bunnyhop
    if Settings.Misc.Bhop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
            if LocalPlayer.Character.Humanoid.FloorMaterial == Enum.Material.Air then
                 -- Автоматически прыгаем, если в воздухе (эмуляция распрыжки)
                 -- Обычно в Lua просто зажимают прыжок, но здесь простой метод:
                 LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end
end)

-- 5. Fake Duck (Анимация)
local FakeDuckAnim
local function ToggleFakeDuck(state)
    local Char = LocalPlayer.Character
    local Hum = Char and Char:FindFirstChild("Humanoid")
    if not Hum then return end

    if state then
        -- Используем ID анимации приседания (как в Arcanum fake duck)
        local Animator = Hum:FindFirstChild("Animator") or Instance.new("Animator", Hum)
        local Anim = Instance.new("Animation")
        Anim.AnimationId = "rbxassetid://102226306945117" -- Стандартный ID из скрипта
        FakeDuckAnim = Animator:LoadAnimation(Anim)
        FakeDuckAnim.Priority = Enum.AnimationPriority.Action4
        FakeDuckAnim.Looped = true
        FakeDuckAnim:Play()
    else
        if FakeDuckAnim then
            FakeDuckAnim:Stop()
            FakeDuckAnim = nil
        end
    end
end


-- // ИНТЕРФЕЙС (UI) // --

Window:AddTabLabel('Main')

-- 1. RAGE TAB
local RageTab = Window:AddTab('Rage', 'locked')
local RageSection = RageTab:AddSection('Aimbot', 'left')

RageSection:AddToggle('Enable Rage', false, function(val)
    Settings.Rage.Enabled = val
    if val then Notification:Notify("info", "Rage", "Ragebot Activated") end
end)

RageSection:AddSlider('FOV Radius', 10, 800, 180, function(val)
    Settings.Rage.FOV = val
end)

RageSection:AddToggle('Team Check', true, function(val)
    Settings.Rage.TeamCheck = val
end)

-- 2. VISUALS TAB
local VisualsTab = Window:AddTab('Visuals', 'mouse')
local EspSection = VisualsTab:AddSection('ESP', 'left')

EspSection:AddToggle('Chams', false, function(val)
    Settings.Visuals.Chams = val
end)

EspSection:AddToggle('Team Check', true, function(val)
    Settings.Visuals.TeamCheck = val
end)

-- 3. MISC TAB
local MiscTab = Window:AddTab('Misc', 'folder')
local MovementSection = MiscTab:AddSection('Movement', 'left')
local ExploitSection = MiscTab:AddSection('Exploits', 'right')

MovementSection:AddToggle('Bunnyhop', false, function(val)
    Settings.Misc.Bhop = val
end)

ExploitSection:AddToggle('Fake Duck', false, function(val)
    Settings.Misc.FakeDuck = val
    ToggleFakeDuck(val)
end)

ExploitSection:AddToggle('Noclip', false, function(val)
    Settings.Misc.Noclip = val
    if val then Notification:Notify("warning", "Misc", "Noclip Enabled") end
end)


-- // ON-SCREEN BUTTONS (G, H, J, K, L) // --

local function CreateOnScreenButtons()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VirtualKeys"
    ScreenGui.Parent = game.CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 260, 0, 60)
    Frame.Position = UDim2.new(0.5, -130, 0.85, 0) -- Внизу экрана по центру
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BackgroundTransparency = 0.5
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(168, 247, 50) -- Акцентный цвет
    UIStroke.Thickness = 2
    UIStroke.Parent = Frame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Frame

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 10)
    Layout.Parent = Frame

    local Keys = {"G", "H", "J", "K", "L"}

    for _, keyName in ipairs(Keys) do
        local Button = Instance.new("TextButton")
        Button.Name = keyName
        Button.Size = UDim2.new(0, 40, 0, 40)
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Button.Text = keyName
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 20
        Button.Parent = Frame

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button

        -- Эмуляция нажатия
        Button.MouseButton1Click:Connect(function()
            -- Визуальный эффект
            Button.BackgroundColor3 = Color3.fromRGB(168, 247, 50)
            Button.TextColor3 = Color3.fromRGB(0, 0, 0)
            
            -- Эмуляция нажатия клавиши
            local KeyCode = Enum.KeyCode[keyName]
            VirtualInputManager:SendKeyEvent(true, KeyCode, false, game) -- Нажать
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, KeyCode, false, game) -- Отпустить
            
            -- Возврат цвета
            task.wait(0.1)
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            print("Virtual Key Pressed: " .. keyName)
        end)
    end
end

-- Создаем кнопки
CreateOnScreenButtons()

Notification:Notify("info", "Neverlose", "Script Loaded Successfully")
