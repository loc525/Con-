local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TSB Loc",
   LoadingTitle = "TSB Hub",
   LoadingSubtitle = "loc.lua",

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MyRayfield",
      FileName = "Config"
   }
})

-- MAIN TAB
local MainTab = Window:CreateTab("Main", 4483362458)

-- SPEED
local speed = 16
local speedEnabled = false

MainTab:CreateToggle({
   Name = "Enable Speed",
   CurrentValue = false,
   Callback = function(Value)
      speedEnabled = Value

      local player = game.Players.LocalPlayer
      local char = player.Character
      if char and char:FindFirstChild("Humanoid") then
         if not Value then
            char.Humanoid.WalkSpeed = 16
         end
      end
   end,
})

MainTab:CreateSlider({
   Name = "Speed Power",
   Range = {16, 500},
   Increment = 5,
   CurrentValue = 16,
   Callback = function(Value)
      speed = Value
   end,
})

game:GetService("RunService").RenderStepped:Connect(function()
   if speedEnabled then
      local player = game.Players.LocalPlayer
      local char = player.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.WalkSpeed = speed
      end
   end
end)

-- RESET SPEED
MainTab:CreateButton({
   Name = "Reset Speed",
   Callback = function()
      local player = game.Players.LocalPlayer
      local char = player.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.WalkSpeed = 16
      end
   end
})

-- FIX LAG
MainTab:CreateButton({
   Name = "Fix Lag",
   Callback = function()
      settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
   end
})

-- SCRIPTS TAB
local Tab = Window:CreateTab("Scripts", 4483362458)

-- AIMLOCK
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local Aimlock = false
local Target = nil

Tab:CreateToggle({
   Name = "Aimlock ON / OFF",
   CurrentValue = false,
   Callback = function(Value)
      Aimlock = Value
   end,
})

Mouse.Button1Down:Connect(function()
   if Aimlock and Mouse.Target then
      local player = Players:GetPlayerFromCharacter(Mouse.Target.Parent)
      if player and player ~= LocalPlayer then
         Target = player
      end
   end
end)

RunService.RenderStepped:Connect(function()
   if Aimlock and Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
      Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.HumanoidRootPart.Position)
   end
end)

-- TRASH SCRIPT
Tab:CreateButton({
   Name = "Trash 2",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/main/Trashcan%20Man"))()
   end
})

-- KIBA SCRIPT
Tab:CreateButton({
   Name = "Kiba Tech 3",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/yqantg-pixel/Find/main/Protected_1593573630798166.lua.txt"))()
   end
})

-- AUTO FARM
Tab:CreateButton({
   Name = "Auto Farm",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/minhnhatdepzai8-cloud/FARM-KILL/main/TSB"))()
   end
})

-- FE TROLLING
Tab:CreateButton({
   Name = "FE Trolling Player",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/3LD4D0/FE-TROLLING-PLAYER-R6-R15/6eff8792afed57458d5114478b453a6f6bce5799/Fe%20trolling%20Player%20R6%20AND%20R15"))()
   end
})
