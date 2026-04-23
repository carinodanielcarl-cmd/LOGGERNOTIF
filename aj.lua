-- AJGODZX CLASSIC (Powered by Laced Logic)
-- Accurate detection with the original simple UI

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")

local UI_NAME = "AJGODZX_CLASSIC"
if CoreGui:FindFirstChild(UI_NAME) then CoreGui[UI_NAME]:Destroy() end

local lp = Players.LocalPlayer
local STEAL_BRAINROT_PLACE_ID = 109983668079237
_G.AJRunning = true

-- ═══════════════════════════════════
-- THEME & SETTINGS
-- ═══════════════════════════════════
local T = {
    BgDark      = Color3.fromRGB(10, 10, 15),
    BgCard      = Color3.fromRGB(15, 15, 25),
    Accent1     = Color3.fromRGB(60, 130, 246),
    White       = Color3.fromRGB(240, 245, 255),
    TextDim     = Color3.fromRGB(150, 150, 170),
    Off         = Color3.fromRGB(30, 30, 40),
    Green       = Color3.fromRGB(45, 210, 110),
    Orange      = Color3.fromRGB(255, 165, 0),
    HighlightC  = Color3.fromRGB(255, 75, 75),
    MidlightC   = Color3.fromRGB(80, 175, 255),
}

local userSettings = {
    AutoJoin = false,
    PlaySound = true,
    WebhookEnabled = true,
    Whitelist = {}
}

local CONFIG_FILE = "AJGODZX_Config.json"
local SHARED_URL = "https://api.npoint.io/3b590339f6bef0db0dfd"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1496851695848657009/OCOh6ewiAsYMsSwvC0T-chTbt_hVvm64jAt919t5rXlhE4FGyssoAA5adTTb_TR_dQHr"

-- [[ PERSISTENCE ]] --
pcall(function()
    if isfile and readfile and isfile(CONFIG_FILE) then
        local saved = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(saved) == "table" then
            for k, v in pairs(saved) do userSettings[k] = v end
        end
    end
end)

task.spawn(function()
    local lastSave = HttpService:JSONEncode(userSettings)
    while _G.AJRunning do
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

-- [[ UTILS ]] --
local NotifSound = Instance.new("Sound")
NotifSound.SoundId = "rbxassetid://4590662766"
NotifSound.Parent = SoundService

local function playNotifSound()
    if userSettings.PlaySound then NotifSound:Play() end
end

local function sendWebhook(data)
    if not userSettings.WebhookEnabled or not WEBHOOK_URL or WEBHOOK_URL == "" then return end
    
    local payload = {
        ["embeds"] = {{
            ["title"] = "💎 New Brainrot Detected!",
            ["description"] = "A high-value item has been found and logged.",
            ["color"] = (data.tier == "Highlights") and 0xFF4B4B or 0x50AFFF,
            ["fields"] = {
                {["name"] = "Item", ["value"] = "```" .. (data.name or "Unknown") .. "```", ["inline"] = true},
                {["name"] = "Value", ["value"] = "```" .. formatNumber(data.value or 0) .. "```", ["inline"] = true},
                {["name"] = "Mutation", ["value"] = "```" .. (data.mutation or "Normal") .. "```", ["inline"] = true},
                {["name"] = "Server Info", ["value"] = "```" .. (data.players or "0/0") .. " Players```", ["inline"] = false},
                {["name"] = "Join Command", ["value"] = "```game:GetService('TeleportService'):TeleportToPlaceInstance(" .. data.place_id .. ", '" .. data.job_id .. "')```", ["inline"] = false}
            },
            ["footer"] = {["text"] = "AJGODZX Premium • " .. os.date("%X")},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    pcall(function()
        local request = (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request) or request
        if request then
            request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        else
            -- Fallback for basic executors
            HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(payload))
        end
    end)
end

local function formatNumber(n)
    n = tonumber(n) or 0
    if n >= 1000000 then
        return (string.format("%.1fM", n / 1000000)):gsub("%.0M", "M")
    elseif n >= 1000 then
        return (string.format("%.1fK", n / 1000)):gsub("%.0K", "K")
    end
    return tostring(n)
end

-- [[ GUI CONSTRUCTION ]] --
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = UI_NAME

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 350, 0, 450)
Main.Position = UDim2.new(0.5, -175, 0.5, -225)
Main.BackgroundColor3 = T.BgDark
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = T.BgCard
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AJGODZX PREMIUM"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = T.White
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = T.HighlightC
CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() 
    _G.AJRunning = false
    Gui:Destroy() 
end)

-- AutoJoin Toggle
local ajBtn = Instance.new("TextButton", Main)
ajBtn.Size = UDim2.new(1, -30, 0, 35)
ajBtn.Position = UDim2.new(0, 15, 0, 55)
ajBtn.BackgroundColor3 = userSettings.AutoJoin and T.Green or T.Off
ajBtn.Text = "AUTO JOIN: " .. (userSettings.AutoJoin and "ON" or "OFF")
ajBtn.Font = Enum.Font.GothamBold
ajBtn.TextSize = 12
ajBtn.TextColor3 = T.White
Instance.new("UICorner", ajBtn).CornerRadius = UDim.new(0, 6)

ajBtn.MouseButton1Click:Connect(function()
    userSettings.AutoJoin = not userSettings.AutoJoin
    ajBtn.Text = "AUTO JOIN: " .. (userSettings.AutoJoin and "ON" or "OFF")
    ajBtn.BackgroundColor3 = userSettings.AutoJoin and T.Green or T.Off
end)

local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -20, 1, -110)
Content.Position = UDim2.new(0, 10, 0, 100)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = T.Accent1

local CLayout = Instance.new("UIListLayout", Content)
CLayout.Padding = UDim.new(0, 8)
CLayout.SortOrder = Enum.SortOrder.LayoutOrder

CLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, CLayout.AbsoluteContentSize.Y + 10)
end)

-- [[ LOG ENTRY ]] --
local function addLogEntry(data)
    local isHL = data.tier == "Highlights"
    
    local card = Instance.new("Frame", Content)
    card.Size = UDim2.new(1, 0, 0, 65)
    card.BackgroundColor3 = T.BgCard
    card.LayoutOrder = -os.time()
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local side = Instance.new("Frame", card)
    side.Size = UDim2.new(0, 4, 1, 0)
    side.BackgroundColor3 = isHL and T.HighlightC or T.MidlightC
    Instance.new("UICorner", side).CornerRadius = UDim.new(1, 0)

    local nameL = Instance.new("TextLabel", card)
    nameL.Size = UDim2.new(1, -120, 0, 20)
    nameL.Position = UDim2.new(0, 12, 0, 10)
    nameL.BackgroundTransparency = 1
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.Text = data.name or "Unknown"
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 13
    nameL.TextColor3 = T.White
    
    local valL = Instance.new("TextLabel", card)
    valL.Size = UDim2.new(1, -120, 0, 14)
    valL.Position = UDim2.new(0, 12, 0, 30)
    valL.BackgroundTransparency = 1
    valL.TextXAlignment = Enum.TextXAlignment.Left
    valL.Text = formatNumber(data.value or 0) .. " • " .. (data.mutation or "Normal") .. " • " .. (data.players or "0/0")
    valL.Font = Enum.Font.Gotham
    valL.TextSize = 11
    valL.TextColor3 = T.TextDim

    local jBtn = Instance.new("TextButton", card)
    jBtn.Size = UDim2.new(0, 45, 0, 26)
    jBtn.Position = UDim2.new(1, -100, 0.5, -13)
    jBtn.BackgroundColor3 = T.Accent1
    jBtn.Text = "JOIN"
    jBtn.Font = Enum.Font.GothamBold
    jBtn.TextSize = 10
    jBtn.TextColor3 = T.White
    Instance.new("UICorner", jBtn).CornerRadius = UDim.new(0, 5)

    local cBtn = Instance.new("TextButton", card)
    cBtn.Size = UDim2.new(0, 45, 0, 26)
    cBtn.Position = UDim2.new(1, -50, 0.5, -13)
    cBtn.BackgroundColor3 = T.Orange
    cBtn.Text = "COPY"
    cBtn.Font = Enum.Font.GothamBold
    cBtn.TextSize = 10
    cBtn.TextColor3 = T.White
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 5)

    jBtn.MouseButton1Click:Connect(function()
        TeleportService:TeleportToPlaceInstance(STEAL_BRAINROT_PLACE_ID, data.job_id, lp)
    end)
    
    cBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(data.job_id) cBtn.Text = "COPIED" task.wait(1) cBtn.Text = "COPY" end
    end)
    
    sendWebhook(data)
    playNotifSound()
end

-- [[ DATA SYNC ]] --
task.spawn(function()
    local seenIds = {}
    while _G.AJRunning do
        pcall(function()
            local res = game:HttpGet(SHARED_URL .. "?t=" .. tick())
            local data = HttpService:JSONDecode(res)
            if data and data.findings then
                for _, finding in ipairs(data.findings) do
                    if not seenIds[finding.id] then
                        seenIds[finding.id] = true
                        addLogEntry(finding)
                        if userSettings.AutoJoin then
                            TeleportService:TeleportToPlaceInstance(STEAL_BRAINROT_PLACE_ID, finding.job_id, lp)
                        end
                    end
                end
            end
        end)
        task.wait(2)
    end
end)

print("✅ AJGODZX CLASSIC LOADED!")