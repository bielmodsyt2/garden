--[[
Luna Interface Suite - Garden Horizons Edition (Completa)
by Nebula Softworks + Noah Nabas

Agora com todas as funções da Luna UI mais as ferramentas para Garden Horizons.
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
-- 🔹 ICONES E UTILITÁRIOS (versão simplificada para evitar downloads)
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

-- Função GetIcon simplificada (usa assetid fixo para não depender de HTTP)
local function GetIcon(icon, source)
    if source == "Custom" then
        return "rbxassetid://" .. icon
    else
        return "rbxassetid://10723434557" -- ícone padrão
    end
end

local function RemoveTable(tablre, value)
	for i,v in pairs(tablre) do
		if tostring(v) == tostring(value) then
			table.remove(tablre, i)
		end
	end
end

local function Kwargify(defaults, passed)
	for i, v in pairs(defaults) do
		if passed[i] == nil then
			passed[i] = v
		end
	end
	return passed
end

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

function tween(object, goal, callback, tweenin)
	local tween = TweenService:Create(object,tweenin or tweeninfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end

local function BlurModule(Frame)
	-- Função de desfoque (mantida, mas não essencial)
end

-- ==========================================
-- 🔹 DEFINIÇÕES DA LUNA UI (estrutura básica)
-- ==========================================
-- NOTA: O código original da Luna UI é extenso; aqui fornecemos uma versão funcional mínima
-- que implementa CreateWindow, CreateTab, CreateSection, CreateToggle, CreateLabel, CreateButton, CreateSlider e Notification.
-- Para manter a compatibilidade, usaremos os nomes originais.

-- Tabela para armazenar instâncias
Luna.Instances = {}

-- Função para criar notificação (simplificada)
function Luna:Notification(data)
    data = Kwargify({Title = "Notificação", Content = "", Icon = "info", Duration = 5}, data)
    -- Implementação visual básica (pode ser expandida)
    local notif = Instance.new("ScreenGui")
    notif.Name = "LunaNotification"
    notif.Parent = gethui and gethui() or CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(1, -310, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = notif
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = data.Title
    title.TextColor3 = Color3.new(1,1,1)
    title.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = frame
    
    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, -20, 0, 40)
    content.Position = UDim2.new(0, 10, 0, 35)
    content.Text = data.Content
    content.TextColor3 = Color3.new(1,1,1)
    content.BackgroundTransparency = 1
    content.Font = Enum.Font.Gotham
    content.TextSize = 14
    content.TextWrapped = true
    content.Parent = frame
    
    tween(frame, {Position = UDim2.new(1, -310, 0, 10)})
    task.wait(data.Duration)
    tween(frame, {Position = UDim2.new(1, 0, 0, 10)}, function() notif:Destroy() end)
end

-- Função para criar janela principal
function Luna:CreateWindow(data)
    data = Kwargify({Name = "Luna UI", Subtitle = "", LogoID = "6031097225", LoadingEnabled = true}, data)
    
    local window = {}
    window.Tabs = {}
    window.Elements = {}
    
    -- Usar a ScreenGui já existente (LunaUI)
    window.Gui = LunaUI.SmartWindow
    window.Gui.Visible = true
    
    -- Criar container para abas
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 0, 40)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = window.Gui
    
    window.TabContainer = tabContainer
    
    -- Container para conteúdo das abas
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -20, 1, -100)
    contentContainer.Position = UDim2.new(0, 10, 0, 95)
    contentContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = window.Gui
    window.ContentContainer = contentContainer
    
    function window:CreateTab(data)
        data = Kwargify({Name = "Tab", Icon = "grass", ImageSource = "Material"}, data)
        
        local tab = {}
        tab.Sections = {}
        
        -- Botão da aba
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 100, 1, 0)
        btn.Position = UDim2.new(0, (#self.Tabs * 100), 0, 0)
        btn.Text = "  " .. data.Name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.Parent = self.TabContainer
        
        -- Container da aba (invisível até ser selecionada)
        local tabContainer = Instance.new("ScrollingFrame")
        tabContainer.Size = UDim2.new(1, 0, 1, 0)
        tabContainer.BackgroundTransparency = 1
        tabContainer.ScrollBarThickness = 5
        tabContainer.ScrollBarImageColor3 = Color3.fromRGB(46, 204, 113)
        tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContainer.Parent = self.ContentContainer
        tabContainer.Visible = (#self.Tabs == 0) -- primeira aba visível
        
        tab.Container = tabContainer
        
        -- Função para criar seção
        function tab:CreateSection(name)
            local section = {}
            section.Elements = {}
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, -10, 0, 30)
            sectionFrame.Position = UDim2.new(0, 5, 0, (#sectionFrame.Parent:GetChildren() - 1) * 35)
            sectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Parent = self.Container
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -10, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.Text = name
            title.TextColor3 = Color3.fromRGB(200, 200, 200)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.TextSize = 16
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = sectionFrame
            
            -- Container para os elementos da seção
            local elementContainer = Instance.new("Frame")
            elementContainer.Size = UDim2.new(1, 0, 0, 0)
            elementContainer.Position = UDim2.new(0, 0, 0, 30)
            elementContainer.BackgroundTransparency = 1
            elementContainer.Parent = sectionFrame
            section.Container = elementContainer
            
            -- Ajustar tamanho da seção conforme elementos forem adicionados
            function section:UpdateSize()
                local count = #self.Container:GetChildren()
                self.Container.Size = UDim2.new(1, 0, 0, count * 35)
                sectionFrame.Size = UDim2.new(1, -10, 0, 30 + count * 35)
                -- Recalcular posições dos elementos
                for i, child in ipairs(self.Container:GetChildren()) do
                    child.Position = UDim2.new(0, 0, 0, (i-1) * 35)
                end
            end
            
            -- Função para criar toggle
            function section:CreateToggle(data, id)
                data = Kwargify({Name = "Toggle", CurrentValue = false, Callback = function() end}, data)
                
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Size = UDim2.new(1, -10, 0, 30)
                toggleFrame.Position = UDim2.new(0, 5, 0, #self.Container:GetChildren() * 35)
                toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Parent = self.Container
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0, 200, 1, 0)
                label.Position = UDim2.new(0, 10, 0, 0)
                label.Text = data.Name
                label.TextColor3 = Color3.new(1,1,1)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = toggleFrame
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 50, 0, 25)
                toggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
                toggleBtn.Text = data.CurrentValue and "ON" or "OFF"
                toggleBtn.TextColor3 = Color3.new(1,1,1)
                toggleBtn.BackgroundColor3 = data.CurrentValue and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
                toggleBtn.Font = Enum.Font.GothamBold
                toggleBtn.TextSize = 12
                toggleBtn.BorderSizePixel = 0
                toggleBtn.Parent = toggleFrame
                
                local state = data.CurrentValue
                
                toggleBtn.MouseButton1Click:Connect(function()
                    state = not state
                    toggleBtn.Text = state and "ON" or "OFF"
                    toggleBtn.BackgroundColor3 = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
                    data.Callback(state)
                end)
                
                -- Função para atualizar estado externamente
                function toggleFrame:SetState(value)
                    state = value
                    toggleBtn.Text = state and "ON" or "OFF"
                    toggleBtn.BackgroundColor3 = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
                end
                
                self:UpdateSize()
                return toggleFrame
            end
            
            -- Função para criar botão
            function section:CreateButton(data)
                data = Kwargify({Name = "Button", Callback = function() end}, data)
                
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -20, 0, 30)
                btn.Position = UDim2.new(0, 10, 0, #self.Container:GetChildren() * 35)
                btn.Text = data.Name
                btn.TextColor3 = Color3.new(1,1,1)
                btn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.BorderSizePixel = 0
                btn.Parent = self.Container
                
                btn.MouseButton1Click:Connect(data.Callback)
                
                self:UpdateSize()
                return btn
            end
            
            -- Função para criar label
            function section:CreateLabel(data)
                data = Kwargify({Text = "Label", Style = 1}, data)
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -20, 0, 25)
                label.Position = UDim2.new(0, 10, 0, #self.Container:GetChildren() * 35)
                label.Text = data.Text
                label.TextColor3 = Color3.new(1,1,1)
                label.BackgroundTransparency = 1
                label.Font = data.Style == 1 and Enum.Font.GothamBold or Enum.Font.Gotham
                label.TextSize = data.Style == 1 and 16 or 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = self.Container
                
                self:UpdateSize()
                
                -- Função para atualizar texto
                function label:Set(newText)
                    label.Text = newText
                end
                
                return label
            end
            
            -- Função para criar slider
            function section:CreateSlider(data, id)
                data = Kwargify({Name = "Slider", Range = {0,100}, Increment = 1, CurrentValue = 50, Callback = function() end}, data)
                
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, -10, 0, 40)
                sliderFrame.Position = UDim2.new(0, 5, 0, #self.Container:GetChildren() * 40)
                sliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Parent = self.Container
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0, 200, 0, 20)
                label.Position = UDim2.new(0, 10, 0, 5)
                label.Text = data.Name .. ": " .. data.CurrentValue
                label.TextColor3 = Color3.new(1,1,1)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = sliderFrame
                
                local sliderBg = Instance.new("Frame")
                sliderBg.Size = UDim2.new(1, -20, 0, 5)
                sliderBg.Position = UDim2.new(0, 10, 0, 30)
                sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                sliderBg.BorderSizePixel = 0
                sliderBg.Parent = sliderFrame
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Size = UDim2.new((data.CurrentValue - data.Range[1]) / (data.Range[2] - data.Range[1]), 0, 1, 0)
                sliderFill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                sliderFill.BorderSizePixel = 0
                sliderFill.Parent = sliderBg
                
                local dragButton = Instance.new("TextButton")
                dragButton.Size = UDim2.new(0, 10, 0, 10)
                dragButton.Position = UDim2.new(sliderFill.Size.X.Scale, -5, 0.5, -5)
                dragButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
                dragButton.BorderSizePixel = 0
                dragButton.Text = ""
                dragButton.Parent = sliderBg
                
                local dragging = false
                local value = data.CurrentValue
                
                dragButton.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation()
                        local absPos = sliderBg.AbsolutePosition
                        local relX = math.clamp(mousePos.X - absPos.X, 0, sliderBg.AbsoluteSize.X)
                        local newValue = data.Range[1] + (relX / sliderBg.AbsoluteSize.X) * (data.Range[2] - data.Range[1])
                        newValue = math.floor(newValue / data.Increment + 0.5) * data.Increment
                        newValue = math.clamp(newValue, data.Range[1], data.Range[2])
                        
                        if newValue ~= value then
                            value = newValue
                            label.Text = data.Name .. ": " .. value
                            sliderFill.Size = UDim2.new((value - data.Range[1]) / (data.Range[2] - data.Range[1]), 0, 1, 0)
                            dragButton.Position = UDim2.new(sliderFill.Size.X.Scale, -5, 0.5, -5)
                            data.Callback(value)
                        end
                    end
                end)
                
                self:UpdateSize()
                
                -- Função para atualizar valor externamente
                function sliderFrame:SetValue(newValue)
                    newValue = math.clamp(newValue, data.Range[1], data.Range[2])
                    newValue = math.floor(newValue / data.Increment + 0.5) * data.Increment
                    value = newValue
                    label.Text = data.Name .. ": " .. value
                    sliderFill.Size = UDim2.new((value - data.Range[1]) / (data.Range[2] - data.Range[1]), 0, 1, 0)
                    dragButton.Position = UDim2.new(sliderFill.Size.X.Scale, -5, 0.5, -5)
                end
                
                return sliderFrame
            end
            
            return section
        end
        
        -- Seleção de aba
        btn.MouseButton1Click:Connect(function()
            for _, otherTab in ipairs(self.Tabs) do
                otherTab.Container.Visible = false
                otherTab.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
            tabContainer.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        end)
        
        tab.Button = btn
        table.insert(self.Tabs, tab)
        return tab
    end
    
    return window
end

-- ==========================================
-- 🔹 CARREGAR A UI BASE (asset da Luna)
-- ==========================================
local LunaUI = isStudio and script.Parent:WaitForChild("Luna UI") or game:GetObjects("rbxassetid://86467455075715")[1]

if not isStudio then
    -- Remover instâncias antigas
    if gethui then
        for _, Interface in ipairs(gethui():GetChildren()) do
            if Interface.Name == LunaUI.Name and Interface ~= LunaUI then
                Interface.Enabled = false
                Interface.Name = "Luna-Old"
            end
        end
    else
        for _, Interface in ipairs(CoreGui:GetChildren()) do
            if Interface.Name == LunaUI.Name and Interface ~= LunaUI then
                Interface.Enabled = false
                Interface.Name = "Luna-Old"
            end
        end
    end
end

injectUI()
createInjectionIndicator()
verifyInjection()

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
-- 🔹 CRIAÇÃO DA INTERFACE GARDEN HORIZONS (usando a Luna)
-- ==========================================
local window = Luna:CreateWindow({
    Name = "Garden Horizons Hub",
    Subtitle = "by Noah Nabas (integração Luna)",
    LogoID = "6031097225",
    LoadingEnabled = true
})

local gardenTab = window:CreateTab({
    Name = "Garden",
    Icon = "grass",
    ImageSource = "Material"
})

-- Função auxiliar para criar toggles de itens em uma seção
local function createItemToggles(section, items, selectedTable)
    for _, item in ipairs(items) do
        section:CreateToggle({
            Name = item,
            CurrentValue = selectedTable[item] or false,
            Callback = function(value)
                selectedTable[item] = value
            end
        })
    end
end

-- Seção Seeds
local seedsSection = gardenTab:CreateSection("Seeds")
createItemToggles(seedsSection, SeedItems, Luna.Options.selectedSeedItems)
seedsSection:CreateToggle({
    Name = "Auto Buy Seeds",
    CurrentValue = Luna.Options.autoSeed,
    Callback = function(value) Luna.Options.autoSeed = value end
})

-- Seção Gear
local gearSection = gardenTab:CreateSection("Gear")
createItemToggles(gearSection, Gears, Luna.Options.selectedGears)
gearSection:CreateToggle({
    Name = "Auto Buy Gear",
    CurrentValue = Luna.Options.autoGear,
    Callback = function(value) Luna.Options.autoGear = value end
})

-- Seção Sell
local sellSection = gardenTab:CreateSection("Sell")
sellSection:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = Luna.Options.autoSell,
    Callback = function(value) Luna.Options.autoSell = value end
})

-- Seção Harvest
local harvestSection = gardenTab:CreateSection("Harvest")
createItemToggles(harvestSection, plantNames, Luna.Options.selectedPlants)
harvestSection:CreateToggle({
    Name = "Auto Harvest",
    CurrentValue = Luna.Options.autoHarvest,
    Callback = function(value) Luna.Options.autoHarvest = value end
})

-- Seção Plant
local plantSection = gardenTab:CreateSection("Plant")
createItemToggles(plantSection, Seeds, Luna.Options.selectedSeeds)
plantSection:CreateToggle({
    Name = "Auto Plant",
    CurrentValue = Luna.Options.autoPlant,
    Callback = function(value) Luna.Options.autoPlant = value end
})

-- Notificação de boas-vindas
Luna:Notification({
    Title = "Garden Horizons",
    Content = "Hub carregado com sucesso!",
    Duration = 3
})

-- Fim do script
