[file name]: source.lua
[file content begin]
--[[

Luna Interface Suite
by Nebula Softworks

Main Credits

Hunter (Nebula Softworks) | Designing And Programming | Main Developer
JustHey (Nebula Softworks) | Configurations, Bug Fixing And More! | Co Developer
Throit | Color Picker
Wally | Dragging And Certain Functions
Sirius | PCall Parsing, Notifications, Slider And Home Tab
Luna Executor | Original UI

Extra Credits / Provided Certain Elements

Pookie Pepelss | Bug Tester
Inori | Configuration Concept
Latte Softworks and qweery | Lucide Icons And Material Icons
kirill9655 | Loading Circle
Deity/dp4pv/x64x70 | Certain Scripting and Testing ig

]]

local Release = "Prerelease Beta 6.1"

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
    
    if gethui then
        print("UI injetada no gethui():", LunaUI.Parent == gethui())
    elseif syn and syn.protect_gui then
        print("UI protegida com syn.protect_gui")
    else
        print("UI injetada no CoreGui:", LunaUI.Parent == game:GetService("CoreGui"))
    end
    return true
end

local function injectUI()
    local success, message = pcall(function()
        -- Tentar métodos de injeção em ordem de preferência
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
            -- Método fallback
            LunaUI.Parent = game:GetService("CoreGui")
            print("UI injetada no CoreGui (método padrão)")
        end
        
        -- Verificar se a UI está visível
        LunaUI.Enabled = true
        LunaUI.SmartWindow.Visible = true
    end)
    
    if not success then
        warn("Falha ao injetar UI: " .. tostring(message))
        -- Tentar método simples como fallback
        pcall(function()
            LunaUI.Parent = game:GetService("CoreGui")
            LunaUI.Enabled = true
            LunaUI.SmartWindow.Visible = true
        end)
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
    text.Text = "Luna UI Injetada ✓"
    text.TextColor3 = Color3.fromRGB(0, 255, 0)
    text.Font = Enum.Font.SourceSansBold
    text.TextSize = 18
    text.Parent = frame
    
    frame.Parent = indicator
    
    -- Tentar injetar o indicador usando os mesmos métodos
    if gethui then
        indicator.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(indicator)
        indicator.Parent = game:GetService("CoreGui")
    else
        indicator.Parent = game:GetService("CoreGui")
    end
    
    -- Remover após 5 segundos
    delay(5, function()
        indicator:Destroy()
    end)
end

local function emergencyInjection()
    for i = 1, 5 do  -- Tentar 5 vezes
        local success = pcall(function()
            -- Tentar diferentes pais possíveis
            local possibleParents = {
                game:GetService("CoreGui"),
                game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"),
                game:GetService("StarterGui")
            }
            
            for _, parent in ipairs(possibleParents) do
                if parent then
                    LunaUI.Parent = parent
                    LunaUI.Enabled = true
                    LunaUI.SmartWindow.Visible = true
                    print("UI injetada no: " .. parent:GetFullName())
                    return true
                end
            end
        end)
        
        if success then
            return true
        end
        
        wait(1)  -- Esperar 1 segundo antes de tentar novamente
    end
    
    return false
end

-- Verificar funções de injeção disponíveis
print("Executor detectado:", identifyexecutor and identifyexecutor() or "Unknown")
print("Versão do Roblox:", version())
print("gethui disponível:", type(gethui) == "function")
print("syn.protect_gui disponível:", type(syn) == "table" and type(syn.protect_gui) == "function")
print("get_hidden_ui disponível:", type(get_hidden_ui) == "function")
print("protect_gui disponível:", type(protect_gui) == "function")

-- ==========================================
-- 🔹 Adaptação para Steal a Brainroot
-- ==========================================
local function getBrainroots()
    local brainroots = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            if string.find(string.lower(obj.Name), "brainroot") then
                table.insert(brainroots, obj)
            end
        end
    end
    return brainroots
end

-- Exemplo de uso (você pode integrar onde precisar dentro da UI):
local function printBrainroots()
    local roots = getBrainroots()
    warn("Foram encontrados " .. tostring(#roots) .. " Brainroots no mapa!")
    for _, r in ipairs(roots) do
        print("Brainroot detectado:", r:GetFullName())
    end
end

-- Chama uma vez no início só para confirmar
printBrainroots()

-- Enhanced brainroot detection with ProximityPrompt support
local function getBrainrootsEnhanced()
    local brainroots = {}
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            -- Look for brainroots with ProximityPrompt components
            if string.find(string.lower(obj.Name), "brainroot") or
               (obj:FindFirstChildOfClass("ProximityPrompt") and 
                (string.find(string.lower(obj.Name), "root") or 
                 string.find(string.lower(obj.Name), "collect"))) then
                table.insert(brainroots, obj)
            end
        end
    end
    
    return brainroots
end

-- Enhanced collection using ProximityPrompt system
function collectAllBrainroots()
    local character = Player.Character or Player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then
        return
    end
    
    local brainroots = getBrainrootsEnhanced()
    local collectionRange = Luna.Options.CollectionRange or 30
    
    for _, brainroot in ipairs(brainroots) do
        local rootPart = brainroot:FindFirstChild("PrimaryPart") or brainroot:FindFirstChildWhichIsA("BasePart")
        local proximityPrompt = brainroot:FindFirstChildOfClass("ProximityPrompt")
        
        if rootPart and proximityPrompt and (humanoidRootPart.Position - rootPart.Position).Magnitude <= collectionRange then
            -- Trigger the ProximityPrompt
            proximityPrompt:InputHoldBegin()
            task.wait(proximityPrompt.HoldDuration or 1)
            proximityPrompt:InputHoldEnd()
            
            -- Optional: Add visual feedback
            task.wait(0.1) -- Small delay to prevent lag
        end
    end
end

-- Function to monitor ProximityPrompt events
local function setupProximityPromptMonitoring()
    local ProximityPrompts = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ProximityPrompts")
    local Prompt = ProximityPrompts and ProximityPrompts:FindFirstChild("Prompt")
    
    if Prompt then
        -- Monitor when prompts appear (indicating nearby interactable objects)
        Prompt:GetPropertyChangedSignal("Visible"):Connect(function()
            if Prompt.Visible and string.find(string.lower(Prompt.Title.Text or ""), "brainroot") then
                -- A brainroot prompt is visible
                if Luna.Options and Luna.Options.AutoFarmBrainroots then
                    -- Auto-collect if farming is enabled
                    Prompt.Triggered:Connect(function()
                        -- The prompt was triggered (player collected the brainroot)
                    end)
                end
            end
        end)
    end
end

-- Credits To Latte Softworks And qweery for Lucide And Material Icons Respectively.
local IconModule = {
	Lucide = nil,
	Material = {
		-- ... (todo o conteúdo original de IconModule aqui)
		-- [IMPORTANTE: Mantenha todo o conteúdo original de IconModule aqui]
	}
}

-- Other Variables
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

local function GetIcon(icon, source)
	if source == "Custom" then
		return "rbxassetid://" .. icon
	elseif source == "Lucide" then
		-- full credit to latte softworks :)
		local iconData = not isStudio and game:HttpGet("https://raw.githubusercontent.com/latte-soft/lucide-roblox/refs/heads/master/lib/Icons.luau")
		local icons = isStudio and IconModule.Lucide or loadstring(iconData)()
		if not isStudio then
			icon = string.match(string.lower(icon), "^%s*(.*)%s*$") :: string
			local sizedicons = icons['48px']

			local r = sizedicons[icon]
			if not r then
				error("Lucide Icons: Failed to find icon by the name of \"" .. icon .. "\.", 2)
			end

			local rirs = r[2]
			local riro = r[3]

			if type(r[1]) ~= "number" or type(rirs) ~= "table" or type(riro) ~= "table" then
				error("Lucide Icons: Internal error: Invalid auto-generated asset entry")
			end

			local irs = Vector2.new(rirs[1], rirs[2])
			local iro = Vector2.new(riro[1], riro[2])

			local asset = {
				id = r[1],
				imageRectSize = irs,
				imageRectOffset = iro,
			}

			return asset
		else
			return "rbxassetid://10723434557"
		end
	else	
		if icon ~= nil and IconModule[source] then
			local sourceicon = IconModule[source]
			return sourceicon[icon]
		else
			return nil
		end
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
	local RunService = game:GetService('RunService')
	local camera = workspace.CurrentCamera
	local MTREL = "Glass"
	local binds = {}
	local root = Instance.new('Folder', camera)
	root.Name = 'LunaBlur'

	local gTokenMH = 99999999
	local gToken = math.random(1, gTokenMH)

	local DepthOfField = Instance.new('DepthOfFieldEffect', game:GetService('Lighting'))
	DepthOfField.FarIntensity = 0
	DepthOfField.FocusDistance = 51.6
	DepthOfField.InFocusRadius = 50
	DepthOfField.NearIntensity = 6
	DepthOfField.Name = "DPT_"..gToken

	local frame = Instance.new('Frame')
	frame.Parent = Frame
	frame.Size = UDim2.new(0.95, 0, 0.95, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundTransparency = 1

	local GenUid; do -- Generate unique names for RenderStepped bindings
		local id = 0
		function GenUid()
			id = id + 1
			return 'neon::'..tostring(id)
		end
	end

	do
		local function IsNotNaN(x)
			return x == x
		end
		local continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
		while not continue do
			RunService.RenderStepped:wait()
			continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
		end
	end

	local DrawQuad; do

		local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
		local sz = 0.22
		local function DrawTriangle(v1, v2, v3, p0, p1) -- I think Stravant wrote this function

			local s1 = (v1 - v2).magnitude
			local s2 = (v2 - v3).magnitude
			local s3 = (v3 - v1).magnitude
			local smax = max(s1, s2, s3)
			local A, B, C
			if s1 == smax then
				A, B, C = v1, v2, v3
			elseif s2 == smax then
				A, B, C = v2, v3, v1
			elseif s3 == smax then
				A, B, C = v3, v1, v2
			end

			local para = ( (B-A).x*(C-A).x + (B-A).y*(C-A).y + (B-A).z*(C-A).z ) / (A-B).magnitude
			local perp = sqrt((C-A).magnitude^2 - para*para)
			local dif_para = (A - B).magnitude - para

			local st = CFrame.new(B, A)
			local za = CFrame.Angles(pi/2,0,0)

			local cf0 = st

			local Top_Look = (cf0 * za).lookVector
			local Mid_Point = A + CFrame.new(A, B).lookVector * para
			local Needed_Look = CFrame.new(Mid_Point, C).lookVector
			local dot = Top_Look.x*Needed_Look.x + Top_Look.y*Needed_Look.y + Top_Look.z*Needed_Look.z

			local ac = CFrame.Angles(0, 0, acos(dot))

			cf0 = cf0 * ac
			if ((cf0 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf0 = cf0 * CFrame.Angles(0, 0, -2*acos(dot))
			end
			cf0 = cf0 * CFrame.new(0, perp/2, -(dif_para + para/2))

			local cf1 = st * ac * CFrame.Angles(0, pi, 0)
			if ((cf1 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf1 = cf1 * CFrame.Angles(0, 0, 2*acos(dot))
			end
			cf1 = cf1 * CFrame.new(0, perp/2, dif_para/2)

			if not p0 then
				p0 = Instance.new('Part')
				p0.FormFactor = 'Custom'
				p0.TopSurface = 0
				p0.BottomSurface = 0
				p0.Anchored = true
				p0.CanCollide = false
				p0.CastShadow = false
				p0.Material = MTREL
				p0.Size = Vector3.new(sz, sz, sz)
				local mesh = Instance.new('SpecialMesh', p0)
				mesh.MeshType = 2
				mesh.Name = 'WedgeMesh'
			end
			p0.WedgeMesh.Scale = Vector3.new(0, perp/sz, para/sz)
			p0.CFrame = cf0

			if not p1 then
				p1 = p0:clone()
			end
			p1.WedgeMesh.Scale = Vector3.new(0, perp/sz, dif_para/sz)
			p1.CFrame = cf1

			return p0, p1
		end

		function DrawQuad(v1, v2, v3, v4, parts)
			parts[1], parts[2] = DrawTriangle(v1, v2, v3, parts[1], parts[2])
			parts[3], parts[4] = DrawTriangle(v3, v2, v4, parts[3], parts[4])
		end
	end

	if binds[frame] then
		return binds[frame].parts
	end

	local uid = GenUid()
	local parts = {}
	local f = Instance.new('Folder', root)
	f.Name = frame.Name

	local parents = {}
	do
		local function add(child)
			if child:IsA'GuiObject' then
				parents[#parents + 1] = child
				add(child.Parent)
			end
		end
		add(frame)
	end

	local function UpdateOrientation(fetchProps)
		local properties = {
			Transparency = 0.98;
			BrickColor = BrickColor.new('Institutional white');
		}
		local zIndex = 1 - 0.05*frame.ZIndex

		local tl, br = frame.AbsolutePosition, frame.AbsolutePosition + frame.AbsoluteSize
		local tr, bl = Vector2.new(br.x, tl.y), Vector2.new(tl.x, br.y)
		do
			local rot = 0;
			for _, v in ipairs(parents) do
				rot = rot + v.Rotation
			end
			if rot ~= 0 and rot%180 ~= 0 then
				local mid = tl:lerp(br, 0.5)
				local s, c = math.sin(math.rad(rot)), math.cos(math.rad(rot))
				local vec = tl
				tl = Vector2.new(c*(tl.x - mid.x) - s*(tl.y - mid.y), s*(tl.x - mid.x) + c*(tl.y - mid.y)) + mid
				tr = Vector2.new(c*(tr.x - mid.x) - s*(tr.y - mid.y), s*(tr.x - mid.x) + c*(tr.y - mid.y)) + mid
				bl = Vector2.new(c*(bl.x - mid.x) - s*(bl.y - mid.y), s*(bl.x - mid.x) + c*(bl.y - mid.y)) + mid
				br = Vector2.new(c*(br.x - mid.x) - s*(br.y - mid.y), s*(br.x - mid.x) + c*(br.y - mid.y)) + mid
			end
		end
		DrawQuad(
			camera:ScreenPointToRay(tl.x, tl.y, zIndex).Origin, 
			camera:ScreenPointToRay(tr.x, tr.y, zIndex).Origin, 
			camera:ScreenPointToRay(bl.x, bl.y, zIndex).Origin, 
			camera:ScreenPointToRay(br.x, br.y, zIndex).Origin, 
			parts
		)
		if fetchProps then
			for _, pt in pairs(parts) do
				pt.Parent = f
			end
			for propName, propValue in pairs(properties) do
				for _, pt in pairs(parts) do
					pt[propName] = propValue
				end
			end
		end

	end

	UpdateOrientation(true)
	RunService:BindToRenderStep(uid, 2000, UpdateOrientation)
end

local function unpackt(array : table)

	local val = ""
	local i = 0
	for _,v in pairs(array) do
		if i < 3 then
			val = val .. v .. ", "
			i += 1
		else
			val = "Various"
			break
		end
	end

	return val
end

-- Interface Management
local LunaUI = isStudio and script.Parent:WaitForChild("Luna UI") or game:GetObjects("rbxassetid://86467455075715")[1]

-- Aplicar as correções de injeção
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

-- Usar o novo sistema de injeção
injectUI()
createInjectionIndicator()

-- Verificar se a injeção foi bem-sucedida
if not verifyInjection() then
    warn("Tentando injeção de emergência...")
    emergencyInjection()
end

-- Resto do código original continua aqui...
-- [IMPORTANTE: Mantenha todo o resto do código original abaixo]

-- ... (o resto do seu código original)

-- ==========================================
-- 🔹 BRAINROOT FARMING SYSTEM
-- ==========================================
local function createBrainrootSection(tab)
    local section = tab:CreateSection("Brainroot Farm")
    
    -- Toggle for auto-farming
    local farmToggle = section:CreateToggle({
        Name = "Auto Farm Brainroots",
        CurrentValue = false,
        Callback = function(value)
            if value then
                Luna:Notification({Title = "Brainroot Farm", Content = "Auto-farming enabled!", Icon = "grass"})
                startBrainrootFarm()
            else
                Luna:Notification({Title = "Brainroot Farm", Content = "Auto-farming disabled!", Icon = "grass"})
                stopBrainrootFarm()
            end
        end
    }, "AutoFarmBrainroots")
    
    -- Button to collect all nearby brainroots
    section:CreateButton({
        Name = "Collect All Brainroots",
        Callback = function()
            collectAllBrainroots()
        end
    })
    
    -- Label to show brainroot count
    local brainrootCountLabel = section:CreateLabel({
        Text = "Brainroots Nearby: 0",
        Style = 1
    })
    
    -- Slider for collection range
    local rangeSlider = section:CreateSlider({
        Name = "Collection Range",
        Range = {10, 100},
        Increment = 5,
        CurrentValue = 30,
        Callback = function(value)
            Luna.Options.CollectionRange = value
        end
    }, "CollectionRange")
    
    -- Update brainroot count periodically
    local function updateBrainrootCount()
        local brainroots = getBrainrootsEnhanced()
        brainrootCountLabel:Set("Brainroots Nearby: " .. #brainroots)
    end
    
    -- Set up periodic updates
    local updateConnection
    farmToggle:UpdateState(false) -- Ensure it starts off
    
    function startBrainrootFarm()
        if updateConnection then
            updateConnection:Disconnect()
        end
        
        updateConnection = RunService.Heartbeat:Connect(function()
            updateBrainrootCount()
            if farmToggle.CurrentValue then
                collectAllBrainroots()
            end
        end)
    end
    
    function stopBrainrootFarm()
        if updateConnection then
            updateConnection:Disconnect()
            updateConnection = nil
        end
    end
    
    -- Initialize
    updateBrainrootCount()
end

-- ==========================================
-- 🔹 SETUP DA JANELA PRINCIPAL
-- ==========================================
local function setupBrainrootTab()
    local window = Luna:CreateWindow({
        Name = "Steal a Brainroot",
        Subtitle = "Farming Utility",
        LogoID = "6031097225",
        LoadingEnabled = true
    })
    
    local mainTab = window:CreateTab({
        Name = "Brainroot Farm",
        Icon = "grass",
        ImageSource = "Material"
    })
    
    createBrainrootSection(mainTab)
    setupProximityPromptMonitoring()
end

-- Iniciar a interface
setupBrainrootTab()
[file content end]
