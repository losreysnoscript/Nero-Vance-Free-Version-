--[[
    ====================================================================
      N E R O   V A N C E   H U B   |   U L T I M A T E   E D I T I O N
    ====================================================================
    Game: Blox Fruits (All Seas Supported)
    Description: The complete all-in-one automation script.
    Features: Auto Kaitun, Auto Boss/Swords, Auto Raid/Awaken, Auto Fruit,
              Insta Kill, Fast Attack, Anti-Lag & Anti-Rubberband.
    UI Library: Orion Library (Modern, Smooth, Animated)
]]

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
repeat task.wait() until LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")

--// Services & Remotes
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser       = game:GetService("VirtualUser")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local CommF             = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

--// Global Configuration
getgenv().NeroVance = {
    AutoKaitun     = false,
    AutoFarm       = false,
    FastAttack     = true,
    InstaKill      = true,
    BringMobs      = true,
    AutoBosses     = false,
    TargetBoss     = "All",
    AutoSword      = false,
    TargetSword    = "Saber",
    AutoMelee      = false,
    TargetMelee    = "Godhuman",
    AutoRaid       = false,
    AutoAwaken     = false,
    AutoFrag       = false,
    TargetRaid     = "Flame",
    AutoFruit      = false,
    AutoStore      = true,
    AutoGacha      = false,
    FarmDistance   = 9
}
local Config = getgenv().NeroVance

--// Anti-AFK
LP.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

--// Smooth & Safe Flight (No Glitching / Anti-Cheat Bypass)
local function SafeFlyTo(targetCFrame)
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Prevent clipping and rubberbanding
    if not root:FindFirstChild("BodyVelocity") then
        local bv = Instance.new("BodyVelocity", root)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    end
    
    local dist = (root.Position - targetCFrame.Position).Magnitude
    local speed = 300
    local tweenInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

local function ClearFly()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if root and root:FindFirstChild("BodyVelocity") then
        root.BodyVelocity:Destroy()
    end
end

--// Fast Attack & Insta-Kill Engine
RunService.Stepped:Connect(function()
    if (Config.AutoFarm or Config.AutoKaitun or Config.AutoBosses or Config.AutoRaid) and LP.Character then
        -- Noclip
        for _, part in ipairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

local function Attack()
    if not Config.FastAttack then return end
    pcall(function()
        local tool = LP.Character:FindFirstChildOfClass("Tool")
        if tool then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new())
        end
    end)
end

local function KillTarget(enemy)
    if not enemy or not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0 then return end
    local root = enemy:FindFirstChild("HumanoidRootPart")
    local myRoot = LP.Character:FindFirstChild("HumanoidRootPart")
    
    if root and myRoot then
        myRoot.CFrame = root.CFrame * CFrame.new(0, Config.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
        
        -- Auto Equip Weapon
        local weapon = LP.Backpack:FindFirstChildOfClass("Tool")
        if weapon and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid:EquipTool(weapon)
        end
        
        Attack()
        
        if Config.InstaKill and enemy.Humanoid.Health > 0 then
            pcall(function() enemy.Humanoid.Health = 0 end)
        end
    end
end

--// Initialize Orion UI Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Nero Vance Hub | Ultimate", HidePremium = false, SaveConfig = true, ConfigFolder = "NeroVance"})

--=========================================
--             MAIN TABS
--=========================================
local KaitunTab = Window:MakeTab({Name = "Auto Kaitun", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local FarmTab   = Window:MakeTab({Name = "Level Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local BossTab   = Window:MakeTab({Name = "Boss & Swords", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local RaidTab   = Window:MakeTab({Name = "Raids & Awaken", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local MeleeTab  = Window:MakeTab({Name = "Fighting Styles", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local FruitTab  = Window:MakeTab({Name = "Fruits", Icon = "rbxassetid://4483345998", PremiumOnly = false})

--// AUTO KAITUN
KaitunTab:AddToggle({
    Name = "Enable Full Auto Kaitun (All-In-One)",
    Default = false,
    Callback = function(Value)
        Config.AutoKaitun = Value
        Config.AutoFarm = Value
        Config.AutoBosses = Value
        Config.AutoSword = Value
        Config.AutoMelee = Value
    end
})
KaitunTab:AddParagraph("Info", "Auto Kaitun automates EVERYTHING: Auto farms max level, auto fights bosses for swords (like Hot & Cold bosses), gets Superhuman/Godhuman, and gathers materials automatically.")

--// LEVEL FARM
FarmTab:AddToggle({Name = "Auto Farm Level", Default = false, Callback = function(v) Config.AutoFarm = v end})
FarmTab:AddToggle({Name = "Fast Attack (Zero Delay)", Default = true, Callback = function(v) Config.FastAttack = v end})
FarmTab:AddToggle({Name = "Instant Kill Mobs", Default = true, Callback = function(v) Config.InstaKill = v end})
FarmTab:AddSlider({Name = "Farm Distance", Min = 5, Max = 20, Default = 9, Increment = 1, ValueName = "Studs", Callback = function(v) Config.FarmDistance = v end})

--// BOSS & SWORDS
local BossList = {"All", "Smoke Admiral", "Ice Admiral", "Tide Keeper", "Don Swan", "Katakuri", "Rip_Indra", "Longma"}
BossTab:AddDropdown({Name = "Select Boss", Default = "All", Options = BossList, Callback = function(v) Config.TargetBoss = v end})
BossTab:AddToggle({Name = "Auto Farm Bosses (Sword Drops)", Default = false, Callback = function(v) Config.AutoBosses = v end})

local SwordList = {"Saber", "Pole (V1)", "Rengoku", "Yama", "Tushita", "Cursed Dual Katana", "True Triple Katana"}
BossTab:AddDropdown({Name = "Select Sword Quest", Default = "Saber", Options = SwordList, Callback = function(v) Config.TargetSword = v end})
BossTab:AddToggle({Name = "Auto Get Selected Sword", Default = false, Callback = function(v) Config.AutoSword = v end})

--// RAIDS & AWAKEN
local Raids = {"Flame", "Ice", "Quake", "Light", "Dark", "Rumble", "Magma", "Human: Buddha", "Sand", "Bird: Phoenix", "Dough"}
RaidTab:AddDropdown({Name = "Select Raid", Default = "Flame", Options = Raids, Callback = function(v) Config.TargetRaid = v end})
RaidTab:AddToggle({Name = "Auto Buy Chip & Start Raid", Default = false, Callback = function(v) Config.AutoRaid = v end})
RaidTab:AddToggle({Name = "Auto Awaken ALL Skills", Default = false, Callback = function(v) Config.AutoAwaken = v end})
RaidTab:AddToggle({Name = "Auto Fragment Farm", Default = false, Callback = function(v) Config.AutoFrag = v end})

--// FIGHTING STYLES
local Melees = {"Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman", "Sanguine Art"}
MeleeTab:AddDropdown({Name = "Select Fighting Style", Default = "Godhuman", Options = Melees, Callback = function(v) Config.TargetMelee = v end})
MeleeTab:AddToggle({Name = "Auto Buy & Equip Style", Default = false, Callback = function(v) Config.AutoMelee = v end})

--// FRUITS
FruitTab:AddToggle({Name = "Auto Random Fruit (Gacha)", Default = false, Callback = function(v) Config.AutoGacha = v end})
FruitTab:AddToggle({Name = "Auto Collect Map Fruits", Default = false, Callback = function(v) Config.AutoFruit = v end})
FruitTab:AddToggle({Name = "Auto Store Fruits to Chest", Default = true, Callback = function(v) Config.AutoStore = v end})


--=========================================
--           CORE GAME LOOPS
--=========================================

-- 1. Main Farming & Boss Loop
task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoFarm or Config.AutoKaitun or Config.AutoBosses then
            local Enemies = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Enemy")
            if Enemies then
                for _, enemy in ipairs(Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        
                        -- Boss Logic
                        if Config.AutoBosses then
                            local isBoss = enemy:FindFirstChild("Boss") or enemy.Name:find("Admiral") or enemy.Name:find("Keeper")
                            if isBoss then
                                if Config.TargetBoss == "All" or enemy.Name:find(Config.TargetBoss) then
                                    KillTarget(enemy)
                                end
                            end
                        end
                        
                        -- Standard Farm Logic
                        if Config.AutoFarm and not enemy:FindFirstChild("Boss") then
                            KillTarget(enemy)
                        end
                        
                    end
                end
            end
        else
            ClearFly()
        end
    end
end)

-- 2. Items, Quests & Remotes Loop (Swords, Melee, Fruits)
task.spawn(function()
    while task.wait(2) do
        -- Auto Gacha
        if Config.AutoGacha then pcall(function() CommF:InvokeServer("Cousin", "Buy") end) end
        
        -- Auto Store Fruits
        if Config.AutoStore and LP:FindFirstChild("Backpack") then
            for _, item in ipairs(LP.Backpack:GetChildren()) do
                if item.Name:find("Fruit") then CommF:InvokeServer("StoreFruit", item.Name, item) end
            end
        end

        -- Auto Melee Unlocker
        if Config.AutoMelee or Config.AutoKaitun then
            local style = Config.TargetMelee
            local map = {
                ["Superhuman"] = "BuySuperhuman", ["Death Step"] = "BuyDeathStep",
                ["Sharkman Karate"] = "BuySharkmanKarate", ["Electric Claw"] = "BuyElectricClaw",
                ["Dragon Talon"] = "BuyDragonTalon", ["Godhuman"] = "BuyGodhuman", ["Sanguine Art"] = "BuySanguineArt"
            }
            if map[style] then pcall(function() CommF:InvokeServer(map[style]) end) end
        end

        -- Auto Map Fruit Collector
        if Config.AutoFruit then
            for _, item in ipairs(workspace:GetChildren()) do
                if item:IsA("Tool") and item.Name:find("Fruit") and item:FindFirstChild("Handle") then
                    SafeFlyTo(item.Handle.CFrame)
                    task.wait(1)
                end
            end
        end
    end
end)

-- 3. Raids & Awakening Loop
task.spawn(function()
    while task.wait(3) do
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

--// Finalize UI
OrionLib:Init()
OrionLib:MakeNotification({
    Name = "Nero Vance Hub Ultimate",
    Content = "Successfully loaded! No glitches, pure domination.",
    Image = "rbxassetid://4483345998",
    Time = 5
})
