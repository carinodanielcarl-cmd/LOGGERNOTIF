-- LOGGERFINDER SCANNER - FULL BRAINROTS LIST
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local lp = Players.LocalPlayer

-- YOUR PASTEBIN INFO
local PASTEBIN_API_KEY = "ZtGs1tRiCfQXw-728nn2Vy8sSCoRLBTw"
local PASTE_ID = "YOUR_PASTE_ID_HERE"

-- COMPLETE BRAINROTS LIST
local allBrainrots = {
    "Los Nooo My Hotspotsitos", "Serafinna Medusella", "La Grande Combinassion", "La Easter Grande", "Rang Ring Bus", "Guest 666",
    "Los Mi Gatitos", "Los Chicleteiras", "Noo My Eggs", "67", "Donkeyturbo Express", "Mariachi Corazoni", "Los Burritos",
    "Los 25", "Tacorillo Crocodillo", "Swag Soda", "Noo my Heart", "Chimnino", "Los Combinasionas", "Chicleteira Noelteira",
    "Fishino Clownino", "Baskito", "Tacorita Bicicleta", "Los Sweethearts", "Spinny Hammy", "Nuclearo Dinosauro", "Las Sis",
    "DJ Panda", "Chicleteira Cupideira", "La Karkerkar Combinasion", "Chillin Chili", "Chipso and Queso", "Money Money Reindeer",
    "Money Money Puggy", "Churrito Bunnito", "Celularcini Viciosini", "Los Planitos", "Los Mobilis", "Los 67",
    "Mieteteira Bicicleteira", "Tuff Toucan", "La Spooky Grande", "Los Spooky Combinasionas", "Cigno Fulgoro", "Los Candies",
    "Los Hotspositos", "Los Jolly Combinasionas", "Los Cupids", "Los Puggies", "W or L", "Tralalalaledon",
    "La Extinct Grande Combinasion", "Tralaledon", "La Jolly Grande", "Los Primos", "Bacuru and Egguru", "Eviledon",
    "Los Tacoritas", "Lovin Rose", "Tang Tang Kelentang", "Ketupat Kepat", "Los Bros", "Tictac Sahur", "La Romantic Grande",
    "Gingerat Gerat", "Orcaledon", "La Lucky Grande", "Ketchuru and Masturu", "Jolly Jolly Sahur", "Garama and Madundung",
    "Rosetti Tualetti", "Nacho Spyder", "Hopilikalika Hopilikalako", "Festive 67", "Sammyni Fattini", "Love Love Bear",
    "La Ginger Sekolah", "Spooky and Pumpky", "Boppin Bunny", "Lavadorito Spinito", "La Food Combinasion", "Los Spaghettis",
    "La Casa Boo", "Fragrama and Chocrama", "Los Sekolahs", "Foxini Lanternini", "La Secret Combinasion", "Los Amigos",
    "Reinito Sleighito", "Ketupat Bros", "Burguro and Fryuro", "Cooki and Milki", "Capitano Moby", "Rosey and Teddy",
    "Popcuru and Fizzuru", "Hydra Bunny", "Celestial Pegasus", "Cerberus", "La Supreme Combinasion", "Dragon Cannelloni",
    "Dragon Gingerini", "Headless Horseman", "Hydra Dragon Cannelloni", "Griffin", "Skibidi Toilet", "Meowl",
    "Strawberry Elephant", "La Vacca Saturno Saturnita", "Pandanini Frostini", "Bisonte Giuppitere", "Blackhole Goat",
    "Jackorilla", "Agarrini Ia Palini", "Chachechi", "Karkerkar Kurkur", "Los Tortus", "Los Matteos", "Sammyni Spyderini",
    "Trenostruzzo Turbo 4000", "Chimpanzini Spiderini", "Boatito Auratito", "Fragola La La La", "Dul Dul Dul",
    "La Vacca Prese Presente", "Frankentteo", "Los Trios", "Karker Sahur", "Torrtuginni Dragonfrutini (Lucky Block)",
    "Los Tralaleritos", "Zombie Tralala", "La Cucaracha", "Vulturino Skeletono", "Guerriro Digitale", "Extinct Tralalero",
    "Yess My Examine", "Extinct Matteo", "Las Tralaleritas", "Rocco Disco", "Reindeer Tralala", "Las Vaquitas Saturnitas",
    "Pumpkin Spyderini", "Job Job Job Sahur", "Los Karkeritos", "Graipuss Medussi", "Santteo", "Fishboard", "Buntteo",
    "La Vacca Jacko Linterino", "Triplito Tralaleritos", "Trickolino", "Paradiso Axolottino", "GOAT", "Giftini Spyderini",
    "Los Spyderinis", "Love Love Love Sahur", "Perrito Burrito", "1x1x1x1", "Los Cucarachas", "Easter Easter Sahur",
    "Please My Present", "Cuadramat and Pakrahmatmamat", "Los Jobcitos", "Nooo My Hotspot", "Pot Hotspot (Lucky Block)",
    "Noo My Examine", "Telemorte", "La Sahur Combinasion", "List List List Sahur", "Bunny Bunny Bunny Sahur", "To To To Sahur",
    "Pirulitoita Bicicletaire", "25", "Santa Hotspot", "Horegini Boom", "Quesadilla Crocodila", "Pot Pumpkin", "Naughty Naughty",
    "Cupid Cupid Sahur", "Ho Ho Ho Sahur", "Mi Gatito", "Chicleteira Bicicleteira", "Eid Eid Eid Sahur", "Cupid Hotspot",
    "Spaghetti Tualetti (Lucky Block)", "Esok Sekolah (Lucky Block)", "Quesadillo Vampiro", "Brunito Marsito", "Chill Puppy",
    "Burrito Bandito", "Chicleteirina Bicicleteirina", "Granny", "Los Bunitos", "Los Quesadillas", "Bunito Bunito Spinito",
    "Noo My Candy"
}

local Mutations = {"Diamond", "Gold", "Cyber", "Rainbow", "Divine", "Galaxy", "Spooky", "Love"}

-- UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Scanner"
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 280, 0, 120)
main.Position = UDim2.new(0.02, 0, 0.5, -60)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔍 SCANNER ACTIVE"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 13

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 35)
status.Text = "Status: Ready"
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.BackgroundTransparency = 1
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left

local foundLabel = Instance.new("TextLabel", main)
foundLabel.Size = UDim2.new(1, -20, 0, 20)
foundLabel.Position = UDim2.new(0, 10, 0, 55)
foundLabel.Text = "Found: 0"
foundLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
foundLabel.BackgroundTransparency = 1
foundLabel.TextSize = 11
foundLabel.TextXAlignment = Enum.TextXAlignment.Left

local hopLabel = Instance.new("TextLabel", main)
hopLabel.Size = UDim2.new(1, -20, 0, 20)
hopLabel.Position = UDim2.new(0, 10, 0, 75)
hopLabel.Text = "Hops: 0"
hopLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
hopLabel.BackgroundTransparency = 1
hopLabel.TextSize = 11
hopLabel.TextXAlignment = Enum.TextXAlignment.Left

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

-- Sound
local notifSound = Instance.new("Sound")
notifSound.SoundId = "rbxassetid://4590662766"
notifSound.Volume = 0.5
notifSound.Parent = SoundService

local function playSound()
    pcall(function() notifSound:Play() end)
end

-- Format number
local function formatNumber(n)
    n = tonumber(n) or 0
    if n >= 1000000 then
        local formatted = string.format("%.1fM", n / 1000000)
        return formatted:gsub("%.0M", "M")
    elseif n >= 1000 then
        local formatted = string.format("%.1fK", n / 1000)
        return formatted:gsub("%.0K", "K")
    else
        return tostring(n)
    end
end

-- Data
local scannedItems = {}
local hopsCount = 0
local findsCount = 0
local isHopping = false

-- Get current logs
local function getCurrentLogs()
    local requestFunc = syn and syn.request or request or http_request
    if not requestFunc then return {} end
    
    local response = requestFunc({
        Url = "https://pastebin.com/raw/" .. PASTE_ID,
        Method = "GET"
    })
    
    if response and response.Body and response.Body ~= "" then
        local success, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
        if success and data and data.findings then return data.findings end
    end
    return {}
end

-- Save to Pastebin
local function saveToPastebin(logs)
    local jsonData = HttpService:JSONEncode({findings = logs, lastUpdate = os.time()})
    local requestFunc = syn and syn.request or request or http_request
    if not requestFunc then return false end
    
    local response = requestFunc({
        Url = "https://pastebin.com/api/api_post.php",
        Method = "POST",
        Body = "api_dev_key=" .. PASTEBIN_API_KEY .. "&api_option=update&api_paste_key=" .. PASTE_ID .. "&api_paste_code=" .. HttpService:URLEncode(jsonData) .. "&api_paste_private=1"
    })
    return response and (response.StatusCode == 200 or (response.Body and string.find(response.Body, "paste")))
end

-- Add log
local function addLog(itemName, mutation, value)
    findsCount = findsCount + 1
    foundLabel.Text = "Found: " .. findsCount
    status.Text = "Found: " .. itemName
    playSound()
    
    local logs = getCurrentLogs()
    local newLog = {
        id = os.time() .. "_" .. game.JobId,
        name = itemName,
        mutation = mutation or "Normal",
        value = value or 50000000,
        formattedValue = formatNumber(value or 50000000),
        job_id = game.JobId,
        place_id = game.PlaceId,
        players = #Players:GetPlayers() .. "/" .. Players.MaxPlayers,
        timestamp = os.time()
    }
    
    table.insert(logs, 1, newLog)
    while #logs > 20 do table.remove(logs) end
    saveToPastebin(logs)
    
    print(string.format("[FOUND] %s | %s | Value: %s", itemName, mutation or "Normal", formatNumber(value)))
    task.wait(2)
    status.Text = "Status: Scanning"
end

-- Scan
local function scanItems()
    local allItems = workspace:GetDescendants()
    for _, item in ipairs(allItems) do
        if item:IsA("Model") or item:IsA("Part") or item:IsA("Tool") then
            local name = item.Name
            for _, brainrot in ipairs(allBrainrots) do
                if string.find(string.lower(name), string.lower(brainrot)) then
                    local mutation = nil
                    for _, mut in ipairs(Mutations) do
                        if string.find(string.lower(name), string.lower(mut)) then
                            mutation = mut
                            break
                        end
                    end
                    local value = 50000000
                    if mutation == "Diamond" then value = 250000000
                    elseif mutation == "Divine" or mutation == "Galaxy" then value = 200000000
                    elseif mutation == "Gold" then value = 100000000
                    elseif mutation == "Cyber" or mutation == "Rainbow" then value = 75000000
                    end
                    local key = game.JobId .. "_" .. name
                    if not scannedItems[key] then
                        scannedItems[key] = true
                        addLog(name, mutation, value)
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
    status.Text = "Status: Hopping"
    
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
        hopLabel.Text = "Hops: " .. hopsCount
    end)
    
    task.wait(3)
    isHopping = false
end

-- Main loop
local lastHop = tick()

task.spawn(function()
    while true do
        pcall(function()
            scanItems()
            if tick() - lastHop >= 10 then
                serverHop()
                lastHop = tick()
                task.wait(3)
                scannedItems = {}
            end
        end)
        task.wait(1)
    end
end)

print("✅ SCANNER LOADED - " .. #allBrainrots .. " brainrots loaded")
