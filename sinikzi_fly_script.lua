if game.CoreGui:FindFirstChild("Sinikzi Fly") then
	game.CoreGui:FindFirstChild("Sinikzi Fly"):Destroy()
end

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 250
local guiVisible = true
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Sinikzi Fly"

-- Menü Frame Ayarları
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

-- Başlık Etiketi
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Sinikzi Fly"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(0, 128, 255)

-- Durum Etiketi
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 30)
statusLabel.Text = "Durum: Kapalı"
statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
statusLabel.BackgroundTransparency = 1

-- Speed Etiketi ve Box
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0, 80, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 60)
speedLabel.Text = "Hız:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BackgroundTransparency = 1

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 80, 0, 30)
speedBox.Position = UDim2.new(0, 100, 0, 60)
speedBox.Text = "250"
speedBox.PlaceholderText = "Hız"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Enable Button
local enableBtn = Instance.new("TextButton", frame)
enableBtn.Size = UDim2.new(0, 80, 0, 30)
enableBtn.Position = UDim2.new(0, 10, 0, 100)
enableBtn.Text = "Aktif Et"
enableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
enableBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Yapan Etiketi
local creatorLabel = Instance.new("TextLabel", frame)
creatorLabel.Size = UDim2.new(1, 0, 0, 20)
creatorLabel.Position = UDim2.new(0, 0, 0, 130)
creatorLabel.Text = "Yapan: Sinikzi"
creatorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
creatorLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
creatorLabel.TextXAlignment = Enum.TextXAlignment.Left
creatorLabel.TextYAlignment = Enum.TextYAlignment.Center

-- Youtube Etiketi
local youtubeLabel = Instance.new("TextLabel", frame)
youtubeLabel.Size = UDim2.new(1, 0, 0, 20)
youtubeLabel.Position = UDim2.new(0, 0, 0, 150)
youtubeLabel.Text = "Youtube: https://www.youtube.com/@sinikzi"
youtubeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
youtubeLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
youtubeLabel.TextXAlignment = Enum.TextXAlignment.Left
youtubeLabel.TextYAlignment = Enum.TextYAlignment.Center

local bodyGyro, bodyVelocity
local rsConn

function startFly()
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
	if rsConn then rsConn:Disconnect() end

	flying = true
	statusLabel.Text = "Durum: Açık"
	statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

	bodyGyro = Instance.new("BodyGyro", hrp)
	bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	bodyGyro.P = 100000
	bodyGyro.CFrame = hrp.CFrame

	bodyVelocity = Instance.new("BodyVelocity", hrp)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)

	rsConn = game:GetService("RunService").RenderStepped:Connect(function()
		if not flying then return end
		local camCF = workspace.CurrentCamera.CFrame
		bodyGyro.CFrame = camCF
		local moveVec = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
		if moveVec.Magnitude > 0 then
			bodyVelocity.Velocity = moveVec.Unit * speed
		else
			bodyVelocity.Velocity = Vector3.zero
		end
		speed = tonumber(speedBox.Text) or 250
	end)
end

function stopFly()
	flying = false
	statusLabel.Text = "Durum: Kapalı"
	statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
	if rsConn then rsConn:Disconnect() end
end

-- Enable Button'a Tıklama Olayı
enableBtn.MouseButton1Click:Connect(function()
	speed = tonumber(speedBox.Text) or 250
	if flying then stopFly() else startFly() end
end)

-- Sol Shift ile GUI görünürlüğünü aç/kapat
UserInputService.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		guiVisible = not guiVisible
		gui.Enabled = guiVisible
	end
end)

-- Karakter eklendiğinde uçuşu başlat
player.CharacterAdded:Connect(function(newChar)
	wait(1)
	char = newChar
	hrp = char:WaitForChild("HumanoidRootPart")
	if flying then startFly() end
end)