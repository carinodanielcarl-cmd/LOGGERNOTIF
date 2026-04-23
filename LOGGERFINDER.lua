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

-- Mutation detection
local Mutations = {"Diamond", "Gold", "Cyber", "Rainbow", "Candy", "Divine", "Galaxy", "Radioactive", "YinYang", "Halloween", "Christmas"}

local allBrainrots = {
    ["67"] = 1000000000,
    ["eviledon"] = 0,
    ["esok-sekolah"] = 1000000000,
    ["la-grande-combinasion"] = 1000000000,
    ["los-puggies"] = 1000000000,
    ["los-combinasionas"] = 1000000000,
    ["spaghetti-tualetti"] = 1000000000,
    ["los-mobilis"] = 1000000000,
    ["los-burritos"] = 1000000000,
    ["los-bros"] = 1000000000,
    ["los-spaghettis"] = 1000000000,
    ["los-spooky-combinasionas"] = 1000000000,
    ["los-nooo-my-hotspotsitos"] = 1000000000,
    ["mariachi-corazoni"] = 1000000000,
    ["los-67"] = 1000000000,
    ["swag-soda"] = 0,
    ["la-secret-combinasion"] = 0,
    ["gobblino-uniciclino"] = 0,
    ["cooki-and-milki"] = 0,
    ["strawberry-elephant"] = 0,
    ["burguro-and-fryuro"] = 0,
    ["dragon-cannelloni"] = 0,
    ["garama-and-madundung"] = 0,
    ["orcaledon"] = 0,
    ["nuclearo-dinossauro"] = 0,
    ["la-taco-combinasion"] = 0,
    ["la-spooky-grande"] = 0,
    ["w-or-l"] = 0,
    ["tralaledon"] = 0,
    ["tictac-sahur"] = 0,
    ["los-primos"] = 1000000000,
    ["lavadorito-spinito"] = 0,
    ["la-extinct-grande"] = 0,
    ["ketchuru-and-musturu"] = 0,
    ["ketupat-kepat"] = 0,
    ["tacorita-bicicleta"] = 0,
    ["capitano-moby"] = 0,
    ["chicleteira-noelteira"] = 0,
    ["la-jolly-grande"] = 0,
    ["spooky-and-pumpky"] = 0,
    ["los-cucarachas"] = 1000000000,
    ["to-to-to-sahur"] = 1000000000,
    ["horegini-boom"] = 1000000000,
    ["burrito-bandito"] = 1000000000,
    ["quesadilla-crocodila"] = 1000000000,
    ["tung-tung-tung-sahur"] = 1000000000,
    ["pot-hotspot"] = 1000000000,
    ["los-jobcitos"] = 1000000000,
    ["graipuss-medussi"] = 1000000000,
    ["la-cucaracha"] = 1000000000,
    ["pumpkini-spyderini"] = 1000000000,
    ["cuadramat-and-pakrahmatmamat"] = 1000000000,
    ["los-quesadillas"] = 1000000000,
    ["guerriro-digitale"] = 1000000000,
    ["los-tipi-tacos"] = 1000000000,
    ["zombie-tralala"] = 1000000000,
    ["las-tralaleritas"] = 1000000000,
    ["fragrama-and-chocrama"] = 0,
    ["los-tralaleritos"] = 1000000000,
    ["chicleteira-bicicleteira"] = 1000000000,
    ["job-job-job-sahur"] = 1000000000,
    ["chillin-chili"] = 0,
    ["los-chicleteiras"] = 1000000000,
    ["chipso-and-queso"] = 0,
    ["chimnino"] = 0,
    ["los-25"] = 1000000000,
    ["los-candies"] = 0,
    ["reinito-sleighito"] = 0,
    ["la-ginger-sekolah"] = 0,
    ["las-sis"] = 0,
    ["la-casa-boo"] = 0,
    ["dragon-gingerini"] = 0,
    ["festive-67"] = 0,
    ["meowl"] = 0,
    ["skibidi-toilet"] = 0,
    ["jolly-jolly-sahur"] = 0,
    ["los-tacoritas"] = 0,
    ["mieteteira-bicicleteira"] = 1000000000,
    ["tang-tang-keletang"] = 1000000000,
    ["money-money-puggy"] = 1000000000,
    ["ginger-gerat"] = 0,
    ["swaggy-bros"] = 0,
    ["headless-horseman"] = 0,
    ["la-supreme-combinasion"] = 0,
    ["money-money-reindeer"] = 0,
    ["los-jolly-combinasionas"] = 0,
    ["tuff-toucan"] = 0,
    ["los-hotspotsitos"] = 1000000000,
    ["fishino-clownino"] = 0,
    ["donkeyturbo-express"] = 0,
    ["cerberus"] = 0,
    ["brunito-marsito"] = 1000000000,
    ["hydra-dragon-cannelloni"] = 0,
    ["ketupat-bros"] = 0,
    ["spinny-hammy"] = 1000000000,
    ["bacuru-and-egguru"] = 1000000000,
    ["popcuru-and-fizzuru"] = 0,
    ["noo-my-heart"] = 1000000000,
    ["los-mi-gatitos"] = 1000000000,
    ["chicleteira-cupideira"] = 1000000000,
    ["rosey-and-teddy"] = 0,
    ["rosetti-tualetti"] = 1000000000,
    ["la-romantic-grande"] = 0,
    ["dj-panda"] = 1000000000,
    ["los-sekolahs"] = 1000000000,
    ["los-amigos"] = 0,
    ["sammyni-fattini"] = 0,
    ["la-food-combinasion"] = 0,
    ["signore-carapace"] = 0,
    ["celestial-pegasus"] = 0,
    ["antonio"] = 0,
    ["ventoliero-pavonero"] = 500000000,
    ["tirilikalika-tirilikalako"] = 0,
    ["elefanto-frigo"] = 0,
    ["griffin"] = 0,
    ["love-love-bear"] = 0,
    ["dug-dug-dug"] = 0,
    ["fortunu-and-cashuru"] = 0,
    ["foxini-lanternini"] = 0,
    ["gold-gold-gold"] = 0,
    ["hydra-bunny"] = 0,
    ["la-lucky-grande"] = 0,
    ["la-easter-grande"] = 0,
    ["baskito"] = 1000000000,
    ["churrito-bunnito"] = 1000000000,
    ["hopilikalika-hopilikalako"] = 0,
    ["pancake-and-syrup"] = 0,
    ["boppin-bunny"] = 0,
    ["bunny-and-eggy"] = 0,
    ["cash-or-card"] = 0,
    ["arcadragon"] = 0
}

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

local ErrorLabel = Instance.new("TextLabel", Main)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Position = UDim2.new(0, 10, 0, 52)
ErrorLabel.Size = UDim2.new(1, -20, 0, 15)
ErrorLabel.Font = Enum.Font.GothamMedium
ErrorLabel.Text = "Last Error: None"
ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
ErrorLabel.TextSize = 8
ErrorLabel.TextXAlignment = Enum.TextXAlignment.Left

local HopBtn = Instance.new("TextButton", Main)
HopBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HopBtn.Position = UDim2.new(0.05, 0, 0.78, 0)
HopBtn.Size = UDim2.new(0.9, 0, 0, 16)
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

local function updateStatus(text, color)
    StatusLabel.Text = "Status: " .. text
    if color then StatusLabel.TextColor3 = color end
end

local function updateStats()
    StatsLabel.Text = "Hops: " .. hopsCount .. " | Pings: " .. pingsCount
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
        while #currentData.findings > 30 do table.remove(currentData.findings, 31) end
        
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
    -- Scans children first for speed
    for _, item in ipairs(game.Workspace:GetChildren()) do
        -- SKIP PLAYER CHARACTERS
        if Players:GetPlayerFromCharacter(item) then continue end

        if item:IsA("Model") or item:IsA("Part") or item:IsA("Folder") then
            local targets = item:IsA("Folder") and item:GetChildren() or {item}
            for _, t in ipairs(targets) do
                -- Skip if 't' itself is a character
                if Players:GetPlayerFromCharacter(t) then continue end
                for base, val in pairs(allBrainrots) do
                    local matched = false
                    local mutation = nil
                    
                    -- FUZZY MATCH: Remove all spaces and hyphens, and make lowercase
                    local cleanTarget = string.lower(string.gsub(t.Name, "[%s%-]", ""))
                    local cleanBase = string.lower(string.gsub(base, "[%s%-]", ""))
                    
                    if cleanTarget == cleanBase then
                        matched = true
                    else
                        for _, mut in ipairs(Mutations) do
                            local cleanMut = string.lower(mut)
                            if cleanTarget == cleanMut .. cleanBase or cleanTarget == cleanBase .. cleanMut then
                                matched = true
                                mutation = mut
                                break
                            end
                        end
                    end

                    if matched then
                        -- Override value if it's an extreme rarity mutation
                        local finalVal = type(val) == "number" and val or 50000000
                        if mutation == "Diamond" or mutation == "Divine" or mutation == "Galaxy" then finalVal = 200000000 end
                        
                        -- CRITICAL: Do NOT use os.time() here!
                        local findingId = game.JobId .. "_" .. t.Name .. "_" .. tostring(mutation)
                        
                        -- Set name to base so aj.lua shows the exact config string!
                        local display_name = base
                        if mutation then display_name = mutation .. " " .. base end

                        table.insert(findings, {
                            id = findingId,
                            name = display_name, base_name = base, value = finalVal, mutation = mutation,
                            tier = (finalVal >= 100000000) and "Highlights" or "Midlights",
                            players = pCount .. "/" .. mPlayers, job_id = game.JobId, place_id = game.PlaceId, timestamp = os.time()
                        })
                        break
                    end
                end
            end
        end
    return findings
end

task.spawn(function()
    local lastHopTime = tick()
    while true do
        pcall(function()
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
                updateStatus("Syncing " .. #batchUpload .. " Pings...", Color3.fromRGB(0, 150, 255))
                postLogBatch(batchUpload)
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