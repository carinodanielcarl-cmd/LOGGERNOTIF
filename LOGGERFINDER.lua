-- LOGGERFINDER v1.5.0 (Value-Priority Scanner)
-- Scans for high-value items first, names second.

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local lp = Players.LocalPlayer

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

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 200, 0, 100)
Main.Position = UDim2.new(0, 10, 1, -110)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "AJGODZX BOT v1.5"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextColor3 = Color3.fromRGB(80, 180, 255)
Title.BackgroundTransparency = 1

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 25)
StatusLabel.Text = "Initializing..."
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.BackgroundTransparency = 1

local StatsLabel = Instance.new("TextLabel", Main)
StatsLabel.Size = UDim2.new(1, 0, 0, 20)
StatsLabel.Position = UDim2.new(0, 0, 0, 45)
StatsLabel.Text = "Hops: 0 | Pings: 0"
StatsLabel.Font = Enum.Font.GothamSemibold
StatsLabel.TextSize = 11
StatsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsLabel.BackgroundTransparency = 1

local MaxValLabel = Instance.new("TextLabel", Main)
MaxValLabel.Size = UDim2.new(1, 0, 0, 20)
MaxValLabel.Position = UDim2.new(0, 0, 0, 65)
MaxValLabel.Text = "MAX: 0"
MaxValLabel.Font = Enum.Font.GothamBold
MaxValLabel.TextSize = 12
MaxValLabel.TextColor3 = Color3.fromRGB(45, 210, 110)
MaxValLabel.BackgroundTransparency = 1

local function updateStatus(txt, col)
    StatusLabel.Text = txt
    if col then StatusLabel.TextColor3 = col end
end

local hopsCount = 0
local pingsCount = 0
local function updateStats(serverMax)
    StatsLabel.Text = "Hops: " .. hopsCount .. " | Pings: " .. pingsCount
    if serverMax then
        MaxValLabel.Text = "MAX: " .. formatNumber(serverMax)
    end
end

-- [[ CORE LOGIC ]] --
local function serverHop()
    hopsCount = hopsCount + 1
    updateStats()
    updateStatus("Hopping...", Color3.fromRGB(255, 150, 0))
    
    local success, err = pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
        for _, s in pairs(servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, lp)
                break
            end
        end
    end)
    if not success then warn("Hop failed: " .. tostring(err)) end
end

local function postLogBatch(batch)
    pcall(function()
        local res = game:HttpGet(SHARED_URL)
        local currentData = HttpService:JSONDecode(res) or {findings = {}}
        
        for _, entry in ipairs(batch) do
            table.insert(currentData.findings, 1, entry)
            pingsCount = pingsCount + 1
        end
        
        -- Keep last 20 logs
        while #currentData.findings > 20 do table.remove(currentData.findings, 21) end
        
        local body = HttpService:JSONEncode(currentData)
        local request = (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request) or request
        request({
            Url = SHARED_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = body
        })
        updateStats()
    end)
end

-- Persistence across teleports
local SEEN_FILE = "aj_seen_servers.txt"
local function markServerSeen(jobId)
    local seen = {}
    if isfile(SEEN_FILE) then
        for id in readfile(SEEN_FILE):gmatch("[^\n]+") do seen[id] = true end
    end
    seen[jobId] = true
    local out = ""
    for id in pairs(seen) do out = out .. id .. "\n" end
    writefile(SEEN_FILE, out)
end

local function isServerSeen(jobId)
    if not isfile(SEEN_FILE) then return false end
    return readfile(SEEN_FILE):find(jobId) ~= nil
end

local function scanWorkspace()
    local findings = {}
    local pCount, mPlayers = #Players:GetPlayers(), Players.MaxPlayers
    local serverMax = 0

    local function processItem(t, base, val, mutation, owner)
        local vObj = t:FindFirstChild("Value") or t:FindFirstChild("Price") or t:FindFirstChild("PriceValue")
        local actualVal = (vObj and vObj:IsA("ValueBase") and vObj.Value) or (type(val) == "number" and val or 0)
        
        if actualVal <= 0 and not base then return end
        if actualVal > serverMax then serverMax = actualVal end
        if base and actualVal <= 0 then actualVal = 50000000 end

        local findingId = game.JobId .. "_" .. t.Name .. "_" .. tostring(mutation) .. "_" .. tostring(owner) .. "_" .. tick()
        local accurate_name = t.Name
        if mutation and not string.find(accurate_name, mutation) then accurate_name = mutation .. " " .. accurate_name end
        if owner then accurate_name = accurate_name .. " (Held by " .. owner .. ")" end

        table.insert(findings, {
            id = findingId,
            name = accurate_name, 
            base_name = base or accurate_name, 
            value = actualVal, 
            mutation = mutation,
            tier = (actualVal >= 100000000) and "Highlights" or "Midlights",
            players = pCount .. "/" .. mPlayers, job_id = game.JobId, place_id = game.PlaceId, timestamp = os.time()
        })
    end

    local function checkMatch(name)
        if not name or #name < 2 then return nil, nil, nil end
        local cleanTarget = string.lower(string.gsub(name, "[%s%-]", ""))
        for _, base in ipairs(allBrainrots) do
            local cleanBase = string.lower(string.gsub(base, "[%s%-]", ""))
            for _, mut in ipairs(Mutations) do
                if string.find(cleanTarget, string.lower(mut)) and string.find(cleanTarget, cleanBase) then
                    return base, 50000000, mut
                end
            end
            if cleanTarget == cleanBase or (#cleanBase > 3 and string.find(cleanTarget, cleanBase)) then
                return base, 50000000, nil
            end
        end
        return nil, nil, nil
    end

    -- SCANNING
    for _, t in ipairs(game.Workspace:GetDescendants()) do
        if t:IsA("Model") or t:IsA("Tool") or t:IsA("MeshPart") then
            local base, val, mut = checkMatch(t.Name)
            local vObj = t:FindFirstChild("Value") or t:FindFirstChild("Price") or t:FindFirstChild("PriceValue")
            if vObj and vObj:IsA("ValueBase") and vObj.Value >= 1000000 then
                processItem(t, base, vObj.Value, mut, nil)
            elseif base then
                processItem(t, base, val, mut, nil)
            end
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        local containers = {player.Character, player:FindFirstChild("Backpack")}
        for _, cont in ipairs(containers) do
            if cont then
                for _, t in ipairs(cont:GetChildren()) do
                    if t:IsA("Tool") or t:IsA("Model") then
                        local base, val, mut = checkMatch(t.Name)
                        local vObj = t:FindFirstChild("Value") or t:FindFirstChild("Price") or t:FindFirstChild("PriceValue")
                        if vObj and vObj:IsA("ValueBase") and vObj.Value >= 1000000 then
                            processItem(t, base, vObj.Value, mut, player.Name)
                        elseif base then
                            processItem(t, base, val, mut, player.Name)
                        end
                    end
                end
            end
        end
    end

    updateStats(serverMax)

    if #findings > 0 then
        table.sort(findings, function(a, b) return a.value > b.value end)
        local peak = { findings[1] }
        if peak[1].value > 0 then
            playNotifSound()
            updateStatus("Syncing Peak: " .. formatNumber(peak[1].value), Color3.fromRGB(0, 255, 150))
            postLogBatch(peak)
            markServerSeen(game.JobId)
        end
    end
end

-- MAIN LOOP
task.spawn(function()
    local lastHopTime = tick()
    updateStatus("Value-Priority Active", Color3.fromRGB(0, 255, 0))
    while true do
        pcall(scanWorkspace)
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