--// SETTINGS
local radius = 10
local speed = 2
local MAX_SPEED = 50

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

--// VARIABLES
local spinning = false
local center = nil
local angle = 0

--// UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true

local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(0, 180, 0, 40)
Toggle.Position = UDim2.new(0, 10, 0, 10)
Toggle.Text = "OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(200,50,50)

local RadiusBox = Instance.new("TextBox", Frame)
RadiusBox.Size = UDim2.new(0, 180, 0, 30)
RadiusBox.Position = UDim2.new(0, 10, 0, 60)
RadiusBox.PlaceholderText = "Radius (vd: 10)"

local SpeedBox = Instance.new("TextBox", Frame)
SpeedBox.Size = UDim2.new(0, 180, 0, 30)
SpeedBox.Position = UDim2.new(0, 10, 0, 100)
SpeedBox.PlaceholderText = "Speed (max 50)"

--// DRAG UI (FIX MOBILE + PC)
local dragging = false
local dragStart, startPos

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch 
	or input.UserInputType == Enum.UserInputType.MouseButton1 then
		
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch 
	or input.UserInputType == Enum.UserInputType.MouseMovement) then
		
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

--// TOGGLE
Toggle.MouseButton1Click:Connect(function()
    spinning = not spinning

    if spinning then
        Toggle.Text = "ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(50,200,50)

        center = hrp.Position
        angle = 0

        -- khóa nhân vật
        hrp.Anchored = true
        humanoid.AutoRotate = false

        if tonumber(RadiusBox.Text) then
            radius = tonumber(RadiusBox.Text)
        end

        if tonumber(SpeedBox.Text) then
            speed = math.clamp(tonumber(SpeedBox.Text), 0, MAX_SPEED)
        end

    else
        Toggle.Text = "OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(200,50,50)

        hrp.Anchored = false
        humanoid.AutoRotate = true
    end
end)

--// LOOP
RunService.RenderStepped:Connect(function(dt)
    if spinning and center then
        angle = angle + speed * dt * 5

        local offset = Vector3.new(
            math.cos(angle) * radius,
            0,
            math.sin(angle) * radius
        )

        local newPos = center + offset
        hrp.CFrame = CFrame.new(newPos, center)
    end
end)
