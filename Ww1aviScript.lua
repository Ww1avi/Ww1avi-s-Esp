print("Script Loaded")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ww2avi's Script"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Name = "ToggleButton"
Button.Size = UDim2.new(0, 200, 0, 50)
Button.Position = UDim2.new(0.5, -100, 0.9, -25)
Button.Text = "Activate"
Button.BackgroundColor3 = Color3.new(0, 0.6, 0.8)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.TextScaled = true
Button.Parent = ScreenGui

-- Variables for activation toggle
local isActive = false
local connections = {}

-- Function to highlight players
local function highlightPlayer(player)
    local function onCharacterAdded(character)
        local rootPart = character:WaitForChild("HumanoidRootPart", 10)
        if not rootPart then return end

        -- Create a BillboardGui
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerHighlight"
        billboard.Adornee = rootPart
        billboard.Size = UDim2.new(4, 0, 1, 0) -- Adjust size
        billboard.StudsOffset = Vector3.new(0, 3, 0) -- Adjust height
        billboard.AlwaysOnTop = true

        -- Add a TextLabel
        local textLabel = Instance.new("TextLabel", billboard)
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name
        textLabel.TextColor3 = Color3.new(1, 1, 0) -- Yellow color
        textLabel.TextScaled = true

        -- Parent the BillboardGui to the character
        billboard.Parent = rootPart
    end

    -- Connect to character loading
    table.insert(connections, player.CharacterAdded:Connect(onCharacterAdded))
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- Enable/Disable the script
local function toggleScript()
    isActive = not isActive
    Button.Text = isActive and "Deactivate" or "Activate"

    if isActive then
        -- Highlight existing players
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                highlightPlayer(player)
            end
        end

        -- Listen for new players joining
        table.insert(connections, Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                highlightPlayer(player)
            end
        end))
    else
        -- Disable and clean up
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        connections = {}

        -- Remove highlights
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = player.Character.HumanoidRootPart:FindFirstChild("PlayerHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

-- Connect button click to toggle function
Button.MouseButton1Click:Connect(toggleScript)
