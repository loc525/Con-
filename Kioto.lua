repeat task.wait() until game.Players.LocalPlayer.Character

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local enabled = false
local running = false
local depth = -3

-- 🌈 highlight
local highlight = Instance.new("Highlight")
highlight.FillTransparency = 0.3
highlight.OutlineTransparency = 0
highlight.Parent = game.CoreGui

local hue = 0

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "SkillUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0,120,0,40)
button.Position = UDim2.new(0,20,0,200)
button.Text = "OFF"
button.TextColor3 = Color3.new(1,1,1)
button.BackgroundColor3 = Color3.fromRGB(170,0,0)

-- tìm player gần nhất
local function getClosest()
	local char = player.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local closest, dist = nil, math.huge

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

-- dash
local function dash()
	VIM:SendKeyEvent(true,"Q",false,game)
	task.wait()
	VIM:SendKeyEvent(false,"Q",false,game)
end

-- chống fling
local function antiFling(root)
	root.AssemblyLinearVelocity = Vector3.new(0,0,0)
	root.AssemblyAngularVelocity = Vector3.new(0,0,0)
end

-- tele trước mặt
local function teleportFront(target)
	if not target or not target.Character then return end

	local root = player.Character:FindFirstChild("HumanoidRootPart")
	local troot = target.Character:FindFirstChild("HumanoidRootPart")

	if root and troot then
		local forward = troot.CFrame.LookVector * 4
		root.CFrame = CFrame.new(troot.Position + forward)
	end
end

-- skill
local function runScript()
	if running then return end
	running = true

	local char = player.Character
	local root = char:FindFirstChild("HumanoidRootPart")

	local target = getClosest()

	if target and target.Character then
		local troot = target.Character:FindFirstChild("HumanoidRootPart")

		if root and troot then
			local start = tick()

			while tick() - start < 1 do
				root.CFrame =
					CFrame.new(
						troot.Position.X,
						troot.Position.Y + depth,
						troot.Position.Z
					) *
					CFrame.Angles(math.rad(90),0,0)

				dash()
				RunService.Heartbeat:Wait()
			end

			task.wait(0.1)
			teleportFront(target)
		end
	end

	if root then
		antiFling(root)
	end

	button.Text = "COOLDOWN"
	button.BackgroundColor3 = Color3.fromRGB(255,170,0)

	task.wait(2)

	button.Text = "OFF"
	button.BackgroundColor3 = Color3.fromRGB(170,0,0)

	running = false
	enabled = false
end

-- toggle
local function toggle()
	if running then return end

	enabled = not enabled

	button.Text = enabled and "ON" or "OFF"
	button.BackgroundColor3 = enabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)

	if enabled then
		runScript()
	end
end

-- 🌈 highlight realtime
RunService.RenderStepped:Connect(function()
	local target = getClosest()

	if target and target.Character then
		highlight.Adornee = target.Character

		hue = hue + 0.01
		if hue > 1 then hue = 0 end

		local color = Color3.fromHSV(hue,1,1)
		highlight.FillColor = color
		highlight.OutlineColor = color
	else
		highlight.Adornee = nil
	end
end)

-- UI click
button.MouseButton1Click:Connect(toggle)

-- phím E
UIS.InputBegan:Connect(function(input,gp)
	if not gp and input.KeyCode == Enum.KeyCode.E then
		toggle()
	end
end)
