local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/DrawLib/master/Linoria.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Инициализация GUI
local Window = Library:CreateWindow({
    Title = "rocstar.lua v5.0 | Steal A Brainrot | @TENSAI_DEV",
    Size = Vector2.new(500, 600),
    Theme = "Dark",
    AnimationSpeed = 0.3
})

-- Вкладки
local Tabs = {
    ESP = Window:AddTab("ESP"),
    Cheats = Window:AddTab("Cheats"),
    Misc = Window:AddTab("Misc"),
    Settings = Window:AddTab("Settings")
}

-- Водяной знак
local Watermark = Library:CreateWatermark({
    Text = "rocstar.lua v5.0 | Steal A Brainrot | TG: @TENSAI_DEV",
    ColorCycle = {Color3.fromRGB(255, 105, 180), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 0), Color3.fromRGB(128, 0, 128)},
    AnimationSpeed = 2
})

-- Переменные для настроек
local ESPSettings = {
    PlayerColor = Color3.fromRGB(255, 105, 180),
    TimerColorOwn = Color3.fromRGB(255, 255, 0),
    TimerColorEnemy = Color3.fromRGB(0, 255, 255),
    ResourceColor = Color3.fromRGB(255, 255, 0),
    Team = "All Teams",
    SkyColor = Color3.fromRGB(135, 206, 235)
}
local CheatSettings = {
    FlySpeed = 50,
    WalkSpeed = 50,
    KillAuraRadius = 10,
    SilentAimRadius = 50
}

-- Вкладка ESP
local ESPGroup = Tabs.ESP:AddGroupbox("ESP Options")
local PlayerESP = false
local TimerESP = false
local ResourceESP = false
local DistanceESP = false
local HealthESP = false

ESPGroup:AddToggle("PlayerESP", {
    Text = "Player ESP",
    Default = false,
    Callback = function(state)
        PlayerESP = state
        Library:Notify(state and "Player ESP включен" or "Player ESP выключен", 3)
    end
})

ESPGroup:AddToggle("TimerESP", {
    Text = "Timer ESP",
    Default = false,
    Callback = function(state)
        TimerESP = state
        Library:Notify(state and "Timer ESP включен" or "Timer ESP выключен", 3)
    end
})

ESPGroup:AddToggle("ResourceESP", {
    Text = "Resource ESP",
    Default = false,
    Callback = function(state)
        ResourceESP = state
        Library:Notify(state and "Resource ESP включен" or "Resource ESP выключен", 3)
    end
})

ESPGroup:AddToggle("DistanceESP", {
    Text = "Distance ESP",
    Default = false,
    Callback = function(state)
        DistanceESP = state
        Library:Notify(state and "Distance ESP включен" or "Distance ESP выключен", 3)
    end
})

ESPGroup:AddToggle("HealthESP", {
    Text = "Health ESP",
    Default = false,
    Callback = function(state)
        HealthESP = state
        Library:Notify(state and "Health ESP включен" or "Health ESP выключен", 3)
    end
})

-- Реализация ESP
local ESP = {}
function ESP:CreateBillboard(instance, text, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = instance
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = color
    textLabel.Text = text
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.Parent = billboard
    billboard.Parent = instance
    return billboard
end

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if PlayerESP and (ESPSettings.Team == "All Teams" or player.Team == LocalPlayer.Team) then
                local billboard = head:FindFirstChild("PlayerESP") or ESP:CreateBillboard(head, player.Name, ESPSettings.PlayerColor)
                if DistanceESP then
                    local distance = (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart and (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude) or 0
                    billboard.TextLabel.Text = player.Name .. " (" .. math.floor(distance) .. "m)"
                end
                if HealthESP and humanoid then
                    billboard.TextLabel.Text = billboard.TextLabel.Text .. " [" .. math.floor(humanoid.Health) .. "%]"
                end
                billboard.Enabled = true
            else
                local billboard = head:FindFirstChild("PlayerESP")
                if billboard then billboard.Enabled = false end
            end
        end
    end
    -- Timer ESP (предполагается наличие Timer.Value в игре)
    for _, base in pairs(workspace:GetDescendants()) do
        if base.Name == "Timer" and base:IsA("IntValue") then
            local parent = base.Parent
            local billboard = parent:FindFirstChild("TimerESP")
            if TimerESP then
                local color = parent.Name == LocalPlayer.Name and ESPSettings.TimerColorOwn or ESPSettings.TimerColorEnemy
                billboard = billboard or ESP:CreateBillboard(parent, "", color)
                local time = base.Value
                billboard.TextLabel.Text = string.format("%02d:%02d", math.floor(time / 60), time % 60)
                billboard.Enabled = true
            elseif billboard then
                billboard.Enabled = false
            end
        end
    end
    -- Resource ESP
    for _, resource in pairs(workspace:GetDescendants()) do
        if resource.Name == "Brain" and resource:IsA("BasePart") then
            local billboard = resource:FindFirstChild("ResourceESP")
            if ResourceESP then
                billboard = billboard or ESP:CreateBillboard(resource, "Brain", ESPSettings.ResourceColor)
                billboard.Enabled = true
            elseif billboard then
                billboard.Enabled = false
            end
        end
    end
end)

-- Вкладка Cheats
local CheatsGroup = Tabs.Cheats:AddGroupbox("Cheat Options")
local NoclipEnabled = false
local FlyEnabled = false
local SpeedHackEnabled = false
local InfiniteJumpEnabled = false
local GodModeEnabled = false
local KillAuraEnabled = false
local FastRespawnEnabled = false
local InvisibleEnabled = false
local AutoHealEnabled = false
local SuperJumpEnabled = false
local NoFallDamageEnabled = false
local SilentAimEnabled = false

CheatsGroup:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,
    Callback = function(state)
        NoclipEnabled = state
        Library:Notify(state and "Noclip включен" or "Noclip выключен", 3)
    end
})

CheatsGroup:AddToggle("Fly", {
    Text = "Fly",
    Default = false,
    Callback = function(state)
        FlyEnabled = state
        Library:Notify(state and "Fly включен" or "Fly выключен", 3)
    end
})

CheatsGroup:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(value)
        CheatSettings.FlySpeed = value
        Library:Notify("Fly Speed установлен на " .. value, 3)
    end
})

CheatsGroup:AddToggle("SpeedHack", {
    Text = "Speed Hack",
    Default = false,
    Callback = function(state)
        SpeedHackEnabled = state
        Library:Notify(state and "Speed Hack включен" or "Speed Hack выключен", 3)
    end
})

CheatsGroup:AddSlider("WalkSpeed", {
    Text = "Walk Speed",
    Default = 50,
    Min = 16,
    Max = 70,
    Rounding = 0,
    Callback = function(value)
        CheatSettings.WalkSpeed = value
        Library:Notify("Walk Speed установлен на " .. value, 3)
    end
})

CheatsGroup:AddToggle("InfiniteJump", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
        Library:Notify(state and "Infinite Jump включен" or "Infinite Jump выключен", 3)
    end
})

CheatsGroup:AddToggle("GodMode", {
    Text = "God Mode",
    Default = false,
    Callback = function(state)
        GodModeEnabled = state
        Library:Notify(state and "God Mode включен" or "God Mode выключен", 3)
    end
})

CheatsGroup:AddToggle("KillAura", {
    Text = "Kill Aura",
    Default = false,
    Callback = function(state)
        KillAuraEnabled = state
        Library:Notify(state and "Kill Aura включена" or "Kill Aura выключена", 3)
    end
})

CheatsGroup:AddToggle("FastRespawn", {
    Text = "Fast Respawn",
    Default = false,
    Callback = function(state)
        FastRespawnEnabled = state
        Library:Notify(state and "Fast Respawn включен" or "Fast Respawn выключен", 3)
    end
})

CheatsGroup:AddToggle("Invisible", {
    Text = "Invisible",
    Default = false,
    Callback = function(state)
        InvisibleEnabled = state
        Library:Notify(state and "Invisible включен" or "Invisible выключен", 3)
    end
})

CheatsGroup:AddToggle("AutoHeal", {
    Text = "Auto Heal",
    Default = false,
    Callback = function(state)
        AutoHealEnabled = state
        Library:Notify(state and "Auto Heal включен" or "Auto Heal выключен", 3)
    end
})

CheatsGroup:AddToggle("SuperJump", {
    Text = "Super Jump",
    Default = false,
    Callback = function(state)
        SuperJumpEnabled = state
        Library:Notify(state and "Super Jump включен" or "Super Jump выключен", 3)
    end
})

CheatsGroup:AddToggle("NoFallDamage", {
    Text = "No Fall Damage",
    Default = false,
    Callback = function(state)
        NoFallDamageEnabled = state
        Library:Notify(state and "No Fall Damage включен" or "No Fall Damage выключен", 3)
    end
})

CheatsGroup:AddToggle("SilentAim", {
    Text = "Silent Aim",
    Default = false,
    Callback = function(state)
        SilentAimEnabled = state
        Library:Notify(state and "Silent Aim включен" or "Silent Aim выключен", 3)
    end
})

-- Реализация читов
local function SetNoclip(state)
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end

local FlyBodyVelocity, FlyBodyGyro
local function SetFly(state)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        if state then
            FlyBodyVelocity = FlyBodyVelocity or Instance.new("BodyVelocity")
            FlyBodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            FlyBodyVelocity.Parent = root
            FlyBodyGyro = FlyBodyGyro or Instance.new("BodyGyro")
            FlyBodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
            FlyBodyGyro.Parent = root
        else
            if FlyBodyVelocity then FlyBodyVelocity:Destroy() FlyBodyVelocity = nil end
            if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if NoclipEnabled then
        SetNoclip(true)
    end
    if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new()
        if Library:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
        if Library:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
        if Library:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
        if Library:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
        if Library:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if Library:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        if FlyBodyVelocity then
            FlyBodyVelocity.Velocity = moveDirection * CheatSettings.FlySpeed
        end
        if FlyBodyGyro then
            FlyBodyGyro.CFrame = camera.CFrame
        end
    end
    if SpeedHackEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = CheatSettings.WalkSpeed
    end
    if GodModeEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = math.huge
    end
    if KillAuraEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance <= CheatSettings.KillAuraRadius then
                    player.Character.Humanoid.Health = 0
                end
            end
        end
    end
    if InvisibleEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.9
            end
        end
    end
    if AutoHealEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
    if SuperJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 100
    end
    if NoFallDamageEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if LocalPlayer.Character.Humanoid.Health < LocalPlayer.Character.Humanoid.MaxHealth then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    if FastRespawnEnabled then
        wait(0.1)
        character.HumanoidRootPart.CFrame = game:GetService("Workspace"):FindFirstChild("SpawnLocation").CFrame
    end
end)

-- Вкладка Misc
local MiscGroup = Tabs.Misc:AddGroupbox("Misc Options")
local PlayersDropdown = MiscGroup:AddDropdown("TeleportToPlayer", {
    Text = "Teleport to Player",
    Values = {},
    Callback = function(playerName)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name == playerName and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                wait(0.5) -- Задержка для обхода анти-чита
                Library:Notify("Телепорт к " .. playerName, 3)
            end
        end
    end
})

local BasesDropdown = MiscGroup:AddDropdown("TeleportToBase", {
    Text = "Teleport to Base",
    Values = {},
    Callback = function(baseName)
        for _, base in pairs(workspace:GetDescendants()) do
            if base.Name == baseName and base:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = base.CFrame + Vector3.new(0, 2, 0)
                wait(0.5)
                Library:Notify("Телепорт к базе " .. baseName, 3)
            end
        end
    end
})

MiscGroup:AddButton("Teleport Home", function()
    for _, base in pairs(workspace:GetDescendants()) do
        if base.Name == LocalPlayer.Name and base:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = base.CFrame + Vector3.new(0, 2, 0)
            wait(0.5)
            Library:Notify("Телепорт на свою базу", 3)
        end
    end
end)

local InfiniteStaminaEnabled = false
MiscGroup:AddToggle("InfiniteStamina", {
    Text = "Infinite Stamina",
    Default = false,
    Callback = function(state)
        InfiniteStaminaEnabled = state
        Library:Notify(state and "Infinite Stamina включена" or "Infinite Stamina выключена", 3)
    end
})

local ChatSpamEnabled = false
local ChatSpamText = "rocstar.lua | @TENSAI_DEV"
MiscGroup:AddToggle("ChatSpam", {
    Text = "Chat Spam",
    Default = false,
    Callback = function(state)
        ChatSpamEnabled = state
        Library:Notify(state and "Chat Spam включен" or "Chat Spam выключен", 3)
    end
})

MiscGroup:AddInput("ChatSpamText", {
    Text = "Chat Spam Text",
    Default = "rocstar.lua | @TENSAI_DEV",
    Callback = function(value)
        ChatSpamText = value
        Library:Notify("Chat Spam текст установлен: " .. value, 3)
    end
})

RunService.RenderStepped:Connect(function()
    if InfiniteStaminaEnabled then
        for _, stamina in pairs(workspace:GetDescendants()) do
            if stamina.Name == "Stamina" and stamina:IsA("IntValue") and stamina.Parent == LocalPlayer.Character then
                stamina.Value = math.huge
            end
        end
    end
    if ChatSpamEnabled then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(ChatSpamText, "All")
        wait(2)
    end
end)

-- Вкладка Settings
local SettingsGroup = Tabs.Settings:AddGroupbox("Settings")
SettingsGroup:AddColorPicker("PlayerESPColor", {
    Text = "Player ESP Color",
    Default = ESPSettings.PlayerColor,
    Callback = function(color)
        ESPSettings.PlayerColor = color
        Library:Notify("Цвет Player ESP изменён", 3)
    end
})

SettingsGroup:AddColorPicker("TimerESPOwnColor", {
    Text = "Timer ESP (Own Base) Color",
    Default = ESPSettings.TimerColorOwn,
    Callback = function(color)
        ESPSettings.TimerColorOwn = color
        Library:Notify("Цвет Timer ESP (своя база) изменён", 3)
    end
})

SettingsGroup:AddColorPicker("TimerESPEnemyColor", {
    Text = "Timer ESP (Enemy Base) Color",
    Default = ESPSettings.TimerColorEnemy,
    Callback = function(color)
        ESPSettings.TimerColorEnemy = color
        Library:Notify("Цвет Timer ESP (чужая база) изменён", 3)
    end
})

SettingsGroup:AddColorPicker("ResourceESPColor", {
    Text = "Resource ESP Color",
    Default = ESPSettings.ResourceColor,
    Callback = function(color)
        ESPSettings.ResourceColor = color
        Library:Notify("Цвет Resource ESP изменён", 3)
    end
})

SettingsGroup:AddColorPicker("SkyColor", {
    Text = "Sky Color",
    Default = ESPSettings.SkyColor,
    Callback = function(color)
        ESPSettings.SkyColor = color
        Lighting.Ambient = color
        for _, sky in pairs(Lighting:GetChildren()) do
            if sky:IsA("Sky") then
                sky.SkyboxBk = color
                sky.SkyboxDn = color
                sky.SkyboxFt = color
                sky.SkyboxLf = color
                sky.SkyboxRt = color
                sky.SkyboxUp = color
            end
        end
        Library:Notify("Цвет неба изменён", 3)
    end
})

local Teams = {"All Teams"}
for _, team in pairs(game:GetService("Teams"):GetChildren()) do
    table.insert(Teams, team.Name)
end
SettingsGroup:AddDropdown("TeamSelector", {
    Text = "Team ESP Selector",
    Values = Teams,
    Default = "All Teams",
    Callback = function(value)
        ESPSettings.Team = value
        Library:Notify("Команда для ESP: " .. value, 3)
    end
})

-- Обновление дропдаунов
RunService.Heartbeat:Connect(function()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        table.insert(playerList, player.Name)
    end
    PlayersDropdown:SetValues(playerList)
    
    local baseList = {}
    for _, base in pairs(workspace:GetDescendants()) do
        if base:IsA("BasePart") and base.Name == LocalPlayer.Name then
            table.insert(baseList, base.Name .. " (Your Base)")
        elseif base:IsA("BasePart") then
            table.insert(baseList, base.Name)
        end
    end
    BasesDropdown:SetValues(baseList)
end)

-- Silent Aim
RunService.RenderStepped:Connect(function()
    if SilentAimEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local closestEnemy = nil
        local closestDistance = CheatSettings.SilentAimRadius
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestEnemy = player
                    closestDistance = distance
                end
            end
        end
        if closestEnemy and closestEnemy.Character and closestEnemy.Character:FindFirstChild("Head") then
            -- Предполагается, что оружие обрабатывает Mouse.Hit
            game:GetService("ReplicatedStorage").WeaponSystem:FireServer(closestEnemy.Character.Head.Position)
        end
    end
end)

Library:Notify("rocstar.lua v5.0 загружен! @TENSAI_DEV", 5)
