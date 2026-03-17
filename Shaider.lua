repeat task.wait() until game:IsLoaded()

local Lighting = game:GetService("Lighting")

-- Xóa sạch hiệu ứng cũ
for _,v in pairs(Lighting:GetChildren()) do
	if v:IsA("BloomEffect") 
	or v:IsA("ColorCorrectionEffect")
	or v:IsA("SunRaysEffect")
	or v:IsA("Sky")
	or v:IsA("Atmosphere") then
		v:Destroy()
	end
end

Lighting.ClockTime = 3
Lighting.Brightness = 3.5
Lighting.Ambient = Color3.fromRGB(150,150,180)
Lighting.OutdoorAmbient = Color3.fromRGB(160,160,200)

Lighting.EnvironmentDiffuseScale = 0.5
Lighting.EnvironmentSpecularScale = 0.5
Lighting.GlobalShadows = false -- bỏ bóng để sáng hơn

local sky = Instance.new("Sky")
sky.StarCount = 9000

sky.SkyboxBk = "rbxassetid://159454299"
sky.SkyboxDn = "rbxassetid://159454296"
sky.SkyboxFt = "rbxassetid://159454293"
sky.SkyboxLf = "rbxassetid://159454286"
sky.SkyboxRt = "rbxassetid://159454300"
sky.SkyboxUp = "rbxassetid://159454288"

sky.Parent = Lighting

local atmo = Instance.new("Atmosphere")
atmo.Density = 0.2
atmo.Offset = 0.1
atmo.Color = Color3.fromRGB(180,200,255)
atmo.Decay = Color3.fromRGB(100,120,180)
atmo.Glare = 0.2
atmo.Haze = 1
atmo.Parent = Lightin

local color = Instance.new("ColorCorrectionEffect")
color.Brightness = 0.1
color.Contrast = 0.35
color.Saturation = 0.1
color.TintColor = Color3.fromRGB(220,235,255)
color.Parent = Lighting

local bloom = Instance.new("BloomEffect")
bloom.Intensity = 0.5
bloom.Size = 45
bloom.Threshold = 1
bloom.Parent = Lighting

local sun = Instance.new("SunRaysEffect")
sun.Intensity = 0.05
sun.Spread = 0.2
sun.Parent = Lighting
