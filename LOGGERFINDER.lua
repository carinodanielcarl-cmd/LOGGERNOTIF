-- AJGODZX SCANNER BOT (Ultra-Robust v1.0.5)
-- Automaticaly hops servers, scans for mutation items, and pings logs to AJ Joiner.

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local task = task or {wait = wait, spawn = spawn}

local lp = Players.LocalPlayer

-- [[ CONFIGURATION ]] --
local SCAN_INTERVAL = 1.0
local SCAN_TIME_PER_SERVER = 5 
local SHARED_URL = "https://api.npoint.io/3b590339f6bef0db0dfd" 
local CONFIG_FILE = "aj_scanner_config.json"

local userSettings = {
    Whitelist = {},
    PlaySound = true,
    MinPingValue = 50000000
}

-- LOAD CONFIG
pcall(function()
    if isfile and readfile and isfile(CONFIG_FILE) then
        local saved = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(saved) == "table" then
            for k, v in pairs(saved) do
                if k == "Whitelist" and type(v) == "table" then
                    for wk, wv in pairs(v) do userSettings.Whitelist[wk] = wv end
                else
                    userSettings[k] = v
                end
            end
        end
    end
end)

-- AUTO SAVE
task.spawn(function()
    local lastSave = HttpService:JSONEncode(userSettings)
    while true do
        task.wait(3)
        pcall(function()
            local current = HttpService:JSONEncode(userSettings)
            if current ~= lastSave then
                if writefile then writefile(CONFIG_FILE, current) end
                lastSave = current
            end
        end)
    end
end) 

-- Mutation detection
local Mutations = {"Diamond", "Gold", "Cyber", "Rainbow", "Candy", "Divine", "Galaxy", "Radioactive", "YinYang", "Halloween", "Christmas"}

local allBrainrots = {
    "Los Nooo My Hotspotsitos", "Serafinna Medusella", "La Grande Combinassion",
    "La Easter Grande", "Rang Ring Bus", "Guest 666", "Los Mi Gatitos",
    "Los Chicleteiras", "Noo My Eggs", "67", "Donkeyturbo Express",
    "Mariachi Corazoni", "Los Burritos", "Los 25", "Tacorillo Crocodillo",
    "Swag Soda", "Noo my Heart", "Chimnino", "Los Combinasionas",
    "Chicleteira Noelteira", "Fishino Clownino", "Baskito", "Tacorita Bicicleta",
    "Los Sweethearts", "Spinny Hammy", "Nuclearo Dinosauro", "Las Sis",
    "DJ Panda", "Chicleteira Cupideira", "La Karkerkar Combinasion",
    "Chillin Chili", "Chipso and Queso", "Money Money Reindeer",
    "Money Money Puggy", "Churrito Bunnito", "Celularcini Viciosini",
    "Los Planitos", "Los Mobilis", "Los 67", "Mieteteira Bicicleteira",
    "Tuff Toucan", "La Spooky Grande", "Los Spooky Combinasionas",
    "Cigno Fulgoro", "Los Candies", "Los Hotspositos", "Los Jolly Combinasionas",
    "Los Cupids", "Los Puggies", "W or L", "Tralalalaledon", "La Extinct Grande Combinasion",
    "Tralaledon", "La Jolly Grande", "Los Primos", "Bacuru and Egguru",
    "Eviledon", "Los Tacoritas", "Lovin Rose", "Tang Tang Kelentang",
    "Ketupat Kepat", "Los Bros", "Tictac Sahur", "La Romantic Grande",
    "Gingerat Gerat", "Orcaledon", "La Lucky Grande", "Ketchuru and Masturu",
    "Jolly Jolly Sahur", "Garama and Madundung", "Rosetti Tualetti",
    "Nacho Spyder", "Hopilikalika Hopilikalako", "Festive 67", "Sammyni Fattini",
    "Love Love Bear", "La Ginger Sekolah", "Spooky and Pumpky", "Boppin Bunny",
    "Lavadorito Spinito", "La Food Combinasion", "Los Spaghettis", "La Casa Boo",
    "Fragrama and Chocrama", "Los Sekolahs", "Foxini Lanternini", "La Secret Combinasion",
    "Los Amigos", "Reinito Sleighito", "Ketupat Bros", "Burguro and Fryuro",
    "Cooki and Milki", "Capitano Moby", "Rosey and Teddy", "Popcuru and Fizzuru",
    "Hydra Bunny", "Celestial Pegasus", "Cerberus", "La Supreme Combinasion",
    "Dragon Cannelloni", "Dragon Gingerini", "Headless Horseman", "Hydra Dragon Cannelloni",
    "Griffin", "Skibidi Toilet", "Meowl", "Strawberry Elephant", "La Vacca Saturno Saturnita",
    "Pandanini Frostini", "Bisonte Giuppitere", "Blackhole Goat", "Jackorilla",
    "Agarrini Ia Palini", "Chachechi", "Karkerkar Kurkur", "Los Tortus", "Los Matteos",
    "Sammyni Spyderini", "Trenostruzzo Turbo 4000", "Chimpanzini Spiderini",
    "Boatito Auratito", "Fragola La La La", "Dul Dul Dul", "La Vacca Prese Presente",
    "Frankentteo", "Los Trios", "Karker Sahur", "Torrtuginni Dragonfrutini (Lucky Block)",
    "Los Tralaleritos", "Zombie Tralala", "La Cucaracha", "Vulturino Skeletono",
    "Guerriro Digitale", "Extinct Tralalero", "Yess My Examine", "Extinct Matteo",
    "Las Tralaleritas", "Rocco Disco", "Reindeer Tralala", "Las Vaquitas Saturnitas",
    "Pumpkin Spyderini", "Job Job Job Sahur", "Los Karkeritos", "Graipuss Medussi",
    "Santteo", "Fishboard", "Buntteo", "La Vacca Jacko Linterino", "Triplito Tralaleritos",
    "Trickolino", "Paradiso Axolottino", "GOAT", "Giftini Spyderini", "Los Spyderinis",
    "Love Love Love Sahur", "Perrito Burrito", "1x1x1x1", "Los Cucarachas",
    "Easter Easter Sahur", "Please My Present", "Cuadramat and Pakrahmatmamat",
    "Los Jobcitos", "Nooo My Hotspot", "Pot Hotspot (Lucky Block)", "Noo My Examine",
    "Telemorte", "La Sahur Combinasion", "List List List Sahur", "Bunny Bunny Bunny Sahur",
    "To To To Sahur", "Pirulitoita Bicicletaire", "25", "Santa Hotspot", "Horegini Boom",
    "Quesadilla Crocodila", "Pot Pumpkin", "Naughty Naughty", "Cupid Cupid Sahur",
    "Ho Ho Ho Sahur", "Mi Gatito", "Chicleteira Bicicleteira", "Eid Eid Eid Sahur",
    "Cupid Hotspot", "Spaghetti Tualetti (Lucky Block)", "Esok Sekolah (Lucky Block)",
    "Quesadillo Vampiro", "Brunito Marsito", "Chill Puppy", "Burrito Bandito",
    "Chicleteirina Bicicleteirina", "Granny", "Los Bunitos", "Los Quesadillas",
    "Bunito Bunito Spinito", "Noo My Candy"
}

local NotifSound = Instance.new("Sound")
NotifSound.Name = "LacedNotifSound"
NotifSound.SoundId = "rbxassetid://4590662766"
NotifSound.Volume = 1
NotifSound.Parent = game:GetService("SoundService")

local function playNotifSound()
    if userSettings.PlaySound then NotifSound:Play() end
end

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

-- [[ UI CREATION ]] --
local Gui = Instance.new("ScreenGui", game:GetService("CoreGui") or lp.PlayerGui)
Gui.Name = "AJGODZX_ULTRA"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Size = UDim2.new(0, 170, 0, 95)
Main.Position = UDim2.new(0.5, -85, 0, 30)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 200)

local Header = Instance.new("TextLabel", Main)
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 20)
Header.Font = Enum.Font.GothamBold
Header.Text = "AJGODZX ULTRA v1.0.5"
Header.TextColor3 = Color3.fromRGB(0, 255, 200)
Header.TextSize = 10

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 22)
StatusLabel.Size = UDim2.new(1, -20, 0, 15)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = "Status: Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 10
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local StatsLabel = Instance.new("TextLabel", Main)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Position = UDim2.new(0, 10, 0, 37)
StatsLabel.Size = UDim2.new(1, -20, 0, 15)
StatsLabel.Font = Enum.Font.GothamMedium
StatsLabel.Text = "Hops: 0 | Pings: 0"
StatsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatsLabel.TextSize = 9
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left

local MaxValLabel = Instance.new("TextLabel", Main)
MaxValLabel.BackgroundTransparency = 1
MaxValLabel.Position = UDim2.new(0, 10, 0, 52)
MaxValLabel.Size = UDim2.new(1, -20, 0, 20)
MaxValLabel.Font = Enum.Font.GothamBold
MaxValLabel.Text = "MAX: 0M"
MaxValLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
MaxValLabel.TextSize = 16
MaxValLabel.TextXAlignment = Enum.TextXAlignment.Left

local ErrorLabel = Instance.new("TextLabel", Main)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Position = UDim2.new(0, 10, 0, 72)
ErrorLabel.Size = UDim2.new(1, -20, 0, 15)
ErrorLabel.Font = Enum.Font.GothamMedium
ErrorLabel.Text = "Last Error: None"
ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
ErrorLabel.TextSize = 8
ErrorLabel.TextXAlignment = Enum.TextXAlignment.Left

local HopBtn = Instance.new("TextButton", Main)
HopBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HopBtn.Position = UDim2.new(0.05, 0, 0.9, 0)
HopBtn.Size = UDim2.new(0.9, 0, 0, 14)
HopBtn.Font = Enum.Font.GothamBold
HopBtn.Text = "FORCE SERVER HOP"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 8
Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 4)

-- Draggable
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(Main)

-- [[ BOT LOGIC ]] --
local seenIds = {}
local hopsCount = 0
local pingsCount = 0
local isHopping = false

-- Persistent JobID Cache to prevent re-logging the same server
local function isServerSeen(jobId)
    if not readfile or not writefile then return false end
    local success, content = pcall(function() return readfile("aj_seen_servers.txt") end)
    if success and content then
        return string.find(content, jobId)
    end
    return false
end

local function markServerSeen(jobId)
    if not readfile or not writefile then return end
    local success, content = pcall(function() return readfile("aj_seen_servers.txt") end)
    local newContent = (success and content or "") .. jobId .. ","
    -- Keep only the last 1000 characters to prevent file bloat
    if #newContent > 1000 then newContent = newContent:sub(-1000) end
    pcall(function() writefile("aj_seen_servers.txt", newContent) end)
end

local function updateStatus(text, color)
    StatusLabel.Text = "Status: " .. text
    if color then StatusLabel.TextColor3 = color end
end

local function updateStats(serverMax)
    StatsLabel.Text = "Hops: " .. hopsCount .. " | Pings: " .. pingsCount
    if serverMax then
        MaxValLabel.Text = "MAX: " .. formatNumber(serverMax)
    end
end

local function logError(text)
    ErrorLabel.Text = "Error: " .. tostring(text)
end

local function serverHop()
    if isHopping then return end
    isHopping = true
    updateStatus("Hopping...", Color3.fromRGB(255, 200, 0))
    
    local success, err = pcall(function()
        if queue_on_teleport then
            queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/carinodanielcarl-cmd/LOGGERNOTIF/main/LOGGERFINDER.lua?t=" .. tostring(tick())))()]])
        end
        
        -- Bypass HttpService limits by using the executor's native request to the official Roblox API
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        local res
        local reqFunction = (syn and syn.request) or request or http_request
        if reqFunction then
            res = reqFunction({Url = url, Method = "GET"}).Body
        else
            res = game:HttpGet(url)
        end
        
        local data = HttpService:JSONDecode(res)
        local servers = {}
        if data and data.data then
            for _, s in ipairs(data.data) do
                if type(s) == "table" and s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then 
                    table.insert(servers, s.id) 
                end
            end
        end

        if #servers > 0 then
            local randomId = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomId, lp)
        else
            TeleportService:Teleport(game.PlaceId, lp)
        end
    end)
    
    if not success then 
        logError("Hop Fail: " .. tostring(err):sub(1,20)) 
        -- If API fails completely, force a standard hop so the bot never gets permanently stuck
        pcall(function() TeleportService:Teleport(game.PlaceId, lp) end)
        task.wait(2)
        isHopping = false
    end
end

HopBtn.MouseButton1Click:Connect(serverHop)

local function postLogBatch(newFindings)
    if #newFindings == 0 then return end
    pcall(function()
        local success, currentRaw = pcall(function() return game:HttpGet(SHARED_URL) end)
        if not success then logError("Download Error") return end
        
        local decodeSuccess, currentData = pcall(function() return HttpService:JSONDecode(currentRaw) end)
        if not decodeSuccess or type(currentData) ~= "table" then currentData = {findings = {}} end
        if not currentData.findings then currentData.findings = {} end
        
        for _, newFinding in ipairs(newFindings) do
            table.insert(currentData.findings, 1, newFinding)
        end
        while #currentData.findings > 20 do table.remove(currentData.findings, 21) end
        
        local body = HttpService:JSONEncode(currentData)
        local options = {
            Url = SHARED_URL, Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = body
        }
        
        local reqFunction = (syn and syn.request) or request or http_request
        if reqFunction then
            reqFunction(options)
        else
            -- Very dangerous to not have request, but attempt a fallback
            pcall(function() HttpService:RequestAsync(options) end)
        end
        
        pingsCount = pingsCount + #newFindings
        updateStats()
    end)
end

local function scanWorkspace()
    local findings = {}
    local pCount, mPlayers = #Players:GetPlayers(), Players.MaxPlayers
    local serverMax = 0

    -- Helper to extract value and update server max
    local function processItem(t, base, val, mutation, owner)
        local vObj = t:FindFirstChild("Value") or t:FindFirstChild("Price") or t:FindFirstChild("PriceValue")
        local actualVal = (vObj and vObj:IsA("ValueBase") and vObj.Value) or (type(val) == "number" and val or 0)
        
        if actualVal > serverMax then serverMax = actualVal end
        
        -- High rarity value overrides
        if mutation == "Diamond" or mutation == "Divine" or mutation == "Galaxy" then 
            if actualVal < 200000000 then actualVal = 200000000 end
        end

        local findingId = game.JobId .. "_" .. t.Name .. "_" .. tostring(mutation) .. "_" .. tostring(owner)
        local accurate_name = t.Name
        if mutation and not string.find(accurate_name, mutation) then
            accurate_name = mutation .. " " .. accurate_name
        end
        
        -- Add owner info to name if found in inventory
        if owner then
            accurate_name = accurate_name .. " (Held by " .. owner .. ")"
        end

        table.insert(findings, {
            id = findingId,
            name = accurate_name, 
            base_name = base or "discovered", 
            value = actualVal, 
            mutation = mutation,
            tier = (actualVal >= 100000000) and "Highlights" or "Midlights",
            players = pCount .. "/" .. mPlayers, job_id = game.JobId, place_id = game.PlaceId, timestamp = os.time()
        })
    end

    local function checkMatch(name)
        local cleanTarget = string.lower(string.gsub(name, "[%s%-]", ""))
        if #cleanTarget > 25 and string.find(name, "-") then return nil, nil end -- Skip UUIDs
        
        for _, base in ipairs(allBrainrots) do
            local cleanBase = string.lower(string.gsub(base, "[%s%-]", ""))
            local val = 0 -- Default value for generic items
            
            -- Exact match for short names, substring for long names
            local isMatch = false
            if #cleanBase <= 3 then
                isMatch = (cleanTarget == cleanBase)
            else
                isMatch = (string.find(cleanTarget, cleanBase) or string.find(cleanBase, cleanTarget))
            end

            if isMatch then
                return base, val, nil
            end
            
            -- Mutation check
            for _, mut in ipairs(Mutations) do
                local cleanMut = string.lower(mut)
                if string.find(cleanTarget, cleanMut) and string.find(cleanTarget, cleanBase) then
                    return base, val, mut
                end
            end
        end
        return nil, nil, nil
    end

    -- SCAN 1: THE GROUND (Workspace)
    for _, item in ipairs(game.Workspace:GetChildren()) do
        if Players:GetPlayerFromCharacter(item) then continue end
        local targets = item:IsA("Folder") and item:GetChildren() or {item}
        for _, t in ipairs(targets) do
            if Players:GetPlayerFromCharacter(t) then continue end
            if t:IsA("Model") or t:IsA("Part") or t:IsA("Tool") then
                local base, val, mut = checkMatch(t.Name)
                if base then 
                    processItem(t, base, val, mut, nil) 
                else
                    -- DISCOVERY MODE: Log anything with a Value > 50M even if not on whitelist
                    local vObj = t:FindFirstChild("Value") or t:FindFirstChild("Price") or t:FindFirstChild("PriceValue")
                    if vObj and vObj:IsA("ValueBase") and vObj.Value >= 50000000 then
                        processItem(t, nil, vObj.Value, nil, nil)
                    end
                end
            end
        end
    end

    -- SCAN 2: PLAYER INVENTORIES (Carried items)
    for _, player in ipairs(Players:GetPlayers()) do
        if player == lp then continue end
        local inv = {}
        if player.Character then 
            for _, c in ipairs(player.Character:GetChildren()) do table.insert(inv, c) end
        end
        local bp = player:FindFirstChild("Backpack")
        if bp then
            for _, c in ipairs(bp:GetChildren()) do table.insert(inv, c) end
        end

        for _, t in ipairs(inv) do
            if t:IsA("Tool") or t:IsA("Model") then
                local base, val, mut = checkMatch(t.Name)
                if base then 
                    processItem(t, base, val, mut, player.Name) 
                else
                    -- DISCOVERY MODE for inventories
                    local vObj = t:FindFirstChild("Value") or t:FindFirstChild("Price") or t:FindFirstChild("PriceValue")
                    if vObj and vObj:IsA("ValueBase") and vObj.Value >= 50000000 then
                        processItem(t, nil, vObj.Value, nil, player.Name)
                    end
                end
            end
        end
    end
    
    updateStats(serverMax)
    return findings
end

task.spawn(function()
    local lastHopTime = tick()
    while true do
        pcall(function()
            if isServerSeen(game.JobId) then
                updateStatus("Server Already Logged", Color3.fromRGB(200, 200, 200))
                return
            end

            updateStatus("Scanning...", Color3.fromRGB(0, 255, 200))
            local findings = scanWorkspace()
            local batchUpload = {}
            for _, find in ipairs(findings) do
                local key = find.name .. game.JobId
                if not seenIds[key] then
                    seenIds[key] = true
                    table.insert(batchUpload, find)
                end
            end
            if #batchUpload > 0 then
                -- PEAK VALUE LOGGING: Only log the absolute best item from the server
                table.sort(batchUpload, function(a, b) return a.value > b.value end)
                local peakFinding = { batchUpload[1] }
                
                playNotifSound()
                updateStatus("Syncing Peak Finding...", Color3.fromRGB(0, 150, 255))
                postLogBatch(peakFinding)
                markServerSeen(game.JobId)
            end
        end)
        
        local elapsed = tick() - lastHopTime
        if elapsed >= SCAN_TIME_PER_SERVER then
            serverHop()
            lastHopTime = tick()
        else
            updateStatus("Hop in: " .. math.ceil(SCAN_TIME_PER_SERVER - elapsed) .. "s", Color3.fromRGB(200, 200, 200))
        end
        task.wait(SCAN_INTERVAL)
    end
end)