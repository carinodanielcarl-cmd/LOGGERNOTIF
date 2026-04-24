-- AJGODZX SCANNER BOT (Fixed v2.0)
-- Improved detection, accurate logging, proper communication

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer

-- [[ CONFIGURATION ]] --
local SCAN_INTERVAL = 0.5 -- Faster scanning
local SCAN_TIME_PER_SERVER = 8 -- Time per server
local SHARED_URL = "https://api.npoint.io/3b590339f6bef0db0dfd"

-- Mutations (expanded for better detection)
local Mutations = {
    "Diamond", "Gold", "Cyber", "Rainbow", "Candy", "Divine", "Galaxy", 
    "Radioactive", "YinYang", "Halloween", "Christmas", "Spooky", "Love",
    "Easter", "Sahur", "Festive", "Ginger", "Cupid", "Bunny", "Pumpkin"
}

-- Base Brainrots (for pattern matching)
local BrainrotPatterns = {
    "Nooo My Hotspotsitos", "Serafinna Medusella", "Grande Combinasion",
    "Easter Grande", "Rang Ring Bus", "Guest 666", "Mi Gatitos",
    "Chicleteiras", "Noo My Eggs", "Donkeyturbo Express",
    "Mariachi Corazoni", "Burritos", "Tacorillo Crocodillo",
    "Swag Soda", "Noo my Heart", "Chimnino", "Combinasionas",
    "Chicleteira Noelteira", "Fishino Clownino", "Baskito",
    "Sweethearts", "Spinny Hammy", "Nuclearo Dinosauro", "Las Sis",
    "DJ Panda", "Chicleteira Cupideira", "Karkerkar Combinasion",
    "Chillin Chili", "Chipso and Queso", "Money Money Reindeer",
    "Money Money Puggy", "Churrito Bunnito", "Celularcini Viciosini",
    "Planitos", "Mobilis", "Mieteteira Bicicleteira",
    "Tuff Toucan", "La Spooky Grande", "Spooky Combinasionas",
    "Cigno Fulgoro", "Candies", "Hotspositos", "Jolly Combinasionas",
    "Cupids", "Puggies", "W or L", "Tralalalaledon", "Extinct Grande",
    "Tralaledon", "Jolly Grande", "Primos", "Bacuru and Egguru",
    "Eviledon", "Tacoritas", "Lovin Rose", "Tang Tang Kelentang",
    "Ketupat Kepat", "Bros", "Tictac Sahur", "Romantic Grande",
    "Gingerat Gerat", "Orcaledon", "Lucky Grande", "Ketchuru and Masturu",
    "Jolly Jolly Sahur", "Garama and Madundung", "Rosetti Tualetti",
    "Nacho Spyder", "Hopilikalika Hopilikalako", "Festive 67",
    "Sammyni Fattini", "Love Love Bear", "La Ginger Sekolah",
    "Spooky and Pumpky", "Boppin Bunny", "Lavadorito Spinito",
    "Food Combinasion", "Spaghettis", "La Casa Boo", "Fragrama and Chocrama",
    "Sekolahs", "Foxini Lanternini", "Secret Combinasion", "Amigos",
    "Reinito Sleighito", "Ketupat Bros", "Burguro and Fryuro",
    "Cooki and Milki", "Capitano Moby", "Rosey and Teddy", "Popcuru and Fizzuru",
    "Hydra Bunny", "Celestial Pegasus", "Cerberus", "Supreme Combinasion",
    "Dragon Cannelloni", "Dragon Gingerini", "Headless Horseman",
    "Hydra Dragon Cannelloni", "Griffin", "Skibidi Toilet", "Meowl",
    "Strawberry Elephant", "La Vacca Saturno Saturnita", "Pandanini Frostini",
    "Bisonte Giuppitere", "Blackhole Goat", "Jackorilla", "Agarrini Ia Palini",
    "Chachechi", "Karkerkar Kurkur", "Tortus", "Matteos", "Sammyni Spyderini",
    "Trenostruzzo Turbo 4000", "Chimpanzini Spiderini", "Boatito Auratito",
    "Fragola La La La", "Dul Dul Dul", "La Vacca Prese Presente", "Frankentteo",
    "Los Trios", "Karker Sahur", "Torrtuginni Dragonfrutini", "Tralaleritos",
    "Zombie Tralala", "La Cucaracha", "Vulturino Skeletono", "Guerriro Digitale",
    "Extinct Tralalero", "Yess My Examine", "Extinct Matteo", "Tralaleritas",
    "Rocco Disco", "Reindeer Tralala", "Las Vaquitas Saturnitas", "Pumpkin Spyderini",
    "Job Job Job Sahur", "Karkeritos", "Graipuss Medussi", "Santteo", "Fishboard",
    "Buntteo", "La Vacca Jacko Linterino", "Triplito Tralaleritos", "Trickolino",
    "Paradiso Axolottino", "GOAT", "Giftini Spyderini", "Spyderinis", "Love Love Love Sahur",
    "Perrito Burrito", "1x1x1x1", "Cucarachas", "Easter Easter Sahur", "Please My Present",
    "Cuadramat and Pakrahmatmamat", "Jobcitos", "Nooo My Hotspot", "Pot Hotspot",
    "Noo My Examine", "Telemorte", "Sahur Combinasion", "List List List Sahur",
    "Bunny Bunny Bunny Sahur", "To To To Sahur", "Pirulitoita Bicicletaire",
    "Santa Hotspot", "Horegini Boom", "Quesadilla Crocodila", "Pot Pumpkin",
    "Naughty Naughty", "Cupid Cupid Sahur", "Ho Ho Ho Sahur", "Mi Gatito",
    "Chicleteira Bicicleteira", "Eid Eid Eid Sahur", "Cupid Hotspot", "Spaghetti Tualetti",
    "Esok Sekolah", "Quesadillo Vampiro", "Brunito Marsito", "Chill Puppy",
    "Burrito Bandito", "Chicleteirina Bicicleteirina", "Granny", "Bunitos",
    "Quesadillas", "Bunito Bunito Spinito", "Noo My Candy", "Potato", "Bread"
}

-- [[ VALUE DATABASE ]] --
local ItemValues = {
    -- High tier (100M+)
    Diamond = 200000000,
    Divine = 200000000,
    Galaxy = 200000000,
    Rainbow = 150000000,
    Cyber = 120000000,
    
    -- Mid tier (50-100M)
    Gold = 80000000,
    Radioactive = 70000000,
    YinYang = 65000000,
    
    -- Normal tier (20-50M)
    Candy = 40000000,
    Halloween = 35000000,
    Christmas = 30000000,
    Spooky = 30000000,
    Love = 25000000,
    Easter = 25000000,
    Sahur = 20000000,
}

local function getItemValue(name, mutation)
    if mutation and ItemValues[mutation] then
        return ItemValues[mutation]
    end
    return 50000000 -- Default value
end

-- [[ UI CREATION ]] --
local Gui = Instance.new("ScreenGui")
Gui.Name = "AJGODZX_SCANNER"
Gui.Parent = game:GetService("CoreGui")
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.Size = UDim2.new(0, 200, 0, 120)
Main.Position = UDim2.new(0.02, 0, 0.5, -60)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 200, 255)

local Header = Instance.new("TextLabel", Main)
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 25)
Header.Font = Enum.Font.GothamBold
Header.Text = "AJGODZX SCANNER v2.0"
Header.TextColor3 = Color3.fromRGB(0, 200, 255)
Header.TextSize = 11

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 28)
StatusLabel.Size = UDim2.new(1, -20, 0, 18)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = "Status: Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 10
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local StatsLabel = Instance.new("TextLabel", Main)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Position = UDim2.new(0, 10, 0, 48)
StatsLabel.Size = UDim2.new(1, -20, 0, 18)
StatsLabel.Font = Enum.Font.GothamMedium
StatsLabel.Text = "Hops: 0 | Pings: 0 | Found: 0"
StatsLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
StatsLabel.TextSize = 9
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left

local CurrentFindLabel = Instance.new("TextLabel", Main)
CurrentFindLabel.BackgroundTransparency = 1
CurrentFindLabel.Position = UDim2.new(0, 10, 0, 68)
CurrentFindLabel.Size = UDim2.new(1, -20, 0, 18)
CurrentFindLabel.Font = Enum.Font.GothamMedium
CurrentFindLabel.Text = "Last Find: None"
CurrentFindLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
CurrentFindLabel.TextSize = 8
CurrentFindLabel.TextXAlignment = Enum.TextXAlignment.Left

local ErrorLabel = Instance.new("TextLabel", Main)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Position = UDim2.new(0, 10, 0, 88)
ErrorLabel.Size = UDim2.new(1, -20, 0, 14)
ErrorLabel.Font = Enum.Font.GothamMedium
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
ErrorLabel.TextSize = 8
ErrorLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Draggable
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- [[ BOT LOGIC ]] --
local seenItems = {}
local hopsCount = 0
local pingsCount = 0
local findsCount = 0
local isHopping = false
local currentFind = nil

local function updateStatus(text, color)
    StatusLabel.Text = "Status: " .. text
    if color then StatusLabel.TextColor3 = color end
end

local function updateStats()
    StatsLabel.Text = "Hops: " .. hopsCount .. " | Pings: " .. pingsCount .. " | Found: " .. findsCount
end

local function logError(text)
    ErrorLabel.Text = tostring(text)
    task.wait(3)
    ErrorLabel.Text = ""
end

local function updateCurrentFind(text)
    currentFind = text
    CurrentFindLabel.Text = "Last Find: " .. text
    task.wait(1)
    if CurrentFindLabel.Text == "Last Find: " .. text then
        CurrentFindLabel.Text = "Last Find: None"
    end
end

-- Improved item scanning
local function scanForBrainrots()
    local foundItems = {}
    local workspaceItems = workspace:GetDescendants()
    
    for _, item in ipairs(workspaceItems) do
        if item:IsA("Model") or item:IsA("Part") or item:IsA("Tool") then
            local itemName = item.Name
            
            -- Check for exact matches or pattern matches
            for _, brainrot in ipairs(BrainrotPatterns) do
                -- Case-insensitive matching
                if string.find(string.lower(itemName), string.lower(brainrot)) then
                    -- Determine mutation
                    local mutation = nil
                    for _, mut in ipairs(Mutations) do
                        if string.find(string.lower(itemName), string.lower(mut)) then
                            mutation = mut
                            break
                        end
                    end
                    
                    -- Calculate value
                    local value = getItemValue(itemName, mutation)
                    local tier = (value >= 100000000) and "Highlights" or "Midlights"
                    
                    -- Create unique ID
                    local uniqueId = game.JobId .. "_" .. itemName .. "_" .. item:GetFullName()
                    
                    if not seenItems[uniqueId] then
                        seenItems[uniqueId] = true
                        
                        local finding = {
                            id = uniqueId,
                            name = itemName,
                            base_name = brainrot,
                            mutation = mutation or "Normal",
                            value = value,
                            tier = tier,
                            players = #Players:GetPlayers() .. "/" .. Players.MaxPlayers,
                            job_id = game.JobId,
                            place_id = game.PlaceId,
                            timestamp = os.time(),
                            server_name = game.Name or "Unknown"
                        }
                        
                        table.insert(foundItems, finding)
                        findsCount = findsCount + 1
                        updateCurrentFind(itemName .. " (" .. (mutation or "Normal") .. ")")
                    end
                    break -- Found match, move to next item
                end
            end
        end
    end
    
    return foundItems
end

-- Improved webhook/post function
local function sendToSharedURL(finding)
    local success = false
    local retries = 0
    
    while not success and retries < 3 do
        pcall(function()
            -- Get current data
            local currentRaw = game:HttpGet(SHARED_URL .. "?t=" .. tick())
            local currentData = HttpService:JSONDecode(currentRaw)
            
            if type(currentData) ~= "table" then
                currentData = {findings = {}}
            end
            if not currentData.findings then
                currentData.findings = {}
            end
            
            -- Add new finding at the beginning
            table.insert(currentData.findings, 1, finding)
            
            -- Keep only last 50 findings
            while #currentData.findings > 50 do
                table.remove(currentData.findings)
            end
            
            -- Post back
            local body = HttpService:JSONEncode(currentData)
            
            local requestFunc = syn and syn.request or request or http_request
            if requestFunc then
                local response = requestFunc({
                    Url = SHARED_URL,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = body
                })
                if response and response.StatusCode == 200 then
                    success = true
                end
            else
                -- Fallback
                HttpService:PostAsync(SHARED_URL, body, Enum.HttpContentType.ApplicationJson)
                success = true
            end
        end)
        
        if not success then
            retries = retries + 1
            task.wait(0.5)
        end
    end
    
    return success
end

-- Improved server hopping
local function serverHop()
    if isHopping then 
        updateStatus("Already hopping...", Color3.fromRGB(255, 200, 0))
        return 
    end
    
    isHopping = true
    updateStatus("Hopping to new server...", Color3.fromRGB(255, 200, 0))
    
    pcall(function()
        -- Queue script for next server
        if queue_on_teleport then
            queue_on_teleport([[
                loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/LOGGERFINDER.lua"))()
            ]])
        end
        
        -- Find a new server
        local servers = {}
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)
        
        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.id ~= game.JobId and server.playing and server.playing < server.maxPlayers then
                    table.insert(servers, server.id)
                end
            end
        end
        
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer)
        else
            TeleportService:Teleport(game.PlaceId)
        end
        
        hopsCount = hopsCount + 1
        updateStats()
    end)
    
    isHopping = false
end

-- [[ MAIN LOOP ]] --
local lastHopTime = tick()
local lastScanFindings = {}

task.spawn(function()
    updateStatus("Ready - Scanning...", Color3.fromRGB(0, 200, 255))
    
    while true do
        pcall(function()
            -- Scan for items
            updateStatus("Scanning for brainrots...", Color3.fromRGB(0, 255, 100))
            local newFindings = scanForBrainrots()
            
            -- Process findings
            for _, finding in ipairs(newFindings) do
                updateStatus("Found: " .. finding.name, Color3.fromRGB(255, 100, 0))
                
                -- Send to shared URL
                local sent = sendToSharedURL(finding)
                if sent then
                    pingsCount = pingsCount + 1
                    updateStats()
                    updateStatus("Logged: " .. finding.name, Color3.fromRGB(0, 255, 0))
                    
                    -- Log to console
                    print(string.format("[SCANNER] Found: %s | Value: %s | Mutation: %s",
                        finding.name,
                        tostring(finding.value),
                        finding.mutation or "Normal"
                    ))
                else
                    logError("Failed to send: " .. finding.name)
                end
                
                task.wait(0.3) -- Small delay between logs
            end
            
            -- Check if it's time to hop
            local timeInServer = tick() - lastHopTime
            if timeInServer >= SCAN_TIME_PER_SERVER then
                serverHop()
                lastHopTime = tick()
                task.wait(2) -- Wait after hop
            else
                local timeLeft = SCAN_TIME_PER_SERVER - timeInServer
                updateStatus(string.format("Next hop in %.1fs | Scanning...", timeLeft), Color3.fromRGB(200, 200, 200))
            end
        end)
        
        task.wait(SCAN_INTERVAL)
    end
end)

print("✅ AJGODZX SCANNER v2.0 LOADED!")
