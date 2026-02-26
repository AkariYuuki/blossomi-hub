-- Blossomi Hub
-- WindUI Library
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- ============================
-- Create Window
-- ============================
local Window = WindUI:CreateWindow({
    Title = "Blossomi Hub",
    Author = "blossomi",
    Icon = "flower-2",
    Width = 480,
    Theme = "Dark",
    Transparent = false,
    Acrylic = false,
    Debug = false,
    Folder = "BlossomiHub",
})

-- ============================
-- TAB: Combat
-- ============================
local CombatTab = Window:AddTab({ Title = "Combat", Icon = "sword" })

local AttackSection = CombatTab:AddSection({ Title = "Attacks" })

local AbilityIndex = 1

AttackSection:AddSlider({
    Title = "Ability Index",
    Desc = "Which ability slot to fire",
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        AbilityIndex = Value
    end,
})

AttackSection:AddButton({
    Title = "Fire Ability",
    Desc = "Fires your selected ability",
    Callback = function()
        pcall(function()
            local args = { [1] = AbilityIndex }
            game:GetService("ReplicatedStorage").AbilitySystem.Remotes.RequestAbility:FireServer(unpack(args))
        end)
    end,
})

AttackSection:AddButton({
    Title = "Request Hit",
    Desc = "Sends a hit request to the server",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").CombatSystem.Remotes.RequestHit:FireServer()
        end)
    end,
})

local AutoSection = CombatTab:AddSection({ Title = "Automation" })

AutoSection:AddToggle({
    Title = "Auto Hit",
    Desc = "Repeatedly sends hit requests",
    Default = false,
    Callback = function(Value)
        _G.AutoHitEnabled = Value
        if Value then
            task.spawn(function()
                while _G.AutoHitEnabled do
                    pcall(function()
                        game:GetService("ReplicatedStorage").CombatSystem.Remotes.RequestHit:FireServer()
                    end)
                    task.wait(0.15)
                end
            end)
        end
    end,
})

AutoSection:AddToggle({
    Title = "Auto Ability",
    Desc = "Repeatedly fires selected ability",
    Default = false,
    Callback = function(Value)
        _G.AutoAbilityEnabled = Value
        if Value then
            task.spawn(function()
                while _G.AutoAbilityEnabled do
                    pcall(function()
                        local args = { [1] = AbilityIndex }
                        game:GetService("ReplicatedStorage").AbilitySystem.Remotes.RequestAbility:FireServer(unpack(args))
                    end)
                    task.wait(0.2)
                end
            end)
        end
    end,
})

-- ============================
-- TAB: Player
-- ============================
local PlayerTab = Window:AddTab({ Title = "Player", Icon = "user" })

local MovementSection = PlayerTab:AddSection({ Title = "Movement" })

local SpeedValue = 50
local JumpConn = nil

MovementSection:AddSlider({
    Title = "Walk Speed",
    Desc = "Set your walk speed",
    Default = 50,
    Min = 16,
    Max = 250,
    Rounding = 0,
    Callback = function(Value)
        SpeedValue = Value
    end,
})

MovementSection:AddToggle({
    Title = "Speed Hack",
    Desc = "Apply custom walk speed",
    Default = false,
    Callback = function(Value)
        local Char = game:GetService("Players").LocalPlayer.Character
        if Char and Char:FindFirstChild("Humanoid") then
            Char.Humanoid.WalkSpeed = Value and SpeedValue or 16
        end
    end,
})

MovementSection:AddToggle({
    Title = "Infinite Jump",
    Desc = "Jump endlessly in the air",
    Default = false,
    Callback = function(Value)
        if Value then
            JumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                local Char = game:GetService("Players").LocalPlayer.Character
                if Char and Char:FindFirstChild("Humanoid") then
                    Char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if JumpConn then
                JumpConn:Disconnect()
                JumpConn = nil
            end
        end
    end,
})

MovementSection:AddSlider({
    Title = "Jump Power",
    Desc = "Set your jump height",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        local Char = game:GetService("Players").LocalPlayer.Character
        if Char and Char:FindFirstChild("Humanoid") then
            Char.Humanoid.JumpPower = Value
        end
    end,
})

-- ============================
-- TAB: Misc
-- ============================
local MiscTab = Window:AddTab({ Title = "Misc", Icon = "sparkles" })

local MiscSection = MiscTab:AddSection({ Title = "Utilities" })

MiscSection:AddButton({
    Title = "Rejoin",
    Desc = "Rejoin the current game server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end,
})

MiscSection:AddButton({
    Title = "Copy UserID",
    Desc = "Copies your UserID to clipboard",
    Callback = function()
        setclipboard(tostring(game:GetService("Players").LocalPlayer.UserId))
        WindUI:Notify({
            Title = "Blossomi Hub",
            Content = "UserID copied to clipboard!",
            Duration = 3,
        })
    end,
})

MiscSection:AddButton({
    Title = "Reset Character",
    Desc = "Kills and resets your character",
    Callback = function()
        local Char = game:GetService("Players").LocalPlayer.Character
        if Char and Char:FindFirstChild("Humanoid") then
            Char.Humanoid.Health = 0
        end
    end,
})

-- ============================
-- Loaded Notification
-- ============================
WindUI:Notify({
    Title = "Blossomi Hub",
    Content = "Loaded successfully! Enjoy~",
    Duration = 5,
})
