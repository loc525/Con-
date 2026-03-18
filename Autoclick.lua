repeat task.wait() until game.Players.LocalPlayer

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local clicking = false
local delay = 0.05 -- tốc độ click (càng nhỏ càng nhanh)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoClickUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0, 20, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

-- ON/OFF
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0, 180, 0, 40)
toggle.Position = UDim2.new(0, 20, 0, 10)
toggle.Text = "OFF"
toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)

-- SPEED BOX
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 180, 0, 30)
speedBox.Position = UDim2.new(0, 20, 0, 60)
speedBox.PlaceholderText = "Delay (vd: 0.05)"
speedBox.Text = tostring(delay)

-- INFO
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(0, 180, 0, 20)
info.Position = UDim2.new(0, 20, 0, 100)
info.Text = "Phím T bật/tắt"
info.TextColor3 = Color3.fromRGB(255,255,255)
info.BackgroundTransparency = 1
info.TextScaled = true

-- cập nhật tốc độ
speedBox.FocusLost:Connect(function()
	local num = tonumber(speedBox.Text)
	if num then
		delay = math.clamp(num, 0.01, 1)
	end
end)

-- auto click loop
task.spawn(function()
	while true do
		if clicking then
			VIM:SendMouseButtonEvent(0,0,0,true,game,0)
			VIM:SendMouseButtonEvent(0,0,0,false,game,0)
		end
		task.wait(delay)
	end
end)

-- toggle
local function setState(state)
	clicking = state
	toggle.Text = state and "ON" or "OFF"
	toggle.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
end

toggle.MouseButton1Click:Connect(function()
	setState(not clicking)
end)

-- phím T
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.T then
		setState(not clicking)
	end
end)
