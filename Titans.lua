-- PLACEID 3082002798
if game.PlaceId ~= 3082002798 then return end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

--------------------------------------------------
-- VARIÁVEIS
--------------------------------------------------
local AutoFarm = false
local AutoTP = false
local AutoJet = false
local AutoBoStaff = false
local HitboxSize = 5
local TargetName = ""

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "VMasterMenu"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.32,0.42)
main.Position = UDim2.fromScale(0.34,0.28)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.fromScale(1,0.12)
title.Text = "VMasterScripts"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true

local function button(txt,y)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.fromScale(0.9,0.1)
	b.Position = UDim2.fromScale(0.05,y)
	b.Text = txt
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local farmBtn = button("Auto Farm: OFF",0.15)
local tpBox = Instance.new("TextBox", main)
tpBox.Size = UDim2.fromScale(0.9,0.1)
tpBox.Position = UDim2.fromScale(0.05,0.27)
tpBox.PlaceholderText = "@Nome do Player"
tpBox.Text = ""

local tpBtn = button("Teleport Player: OFF",0.39)
local jetBtn = button("Auto Equip Jet: OFF",0.51)
local boBtn = button("Auto BoStaff: OFF",0.63)

local hitBox = Instance.new("TextBox", main)
hitBox.Size = UDim2.fromScale(0.9,0.1)
hitBox.Position = UDim2.fromScale(0.05,0.75)
hitBox.PlaceholderText = "HitBox (ex: 20)"
hitBox.Text = ""

--------------------------------------------------
-- BOTÕES
--------------------------------------------------
farmBtn.MouseButton1Click:Connect(function()
	AutoFarm = not AutoFarm
	farmBtn.Text = "Auto Farm: "..(AutoFarm and "ON" or "OFF")
end)

tpBtn.MouseButton1Click:Connect(function()
	AutoTP = not AutoTP
	TargetName = tpBox.Text
	tpBtn.Text = "Teleport Player: "..(AutoTP and "ON" or "OFF")
end)

jetBtn.MouseButton1Click:Connect(function()
	AutoJet = not AutoJet
	jetBtn.Text = "Auto Equip Jet: "..(AutoJet and "ON" or "OFF")
end)

boBtn.MouseButton1Click:Connect(function()
	AutoBoStaff = not AutoBoStaff
	boBtn.Text = "Auto BoStaff: "..(AutoBoStaff and "ON" or "OFF")
end)

hitBox.FocusLost:Connect(function()
	local n = tonumber(hitBox.Text)
	if n then HitboxSize = n end
end)

--------------------------------------------------
-- AUTO FARM
--------------------------------------------------
task.spawn(function()
	while task.wait(1) do
		if AutoFarm and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
			local list = Players:GetPlayers()
			local t = list[math.random(#list)]
			if t ~= LP and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
				LP.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-2)
			end
		end
	end
end)

--------------------------------------------------
-- TELEPORT PLAYER
--------------------------------------------------
task.spawn(function()
	while task.wait(1) do
		if AutoTP and TargetName ~= "" then
			local t = Players:FindFirstChild(TargetName)
			if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
				LP.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-2)
			end
		end
	end
end)

--------------------------------------------------
-- HITBOX
--------------------------------------------------
RunService.Stepped:Connect(function()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			p.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize,HitboxSize,HitboxSize)
			p.Character.HumanoidRootPart.Transparency = 0.7
			p.Character.HumanoidRootPart.CanCollide = false
		end
	end
end)

--------------------------------------------------
-- ESP
--------------------------------------------------
local function ESP(char)
	if char:FindFirstChild("ESP") then return end
	local box = Instance.new("BoxHandleAdornment", char)
	box.Name = "ESP"
	box.Adornee = char:WaitForChild("HumanoidRootPart")
	box.Size = Vector3.new(4,6,4)
	box.Color3 = Color3.new(1,0,0)
	box.AlwaysOnTop = true
	box.ZIndex = 5
	box.Transparency = 0.5
end

for _,p in ipairs(Players:GetPlayers()) do
	if p ~= LP then
		p.CharacterAdded:Connect(ESP)
		if p.Character then ESP(p.Character) end
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(ESP)
end)

--------------------------------------------------
-- AUTO JET / BOSTAFF (PRONTO PRA REMOTE)
--------------------------------------------------
LP.CharacterAdded:Connect(function()
	task.wait(1)
	if AutoJet then
		-- AQUI VAI O REMOTE DO JET
		-- RS.Shared_GizmoidJetpack:FireServer(true)
	end
	if AutoBoStaff then
		-- AQUI VAI O REMOTE DO BOSTAFF
	end
end)
