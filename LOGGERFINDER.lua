-- LOGGERFINDER SCANNER - WORKING VERSION
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local lp = Players.LocalPlayer

-- WEBHOOK FOR COMMUNICATION (FREE SERVICE)
local WEBHOOK_URL = "https://webhook.site/be6f6e6e-6e6e-6e6e-6e6e-6e6e6e6e6e6e"

-- BRAINROTS
local Brainrots = {
    "Los Matteos", "25", "La Cucaracha", "Guest 666", "Nooo My Hotspotsitos",
    "Serafinna Medusella", "Grande Combinasion", "67", "Donkeyturbo Express",
    "Swag Soda", "Skibidi Toilet", "GOAT", "1x1x1x1", "Granny",
    "La Supreme Combinasion", "Dragon Cannelloni", "Headless Horseman", "Bread",
    "Potato", "Candy", "Love Bear", "Spooky", "Pumpkin", "Cyber", "Rainbow",
    "Diamond", "Gold", "Divine", "Galaxy"
}

local Mutations = {"Diamond", "Gold", "Cyber", "Rainbow", "Divine", "Galaxy", "Spooky", "Love"}

-- UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScannerBot"
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
pcall(function() if not screenGui.Parent then screenGui.Parent = lp:WaitForChild("PlayerGui") end end)

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 280, 0, 120)
main.Position = UDim2.new(0.02, 0, 0.5, -60)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔍 SCANNER BOT ACTIVE"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 13

local statusLabel = Instance.new("TextLabel", main)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 35)
statusLabel.Text = "Status: Scanning..."
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local foundLabel = Instance.new("TextLabel", main)
foundLabel.Size = UDim2.new(1, -20, 0, 20)
foundLabel.Position = UDim2.new(0, 10, 0, 55)
foundLabel.Text = "Found: 0 items"
foundLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
foundLabel.BackgroundTransparency = 1
foundLabel.TextSize = 11
foundLabel.TextXAlignment = Enum.TextXAlignment.Left

local hopsLabel = Instance.new("TextLabel", main)
hopsLabel.Size = UDim2.new(1, -20, 0, 20)
hopsLabel.Position = UDim2.new(0, 10, 0, 75)
hopsLabel.Text = "Hops: 0"
hopsLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
hopsLabel.BackgroundTransparency = 1
hopsLabel.TextSize = 11
hopsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Make draggable
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Data
local scannedItems = {}
local hopsCount = 0
local findsCount = 0
local isHopping = false
local currentLogs = {}

-- Send log to webhook
local function sendToWebhook(logEntry)
    local success, err = pcall(function()
        local data = {
            findings = currentLogs,
            lastUpdate = os.time(),
            type = "BRAINROT_LOG"
        }
        local jsonData = HttpService:JSONEncode(data)
        
        local requestFunc = syn and syn.request or request or http_request or (HttpService and HttpService.RequestAsync)
        
        if requestFunc then
            local response = requestFunc({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        end
    end)
    
    if not success then
        warn("Webhook failed: " .. tostring(err))
    end
end

-- Add log
local function addLog(itemName, mutation, value, jobId, placeId, playerCount)
    findsCount = findsCount + 1
    foundLabel.Text = "Found: " .. findsCount .. " items"
    
    local logEntry = {
        id = os.time() .. "_" .. game.JobId .. "_" .. itemName,
        name = itemName,
        mutation = mutation or "Normal",
        value = value or 50000000,
        job_id = jobId or game.JobId,
        place_id = placeId or game.PlaceId,
        players = playerCount or (#Players:GetPlayers() .. "/" .. Players.MaxPlayers),
        timestamp = os.time()
    }
    
    -- Add to beginning
    table.insert(currentLogs, 1, logEntry)
    
    -- Keep only last 20
    while #currentLogs > 20 do
        table.remove(currentLogs)
    end
    
    -- Save to _G for same-executor communication
    _G.BRAINROT_LOGS = currentLogs
    
    -- Send to webhook
    sendToWebhook(logEntry)
    
    -- Print
    print(string.format("[FOUND] %s | %s | Value: %s", itemName, mutation or "Normal", value))
    statusLabel.Text = "Found: " .. itemName
    task.wait(2)
    statusLabel.Text = "Status: Scanning..."
end

-- Scan
local function scanItems()
    local allItems = workspace:GetDescendants()
    local currentPlayers = #Players:GetPlayers() .. "/" .. Players.MaxPlayers
    
    for _, item in ipairs(allItems) do
        if item:IsA("Model") or item:IsA("Part") or item:IsA("Tool") then
            local itemName = item.Name
            
            for _, brainrot in ipairs(Brainrots) do
                if string.find(string.lower(itemName), string.lower(brainrot)) then
                    local mutation = nil
                    for _, mut in ipairs(Mutations) do
                        if string.find(string.lower(itemName), string.lower(mut)) then
                            mutation = mut
                            break
                        end
                    end
                    
                    local value = 50000000
                    if mutation == "Diamond" then value = 250000000
                    elseif mutation == "Divine" or mutation == "Galaxy" then value = 200000000
                    elseif mutation == "Gold" then value = 100000000
                    elseif mutation == "Rainbow" or mutation == "Cyber" then value = 75000000
                    end
                    
                    local key = game.JobId .. "_" .. itemName
                    if not scannedItems[key] then
                        scannedItems[key] = true
                        addLog(itemName, mutation, value, game.JobId, game.PlaceId, currentPlayers)
                    end
                    break
                end
            end
        end
    end
end

-- Server hop
local function serverHop()
    if isHopping then return end
    isHopping = true
    statusLabel.Text = "Status: Hopping..."
    
    pcall(function()
        if queue_on_teleport then
            queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/LOGGERFINDER.lua"))()')
        end
        
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)
        
        local servers = {}
        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.id ~= game.JobId and server.playing and server.playing < server.maxPlayers then
                    table.insert(servers, server.id)
                end
            end
        end
        
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
        else
            TeleportService:Teleport(game.PlaceId)
        end
        
        hopsCount = hopsCount + 1
        hopsLabel.Text = "Hops: " .. hopsCount
    end)
    
    task.wait(2)
    isHopping = false
end

-- Main loop
local lastHop = tick()
local SCAN_INTERVAL = 1
local HOP_INTERVAL = 10

task.spawn(function()
    while true do
        pcall(function()
            scanItems()
            
            if tick() - lastHop >= HOP_INTERVAL then
                serverHop()
                lastHop = tick()
                task.wait(3)
                scannedItems = {}
            end
        end)
        task.wait(SCAN_INTERVAL)
    end
end)

print("✅ SCANNER LOADED - Press F9 to see console")
print("📡 Scanning for brainrots every 1 second")
print("🔄 Hopping servers every 10 seconds")
