-- FPS Boost Script for Roblox
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

-- Function to reduce the number of physics calculations
local function optimizePhysics()
    -- Reduce physics accuracy for non-local players to save resources
    game:GetService("PhysicsService"):SetPartCollisionGroup("Default", "NoCollide")
    
    -- Reduce frequency of physics updates
    RunService.Heartbeat:Connect(function()
        if game:GetService("PhysicsService") then
            game:GetService("PhysicsService"):SetPartCollisionGroup("Default", "NoCollide")
        end
    end)
end

-- Function to disable unnecessary features
local function disableUnnecessaryFeatures()
    -- Disable some built-in effects
    Lighting.GlobalShadows = false  -- Disable global shadows
    Lighting.FogEnd = 1000  -- Limit the range of the fog
    Lighting.Brightness = 1  -- Set lower brightness
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)  -- Simpler ambient light
    
    -- Limit reflections
    game:GetService("Lighting").ReflectionQuality = Enum.ReflectionQuality.Low
end

-- Function to optimize models and game objects
local function optimizeModels()
    -- Disable unnecessary particle emitters
    local function disableParticles(obj)
        if obj:IsA("ParticleEmitter") then
            obj.Enabled = false
        end
        for _, child in pairs(obj:GetChildren()) do
            disableParticles(child)
        end
    end

    -- Disable particles in the entire game
    for _, obj in pairs(workspace:GetDescendants()) do
        disableParticles(obj)
    end
end

-- Function to disable unused decals and textures
local function disableTexturesAndDecals()
    -- Remove all decals and textures
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        end
    end
end

-- Function to optimize lights in the game
local function optimizeLights()
    -- Disable dynamic lights (including point lights, spot lights, etc.)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        end
    end
end

-- Function to reduce the number of renderable parts
local function limitRenderDistance()
    -- Make the fog end closer, limiting the render distance
    Lighting.FogEnd = 1000  -- Only render objects within a certain distance
end

-- Function to reduce camera effects and background elements
local function reduceCameraEffects()
    -- Turn off blur and other camera effects
    local camera = game.Workspace.CurrentCamera
    camera.FieldOfView = 70  -- Lower field of view
    camera.CameraType = Enum.CameraType.Custom
end

-- Function to reduce the number of complex models
local function limitComplexModels()
    -- Disable models that are far away from the player
    local function cleanFarModels()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.PrimaryPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 1000 then
                obj:Destroy()  -- Remove models far from the player
            end
        end
    end

    -- Run the cleaning function periodically
    RunService.Heartbeat:Connect(cleanFarModels)
end

-- Function to apply all optimizations
local function applyFPSBoost()
    -- Apply optimizations
    optimizePhysics()
    disableUnnecessaryFeatures()
    optimizeModels()
    disableTexturesAndDecals()
    optimizeLights()
    limitRenderDistance()
    reduceCameraEffects()
    limitComplexModels()
end