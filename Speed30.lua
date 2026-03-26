local UIS = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", UIS)
local Toggle = Instance.new("TextButton", Frame)

Frame.Size = UDim2.new(0,150,0,100)
Frame.Position = UDim2.new(0.1,0,0.3,0)

Toggle.Size = UDim2.new(1,0,1,0)
Toggle.Text = "Speed: OFF"

local on = false

Toggle.MouseButton1Click:Connect(function()
    on = not on
    if on then
        Toggle.Text = "Speed: ON"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 80
    else
        Toggle.Text = "Speed: OFF"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)
