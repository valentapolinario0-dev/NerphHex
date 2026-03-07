--==================================================
-- MM2 HUB COMPLETO
--==================================================
if game.PlaceId ~= 142823291 then return end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local cam = Workspace.CurrentCamera

--==================================================
-- CHARACTER SAFE
--==================================================
local function getChar()
	local char = lp.Character or lp.CharacterAdded:Wait()
	return char,
	char:WaitForChild("Humanoid"),
	char:WaitForChild("HumanoidRootPart")
end

local char, hum, hrp = getChar()

lp.CharacterAdded:Connect(function()
	char, hum, hrp = getChar()
end)

--==================================================
-- STATES
--==================================================
local AutoFarm = false
local ESP = false
local ESPTeams = false
local AutoGun = false
local AimInstant = false
local FakeSpeed = false

local TweenSpeed = 21
local CurrentTween

local SpeedValue = 16
local JumpValue = 50

--==================================================
-- GUI
--==================================================
local gui = Instance.new("ScreenGui")
gui.Name = "MM2Hub"
gui.ResetOnSpawn = false
gui.Parent = lp.PlayerGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.4,0.45)
main.Position = UDim2.fromScale(0.3,0.25)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

--==================================================
-- BOTÃO FLUTUANTE
--==================================================
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.fromOffset(30,60)
toggleBtn.Position = UDim2.fromScale(0.02,0.4)
toggleBtn.Text = "MM2"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Active = true
toggleBtn.Draggable = true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

local menuVisible = true
toggleBtn.MouseButton1Click:Connect(function()
	menuVisible = not menuVisible
	main.Visible = menuVisible
end)

--==================================================
-- TABS
--==================================================
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.fromScale(1,0.12)
tabBar.BackgroundTransparency = 1

local pages = Instance.new("Folder", main)

local function newPage()
	local f = Instance.new("Frame", pages)
	f.Size = UDim2.fromScale(1,0.88)
	f.Position = UDim2.fromScale(0,0.12)
	f.Visible = false
	f.BackgroundTransparency = 1
	local l = Instance.new("UIListLayout", f)
	l.Padding = UDim.new(0,8)
	return f
end

local function tab(txt,page,pos)
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.fromScale(0.2,1)
	b.Position = UDim2.fromScale(pos,0)
	b.Text = txt
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(function()
		for _,p in pairs(pages:GetChildren()) do p.Visible=false end
		page.Visible = true
	end)
end

local Main = newPage()
local ESPPage = newPage()
local Player = newPage()
local Premium = newPage()
local Anim = newPage()

Main.Visible = true

tab("MENU",Main,0)
tab("ESP",ESPPage,0.2)
tab("JOGADOR",Player,0.4)
tab("⭐PREMIUM",Premium,0.6)
tab("ANIMAÇÕES",Anim,0.8)

--==================================================
-- UI HELPERS
--==================================================
local function Button(parent,text,cb)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.fromScale(0.95,0.13)
	b.Text = text
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(function() cb(b) end)
	return b
end

local function Input(parent,ph,cb)
	local box = Instance.new("TextBox", parent)
	box.Size = UDim2.fromScale(0.95,0.13)
	box.PlaceholderText = ph
	box.Text = ""
	box.TextScaled = true
	box.Font = Enum.Font.Gotham
	box.BackgroundColor3 = Color3.fromRGB(30,30,30)
	box.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", box)
	box.FocusLost:Connect(function()
		local v = tonumber(box.Text)
		if v then cb(v) end
	end)
end

--==================================================
-- AUTO FARM COINS
--==================================================
Button(Main,"AUTO FARM COINS: OFF",function(btn)

	AutoFarm = not AutoFarm
	btn.Text = "AUTO FARM COINS: "..(AutoFarm and "ON" or "OFF")

	if not AutoFarm and CurrentTween then
		CurrentTween:Cancel()
	end

end)

local function getCoins()

	local coins = {}

	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("TouchTransmitter") and v.Parent:IsA("BasePart") then
			table.insert(coins,v.Parent)
		end
	end

	return coins

end

task.spawn(function()

	while task.wait(0.6) do

		if AutoFarm and hrp then

			for _,coin in ipairs(getCoins()) do

				if not AutoFarm then break end

				local dist = (hrp.Position - coin.Position).Magnitude

				CurrentTween = TweenService:Create(
					hrp,
					TweenInfo.new(dist/21,Enum.EasingStyle.Linear),
					{CFrame = coin.CFrame + Vector3.new(0,2,0)}
				)

				CurrentTween:Play()
				CurrentTween.Completed:Wait()

			end
		end
	end
end)

--==================================================
-- ROLE DETECTION
--==================================================
local function getRole(plr)

	local bp = plr:FindFirstChild("Backpack")
	local ch = plr.Character

	if (bp and bp:FindFirstChild("Knife")) or (ch and ch:FindFirstChild("Knife")) then
		return "Murderer"
	end

	if (bp and bp:FindFirstChild("Gun")) or (ch and ch:FindFirstChild("Gun")) then
		return "Sheriff"
	end

	return "Innocent"

end

--==================================================
-- ESP
--==================================================
Button(ESPPage,"ESP NORMAL: OFF",function(btn)

	ESP = not ESP
	btn.Text = "ESP NORMAL: "..(ESP and "ON" or "OFF")

end)

Button(ESPPage,"ESP TEAM: OFF",function(btn)

	ESPTeams = not ESPTeams
	btn.Text = "ESP TEAM: "..(ESPTeams and "ON" or "OFF")

end)

task.spawn(function()

	while task.wait(0.4) do

		for _,plr in ipairs(Players:GetPlayers()) do

			if plr ~= lp and plr.Character then

				local h = plr.Character:FindFirstChild("MM2ESP")

				if ESP or ESPTeams then

					if not h then
						h = Instance.new("Highlight")
						h.Name = "MM2ESP"
						h.Parent = plr.Character
					end

					if ESPTeams then

						local role = getRole(plr)

						if role == "Murderer" then
							h.FillColor = Color3.fromRGB(255,0,0)

						elseif role == "Sheriff" then
							h.FillColor = Color3.fromRGB(0,170,255)

						else
							h.FillColor = Color3.fromRGB(0,255,0)
						end

					else
						h.FillColor = Color3.fromRGB(255,255,255)
					end

					h.OutlineColor = h.FillColor

				else

					if h then
						h:Destroy()
					end

				end
			end
		end
	end
end)

--==================================================
-- PLAYER
--==================================================
Input(Player,"SPEED",function(v) SpeedValue = v end)
Input(Player,"JUMP",function(v) JumpValue = v end)
Input(Player,"GRAVITY",function(v) workspace.Gravity = v end)

Button(Player,"FAKE SPEED GLITCH: OFF",function(btn)

	FakeSpeed = not FakeSpeed
	btn.Text = "FAKE SPEED GLITCH: "..(FakeSpeed and "ON" or "OFF")

end)

RunService.Heartbeat:Connect(function()

	if hum then
		hum.WalkSpeed = SpeedValue
		hum.JumpPower = JumpValue

		if FakeSpeed and hum.FloorMaterial == Enum.Material.Air then
			hum.WalkSpeed = 77
		end
	end

end)

--==================================================
-- AUTO GUN
--==================================================
Button(Premium,"AUTO GET GUN: OFF",function(btn)

	AutoGun = not AutoGun
	btn.Text = "AUTO GET GUN: "..(AutoGun and "ON" or "OFF")

end)

task.spawn(function()

	while task.wait(0.3) do

		if AutoGun and hrp then

			local gun = workspace:FindFirstChild("GunDrop",true)

			if gun then

				local save = hrp.CFrame

				hrp.CFrame = gun.CFrame + Vector3.new(0,2,0)

				task.wait(0.15)

				hrp.CFrame = save

			end
		end
	end
end)

--==================================================
-- AIM INSTANT
--==================================================
Button(Premium,"AIM INSTANT: OFF",function(btn)

	AimInstant = not AimInstant
	btn.Text = "AIM INSTANT: "..(AimInstant and "ON" or "OFF")

end)

RunService.RenderStepped:Connect(function()

	if not AimInstant then return end

	for _,plr in ipairs(Players:GetPlayers()) do

		if plr ~= lp and getRole(plr) == "Murderer" and plr.Character then

			local t = plr.Character:FindFirstChild("HumanoidRootPart")

			if t then
				cam.CFrame = CFrame.new(cam.CFrame.Position,t.Position)
			end

			break
		end
	end

end)

--==================================================
-- ANIMAÇÕES
--==================================================
local function setAnimation(idle,walk,run,jump,fall,climb)

	local animate = char:FindFirstChild("Animate")

	if animate then

		animate.idle.Animation1.AnimationId = "rbxassetid://"..idle
		animate.walk.WalkAnim.AnimationId = "rbxassetid://"..walk
		animate.run.RunAnim.AnimationId = "rbxassetid://"..run
		animate.jump.JumpAnim.AnimationId = "rbxassetid://"..jump
		animate.fall.FallAnim.AnimationId = "rbxassetid://"..fall
		animate.climb.ClimbAnim.AnimationId = "rbxassetid://"..climb

	end

end

Button(Anim,"ADIDAS",function()
	setAnimation(18537376492,18537392113,18537384940,18537380791,18537367238,18537363391)
end)

Button(Anim,"NINJA",function()
	setAnimation(656117400,656118341,656118852,656117878,656115606,656114359)
end)

Button(Anim,"LEVITATION",function()
	setAnimation(616006778,616013216,616010382,616008936,616005863,616003713)
end)

Button(Anim,"TOY",function()
	setAnimation(782841498,782842708,782843345,782847020,782846423,782843869)
end)

Button(Anim,"CARTOONY",function()
	setAnimation(742637544,742640026,742638842,742637942,742637151,742636889)
end)
