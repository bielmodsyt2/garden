--[[
	Garden Horizons Hub - UI Aprimorada
	
]]

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Remotes (mesma lógica)
local BuyRemote = RS:WaitForChild("RemoteEvents"):WaitForChild("PurchaseShopItem")
local SellRemote = RS:WaitForChild("RemoteEvents"):WaitForChild("SellItems")
local PlantRemote = RS:WaitForChild("RemoteEvents"):WaitForChild("PlantSeed")
local PlantsFolder = RS:WaitForChild("Plants"):WaitForChild("Models")

-- Listas completas
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

-- Tabelas de seleção e estados
local selectedSeedItems, selectedSeeds, selectedGears, selectedPlants = {},{},{},{}
local autoSeed, autoGear, autoSell, autoHarvest, autoPlant = false,false,false,false,false

-- Criando a GUI principal
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GardenHorizonsHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Função para criar sombra (usando frame com blur)
local function createShadow(parent, size, position, color)
    local shadow = Instance.new("Frame")
    shadow.Size = size
    shadow.Position = position
    shadow.BackgroundColor3 = color or Color3.new(0,0,0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSize = 0
    shadow.Parent = parent
    return shadow
end

-- Botão de abrir (estilo flutuante)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 140, 0, 40)
openBtn.Position = UDim2.new(0, 15, 0.3, 0)
openBtn.Text = "🌱 Garden Horizons"
openBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Verde
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
openBtn.BorderSize = 0
openBtn.Active = true
openBtn.Draggable = true
-- Arredondar cantos
local openCorner = Instance.new("UICorner", openBtn)
openCorner.CornerRadius = UDim.new(0, 8)

-- Efeito hover no botão
openBtn.MouseEnter:Connect(function()
    openBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
end)
openBtn.MouseLeave:Connect(function()
    openBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
end)

-- Frame principal (janela)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 420)
frame.Position = UDim2.new(0.5, -175, 0.5, -210) -- Centralizado
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSize = 0
frame.Active = true
frame.Draggable = true
frame.Visible = false

-- Sombra da janela
local shadow = Instance.new("ImageLabel", gui)
shadow.Size = frame.Size + UDim2.new(0, 20, 0, 20)
shadow.Position = frame.Position + UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217" -- Sombra arredondada
shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ImageTransparency = 0.6
shadow.Visible = false
shadow.ZIndex = 0
frame:GetPropertyChangedSignal("Visible"):Connect(function()
    shadow.Visible = frame.Visible
end)
frame:GetPropertyChangedSignal("Position"):Connect(function()
    shadow.Position = frame.Position + UDim2.new(0, -10, 0, -10)
end)

-- Cantos arredondados na janela
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

-- Título com gradiente
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSize = 0
local titleBarCorner = Instance.new("UICorner", titleBar)
titleBarCorner.CornerRadius = UDim.new(0, 12)

-- Gradiente no título (UI Gradient)
local gradient = Instance.new("UIGradient", titleBar)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(46, 204, 113)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(39, 174, 96))
})
gradient.Rotation = 90

-- Ícone e texto do título
local titleIcon = Instance.new("TextLabel", titleBar)
titleIcon.Size = UDim2.new(0, 30, 1, 0)
titleIcon.Position = UDim2.new(0, 10, 0, 0)
titleIcon.Text = "🌿"
titleIcon.TextColor3 = Color3.new(1,1,1)
titleIcon.BackgroundTransparency = 1
titleIcon.Font = Enum.Font.GothamBold
titleIcon.TextSize = 24

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 45, 0, 0)
titleText.Text = "Garden Horizons"
titleText.TextColor3 = Color3.new(1,1,1)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 20
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- Botão fechar (X) estilizado
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BorderSize = 0
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
end)

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Abrir/fechar com o botão principal
openBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Crédito abaixo do título
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 0, 40)
credit.Text = "by Noah Nabas • UI aprimorada"
credit.TextColor3 = Color3.fromRGB(180, 180, 180)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.Gotham
credit.TextSize = 12

-- Abas
local tabHolder = Instance.new("Frame", frame)
tabHolder.Size = UDim2.new(1, -20, 0, 35)
tabHolder.Position = UDim2.new(0, 10, 0, 65)
tabHolder.BackgroundTransparency = 1

local tabs = {"🌱 Seeds","🔧 Gear","💰 Sell","🌾 Harvest","🌿 Plant"}
local panels = {}
local tabButtons = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabHolder)
    btn.Size = UDim2.new(1 / #tabs, -4, 1, 0)
    btn.Position = UDim2.new((i - 1) / #tabs, 2, 0, 0)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.BorderSize = 0
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    tabButtons[i] = btn

    local panel = Instance.new("ScrollingFrame", frame)
    panel.Size = UDim2.new(1, -20, 1, -140)
    panel.Position = UDim2.new(0, 10, 0, 105)
    panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    panel.BorderSize = 0
    panel.ScrollBarThickness = 5
    panel.ScrollBarImageColor3 = Color3.fromRGB(46, 204, 113)
    panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    panel.CanvasSize = UDim2.new(0, 0, 0, 0)
    panel.Visible = (i == 1)
    panels[i] = panel

    btn.MouseButton1Click:Connect(function()
        for j = 1, #tabs do
            panels[j].Visible = false
            tabButtons[j].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        panel.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    end)
end

-- Função para preencher cada painel com itens clicáveis
local function populatePanel(panel, items, selectedTable)
    for _, item in ipairs(items) do
        selectedTable[item] = false
        local btn = Instance.new("TextButton", panel)
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, (#panel:GetChildren() - 1) * 32)
        btn.Text = "☐ " .. item
        btn.TextColor3 = Color3.new(1,1,1)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.BorderSize = 0
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 4)

        btn.MouseButton1Click:Connect(function()
            selectedTable[item] = not selectedTable[item]
            btn.Text = (selectedTable[item] and "☑ " or "☐ ") .. item
            btn.BackgroundColor3 = selectedTable[item] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 35)
        end)
    end
    panel.CanvasSize = UDim2.new(0, 0, 0, #items * 32 + 10)
end

-- Preencher painéis
populatePanel(panels[1], SeedItems, selectedSeedItems) -- Seeds
populatePanel(panels[2], Gears, selectedGears)       -- Gear
populatePanel(panels[4], Seeds, selectedSeeds)       -- Plant (usando Seeds)
-- Harvest: obter plantas do jogo
local plantNames = {}
for _, p in pairs(PlantsFolder:GetChildren()) do
    table.insert(plantNames, p.Name)
end
populatePanel(panels[4], plantNames, selectedPlants)  -- Atenção: índice 4 é Harvest, 5 é Plant? Vamos corrigir: tabs: 1 Seeds,2 Gear,3 Sell,4 Harvest,5 Plant. Então Harvest é painel 4, Plant é painel 5. Vamos ajustar.

-- Corrigindo índices:
-- Harvest panel = 4, Plant panel = 5
populatePanel(panels[4], plantNames, selectedPlants)   -- Harvest
populatePanel(panels[5], Seeds, selectedSeeds)         -- Plant

-- Painel Sell: apenas um botão de toggle
local sellToggleBtn = Instance.new("TextButton", panels[3])
sellToggleBtn.Size = UDim2.new(1, -20, 0, 40)
sellToggleBtn.Position = UDim2.new(0, 10, 0, 10)
sellToggleBtn.Text = "Auto Sell: OFF"
sellToggleBtn.TextColor3 = Color3.new(1,1,1)
sellToggleBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
sellToggleBtn.Font = Enum.Font.GothamBold
sellToggleBtn.TextSize = 16
sellToggleBtn.BorderSize = 0
local sellCorner = Instance.new("UICorner", sellToggleBtn)
sellCorner.CornerRadius = UDim.new(0, 8)

sellToggleBtn.MouseButton1Click:Connect(function()
    autoSell = not autoSell
    sellToggleBtn.Text = "Auto Sell: " .. (autoSell and "ON" or "OFF")
    sellToggleBtn.BackgroundColor3 = autoSell and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
end)

-- Botões toggle nos outros painéis (dentro de cada painel, no final)
local function createToggle(parent, text, getter, setter)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 1, -50)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.BorderSize = 0
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        local new = not getter()
        setter(new)
        btn.Text = text .. ": " .. (new and "ON" or "OFF")
        btn.BackgroundColor3 = new and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
    end)
end

-- Adicionar toggles em cada painel (exceto Sell que já tem)
createToggle(panels[1], "Auto Buy Seed", function() return autoSeed end, function(v) autoSeed = v end)
createToggle(panels[2], "Auto Buy Gear", function() return autoGear end, function(v) autoGear = v end)
createToggle(panels[4], "Auto Harvest", function() return autoHarvest end, function(v) autoHarvest = v end)
createToggle(panels[5], "Auto Plant", function() return autoPlant end, function(v) autoPlant = v end)

-- Ajustar canvas dos painéis para dar espaço ao toggle
for i = 1, #tabs do
    if i ~= 3 then -- Sell já tem toggle incluso
        local panel = panels[i]
        -- O toggle foi adicionado como último filho, então precisamos expandir o canvas
        panel.CanvasSize = UDim2.new(0, 0, 0, panel.CanvasSize.Y.Offset + 60)
    end
end

-- Loop automático (mesma lógica)
task.spawn(function()
    while task.wait(1) do
        if autoSeed then
            for s, on in pairs(selectedSeedItems) do
                if on then
                    pcall(function() BuyRemote:InvokeServer("SeedShop", s) end)
                end
            end
        end
        if autoGear then
            for g, on in pairs(selectedGears) do
                if on then
                    pcall(function() BuyRemote:InvokeServer("GearShop", g) end)
                end
            end
        end
        if autoSell then
            pcall(function() SellRemote:InvokeServer("SellAll") end)
        end
        if autoHarvest then
            for _, plant in pairs(workspace:FindFirstChild("ClientPlants") and workspace.ClientPlants:GetChildren() or {}) do
                local base = plant.Name:gsub("%d", "")
                if selectedPlants[base] then
                    for _, v in pairs(plant:GetDescendants()) do
                        if v:IsA("ProximityPrompt") and v.Name == "HarvestPrompt" then
                            v.HoldDuration = 0
                            fireproximityprompt(v)
                        end
                    end
                end
            end
        end
        if autoPlant and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            for _, seed in pairs(Seeds) do
                if selectedSeeds[seed] then
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
    end
end)
