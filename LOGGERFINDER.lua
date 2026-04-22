-- AJGODZX SCANNER BOT (Professional Headless Version)
-- Automaticaly hops servers, scans for mutation items, and pings logs to AJ Joiner.
-- VERSION: 1.0.3 (Teleport FIX)

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local task = task or {wait = wait, spawn = spawn}

local lp = Players.LocalPlayer

-- [[ CONFIGURATION ]] --
local SCAN_INTERVAL = 1.0
local SCAN_TIME_PER_SERVER = 5 -- 5 Seconds as requested
local SHARED_URL = "https://api.npoint.io/3b590339f6bef0db0dfd" 

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

local seenIds = {}

local function serverHop()
    print("📦 [BOT] Fetching servers...")
    local success, result = pcall(function()
        local servers = {}
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        local res = game:HttpGet(url)
        local data = HttpService:JSONDecode(res)
        
        for _, s in ipairs(data.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                table.insert(servers, s)
            end
        end
        
        if #servers > 0 then
            table.sort(servers, function(a, b) return a.playing < b.playing end)
            local target = servers[1].id
            print("📦 [BOT] Target found: " .. target)
            
            if queue_on_teleport then
                queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/carinodanielcarl-cmd/LOGGERNOTIF/main/LOGGERFINDER.lua"))()]])
            end
            
            TeleportService:TeleportToPlaceInstance(game.PlaceId, target, lp)
        else
            print("📦 [BOT] No available servers found. Retrying in 5s...")
        end
    end)
    if not success then print("📦 [BOT] Hop failed: " .. tostring(result)) end
    return success
end

local function postLog(newFinding)
    pcall(function()
        local success, currentRaw = pcall(function() return game:HttpGet(SHARED_URL) end)
        if not success then return end
        
        local decodeSuccess, currentData = pcall(function() return HttpService:JSONDecode(currentRaw) end)
        if not decodeSuccess or not currentData then currentData = {findings = {}} end
        if not currentData.findings then currentData.findings = {} end
        
        newFinding.id = os.time() + math.random(1, 1000)
        table.insert(currentData.findings, 1, newFinding) 
        
        if #currentData.findings > 30 then table.remove(currentData.findings, 31) end
        
        local body = HttpService:JSONEncode(currentData)
        local options = {
            Url = SHARED_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = body
        }
        
        if syn and syn.request then syn.request(options)
        elseif request then request(options)
        elseif http_request then http_request(options)
        end
    end)
end

local function scanWorkspace()
    local findings = {}
    local pCount = #Players:GetPlayers()
    local mPlayers = Players.MaxPlayers
    
    for _, item in ipairs(game.Workspace:GetDescendants()) do
        if item:IsA("Model") or item:IsA("Part") then
            for _, base in ipairs(allBrainrots) do
                if item.Name:find(base) then
                    local mutation = nil
                    for _, mut in ipairs(Mutations) do
                        if item.Name:find(mut) then mutation = mut break end
                    end
                    
                    local val = 50000000 -- Default (Mid)
                    if mutation == "Diamond" or mutation == "Divine" or mutation == "Galaxy" then val = 200000000 end
                    
                    table.insert(findings, {
                        name = item.Name,
                        base_name = base,
                        value = val,
                        mutation = mutation,
                        tier = (val >= 100000000) and "Highlights" or "Midlights",
                        players = pCount .. "/" .. mPlayers,
                        job_id = game.JobId,
                        timestamp = os.time()
                    })
                    break
                end
            end
        end
    end
    return findings
end

print("========================================")
print("🤖 AJGODZX PRO BOT RUNNING (v1.0.3)")
print("📡 Mode: Headless Serverless")
print("⏳ Hop Speed: " .. SCAN_TIME_PER_SERVER .. "s")
print("========================================")

_G.AJGODZXScannerRunning = true

task.spawn(function()
    local startTime = tick()
    while _G.AJGODZXScannerRunning do
        pcall(function()
            local findings = scanWorkspace()
            for _, find in ipairs(findings) do
                local key = find.name .. game.JobId
                if not seenIds[key] then
                    seenIds[key] = true
                    print("💎 [BOT] Found " .. find.name .. "! Syncing...")
                    postLog(find)
                end
            end
        end)
        
        if (tick() - startTime) >= SCAN_TIME_PER_SERVER then
            print("📦 [BOT] 5s elapsed. Preparing to hop...")
            task.wait(0.5) 
            serverHop()
            startTime = tick() 
        end
        
        task.wait(SCAN_INTERVAL)
    end
end)