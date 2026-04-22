-- AJGODZX SCANNER BOT (Mini-UI Version v1.0.4)
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

-- [[ UI CREATION ]] --
local Gui = Instance.new("ScreenGui", game:GetService("CoreGui") or lp.PlayerGui)
Gui.Name = "AJGODZX_MINI"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Size = UDim2.new(0, 160, 0, 75)
Main.Position = UDim2.new(0.5, -80, 0, 20)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 200)

local Header = Instance.new("TextLabel", Main)
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 20)
Header.Font = Enum.Font.GothamBold
Header.Text = "AJGODZX BOT v1.0.4"
Header.TextColor3 = Color3.fromRGB(0, 255, 200)
Header.TextSize = 10

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 25)
StatusLabel.Size = UDim2.new(1, -20, 0, 15)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = "Status: Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 10
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local StatsLabel = Instance.new("TextLabel", Main)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Position = UDim2.new(0, 10, 0, 40)
StatsLabel.Size = UDim2.new(1, -20, 0, 15)
StatsLabel.Font = Enum.Font.GothamMedium
StatsLabel.Text = "Hops: 0 | Pings: 0"
StatsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatsLabel.TextSize = 9
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left

local HopBtn = Instance.new("TextButton", Main)
HopBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HopBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
HopBtn.Size = UDim2.new(0.9, 0, 0, 15)
HopBtn.Font = Enum.Font.GothamBold
HopBtn.Text = "MANUAL HOP"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 8
Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 4)

-- Draggable logic
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

local function updateStatus(text, color)
    StatusLabel.Text = "Status: " .. text
    if color then StatusLabel.TextColor3 = color end
end

local function updateStats()
    StatsLabel.Text = "Hops: " .. hopsCount .. " | Pings: " .. pingsCount
end

local function serverHop()
    updateStatus("Hopping...", Color3.fromRGB(255, 200, 0))
    pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        local res = game:HttpGet(url)
        local data = HttpService:JSONDecode(res)
        local servers = {}
        for _, s in ipairs(data.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then table.insert(servers, s) end
        end
        if #servers > 0 then
            table.sort(servers, function(a, b) return a.playing < b.playing end)
            local target = servers[1].id
            if queue_on_teleport then
                queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/carinodanielcarl-cmd/LOGGERNOTIF/main/LOGGERFINDER.lua"))()]])
            end
            TeleportService:TeleportToPlaceInstance(game.PlaceId, target, lp)
        end
    end)
end

HopBtn.MouseButton1Click:Connect(serverHop)

local function postLog(newFinding)
    pcall(function()
        local success, currentRaw = pcall(function() return game:HttpGet(SHARED_URL) end)
        if not success then return end
        local decodeSuccess, currentData = pcall(function() return HttpService:JSONDecode(currentRaw) end)
        if not decodeSuccess or not currentData then currentData = {findings = {}} end
        
        table.insert(currentData.findings, 1, newFinding)
        if #currentData.findings > 30 then table.remove(currentData.findings, 31) end
        
        local options = {
            Url = SHARED_URL, Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(currentData)
        }
        if syn and syn.request then syn.request(options) elseif request then request(options) end
        pingsCount = pingsCount + 1
        updateStats()
    end)
end

local function scanWorkspace()
    updateStatus("Scanning...", Color3.fromRGB(0, 255, 200))
    local findings = {}
    local pCount, mPlayers = #Players:GetPlayers(), Players.MaxPlayers
    for _, item in ipairs(game.Workspace:GetDescendants()) do
        if item:IsA("Model") or item:IsA("Part") then
            for _, base in ipairs(allBrainrots) do
                if item.Name:find(base) then
                    local mutation = nil
                    for _, mut in ipairs(Mutations) do if item.Name:find(mut) then mutation = mut break end end
                    local val = 50000000 
                    if mutation == "Diamond" or mutation == "Divine" or mutation == "Galaxy" then val = 200000000 end
                    table.insert(findings, {
                        name = item.Name, base_name = base, value = val, mutation = mutation,
                        tier = (val >= 100000000) and "Highlights" or "Midlights",
                        players = pCount .. "/" .. mPlayers, job_id = game.JobId, timestamp = os.time()
                    })
                    break
                end
            end
        end
    end
    return findings
end

task.spawn(function()
    local startTime = tick()
    while true do
        pcall(function()
            local findings = scanWorkspace()
            for _, find in ipairs(findings) do
                local key = find.name .. game.JobId
                if not seenIds[key] then
                    seenIds[key] = true
                    updateStatus("Syncing Ping...", Color3.fromRGB(0, 150, 255))
                    postLog(find)
                end
            end
        end)
        
        local elapsed = tick() - startTime
        if elapsed >= SCAN_TIME_PER_SERVER then
            serverHop()
            startTime = tick()
        else
            updateStatus("Next Hop: " .. math.ceil(SCAN_TIME_PER_SERVER - elapsed) .. "s", Color3.fromRGB(200, 200, 200))
        end
        task.wait(SCAN_INTERVAL)
    end
end)