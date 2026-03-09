--[[
	Garden Horizons Hub - Versão Ultra Estável
	UI funcional, sem dependências de remotos (opcionais)
]]
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Criar GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GardenHorizonsHub"
gui.ResetOnSpawn = false

-- Botão abrir/fechar
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 120, 0, 30)
openBtn.Position = UDim2.new(0, 10, 0.3, 0)
openBtn.Text = "🌾 Garden Horizons"
openBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Draggable = true

-- Janela principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 360)
frame.Position = UDim2.new(0.3, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Visible = false

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🌾 Garden Horizons Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.TextScaled = true

-- Crédito
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, 0, 0, 18)
credit.Position = UDim2.new(0, 0, 0, 30)
credit.Text = "By Noah Nabas (ultra estável)"
credit.TextSize = 14
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.BackgroundTransparency = 1

-- Fechar
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Alternar visibilidade
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Listas de exemplo (apenas para preencher as abas)
local SeedItems = {"Carrot Seed", "Tomato Seed", "Potato Seed"}
local Gears = {"Watering Can", "Basic Sprinkler"}
local Seeds = {"Carrot", "Tomato"}
local plantNames = {"Carrot", "Tomato"}  -- simulado

-- Tabelas de seleção
local selectedSeedItems = {}
local selectedSeeds = {}
local selectedGears = {}
local selectedPlants = {}

-- Criar abas
local tabs = {"Seeds","Gear","Sell","Harvest","Plant"}
local panels = {}
local tabButtons = {}

for i, name in ipairs(tabs) do
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1 / #tabs, 0, 0, 25)
	btn.Position = UDim2.new((i - 1) / #tabs, 0, 0, 73)
	btn.Text = name
	btn.TextSize = 12
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	tabButtons[name] = btn

	local panel = Instance.new("Frame", frame)
	panel.Size = UDim2.new(1, 0, 1, -98)
	panel.Position = UDim2.new(0, 0, 0, 98)
	panel.BackgroundTransparency = 1
	panel.Visible = (i == 1)
	panels[name] = panel

	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(panels) do p.Visible = false end
		for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end
		panel.Visible = true
		btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
	end)
end

-- Função para criar scroll
local function makeScroll(parent, list, selected)
	local scroll = Instance.new("ScrollingFrame", parent)
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.ScrollBarThickness = 5
	local y = 0
	for _, name in ipairs(list) do
		selected[name] = false
		local b = Instance.new("TextButton", scroll)
		b.Size = UDim2.new(1, -6, 0, 22)
		b.Position = UDim2.new(0, 3, 0, y)
		b.Text = "☐ " .. name
		b.TextSize = 12
		b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		b.TextColor3 = Color3.new(1, 1, 1)
		y = y + 24

		b.MouseButton1Click:Connect(function()
			selected[name] = not selected[name]
			b.Text = (selected[name] and "☑ " or "☐ ") .. name
			b.BackgroundColor3 = selected[name] and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(35, 35, 35)
		end)
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Preencher abas
makeScroll(panels["Seeds"], SeedItems, selectedSeedItems)
makeScroll(panels["Gear"], Gears, selectedGears)
makeScroll(panels["Plant"], Seeds, selectedSeeds)
makeScroll(panels["Harvest"], plantNames, selectedPlants)

-- Botões toggle (apenas estética, sem funções automáticas)
local function makeDummyToggle(parent, text)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -10, 0, 25)
	btn.Position = UDim2.new(0, 5, 1, -30)
	btn.Text = text .. ": OFF"
	btn.TextSize = 12
	btn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.MouseButton1Click:Connect(function()
		-- apenas alterna visualmente
		if btn.Text:find("OFF") then
			btn.Text = text .. ": ON"
			btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
		else
			btn.Text = text .. ": OFF"
			btn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
		end
	end)
end

makeDummyToggle(panels["Seeds"], "Auto Buy Seed")
makeDummyToggle(panels["Gear"], "Auto Buy Gear")
makeDummyToggle(panels["Sell"], "Auto Sell")
makeDummyToggle(panels["Harvest"], "Auto Harvest")
makeDummyToggle(panels["Plant"], "Auto Plant")

print("UI carregada com sucesso! Clique no botão verde.")
-- Fim do script
