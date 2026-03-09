-- Gui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 220, 0, 180) -- aumentei altura para caber novo botão
Frame.Position = UDim2.new(0.4, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.1
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

-- Título
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Skin Toggle Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

-- Botão Toggle Skin
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(0, 160, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -80, 0.35, -20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Text = "Skin: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

-- Ícone dentro do botão Skin
local Icon = Instance.new("ImageLabel")
Icon.Parent = ToggleButton
Icon.Size = UDim2.new(0, 24, 0, 24)
Icon.Position = UDim2.new(0, 8, 0.5, -12)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://6031094670" -- Ícone OFF (círculo vazio)

-- Variáveis Skin
local enabled = false
local savedSkins = {}

-- Funções Skin
local function removeSkins()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            if not savedSkins[player] then
                savedSkins[player] = {}
                for _, accessory in pairs(player.Character:GetChildren()) do
                    if accessory:IsA("Accessory") or accessory:IsA("Shirt") or accessory:IsA("Pants") then
                        table.insert(savedSkins[player], accessory:Clone())
                        accessory:Destroy()
                    end
                end
            end
        end
    end
end

local function restoreSkins()
    for player, items in pairs(savedSkins) do
        if player.Character then
            for _, item in pairs(items) do
                if not player.Character:FindFirstChild(item.Name) then
                    item:Clone().Parent = player.Character
                end
            end
        end
    end
    savedSkins = {}
end

ToggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        ToggleButton.Text = "Skin: ON"
        Icon.Image = "rbxassetid://6031094667" -- Ícone verde (check)
        removeSkins()
    else
        ToggleButton.Text = "Skin: OFF"
        Icon.Image = "rbxassetid://6031094670" -- Ícone OFF (círculo vazio)
        restoreSkins()
    end
end)

--================= ESP Timer =================--

-- Botão Toggle ESP Timer
local ESPButton = Instance.new("TextButton")
ESPButton.Parent = Frame
ESPButton.Size = UDim2.new(0, 160, 0, 40)
ESPButton.Position = UDim2.new(0.5, -80, 0.7, -20)
ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ESPButton.Text = "ESP Timer: OFF"
ESPButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ESPButton.Font = Enum.Font.GothamBold
ESPButton.TextSize = 14

local ESPButtonCorner = Instance.new("UICorner")
ESPButtonCorner.CornerRadius = UDim.new(0, 8)
ESPButtonCorner.Parent = ESPButton

-- Ícone dentro do botão ESP
local ESPIcon = Instance.new("ImageLabel")
ESPIcon.Parent = ESPButton
ESPIcon.Size = UDim2.new(0, 24, 0, 24)
ESPIcon.Position = UDim2.new(0, 8, 0.5, -12)
ESPIcon.BackgroundTransparency = 1
ESPIcon.Image = "rbxassetid://6031094670" -- Ícone OFF

-- Variáveis ESP
local ESPEnabled = false
local BaseLabels = {}

-- Funções ESP Timer
local function CreateESP(basePlot)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.Name = "BaseTimerESP"

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.2
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Text = "Carregando..."

    local part = basePlot:FindFirstChildWhichIsA("BasePart")
    if part then
        billboard.Parent = part
    end

    return label
end

local function FindRemainingTime(plot)
    for _, desc in pairs(plot:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Name == "RemainingTime" then
            return desc
        end
    end
end

-- Criar ESP para cada base
for _, plot in pairs(workspace.Plots:GetChildren()) do
    local lbl = CreateESP(plot)
    BaseLabels[plot] = lbl
end

-- Atualizador
task.spawn(function()
    while task.wait(1) do
        if ESPEnabled then
            for plot, uiLabel in pairs(BaseLabels) do
                local timer = FindRemainingTime(plot)

                if timer and timer.Text ~= "" then
                    local num = tonumber(timer.Text:match("%d+"))

                    if num and num > 0 then
                        uiLabel.Text = timer.Text
                        if num <= 10 then
                            uiLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        else
                            uiLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    else
                        uiLabel.Text = "Aberta"
                        uiLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    end
                else
                    uiLabel.Text = "Aberta"
                    uiLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                end
            end
        else
            for _, uiLabel in pairs(BaseLabels) do
                uiLabel.Text = ""
            end
        end
    end
end)

-- Toggle ESP Timer
ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ESPButton.Text = "ESP Timer: ON"
        ESPIcon.Image = "rbxassetid://6031094667" -- ícone verde
    else
        ESPButton.Text = "ESP Timer: OFF"
        ESPIcon.Image = "rbxassetid://6031094670" -- ícone OFF
    end
end)


-- ====================== ADIÇÃO: ESP PLAYER (sem alterar seu código) ======================
-- Este bloco implementa o ESP para jogadores ("esp player"), usando BoxHandleAdornment + Billboard com nome e distância.
-- Não alterei nada do código acima; apenas adicionei abaixo.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Toggle global para ativar/desativar o ESP de players
local EspPlayersEnabled = true -- coloque false se quiser começar desligado

-- Tabela para controlar adornamentos criados
local PlayerESP = {} -- [player] = {box = BoxHandleAdornment, billboard = BillboardGui, label = TextLabel}

-- Função para limpar ESP de um player (chamada no character removal/desconexão)
local function ClearPlayerESP(player)
    local entry = PlayerESP[player]
    if entry then
        pcall(function()
            if entry.box and entry.box.Parent then entry.box:Destroy() end
            if entry.billboard and entry.billboard.Parent then entry.billboard:Destroy() end
        end)
        PlayerESP[player] = nil
    end
end

-- Função que cria/atualiza ESP para um character
local function SetupPlayerESP(player)
    -- evita aplicar no local player
    if player == LocalPlayer then return end

    -- espera character
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
    if not hrp then
        -- tenta esperar o HRP por alguns instantes
        hrp = char:WaitForChild("HumanoidRootPart", 2)
        if not hrp then
            hrp = char:FindFirstChildWhichIsA("BasePart")
            if not hrp then
                return
            end
        end
    end

    -- limpa se já existir
    ClearPlayerESP(player)

    -- Caixa 3D (BoxHandleAdornment)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "esp player_box"
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 0
    box.Size = Vector3.new(2.5, 4, 1.5) -- ajuste conforme modelo do jogo
    box.Color3 = Color3.fromRGB(0, 255, 255)
    box.Transparency = 0.6
    box.Parent = hrp -- parent no HRP é ok

    -- BillboardGui para nome + distância (nomeado com "esp player")
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "esp player"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = hrp

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 255, 255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Text = player.Name
    label.Parent = billboard

    PlayerESP[player] = { box = box, billboard = billboard, label = label, hrp = hrp }
end

-- Atualiza distância em cada frame (renderstepped) — se ESP estiver habilitado
RunService.RenderStepped:Connect(function()
    if not EspPlayersEnabled then
        -- opcional: esconde adornos quando desabilitado
        for player, data in pairs(PlayerESP) do
            pcall(function()
                if data.box then data.box.Visible = false end
                if data.billboard then data.billboard.Enabled = false end
            end)
        end
        return
    end

    -- se habilitado, atualiza e garante visibilidade
    for player, data in pairs(PlayerESP) do
        local success, _ = pcall(function()
            if not player.Character or not data.hrp then
                ClearPlayerESP(player)
                return
            end

            -- garante visibilidade dos adornos
            if data.box then data.box.Visible = true end
            if data.billboard then data.billboard.Enabled = true end

            -- atualiza texto com distância em studs
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and data.hrp then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - data.hrp.Position).Magnitude
                if data.label then
                    data.label.Text = string.format("%s\n[%.0f studs]", player.Name, dist)
                end
            end
        end)
        if not success then
            ClearPlayerESP(player)
        end
    end
end)

-- Conecta quando character spawna
local function OnCharacterAdded(player)
    return function(char)
        -- aguarda um pouco para garantir partes
        task.wait(0.8)
        if EspPlayersEnabled then
            pcall(function() SetupPlayerESP(player) end)
        end
    end
end

-- Monitora jogadores existentes
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        -- cria se já tiver character
        if player.Character then
            pcall(function() SetupPlayerESP(player) end)
        end
        player.CharacterAdded:Connect(OnCharacterAdded(player))
        player.AncestryChanged:Connect(function()
            -- se sair do jogo, limpa
            if not player:IsDescendantOf(game) then
                ClearPlayerESP(player)
            end
        end)
    end
end

-- Monitora novos jogadores
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(OnCharacterAdded(player))
    end
end)

-- Limpa ESP quando jogador sai
Players.PlayerRemoving:Connect(function(player)
    ClearPlayerESP(player)
end)

-- Função pública para ligar/desligar o ESP de players sem mexer no restante do script
-- você pode chamar isso em outro lugar se quiser: EspPlayersEnabled = false/true
-- ou usar:
-- EspPlayersEnabled = not EspPlayersEnabled

-- EOF - fim da adição ESP PLAYER
