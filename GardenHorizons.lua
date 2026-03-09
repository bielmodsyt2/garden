--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Garden Horizons Hub
-- Script by Noah Nabas

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Remotes
local BuyRemote = RS:WaitForChild("RemoteEvents"):WaitForChild("PurchaseShopItem")
local SellRemote = RS:WaitForChild("RemoteEvents"):WaitForChild("SellItems")
local PlantRemote = RS:WaitForChild("RemoteEvents"):WaitForChild("PlantSeed")
local PlantsFolder = RS:WaitForChild("Plants"):WaitForChild("Models")

-- FULL SEED LIST
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

-- Tables
local selectedSeedItems, selectedSeeds, selectedGears, selectedPlants = {},{},{},{}
local autoSeed, autoGear, autoSell, autoHarvest, autoPlant = false,false,false,false,false

--------------------------------------------------
-- OPEN BUTTON
--------------------------------------------------
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GardenHorizonsUnified"

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,120,0,30)
openBtn.Position = UDim2.new(0,10,0.3,0)
openBtn.Text = "🌾 Garden Horizons"
openBtn.BackgroundColor3 = Color3.fromRGB(0,120,0)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Active = true
openBtn.Draggable = true

--------------------------------------------------
-- MAIN GUI FRAME
--------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,360)
frame.Position = UDim2.new(0.3,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.Visible = true  -- starts hidden

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🌾 Garden Horizons Hub"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextScaled = true

-- Credit under title
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1,0,0,18)
credit.Position = UDim2.new(0,0,0,30)
credit.Text = "By Noah Nabas"
credit.TextSize = 14
credit.TextColor3 = Color3.fromRGB(200,200,200)
credit.BackgroundTransparency = 1
credit.TextXAlignment = Enum.TextXAlignment.Center

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-30,0,0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Open button function
openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
end)

-- Tabs
local tabs = {"Seeds","Gear","Sell","Harvest","Plant"}
local panels = {}
local tabButtons = {}

for i,name in ipairs(tabs) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1/#tabs,0,0,25)
    btn.Position = UDim2.new((i-1)/#tabs,0,0,73)
    btn.Text = name
    btn.TextSize = 12
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    tabButtons[name] = btn

    local panel = Instance.new("Frame", frame)
    panel.Size = UDim2.new(1,0,1,-98)
    panel.Position = UDim2.new(0,0,0,98)
    panel.BackgroundTransparency = 1
    panel.Visible = (i==1)
    panels[name] = panel

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(panels) do p.Visible=false end
        for _,b in pairs(tabButtons) do b.BackgroundColor3=Color3.fromRGB(50,50,50) end
        panel.Visible=true
        btn.BackgroundColor3=Color3.fromRGB(0,120,0)
    end)
end

-- Scroll creator
local function makeScroll(parent,list,selected)
    local scroll = Instance.new("ScrollingFrame", parent)
    scroll.Size = UDim2.new(1,0,1,0)
    scroll.ScrollBarThickness = 5
    local y=0
    for _,name in ipairs(list) do
        selected[name]=false
        local b = Instance.new("TextButton",scroll)
        b.Size = UDim2.new(1,-6,0,22)
        b.Position = UDim2.new(0,3,0,y)
        b.Text="☐ "..name
        b.TextSize=12
        b.BackgroundColor3=Color3.fromRGB(35,35,35)
        b.TextColor3=Color3.new(1,1,1)
        y=y+24

        b.MouseButton1Click:Connect(function()
            selected[name]=not selected[name]
            b.Text=(selected[name] and "☑ " or "☐ ")..name
            b.BackgroundColor3=selected[name] and Color3.fromRGB(0,120,0) or Color3.fromRGB(35,35,35)
        end)
    end
    scroll.CanvasSize=UDim2.new(0,0,y,0)
end

-- Create lists
makeScroll(panels["Seeds"],SeedItems,selectedSeedItems)
makeScroll(panels["Gear"],Gears,selectedGears)
makeScroll(panels["Plant"],Seeds,selectedSeeds)

-- All plants auto list
local plantNames={}
for _,p in pairs(PlantsFolder:GetChildren()) do
    table.insert(plantNames,p.Name)
end
makeScroll(panels["Harvest"],plantNames,selectedPlants)

-- Toggle Buttons
local function makeToggle(parent,text,callback)
    local btn = Instance.new("TextButton",parent)
    btn.Size = UDim2.new(1,-10,0,25)
    btn.Position = UDim2.new(0,5,1,-30)
    btn.Text = text..": OFF"
    btn.TextSize = 12
    btn.BackgroundColor3 = Color3.fromRGB(120,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function()
        local state=callback()
        btn.Text=text..(state and ": ON" or ": OFF")
        btn.BackgroundColor3=state and Color3.fromRGB(0,120,0) or Color3.fromRGB(120,0,0)
    end)
end

makeToggle(panels["Seeds"],"Auto Buy Seed",function() autoSeed=not autoSeed return autoSeed end)
makeToggle(panels["Gear"],"Auto Buy Gear",function() autoGear=not autoGear return autoGear end)
makeToggle(panels["Sell"],"Auto Sell",function() autoSell=not autoSell return autoSell end)
makeToggle(panels["Harvest"],"Auto Harvest",function() autoHarvest=not autoHarvest return autoHarvest end)
makeToggle(panels["Plant"],"Auto Plant",function() autoPlant=not autoPlant return autoPlant end)

-- AUTO LOOP
task.spawn(function()
    while task.wait(1) do
        if autoSeed then
            for s,on in pairs(selectedSeedItems) do if on then BuyRemote:InvokeServer("SeedShop",s) end end
        end
        if autoGear then
            for g,on in pairs(selectedGears) do if on then BuyRemote:InvokeServer("GearShop",g) end end
        end
        if autoSell then
            SellRemote:InvokeServer("SellAll")
        end
        if autoHarvest then
            for _,plant in pairs(workspace.ClientPlants:GetChildren()) do
                local base=plant.Name:gsub("%d","")
                if selectedPlants[base] then
                    for _,v in pairs(plant:GetDescendants()) do
                        if v:IsA("ProximityPrompt") and v.Name=="HarvestPrompt" then
                            v.HoldDuration=0
                            fireproximityprompt(v)
                        end
                    end
                end
            end
        end
        if autoPlant and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos=player.Character.HumanoidRootPart.Position
            for _,seed in pairs(Seeds) do
                if selectedSeeds[seed] then
                    for x=-4,4,2 do
                        for z=-4,4,2 do
                            PlantRemote:InvokeServer(seed,pos+Vector3.new(x,-3,z))
                        end
                    end
                end
            end
        end
    end
end)
