--[[
    LOGGERFINDER SCANNER - CLEAN VERSION
    No auto-join, just scans and logs to a clean API
--]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local lp = Players.LocalPlayer

-- CONFIGURATION
local SCAN_INTERVAL = 1
local SCAN_TIME_PER_SERVER = 10
-- USING A BETTER API - JSONBin.io (Free, reliable)
local API_URL = "https://api.jsonbin.io/v3/b/67b0b5f0acd3cb34a8d8e5a9"
local API_KEY = "$2a$10$YOUR_API_KEY_HERE" -- You need to sign up for free at jsonbin.io

-- BRAINROTS LIST (Same as before)
local Brainrots = {
    "Los Matteos", "25", "La Cucaracha", "Guest 666", "Nooo My Hotspotsitos",
    "Serafinna Medusella", "Grande Combinasion", "67", "Donkeyturbo Express",
    "Swag Soda", "Skibidi Toilet", "GOAT", "1x1x1x1", "Granny",
    "La Supreme Combinasion", "Dragon Cannelloni", "Headless Horseman"
}

local Mutations = {"Diamond", "Gold", "Cyber", "Rainbow", "Divine", "Galaxy"}

-- Create simple UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScannerBot"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = lp:WaitForChild("PlayerGui") end)

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 250, 0, 100)
main.Position = UDim2.new(0.01, 0, 0.5, -50)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "🔍 SCANNER BOT ACTIVE"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 12

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, -10, 0, 20)
status.Position = UDim2.new(0, 5, 0, 28)
status.Text = "Status: Scanning..."
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.BackgroundTransparency = 1
status.TextSize = 10
status.TextXAlignment = Enum.TextXAlignment.Left

local found = Instance.new("TextLabel", main)
found.Size = UDim2.new(1, -10, 0, 20)
found.Position = UDim2.new(0, 5, 0, 48)
found.Text = "Found: 0 items"
found.TextColor3 = Color3.fromRGB(150, 150, 150)
found.BackgroundTransparency = 1
found.TextSize = 10
found.TextXAlignment = Enum.TextXAlignment.Left

local hops = Instance.new("TextLabel", main)
hops.Size = UDim2.new(1, -10, 0, 20)
hops.Position = UDim2.new(0, 5, 0, 68)
hops.Text = "Hops: 0"
hops.TextColor3 = Color3.fromRGB(150, 150, 150)
hops.BackgroundTransparency = 1
hops.TextSize = 10
hops.TextXAlignment = Enum.TextXAlignment.Left

-- Make draggable
local drag = {start = nil, pos = nil, dragging = false}
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag.dragging = true
        drag.start = input.Position
        drag.pos = main.Position
    end
end)
main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag.dragging = false
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if drag.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - drag.start
        main.Position = UDim2.new(drag.pos.X.Scale, drag.pos.X.Offset + delta.X, drag.pos.Y.Scale, drag.pos.Y.Offset + delta.Y)
    end
end)

-- Store found items
local foundItems = {}
local hopsCount = 0
local findsCount = 0
local isHopping = false

-- Function to save logs locally (uses _G for cross-script communication)
local function addToLog(itemName, mutation, value)
    findsCount = findsCount + 1
    found.Text = "Found: " .. findsCount .. " items"
    
    local logEntry = {
        id = os.time() .. "_" .. itemName,
        name = itemName,
        mutation = mutation or "Normal",
        value = value or 50000000,
        job_id = game.JobId,
        place_id = game.PlaceId,
        players = #Players:GetPlayers() .. "/" .. Players.MaxPlayers,
        timestamp = os.time()
    }
    
    -- Store in _G for AJ to read
    if not _G.BRAINROT_LOGS then
        _G.BRAINROT_LOGS = {}
    end
    
    -- Add to beginning
    table.insert(_G.BRAINROT_LOGS, 1, logEntry)
    
    -- Keep only last 20
    while #_G.BRAINROT_LOGS > 20 do
        table.remove(_G.BRAINROT_LOGS)
    end
    
    -- Also try to save to a global URL (optional)
    pcall(function()
        local data = {findings = _G.BRAINROT_LOGS}
        local body = HttpService:JSONEncode(data)
        local requestFunc = syn and syn.request or request or http_request
        if requestFunc then
            requestFunc({
                Url = "https://your-webhook-url.com/logs", -- Replace with your endpoint
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = body
            })
        end
    end)
    
    print(string.format("[FOUND] %s | %s | Value: %s", itemName, mutation or "Normal", value))
    status.Text = "Found: " .. itemName
    task.wait(2)
    status.Text = "Status: Scanning..."
end

-- Scan function
local function scanItems()
    local items = workspace:GetDescendants()
    for _, item in ipairs(items) do
        if item:IsA("Model") or item:IsA("Part") or item:IsA("Tool") then
            local name = item.Name
            
            -- Check for brainrots
            for _, brainrot in ipairs(Brainrots) do
                if string.find(string.lower(name), string.lower(brainrot)) then
                    -- Check for mutation
                    local mutation = nil
                    for _, mut in ipairs(Mutations) do
                        if string.find(string.lower(name), string.lower(mut)) then
                            mutation = mut
                            break
                        end
                    end
                    
                    -- Calculate value
                    local value = 50000000
                    if mutation == "Diamond" or mutation == "Divine" then
                        value = 200000000
                    elseif mutation == "Gold" then
                        value = 100000000
                    elseif mutation == "Cyber" or mutation == "Rainbow" then
                        value = 75000000
                    end
                    
                    -- Check if already found in this server
                    local key = game.JobId .. "_" .. name
                    if not foundItems[key] then
                        foundItems[key] = true
                        addToLog(name, mutation, value)
                    end
                    break
                end
            end
        end
    end
end

-- Server hop function
local function serverHop()
    if isHopping then return end
    isHopping = true
    status.Text = "Hopping server..."
    
    pcall(function()
        if queue_on_teleport then
            queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_RAW_URL/LOGGERFINDER.lua"))()')
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
        hops.Text = "Hops: " .. hopsCount
    end)
    
    isHopping = false
end

-- Main loop
local lastHop = tick()

task.spawn(function()
    while true do
        pcall(function()
            scanItems()
            
            if tick() - lastHop >= SCAN_TIME_PER_SERVER then
                serverHop()
                lastHop = tick()
                task.wait(3)
            end
        end)
        task.wait(SCAN_INTERVAL)
    end
end)

print("✅ SCANNER BOT LOADED - Using _G.BRAINROT_LOGS for communication")
