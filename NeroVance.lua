--[[
    Nero Vance Hub | V4 Ultimate Edition
    Added: Auto Second Sea, Auto Third Sea, Advanced Anti-AFK
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

--// Advanced Anti-AFK (Cannot be disconnected)
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

--// Global Settings
getgenv().NeroVance = {
    AutoKaitun     = false,
    AutoFarm       = false,
    FastAttack     = true,
    InstaKill      = true,
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
    AutoSea2       = false,
    AutoSea3       = false,
    FarmDistance   = 9
}
local Config = getgenv().NeroVance

--// Safe Wait for Character
local function GetChar()
    return LP.Character or LP.CharacterAdded:Wait()
end

local function GetHRP()
    local char = GetChar()
    return char:WaitForChild("HumanoidRootPart", 5)
end

--// Fast Attack
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

--// Noclip Loop
RunService.Stepped:Connect(function()
    if (Config.AutoFarm or Config.AutoKaitun or Config.AutoBosses or Config.AutoSea2 or Config.AutoSea3) then
        local char = LP.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

--// Insta Kill Function
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

--// Load Orion UI
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Nero Vance Hub | Ultimate", HidePremium = true, SaveConfig = false})

--// TABS
local KaitunTab = Window:MakeTab({Name = "Auto Kaitun", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local SeaTab    = Window:MakeTab({Name = "Auto Seas", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local FarmTab   = Window:MakeTab({Name = "Level Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local BossTab   = Window:MakeTab({Name = "Bosses", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local RaidTab   = Window:MakeTab({Name = "Raids", Icon = "rbxassetid://4483345998", PremiumOnly = false})

--// KAITUN
KaitunTab:AddToggle({
    Name = "Enable Full Auto Kaitun",
    Default = false,
    Callback = function(Value)
        Config.AutoKaitun = Value
        Config.AutoFarm = Value
        Config.AutoBosses = Value
        Config.AutoSea2 = Value
        Config.AutoSea3 = Value
    end
})

--// AUTO SEAS
SeaTab:AddToggle({Name = "Auto Go To Second Sea (Lvl 700+)", Default = false, Callback = function(v) Config.AutoSea2 = v end})
SeaTab:AddToggle({Name = "Auto Go To Third Sea (Lvl 1500+)", Default = false, Callback = function(v) Config.AutoSea3 = v end})
SeaTab:AddButton({Name = "Teleport to Second Sea", Callback = function() CommF:InvokeServer("TravelDressrosa") end})
SeaTab:AddButton({Name = "Teleport to Third Sea", Callback = function() CommF:InvokeServer("TravelZou") end})

--// FARM & BOSSES
FarmTab:AddToggle({Name = "Auto Farm Level", Default = false, Callback = function(v) Config.AutoFarm = v end})
FarmTab:AddToggle({Name = "Instant Kill", Default = true, Callback = function(v) Config.InstaKill = v end})
BossTab:AddDropdown({Name = "Select Boss", Default = "All", Options = {"All", "Smoke Admiral", "Ice Admiral", "Tide Keeper", "Don Swan", "Katakuri", "Rip_Indra"}, Callback = function(v) Config.TargetBoss = v end})
BossTab:AddToggle({Name = "Auto Boss", Default = false, Callback = function(v) Config.AutoBosses = v end})

--// CORE LOOPS
task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoFarm or Config.AutoKaitun or Config.AutoBosses then
            local Enemies = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Enemy")
            if Enemies then
                for _, enemy in ipairs(Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        if Config.AutoBosses and (enemy:FindFirstChild("Boss") or enemy.Name:find("Admiral")) then
                            if Config.TargetBoss == "All" or enemy.Name:find(Config.TargetBoss) then KillTarget(enemy) end
                        elseif Config.AutoFarm and not enemy:FindFirstChild("Boss") then
                            KillTarget(enemy)
                        end
                    end
                end
            end
        end
    end
end)

--// Auto Sea Progression Loop
task.spawn(function()
    while task.wait(5) do
        if Config.AutoSea2 and LP.Data.Level.Value >= 700 then
            -- Bypass quest and force teleport
            pcall(function() CommF:InvokeServer("TravelDressrosa") end)
        end
        if Config.AutoSea3 and LP.Data.Level.Value >= 1500 then
            -- Bypass quest and force teleport
            pcall(function() CommF:InvokeServer("TravelZou") end)
        end
    end
end)

OrionLib:Init()
OrionLib:MakeNotification({Name = "Success", Content = "Nero Vance loaded successfully!", Image = "rbxassetid://4483345998", Time = 5})
