repeat task.wait() until game.Players.LocalPlayer.Character

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local enabled = false
local running = false
local depth = -3

local lastTarget = nil -- lưu target

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0,120,0,40)
button.Position = UDim2.new(0,20,0,200)
button.Text = "OFF"
button.BackgroundColor3 = Color3.fromRGB(170,0,0)

-- tìm người gần nhất
local function getClosest()
	local char = player.Character
	if not char then return end

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

-- tele ra trước mặt
local function teleportFront(target)
	if not target or not target.Character then return end

	local root = player.Character:FindFirstChild("HumanoidRootPart")
	local troot = target.Character:FindFirstChild("HumanoidRootPart")

	if root and troot then
		local forward = troot.CFrame.LookVector * 4 -- trước mặt 4 studs

		root.CFrame = CFrame.new(
			troot.Position + forward
		)
	end
end

-- chạy script
local function runScript()
	if running then return end
	running = true

	local char = player.Character
	local root = char:FindFirstChild("HumanoidRootPart")

	local target = getClosest()
	lastTarget = target -- lưu lại

	if target and target.Character then
		local troot = target.Character:FindFirstChild("HumanoidRootPart")

		if root and troot then
			local start = tick()

			while tick() - start < 1 do
				local pos = Vector3.new(
					troot.Position.X,
					troot.Position.Y + depth,
					troot.Position.Z
				)

				root.CFrame =
					CFrame.new(pos) *
					CFrame.Angles(math.rad(90),0,0)

				dash()
				RunService.Heartbeat:Wait()
			end
		end
	end

	-- chống fling
	if root then
		antiFling(root)
	end

	-- 🔥 tele ra trước mặt
	task.wait(0.1)
	teleportFront(lastTarget)

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

-- GUI
button.MouseButton1Click:Connect(toggle)

-- phím E
UIS.InputBegan:Connect(function(input,gp)
	if gp then return end

	if input.KeyCode == Enum.KeyCode.E then
		toggle()
	end
end)
