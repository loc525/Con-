local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

player.CharacterAdded:Connect(function(c)
	char = c
end)

local cooldown = false
local depth = -2.5

-- tìm player gần nhất
local function getClosest()

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local closest
	local dist = math.huge

	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then

			local troot = plr.Character:FindFirstChild("HumanoidRootPart")

			if troot then
				local d = (root.Position - troot.Position).Magnitude

				if d < dist then
					dist = d
					closest = plr
				end
			end
		end
	end

	return closest
end


-- countdown
local function countdown()

	local head = char:FindFirstChild("Head")
	if not head then return end

	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.new(0,120,0,60)
	gui.StudsOffset = Vector3.new(0,3,0)
	gui.AlwaysOnTop = true
	gui.Parent = head

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1,0,1,0)
	text.BackgroundTransparency = 1
	text.TextScaled = true
	text.TextColor3 = Color3.new(1,0,0)
	text.Parent = gui

	for i = 2,0,-1 do
		text.Text = tostring(i)
		task.wait(1)
	end

	gui:Destroy()
	cooldown = false

end


local function runScript()

	if cooldown then return end
	cooldown = true

	local start = tick()

	local conn
	conn = RunService.Heartbeat:Connect(function()

		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local target = getClosest()

		if target and target.Character then

			local troot = target.Character:FindFirstChild("HumanoidRootPart")

			if troot then

				root.CFrame =
					CFrame.new(
						troot.Position.X,
						troot.Position.Y + depth,
						troot.Position.Z
					) *
					CFrame.Angles(math.rad(90),0,0)

			end
		end

		if tick() - start > 1.5 then
			conn:Disconnect()
			task.spawn(countdown)
		end

	end)

end


-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,120,0,60)
frame.Position = UDim2.new(0,100,0,200)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local btn = Instance.new("TextButton")
btn.Parent = frame
btn.Size = UDim2.new(1,-10,0,30)
btn.Position = UDim2.new(0,5,0,15)
btn.Text = "RUN"
btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
btn.TextColor3 = Color3.new(1,1,1)

btn.MouseButton1Click:Connect(runScript)
