repeat task.wait() until game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MusicPC"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 230, 0, 120)
frame.Position = UDim2.new(0.5, -115, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

-- nhập ID
local box = Instance.new("TextBox")
box.Parent = frame
box.Size = UDim2.new(0, 190, 0, 30)
box.Position = UDim2.new(0, 20, 0, 10)
box.PlaceholderText = "Nhập Music ID..."
box.TextScaled = true

-- PLAY
local playBtn = Instance.new("TextButton")
playBtn.Parent = frame
playBtn.Size = UDim2.new(0, 80, 0, 30)
playBtn.Position = UDim2.new(0, 20, 0, 60)
playBtn.Text = "Play"

-- STOP
local stopBtn = Instance.new("TextButton")
stopBtn.Parent = frame
stopBtn.Size = UDim2.new(0, 80, 0, 30)
stopBtn.Position = UDim2.new(0, 130, 0, 60)
stopBtn.Text = "Stop"

-- sound
local sound = Instance.new("Sound")
sound.Volume = 2
sound.Looped = true
sound.Parent = workspace

-- lấy ID
local function getId(text)
	return text:match("%d+")
end

-- PLAY
local function playMusic()
	local id = getId(box.Text)
	if id then
		sound.SoundId = "rbxassetid://"..id
		sound:Play()
	end
end

-- STOP
local function stopMusic()
	sound:Stop()
end

playBtn.MouseButton1Click:Connect(playMusic)
stopBtn.MouseButton1Click:Connect(stopMusic)

-- 🎮 PHÍM TẮT PC
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end

	if input.KeyCode == Enum.KeyCode.P then
		playMusic()
	elseif input.KeyCode == Enum.KeyCode.O then
		stopMusic()
	end
end)
