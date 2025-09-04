local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local menuKey = Enum.KeyCode.Insert
local menuVisible = false
local menuColor = Color3.fromRGB(0, 100, 0)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatMenu"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 500)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

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

local function createToggle(text, position, parent, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 20)
    toggleFrame.Position = position
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 20, 0, 20)
    toggle.Position = UDim2.new(0, 0, 0, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    toggle.BorderSizePixel = 0
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
    local button = Instance.new("TextLabel")
    button.Size = UDim2.new(1, -20, 0, 25)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    button.TextXAlignment = Enum.TextXAlignment.Center
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
    sliderFrame.Visible = true
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
    
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 10, 0, 15)
    handle.Position = UDim2.new((default - min) / (max - min), -5, 0, -5)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.BorderSizePixel = 0
    handle.Parent = track
    
    local value = default
    
    track.MouseButton1Down:Connect(function()
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
local bhopSpeed = 50

local function applySpeedHack()
    if not character or not humanoid or not rootPart then return end
    
    local moveDirection = humanoid.MoveDirection
    if moveDirection.Magnitude > 0 then
        local currentVelocity = rootPart.Velocity
        
        local newVelocity = Vector3.new(
            moveDirection.X * 16 * speedHackMultiplier,
            currentVelocity.Y,
            moveDirection.Z * 16 * speedHackMultiplier
        )
        
        rootPart.Velocity = newVelocity
    end
end

local function forceJump()
    if not character or not humanoid or not rootPart then return end
    
    local state = humanoid:GetState()
    if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        
        local currentVelocity = rootPart.Velocity
        rootPart.Velocity = Vector3.new(currentVelocity.X, jumpPower, currentVelocity.Z)
    end
end

local function preventRagdoll()
    if not humanoid then return end
    
    if humanoid:GetState() == Enum.HumanoidStateType.FallingDown or
       humanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function forceMove()
    if not humanoid then return end
    
    if humanoid.MoveDirection.Magnitude > 0 then
        if humanoid:GetState() == Enum.HumanoidStateType.Seated or
           humanoid:GetState() == Enum.HumanoidStateType.Physics then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
end

local function applyBunnyHop()
    if not character or not humanoid then return end
    
    if humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        local currentVelocity = rootPart.Velocity
        local moveDirection = humanoid.MoveDirection
        
        if moveDirection.Magnitude > 0 then
            local newVelocity = Vector3.new(
                moveDirection.X * bhopSpeed,
                currentVelocity.Y,
                moveDirection.Z * bhopSpeed
            )
            rootPart.Velocity = newVelocity
        end
    end
end

local function handleAirJump()
    if not character or not humanoid then return end
    
    if (humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid:GetState() == Enum.HumanoidStateType.Freefall) then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        
        local currentVelocity = rootPart.Velocity
        rootPart.Velocity = Vector3.new(currentVelocity.X, 50, currentVelocity.Z)
    end
end

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
        
        local currentPosition = rootPart.Position
        local currentVelocity = rootPart.Velocity
        
        local currentRotation = rootPart.Orientation
        rootPart.CFrame = CFrame.new(currentPosition) * CFrame.Angles(0, math.rad(currentRotation.Y + antiAimSpeed), 0)
        
        rootPart.Velocity = Vector3.new(0, currentVelocity.Y, 0)
    end)
end

local function disableCollision(object)
    if object:IsA("BasePart") then
        object.CanCollide = false
    elseif object:IsA("Model") then
        for _, part in ipairs(object:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

local function giveSword()
    if not character then return end
    
    local oldSword = character:FindFirstChild("CheatSword")
    if oldSword then
        oldSword:Destroy()
    end
    
    local sword = Instance.new("Tool")
    sword.Name = "CheatSword"
    sword.Parent = character
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.5, 1, 0.5)
    handle.BrickColor = BrickColor.new("Really black")
    handle.Parent = sword
    
    local blade = Instance.new("Part")
    blade.Name = "Blade"
    blade.Size = Vector3.new(0.3, 3, 0.3)
    blade.BrickColor = BrickColor.new("Bright blue")
    blade.Position = Vector3.new(0, 2, 0)
    blade.Parent = sword
    
    local weld = Instance.new("Weld")
    weld.Part0 = handle
    weld.Part1 = blade
    weld.C0 = CFrame.new(0, 1.5, 0)
    weld.Parent = handle
    
    blade.Touched:Connect(function(hit)
        local hitHumanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
        if hitHumanoid and hitHumanoid ~= humanoid then
            hitHumanoid:TakeDamage(50)
        end
    end)
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://54419919"
    mesh.TextureId = "rbxassetid://54419936"
    mesh.Scale = Vector3.new(1, 1, 1)
    mesh.Parent = handle
end

local function getCharacter()
    character = player.Character
    if character then
        humanoid = character:FindFirstChildOfClass("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
    end
end

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    rootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

getCharacter()

local bhopToggle = createToggle("Bunny hop", UDim2.new(0, 10, 0, 40), MainFrame, function(state)
    bhopEnabled = state
end)

local bhopSpeedSlider = createSlider("Bhop Speed", UDim2.new(0, 10, 0, 70), MainFrame, 10, 100, 50, function(value)
    bhopSpeed = value
end)

local airJumpToggle = createToggle("Air Jump", UDim2.new(0, 10, 0, 110), MainFrame, function(state)
    airJumpEnabled = state
end)

local forceJumpToggle = createToggle("Force Jump", UDim2.new(0, 10, 0, 140), MainFrame, function(state)
    forceJumpEnabled = state
    
    if state then
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

local noRagdollToggle = createToggle("No Ragdoll", UDim2.new(0, 10, 0, 170), MainFrame, function(state)
    noRagdollEnabled = state
    
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

local allowMoveToggle = createToggle("Allow Move", UDim2.new(0, 10, 0, 200), MainFrame, function(state)
    allowMoveEnabled = state
    
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

local antiAimToggle = createToggle("Anti Aim", UDim2.new(0, 10, 0, 230), MainFrame, function(state)
    antiAimEnabled = state
    
    if state then
        startAntiAim()
    elseif antiAimConnection then
        antiAimConnection:Disconnect()
        antiAimConnection = nil
    end
end)

local speedHackToggle = createToggle("Speed Hack", UDim2.new(0, 10, 0, 260), MainFrame, function(state)
    speedHackEnabled = state
    
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

local noCollisionToggle = createToggle("No Collision Click", UDim2.new(0, 10, 0, 290), MainFrame, function(state)
    noCollisionEnabled = state
end)

local antiAimSpeedSlider = createSlider("Anti Aim Speed", UDim2.new(0, 10, 0, 320), MainFrame, 1, 50, 15, function(value)
    antiAimSpeed = value
end)

local speedHackSlider = createSlider("Speed Hack Multiplier", UDim2.new(0, 10, 0, 350), MainFrame, 1, 10, 2, function(value)
    speedHackMultiplier = value
end)

createButton("Give Gun (Sword)", UDim2.new(0, 10, 0, 380), MainFrame, function()
    giveSword()
end)

createButton("Unload", UDim2.new(0, 10, 0, 415), MainFrame, function()
    ScreenGui:Destroy()
end)

mouse.Button1Down:Connect(function()
    if noCollisionEnabled and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local target = mouse.Target
        if target then
            disableCollision(target)
        end
    end
end)

local dragging = false

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Delta
        MainFrame.Position = MainFrame.Position + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == menuKey then
        menuVisible = not menuVisible
        MainFrame.Visible = menuVisible
    end
    
    if airJumpEnabled and input.KeyCode == Enum.KeyCode.Space then
        handleAirJump()
    end
end)

RunService.Heartbeat:Connect(function()
    if bhopEnabled and character and humanoid and rootPart then
        applyBunnyHop()
    end
end)