-- NerphHex Hub

local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("NerphHex Hub Loaded")

-- Notificação
pcall(function()
    game.StarterGui:SetCore("SendNotification",{
        Title = "NerphHex Hub",
        Text = "Carregado com sucesso!",
        Duration = 5
    })
end)

-- Menu simples
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Button = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,200,0,100)
Frame.Position = UDim2.new(0.5,-100,0.5,-50)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

Button.Parent = Frame
Button.Size = UDim2.new(1,0,1,0)
Button.Text = "Load Script"
Button.BackgroundColor3 = Color3.fromRGB(40,40,40)
Button.TextColor3 = Color3.fromRGB(0,255,150)

Button.MouseButton1Click:Connect(function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/valentapolinario0-dev/NerphHex/main/hub.lua"))()
end)
