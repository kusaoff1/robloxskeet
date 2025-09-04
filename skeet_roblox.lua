-- Roblox GUI Menu Script
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Основные настройки
local menuKey = Enum.KeyCode.Insert
local menuVisible = false
local menuColor = Color3.fromRGB(0, 100, 0) -- Темно-зеленый цвет

-- Создание основного GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatMenu"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Основной фрейм меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 360) -- Увеличил высоту для нового слайдера
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -180)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = menuColor
Title.Text = "Skeet"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- Функции для создания элементов UI
local function createToggle(text, position, parent, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 20)
    toggleFrame.Position = position
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 20, 0, 20)
    toggle.Position = UDim2.new(0, 0, 0, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    toggle.Text = ""
    toggle.Parent = toggleFrame
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Size = UDim2.new(1, -30, 1, 0)
    toggleText.Position = UDim2.new(0, 25, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = text
    toggleText.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggleText.Font = Enum.Font.Gotham
    toggleText.TextSize = 12
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Parent = toggleFrame
    
    local enabled = false
    
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            toggle.BackgroundColor3 = menuColor
        else
            toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        end
        if callback then
            callback(enabled)
        end
    end)
    
    return {Frame = toggleFrame, Toggle = toggle, Enabled = function() return enabled end}
end

local function createButton(text, position, parent, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 25)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    button.Parent = parent
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return button
end

local function createSlider(text, position, parent, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 30)
    sliderFrame.Position = position
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Visible = true -- Всегда видим
    sliderFrame.Parent = parent
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Size = UDim2.new(1, 0, 0, 15)
    sliderText.Position = UDim2.new(0, 0, 0, 0)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = text .. ": " .. default
    sliderText.TextColor3 = Color3.fromRGB(200, 200, 200)
    sliderText.Font = Enum.Font.Gotham
    sliderText.TextSize = 11
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Parent = sliderFrame
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 5)
    track.Position = UDim2.new(0, 0, 0, 20)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    track.BorderSizePixel = 0
    track.Parent = sliderFrame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = menuColor
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 10, 0, 15)
    handle.Position = UDim2.new((default - min) / (max - min), -5, 0, -5)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.Text = ""
    handle.Parent = track
    
    local value = default
    local dragging = false
    
    handle.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackAbsolutePos = track.AbsolutePosition
            local trackAbsoluteSize = track.AbsoluteSize
            
            local relativeX = math.clamp((mousePos.X - trackAbsolutePos.X) / trackAbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * relativeX)
            
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            handle.Position = UDim2.new(relativeX, -5, 0, -5)
            sliderText.Text = text .. ": " .. value
            
            if callback then
                callback(value)
            end
        end
    end)
    
    return {
        Frame = sliderFrame,
        SetValue = function(newValue)
            value = math.clamp(newValue, min, max)
            local relativeX = (value - min) / (max - min)
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            handle.Position = UDim2.new(relativeX, -5, 0, -5)
            sliderText.Text = text .. ": " .. value
            if callback then
                callback(value)
            end
        end,
        GetValue = function() return value end,
        SetVisible = function(visible) sliderFrame.Visible = visible end
    }
end

-- Переменные
local bhopEnabled = false
local airJumpEnabled = false
local forceJumpEnabled = false
local antiAimEnabled = false
local noCollisionEnabled = false
local noRagdollEnabled = false
local allowMoveEnabled = false
local speedHackEnabled = false
local humanoid = nil
local character = nil
local rootPart = nil
local antiAimConnection = nil
local jumpConnection = nil
local ragdollConnection = nil
local moveConnection = nil
local speedHackConnection = nil
local antiAimSpeed = 15
local jumpPower = 50
local speedHackMultiplier = 2

-- Функция для спидхака
local function applySpeedHack()
    if not character or not humanoid or not rootPart then return end
    
    -- Увеличиваем скорость движения
    local moveDirection = humanoid.MoveDirection
    if moveDirection.Magnitude > 0 then
        -- Получаем текущую скорость
        local currentVelocity = rootPart.Velocity
        
        -- Применяем множитель скорости только к горизонтальному движению
        local newVelocity = Vector3.new(
            moveDirection.X * 16 * speedHackMultiplier, -- Базовая скорость 16 * множитель
            currentVelocity.Y,                          -- Сохраняем вертикальную скорость
            moveDirection.Z * 16 * speedHackMultiplier   -- Базовая скорость 16 * множитель
        )
        
        rootPart.Velocity = newVelocity
    end
end

-- Функция для принудительного прыжка
local function forceJump()
    if not character or not humanoid or not rootPart then return end
    
    -- Проверяем, не находится ли персонаж уже в состоянии прыжка
    local state = humanoid:GetState()
    if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
        -- Принудительно меняем состояние на прыжок
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        
        -- Применяем вертикальную скорость для прыжка
        local currentVelocity = rootPart.Velocity
        rootPart.Velocity = Vector3.new(currentVelocity.X, jumpPower, currentVelocity.Z)
    end
end

-- Функция для предотвращения ragdoll
local function preventRagdoll()
    if not humanoid then return end
    
    -- Постоянно проверяем состояние ragdoll и выходим из него
    if humanoid:GetState() == Enum.HumanoidStateType.FallingDown or
       humanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

-- Функция для принудительного движения
local function forceMove()
    if not humanoid then return end
    
    -- Сохраняем возможность движения
    if humanoid.MoveDirection.Magnitude > 0 then
        -- Принудительно включаем бег/ходьбу
        if humanoid:GetState() == Enum.HumanoidStateType.Seated or
           humanoid:GetState() == Enum.HumanoidStateType.Physics then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
end

-- Функция для быстрого перемещения в воздухе
local function applyBunnyHop()
    if not character or not humanoid then return end
    
    -- Проверяем, находится ли персонаж в воздухе
    if humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        -- Получаем текущую скорость
        local currentVelocity = rootPart.Velocity
        local moveDirection = humanoid.MoveDirection
        
        -- Увеличиваем горизонтальную скорость в воздухе
        if moveDirection.Magnitude > 0 then
            local newVelocity = Vector3.new(
                moveDirection.X * 50, -- Увеличиваем скорость по X
                currentVelocity.Y,    -- Сохраняем вертикальную скорость
                moveDirection.Z * 50  -- Увеличиваем скорость по Z
            )
            rootPart.Velocity = newVelocity
        end
    end
end

-- Функция для прыжка в воздухе
local function handleAirJump()
    if not character or not humanoid then return end
    
    -- Проверяем, находится ли персонаж в воздухе и нажата ли клавиша прыжка
    if (humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid:GetState() == Enum.HumanoidStateType.Freefall) then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        
        -- Применяем вертикальную скорость для прыжка
        local currentVelocity = rootPart.Velocity
        rootPart.Velocity = Vector3.new(currentVelocity.X, 50, currentVelocity.Z)
    end
end

-- Функция для Anti-Aim (вращение на месте как в CS)
local function startAntiAim()
    if antiAimConnection then
        antiAimConnection:Disconnect()
        antiAimConnection = nil
    end
    
    antiAimConnection = RunService.Heartbeat:Connect(function()
        if not character or not rootPart or not antiAimEnabled then
            if antiAimConnection then
                antiAimConnection:Disconnect()
                antiAimConnection = nil
            end
            return
        end
        
        -- Сохраняем текущую позицию и скорость
        local currentPosition = rootPart.Position
        local currentVelocity = rootPart.Velocity
        
        -- Вращаем корневую часть на месте с заданной скоростью
        local currentRotation = rootPart.Orientation
        rootPart.CFrame = CFrame.new(currentPosition) * CFrame.Angles(0, math.rad(currentRotation.Y + antiAimSpeed), 0)
        
        -- Сохраняем вертикальную скорость (гравитация)
        rootPart.Velocity = Vector3.new(0, currentVelocity.Y, 0)
    end)
end

-- Функция для отключения коллизии объекта
local function disableCollision(object)
    if object:IsA("BasePart") then
        object.CanCollide = false
        print("Collision disabled for: " .. object.Name)
    elseif object:IsA("Model") then
        for _, part in ipairs(object:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        print("Collision disabled for model: " .. object.Name)
    end
end

-- Функция для выдачи оружия (меча)
local function giveSword()
    if not character then return end
    
    -- Удаляем старое оружие если есть
    local oldSword = character:FindFirstChild("CheatSword")
    if oldSword then
        oldSword:Destroy()
    end
    
    -- Создаем меч
    local sword = Instance.new("Tool")
    sword.Name = "CheatSword"
    sword.Parent = character
    
    -- Создаем рукоятку меча
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.5, 1, 0.5)
    handle.BrickColor = BrickColor.new("Really black")
    handle.Parent = sword
    
    -- Создаем лезвие меча
    local blade = Instance.new("Part")
    blade.Name = "Blade"
    blade.Size = Vector3.new(0.3, 3, 0.3)
    blade.BrickColor = BrickColor.new("Bright blue")
    blade.Position = Vector3.new(0, 2, 0)
    blade.Parent = sword
    
    -- Соединяем лезвие с рукояткой
    local weld = Instance.new("Weld")
    weld.Part0 = handle
    weld.Part1 = blade
    weld.C0 = CFrame.new(0, 1.5, 0)
    weld.Parent = handle
    
    -- Добавляем урон при касании
    blade.Touched:Connect(function(hit)
        local hitHumanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
        if hitHumanoid and hitHumanoid ~= humanoid then
            hitHumanoid:TakeDamage(50) -- Урон 50 HP
        end
    end)
    
    -- Добавляем текстуру для красоты
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://54419919" -- Меч из Roblox catalog
    mesh.TextureId = "rbxassetid://54419936"
    mesh.Scale = Vector3.new(1, 1, 1)
    mesh.Parent = handle
    
    print("Sword given!")
end

-- Получение humanoid и character
local function getCharacter()
    character = player.Character
    if character then
        humanoid = character:FindFirstChildOfClass("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
    end
end

-- Соединение для обновления character при появлении персонажа
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    rootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

getCharacter()

-- Создание UI элементов
local bhopToggle = createToggle("Bunny hop", UDim2.new(0, 10, 0, 40), MainFrame, function(state)
    bhopEnabled = state
    print("Bunny hop:", state)
end)

local airJumpToggle = createToggle("Air Jump", UDim2.new(0, 10, 0, 70), MainFrame, function(state)
    airJumpEnabled = state
    print("Air Jump:", state)
end)

local forceJumpToggle = createToggle("Force Jump", UDim2.new(0, 10, 0, 100), MainFrame, function(state)
    forceJumpEnabled = state
    print("Force Jump:", state)
    
    if state then
        -- Создаем соединение для принудительного прыжка
        if jumpConnection then
            jumpConnection:Disconnect()
        end
        
        jumpConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == Enum.KeyCode.Space then
                forceJump()
            end
        end)
    elseif jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
end)

local noRagdollToggle = createToggle("No Ragdoll", UDim2.new(0, 10, 0, 130), MainFrame, function(state)
    noRagdollEnabled = state
    print("No Ragdoll:", state)
    
    if state then
        if ragdollConnection then
            ragdollConnection:Disconnect()
        end
        
        ragdollConnection = RunService.Heartbeat:Connect(function()
            if noRagdollEnabled and humanoid then
                preventRagdoll()
            end
        end)
    elseif ragdollConnection then
        ragdollConnection:Disconnect()
        ragdollConnection = nil
    end
end)

local allowMoveToggle = createToggle("Allow Move", UDim2.new(0, 10, 0, 160), MainFrame, function(state)
    allowMoveEnabled = state
    print("Allow Move:", state)
    
    if state then
        if moveConnection then
            moveConnection:Disconnect()
        end
        
        moveConnection = RunService.Heartbeat:Connect(function()
            if allowMoveEnabled and humanoid then
                forceMove()
            end
        end)
    elseif moveConnection then
        moveConnection:Disconnect()
        moveConnection = nil
    end
end)

local antiAimToggle = createToggle("Anti Aim", UDim2.new(0, 10, 0, 190), MainFrame, function(state)
    antiAimEnabled = state
    print("Anti Aim:", state)
    
    if state then
        startAntiAim()
    elseif antiAimConnection then
        antiAimConnection:Disconnect()
        antiAimConnection = nil
    end
end)

local speedHackToggle = createToggle("Speed Hack", UDim2.new(0, 10, 0, 220), MainFrame, function(state)
    speedHackEnabled = state
    print("Speed Hack:", state)
    
    if state then
        if speedHackConnection then
            speedHackConnection:Disconnect()
        end
        
        speedHackConnection = RunService.Heartbeat:Connect(function()
            if speedHackEnabled and character and humanoid and rootPart then
                applySpeedHack()
            end
        end)
    elseif speedHackConnection then
        speedHackConnection:Disconnect()
        speedHackConnection = nil
    end
end)

local noCollisionToggle = createToggle("No Collision Click", UDim2.new(0, 10, 0, 250), MainFrame, function(state)
    noCollisionEnabled = state
    print("No Collision Click:", state)
end)

-- Создаем слайдер для скорости вращения Anti Aim (всегда видимый)
local antiAimSpeedSlider = createSlider("Anti Aim Speed", UDim2.new(0, 10, 0, 280), MainFrame, 1, 50, 15, function(value)
    antiAimSpeed = value
    print("Anti Aim speed set to:", value)
end)

-- Создаем слайдер для скорости спидхака (всегда видимый)
local speedHackSlider = createSlider("Speed Hack Multiplier", UDim2.new(0, 10, 0, 310), MainFrame, 1, 10, 2, function(value)
    speedHackMultiplier = value
    print("Speed Hack multiplier set to:", value)
end)

createButton("Give Gun (Sword)", UDim2.new(0, 10, 0, 350), MainFrame, function()
    giveSword()
end)

createButton("Unload", UDim2.new(0, 10, 0, 385), MainFrame, function()
    ScreenGui:Destroy()
    print("Menu unloaded")
end)

-- Обработка клика для отключения коллизии
mouse.Button1Down:Connect(function()
    if noCollisionEnabled and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local target = mouse.Target
        if target then
            disableCollision(target)
        end
    end
end)

-- Перетаскивание меню
local dragging = false
local dragStart = Vector2.new(0, 0)
local frameStart = Vector2.new(0, 0)

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        frameStart = Vector2.new(MainFrame.Position.X.Scale, MainFrame.Position.Y.Scale)
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = Vector2.new(mouse.X, mouse.Y)
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local newX = mousePos.X / viewportSize.X
        local newY = mousePos.Y / viewportSize.Y
        
        MainFrame.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

-- Обработка нажатия клавиши прыжка для Air Jump
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Открытие/закрытие меню
    if input.KeyCode == menuKey then
        menuVisible = not menuVisible
        MainFrame.Visible = menuVisible
        
        -- При открытии центрируем меню
        if menuVisible then
            MainFrame.Position = UDim2.new(0.5, -150, 0.5, -180)
        end
    end
    
    -- Обработка прыжка для Air Jump
    if airJumpEnabled and input.KeyCode == Enum.KeyCode.Space then
        handleAirJump()
    end
end)

-- Основной цикл для Bunny hop
RunService.Heartbeat:Connect(function()
    if bhopEnabled and character and humanoid and rootPart then
        applyBunnyHop()
    end
end)

print("Skeet menu loaded! Press Insert to open/close")