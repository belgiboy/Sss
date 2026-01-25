-- NexHub | AUTO FLASH TELEPORT on Brainrot Steal (2026)
-- Когда Brainrot уже в руках → авто-юз Flash Teleport (куда смотришь)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Настройки
local FLASH_PATTERNS = {"flash teleport", "flash tp", "flash", "teleport flash"}  -- добавь своё имя тулки, если другое

local lastActivation = 0
local COOLDOWN = 2.5  -- не спамить

-- Функция: есть ли Brainrot в руках
local function hasBrainrot()
    local char = player.Character
    if not char then return false end
    
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Model") and obj.Name:lower():find("brainrot") then
            return true
        end
    end
    return false
end

-- Функция: найти Flash Teleport
local function findFlashTool()
    local char = player.Character
    local backpack = player.Backpack
    
    -- Сначала в руках
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                for _, p in ipairs(FLASH_PATTERNS) do
                    if n:find(p) then return tool end
                end
            end
        end
    end
    
    -- Потом в рюкзаке
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            for _, p in ipairs(FLASH_PATTERNS) do
                if n:find(p) then return tool end
            end
        end
    end
    
    return nil
end

-- Основной цикл
RunService.Heartbeat:Connect(function()
    if tick() - lastActivation < COOLDOWN then return end
    
    if hasBrainrot() then
        local flash = findFlashTool()
        if flash then
            lastActivation = tick()
            
            local char = player.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            
            -- Equip если не в руках
            if flash.Parent ~= char then
                flash.Parent = char
                task.wait(0.12)
            end
            
            -- Активация
            pcall(function()
                flash:Activate()  -- основной способ
            end)
            
            -- Fallback: симуляция клика по Handle
            local handle = flash:FindFirstChild("Handle") or flash.PrimaryPart or flash
            if handle then
                pcall(function()
                    firetouchinterest(char.HumanoidRootPart, handle, 0)
                    task.wait(0.03)
                    firetouchinterest(char.HumanoidRootPart, handle, 1)
                end)
            end
            
            -- Уведомление (чтобы видеть, что сработало)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Flash Auto",
                Text = "Brainrot в руках → Flash Teleport activated!",
                Duration = 2
            })
            
            print("Brainrot украден → Flash Teleport использован!")
        end
    end
end)

-- Обновление персонажа при респауне
player.CharacterAdded:Connect(function(newChar)
    char = newChar
end)

print("=== NexHub Flash Teleport AUTO on Steal Loaded ===")
