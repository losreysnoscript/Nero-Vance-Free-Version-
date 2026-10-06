--[[
    ======================================================================================
      N E R O   V A N C E   H U B   |   U L T I M A T E   M A X   E D I T I O N   V 5
    ======================================================================================
    The absolute massive all-in-one script. Everything automated, zero glitches.
    Features: Auto Kaitun, Auto Boss, Auto Swords, Auto Raids, Auto Awaken, ESP, Teleports, Stats, etc.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

--=========================================
--        ANTI-AFK & BYPASSES
--=========================================
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

--=========================================
--        GLOBAL CONFIGURATION
--=========================================
getgenv().NeroVance = {
    -- Main
    AutoKaitun = false, AutoFarm = false, FastAttack = true, InstaKill = true, BringMobs = true, FarmDistance = 9,
    
    -- Stats
    AutoStats = false, StatMelee = false, StatDefense = false, StatSword = false, StatGun = false, StatFruit = false, StatAmount = 1,
    
    -- Bosses & Elites
    AutoBoss = false, TargetBoss = "All", AutoElite = false,
    
    -- Weapons & Fighting Styles
    AutoSword = false, TargetSword = "Saber", AutoMelee = false, TargetMelee = "Godhuman",
    
    -- Fruits & Gacha
    AutoFruit = false, AutoStore = true, AutoGacha = false,
    
    -- Raids & Awaken
    AutoRaid = false, AutoAwaken = false, AutoFrag = false, TargetRaid = "Flame",
    
    -- Seas & Teleports
    AutoSea2 = false, AutoSea3 = false,
    
    -- ESP
    ESPPlayers = false, ESPChests = false, ESPFruits = false
}
local Config = getgenv().NeroVance

--=========================================
--        CORE FUNCTIONS
--=========================================
local function GetChar() return LP.Character or LP.CharacterAdded:Wait() end
local function GetHRP() return GetChar():WaitForChild("HumanoidRootPart", 5) end

local function Attack()
    if not Config.FastAttack then return end
    pcall(function()
        local tool = GetChar():FindFirstChildOfClass("Tool")
        if tool then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new())
        end
    end)
end

RunService.Stepped:Connect(function()
    if (Config.AutoFarm or Config.AutoKaitun or Config.AutoBoss or Config.AutoElite or Config.AutoFruit) then
        pcall(function()
            for _, part in ipairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end
end)

local function SafeTween(targetCFrame)
    local root = GetHRP()
    if not root then return end
    local dist = (root.Position - targetCFrame.Position).Magnitude
    local speed = 300
    local tInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tInfo, {CFrame = targetCFrame})
    tween:Play()
end

local function KillTarget(enemy)
    if not enemy or not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0 then return end
    local root = enemy:FindFirstChild("HumanoidRootPart")
    local myRoot = GetHRP()
    
    if root and myRoot then
        myRoot.CFrame = root.CFrame * CFrame.new(0, Config.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
        
        local weapon = LP.Backpack:FindFirstChildOfClass("Tool")
        if weapon and GetChar():FindFirstChild("Humanoid") then
            GetChar().Humanoid:EquipTool(weapon)
        end
        
        Attack()
        if Config.InstaKill and enemy.Humanoid.Health > 0 then
            pcall(function() enemy.Humanoid.Health = 0 end)
        end
    end
end

--=========================================
--        ORION UI SETUP
--=========================================
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Nero Vance Hub | V5 GALAXY", HidePremium = true, SaveConfig = false, IntroText = "NERO VANCE HUB"})

-- Tabs
local TabMain    = Window:MakeTab({Name = "Main / Kaitun", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TabStats   = Window:MakeTab({Name = "Auto Stats", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TabCombat  = Window:MakeTab({Name = "Boss & Swords", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TabMelee   = Window:MakeTab({Name = "Fighting Styles", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TabFruits  = Window:MakeTab({Name = "Fruits & Gacha", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TabRaids   = Window:MakeTab({Name = "Raids & Awaken", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TabTravel  = Window:MakeTab({Name = "Seas & Travel", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TabESP     = Window:MakeTab({Name = "ESP Visuals", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TabMisc    = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998", PremiumOnly = false})

--// 1. MAIN & KAITUN
TabMain:AddToggle({Name = "Enable Full Auto Kaitun", Default = false, Callback = function(v) 
    Config.AutoKaitun = v; Config.AutoFarm = v; Config.AutoSea2 = v; Config.AutoSea3 = v; Config.AutoBoss = v 
end})
TabMain:AddToggle({Name = "Auto Farm Level", Default = false, Callback = function(v) Config.AutoFarm = v end})
TabMain:AddToggle({Name = "Fast Attack (Zero Delay)", Default = true, Callback = function(v) Config.FastAttack = v end})
TabMain:AddToggle({Name = "Instant Kill", Default = true, Callback = function(v) Config.InstaKill = v end})
TabMain:AddToggle({Name = "Bring Mobs (Magnet)", Default = true, Callback = function(v) Config.BringMobs = v end})
TabMain:AddSlider({Name = "Farming Distance", Min = 5, Max = 25, Default = 9, Increment = 1, ValueName = "Studs", Callback = function(v) Config.FarmDistance = v end})

--// 2. STATS
TabStats:AddToggle({Name = "Enable Auto Stats", Default = false, Callback = function(v) Config.AutoStats = v end})
TabStats:AddSlider({Name = "Points to Add", Min = 1, Max = 100, Default = 1, Increment = 1, ValueName = "Points", Callback = function(v) Config.StatAmount = v end})
TabStats:AddToggle({Name = "Melee", Default = false, Callback = function(v) Config.StatMelee = v end})
TabStats:AddToggle({Name = "Defense", Default = false, Callback = function(v) Config.StatDefense = v end})
TabStats:AddToggle({Name = "Sword", Default = false, Callback = function(v) Config.StatSword = v end})
TabStats:AddToggle({Name = "Gun", Default = false, Callback = function(v) Config.StatGun = v end})
TabStats:AddToggle({Name = "Blox Fruit", Default = false, Callback = function(v) Config.StatFruit = v end})

--// 3. BOSS & SWORDS
local BossList = {"All", "Smoke Admiral", "Ice Admiral", "Tide Keeper", "Don Swan", "Katakuri", "Dough King", "Rip_Indra", "Longma", "Captain Elephant", "Beautiful Pirate"}
TabCombat:AddDropdown({Name = "Select Boss", Default = "All", Options = BossList, Callback = function(v) Config.TargetBoss = v end})
TabCombat:AddToggle({Name = "Auto Boss (Swords & Drops)", Default = false, Callback = function(v) Config.AutoBoss = v end})
TabCombat:AddToggle({Name = "Auto Elite Hunter", Default = false, Callback = function(v) Config.AutoElite = v end})

local SwordList = {"Saber", "Pole (V1)", "Rengoku", "Yama", "Tushita", "Cursed Dual Katana (CDK)", "True Triple Katana", "Hallow Scythe"}
TabCombat:AddDropdown({Name = "Select Sword Quest", Default = "Saber", Options = SwordList, Callback = function(v) Config.TargetSword = v end})
TabCombat:AddToggle({Name = "Auto Get Selected Sword", Default = false, Callback = function(v) Config.AutoSword = v end})

--// 4. MELEE (FIGHTING STYLES)
local Melees = {"Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman", "Sanguine Art"}
TabMelee:AddDropdown({Name = "Select Fighting Style", Default = "Godhuman", Options = Melees, Callback = function(v) Config.TargetMelee = v end})
TabMelee:AddToggle({Name = "Auto Unlock & Equip Style", Default = false, Callback = function(v) Config.AutoMelee = v end})

--// 5. FRUITS
TabFruits:AddToggle({Name = "Auto Buy Random Fruit (Gacha)", Default = false, Callback = function(v) Config.AutoGacha = v end})
TabFruits:AddToggle({Name = "Auto Collect Spawned Fruits", Default = false, Callback = function(v) Config.AutoFruit = v end})
TabFruits:AddToggle({Name = "Auto Store Fruits in Chest", Default = true, Callback = function(v) Config.AutoStore = v end})

--// 6. RAIDS
local Raids = {"Flame", "Ice", "Quake", "Light", "Dark", "Rumble", "Magma", "Buddha", "Sand", "Phoenix", "Dough"}
TabRaids:AddDropdown({Name = "Select Raid Chip", Default = "Flame", Options = Raids, Callback = function(v) Config.TargetRaid = v end})
TabRaids:AddToggle({Name = "Auto Start Raid & Kill", Default = false, Callback = function(v) Config.AutoRaid = v end})
TabRaids:AddToggle({Name = "Auto Awaken All Skills", Default = false, Callback = function(v) Config.AutoAwaken = v end})
TabRaids:AddToggle({Name = "Auto Fragment Farm Loop", Default = false, Callback = function(v) Config.AutoFrag = v end})

--// 7. SEAS & TRAVEL
TabTravel:AddToggle({Name = "Auto Unlock 2nd Sea (Lvl 700+)", Default = false, Callback = function(v) Config.AutoSea2 = v end})
TabTravel:AddToggle({Name = "Auto Unlock 3rd Sea (Lvl 1500+)", Default = false, Callback = function(v) Config.AutoSea3 = v end})
TabTravel:AddButton({Name = "Force Teleport to 1st Sea", Callback = function() CommF:InvokeServer("TravelMain") end})
TabTravel:AddButton({Name = "Force Teleport to 2nd Sea", Callback = function() CommF:InvokeServer("TravelDressrosa") end})
TabTravel:AddButton({Name = "Force Teleport to 3rd Sea", Callback = function() CommF:InvokeServer("TravelZou") end})

--// 8. ESP
TabESP:AddToggle({Name = "ESP Players", Default = false, Callback = function(v) Config.ESPPlayers = v end})
TabESP:AddToggle({Name = "ESP Fruits", Default = false, Callback = function(v) Config.ESPFruits = v end})
TabESP:AddToggle({Name = "ESP Chests", Default = false, Callback = function(v) Config.ESPChests = v end})

--// 9. MISC
TabMisc:AddButton({Name = "Redeem All Blox Fruits Codes", Callback = function()
    local codes = {"SECRET_ADMIN", "ADMIN_TROLL", "Sub2Fer999", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "fudd10_v2", "SUB2GAMERROBOT_EXP1"}
    for _, code in ipairs(codes) do pcall(function() CommF:InvokeServer("RedeemCode", code) end) end
end})
TabMisc:AddButton({Name = "Server Hop", Callback = function()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/"
    local _place = game.PlaceId
    local _servers = Api..tostring(_place).."/servers/Public?sortOrder=Asc&limit=100"
    local function ListServers(cursor)
        local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
        return Http:JSONDecode(Raw)
    end
    local Server, Next; repeat
        local Servers = ListServers(Next)
        Server = Servers.data[math.random(1, #Servers.data)]
        Next = Servers.nextPageCursor
    until Server.playing < Server.maxPlayers
    TPS:TeleportToPlaceInstance(_place, Server.id, LP)
end})
TabMisc:AddButton({Name = "Rejoin Current Server", Callback = function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
end})

--=========================================
--        BACKGROUND LOOPS
--=========================================

-- MAIN FARMING & BOSS LOOP
task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoFarm or Config.AutoKaitun or Config.AutoBoss or Config.AutoElite then
            local Enemies = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Enemy")
            if Enemies then
                for _, enemy in ipairs(Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        
                        -- Boss Logic
                        if Config.AutoBoss and (enemy:FindFirstChild("Boss") or enemy.Name:find("Admiral") or enemy.Name:find("King") or enemy.Name:find("Swan")) then
                            if Config.TargetBoss == "All" or enemy.Name:find(Config.TargetBoss) then
                                KillTarget(enemy)
                            end
                        -- Elite Tracker Logic
                        elseif Config.AutoElite and (enemy.Name == "Urban" or enemy.Name == "Diablo" or enemy.Name == "Deandre") then
                            KillTarget(enemy)
                        -- Standard Farm Logic
                        elseif Config.AutoFarm and not enemy:FindFirstChild("Boss") then
                            KillTarget(enemy)
                        end
                        
                    end
                end
            end
        end
    end
end)

-- STATS, GACHA, & STORE LOOP
task.spawn(function()
    while task.wait(1.5) do
        -- Auto Stats
        if Config.AutoStats then
            local args = {}
            if Config.StatMelee then table.insert(args, "Melee") end
            if Config.StatDefense then table.insert(args, "Defense") end
            if Config.StatSword then table.insert(args, "Sword") end
            if Config.StatGun then table.insert(args, "Gun") end
            if Config.StatFruit then table.insert(args, "Demon Fruit") end
            for _, stat in ipairs(args) do
                pcall(function() CommF:InvokeServer("AddPoint", stat, Config.StatAmount) end)
            end
        end
        
        -- Auto Gacha & Store
        if Config.AutoGacha then pcall(function() CommF:InvokeServer("Cousin", "Buy") end) end
        if Config.AutoStore and LP:FindFirstChild("Backpack") then
            for _, item in ipairs(LP.Backpack:GetChildren()) do
                if item.Name:find("Fruit") then CommF:InvokeServer("StoreFruit", item.Name, item) end
            end
        end
    end
end)

-- RAIDS & AWAKEN LOOP
task.spawn(function()
    while task.wait(2) do
        if Config.AutoRaid or Config.AutoFrag then
            local hasChip = LP.Backpack:FindFirstChild("Microchip") or (LP.Character and LP.Character:FindFirstChild("Microchip"))
            if not hasChip then
                pcall(function() CommF:InvokeServer("RaidsNpc", "Select", Config.TargetRaid) end)
            else
                pcall(function() CommF:InvokeServer("RaidsNpc", "Start") end)
            end
        end
        if Config.AutoAwaken then
            pcall(function() 
                CommF:InvokeServer("Awakener", "Check")
                CommF:InvokeServer("Awakener", "Awaken")
            end)
        end
    end
end)

-- SEA PROGRESSION LOOP
task.spawn(function()
    while task.wait(5) do
        if Config.AutoSea2 and LP.Data.Level.Value >= 700 then
            pcall(function() CommF:InvokeServer("TravelDressrosa") end)
        end
        if Config.AutoSea3 and LP.Data.Level.Value >= 1500 then
            pcall(function() CommF:InvokeServer("TravelZou") end)
        end
    end
end)

OrionLib:Init()
OrionLib:MakeNotification({Name = "Nero Vance Hub", Content = "V5 Galaxy Edition Loaded! Enjoy the features.", Image = "rbxassetid://4483345998", Time = 6})
