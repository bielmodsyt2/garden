--[[
Luna Interface Suite - Garden Horizons Edition
by Nebula Softworks (adaptado para Garden Horizons)

Funcionalidades:
- Auto Buy Seeds/Gear
- Auto Sell
- Auto Harvest
- Auto Plant
- Seleção individual de itens
]]
local Release = "Garden Horizons Edition"

local Luna = { Folder = "Luna", Options = {}, ThemeGradient = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(117, 164, 206)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(123, 201, 201)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(224, 138, 175))} }

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Localization = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local RS = game:GetService("ReplicatedStorage")

local isStudio
local website = "github.com/Nebula-Softworks"

if RunService:IsStudio() then
    isStudio = true
end

-- ==========================================
-- 🔹 VERIFICAÇÃO DE INJEÇÃO DA UI
-- ==========================================
local function verifyInjection()
    if not LunaUI or not LunaUI.Parent then
        warn("LunaUI não foi injetada corretamente!")
        return false
    end
    return true
end

local function injectUI()
    local success, message = pcall(function()
        if gethui then
            LunaUI.Parent = gethui()
            print("UI injetada usando gethui()")
        elseif syn and syn.protect_gui then
            syn.protect_gui(LunaUI)
            LunaUI.Parent = game:GetService("CoreGui")
            print("UI injetada usando syn.protect_gui")
        elseif get_hidden_ui then
            LunaUI.Parent = get_hidden_ui()
            print("UI injetada usando get_hidden_ui")
        elseif protect_gui then
            protect_gui(LunaUI)
            LunaUI.Parent = game:GetService("CoreGui")
            print("UI injetada usando protect_gui")
        else
            LunaUI.Parent = game:GetService("CoreGui")
            print("UI injetada no CoreGui (método padrão)")
        end
        LunaUI.Enabled = true
        LunaUI.SmartWindow.Visible = true
    end)
    
    if not success then
        warn("Falha ao injetar UI: " .. tostring(message))
    end
end

local function createInjectionIndicator()
    local indicator = Instance.new("ScreenGui")
    indicator.Name = "LunaInjectionIndicator"
    indicator.DisplayOrder = 9999
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 60)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "Luna UI - Garden Horizons ✓"
    text.TextColor3 = Color3.fromRGB(0, 255, 0)
    text.Font = Enum.Font.SourceSansBold
    text.TextSize = 18
    text.Parent = frame
    
    frame.Parent = indicator
    
    if gethui then
        indicator.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(indicator)
        indicator.Parent = game:GetService("CoreGui")
    else
        indicator.Parent = game:GetService("CoreGui")
    end
    
    delay(5, function()
        indicator:Destroy()
    end)
end

-- ==========================================
-- 🔹 ICONES E UTILITÁRIOS (mantidos da Luna original)
-- ==========================================
local IconModule = {
    Lucide = nil,
    Material = {}
}

local request = (syn and syn.request) or (http and http.request) or http_request or nil
local tweeninfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local PresetGradients = {
    ["Nightlight (Classic)"] = {Color3.fromRGB(147, 255, 239), Color3.fromRGB(201,211,233), Color3.fromRGB(255, 167, 227)},
    ["Nightlight (Neo)"] = {Color3.fromRGB(117, 164, 206), Color3.fromRGB(123, 201, 201), Color3.fromRGB(224, 138, 175)},
    Starlight = {Color3.fromRGB(147, 255, 239), Color3.fromRGB(181, 206, 241), Color3.fromRGB(214, 158, 243)},
    Solar = {Color3.fromRGB(242, 157, 76), Color3.fromRGB(240, 179, 81), Color3.fromRGB(238, 201, 86)},
    Sparkle = {Color3.fromRGB(199, 130, 242), Color3.fromRGB(221, 130, 238), Color3.fromRGB(243, 129, 233)},
    Lime = {Color3.fromRGB(170, 255, 127), Color3.fromRGB(163, 220, 138), Color3.fromRGB(155, 185, 149)},
    Vine = {Color3.fromRGB(0, 191, 143), Color3.fromRGB(0, 126, 94), Color3.fromRGB(0, 61, 46)},
    Cherry = {Color3.fromRGB(148, 54, 54), Color3.fromRGB(168, 67, 70), Color3.fromRGB(188, 80, 86)},
    Daylight = {Color3.fromRGB(51, 156, 255), Color3.fromRGB(89, 171, 237), Color3.fromRGB(127, 186, 218)},
    Blossom = {Color3.fromRGB(255, 165, 243), Color3.fromRGB(213, 129, 231), Color3.fromRGB(170, 92, 218)},
}

-- Funções auxiliares (mantidas)
local function GetIcon(icon, source) return "rbxassetid://10723434557" end -- simplificado
local function RemoveTable(tablre, value) end
local function Kwargify(defaults, passed) return passed end
local function PackColor(Color) return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255} end
local function UnpackColor(Color) return Color3.fromRGB(Color.R, Color.G, Color.B) end
function tween(object, goal, callback, tweenin) end
local function BlurModule(Frame) end

-- ==========================================
-- 🔹 CONFIGURAÇÕES DO GARDEN HORIZONS
-- ==========================================

-- Remotes (com segurança)
local BuyRemote = RS:FindFirstChild("RemoteEvents") and RS.RemoteEvents:FindFirstChild("PurchaseShopItem")
local SellRemote = RS:FindFirstChild("RemoteEvents") and RS.RemoteEvents:FindFirstChild("SellItems")
local PlantRemote = RS:FindFirstChild("RemoteEvents") and RS.RemoteEvents:FindFirstChild("PlantSeed")
local PlantsFolder = RS:FindFirstChild("Plants") and RS.Plants:FindFirstChild("Models")

-- Listas de itens
local SeedItems = {
    "Carrot Seed","Tomato Seed","Potato Seed","Wheat Seed","Pumpkin Seed",
    "Corn Seed","Strawberry Seed","Blueberry Seed","Onion Seed","Garlic Seed",
    "Cabbage Seed","Banana Seed","Apple Seed","Plum Seed","Cherry Seed","Mushroom Seed","Rose Seed"
}
local Seeds = {
    "Carrot","Tomato","Potato","Wheat","Pumpkin","Corn","Strawberry","Blueberry",
    "Onion","Garlic","Cabbage","Banana","Apple","Plum","Cherry","Mushroom","Rose"
}
local Gears = {"Watering Can","Basic Sprinkler","Harvest All","Turbo Sprinkler","Favorite Tool","Super Sprinkler"}

-- Tabelas de seleção (armazenadas em Luna.Options para persistência)
Luna.Options.selectedSeedItems = Luna.Options.selectedSeedItems or {}
Luna.Options.selectedSeeds = Luna.Options.selectedSeeds or {}
Luna.Options.selectedGears = Luna.Options.selectedGears or {}
Luna.Options.selectedPlants = Luna.Options.selectedPlants or {}

-- Estados dos toggles automáticos
Luna.Options.autoSeed = Luna.Options.autoSeed or false
Luna.Options.autoGear = Luna.Options.autoGear or false
Luna.Options.autoSell = Luna.Options.autoSell or false
Luna.Options.autoHarvest = Luna.Options.autoHarvest or false
Luna.Options.autoPlant = Luna.Options.autoPlant or false

-- Obter nomes das plantas para harvest
local plantNames = {}
if PlantsFolder then
    for _, p in ipairs(PlantsFolder:GetChildren()) do
        table.insert(plantNames, p.Name)
    end
else
    table.insert(plantNames, "Nenhuma planta encontrada")
end

-- Inicializar seleções se vazias
for _, item in ipairs(SeedItems) do
    if Luna.Options.selectedSeedItems[item] == nil then
        Luna.Options.selectedSeedItems[item] = false
    end
end
for _, item in ipairs(Seeds) do
    if Luna.Options.selectedSeeds[item] == nil then
        Luna.Options.selectedSeeds[item] = false
    end
end
for _, item in ipairs(Gears) do
    if Luna.Options.selectedGears[item] == nil then
        Luna.Options.selectedGears[item] = false
    end
end
for _, item in ipairs(plantNames) do
    if Luna.Options.selectedPlants[item] == nil then
        Luna.Options.selectedPlants[item] = false
    end
end

-- ==========================================
-- 🔹 FUNÇÕES PRINCIPAIS DO GARDEN HORIZONS
-- ==========================================
local function buySeeds()
    for s, enabled in pairs(Luna.Options.selectedSeedItems) do
        if enabled and BuyRemote then
            pcall(function() BuyRemote:InvokeServer("SeedShop", s) end)
        end
    end
end

local function buyGear()
    for g, enabled in pairs(Luna.Options.selectedGears) do
        if enabled and BuyRemote then
            pcall(function() BuyRemote:InvokeServer("GearShop", g) end)
        end
    end
end

local function sellAll()
    if SellRemote then
        pcall(function() SellRemote:InvokeServer("SellAll") end)
    end
end

local function harvestPlants()
    local clientPlants = workspace:FindFirstChild("ClientPlants")
    if not clientPlants then return end
    for _, plant in pairs(clientPlants:GetChildren()) do
        local base = plant.Name:gsub("%d", "")
        if Luna.Options.selectedPlants[base] then
            for _, v in pairs(plant:GetDescendants()) do
                if v:IsA("ProximityPrompt") and v.Name == "HarvestPrompt" then
                    v.HoldDuration = 0
                    fireproximityprompt(v)
                end
            end
        end
    end
end

local function plantSeeds()
    if not (Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")) then return end
    local pos = Player.Character.HumanoidRootPart.Position
    for _, seed in pairs(Seeds) do
        if Luna.Options.selectedSeeds[seed] and PlantRemote then
            for x = -4, 4, 2 do
                for z = -4, 4, 2 do
                    pcall(function()
                        PlantRemote:InvokeServer(seed, pos + Vector3.new(x, -3, z))
                    end)
                end
            end
        end
    end
end

-- Loop automático
task.spawn(function()
    while task.wait(1) do
        if Luna.Options.autoSeed then buySeeds() end
        if Luna.Options.autoGear then buyGear() end
        if Luna.Options.autoSell then sellAll() end
        if Luna.Options.autoHarvest then harvestPlants() end
        if Luna.Options.autoPlant then plantSeeds() end
    end
end)

-- ==========================================
-- 🔹 CRIAÇÃO DA INTERFACE LUNA
-- ==========================================
local LunaUI = isStudio and script.Parent:WaitForChild("Luna UI") or game:GetObjects("rbxassetid://86467455075715")[1]

-- Remover instâncias antigas
if gethui then
    for _, Interface in ipairs(gethui():GetChildren()) do
        if Interface.Name == LunaUI.Name and Interface ~= LunaUI then
            Interface.Enabled = false
            Interface.Name = "Luna-Old"
        end
    end
elseif not isStudio then
    for _, Interface in ipairs(CoreGui:GetChildren()) do
        if Interface.Name == LunaUI.Name and Interface ~= LunaUI then
            Interface.Enabled = false
            Interface.Name = "Luna-Old"
        end
    end
end

injectUI()
createInjectionIndicator()
verifyInjection()

-- ==========================================
-- 🔹 CONFIGURAÇÃO DAS ABAS E SEÇÕES
-- ==========================================

-- Função auxiliar para criar toggles de itens em uma seção
local function createItemToggles(section, items, selectedTable, prefix)
    for _, item in ipairs(items) do
        section:CreateToggle({
            Name = item,
            CurrentValue = selectedTable[item] or false,
            Callback = function(value)
                selectedTable[item] = value
            end
        }, prefix .. item)
    end
end

-- Criar janela principal
local window = Luna:CreateWindow({
    Name = "Garden Horizons Hub",
    Subtitle = "by Noah Nabas (integração Luna)",
    LogoID = "6031097225",
    LoadingEnabled = true
})

-- Aba principal
local gardenTab = window:CreateTab({
    Name = "Garden",
    Icon = "grass",
    ImageSource = "Material"
})

-- Seção Seeds
local seedsSection = gardenTab:CreateSection("Seeds")
createItemToggles(seedsSection, SeedItems, Luna.Options.selectedSeedItems, "Seed_")
seedsSection:CreateToggle({
    Name = "Auto Buy Seeds",
    CurrentValue = Luna.Options.autoSeed,
    Callback = function(value) Luna.Options.autoSeed = value end
}, "AutoSeed")

-- Seção Gear
local gearSection = gardenTab:CreateSection("Gear")
createItemToggles(gearSection, Gears, Luna.Options.selectedGears, "Gear_")
gearSection:CreateToggle({
    Name = "Auto Buy Gear",
    CurrentValue = Luna.Options.autoGear,
    Callback = function(value) Luna.Options.autoGear = value end
}, "AutoGear")

-- Seção Sell
local sellSection = gardenTab:CreateSection("Sell")
sellSection:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Luna.Options.autoSell,
    Callback = function(value) Luna.Options.autoSell = value end
}, "AutoSell")

-- Seção Harvest
local harvestSection = gardenTab:CreateSection("Harvest")
createItemToggles(harvestSection, plantNames, Luna.Options.selectedPlants, "Plant_")
harvestSection:CreateToggle({
    Name = "Auto Harvest",
    CurrentValue = Luna.Options.autoHarvest,
    Callback = function(value) Luna.Options.autoHarvest = value end
}, "AutoHarvest")

-- Seção Plant
local plantSection = gardenTab:CreateSection("Plant")
createItemToggles(plantSection, Seeds, Luna.Options.selectedSeeds, "SeedType_")
plantSection:CreateToggle({
    Name = "Auto Plant",
    CurrentValue = Luna.Options.autoPlant,
    Callback = function(value) Luna.Options.autoPlant = value end
}, "AutoPlant")

-- Notificação de boas-vindas
Luna:Notification({
    Title = "Garden Horizons",
    Content = "Hub carregado com sucesso!",
    Icon = "grass"
})

-- Fim do script
