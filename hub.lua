-- Hub Script using WindUI
-- Load WindUI Library
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Create Window
local Window = WindUI:CreateWindow({
    Title = "My Hub",
    Author = "Author",
    Icon = "home",
    Width = 480,
    Theme = "Dark",
    Transparent = false,
    Acrylic = false,
    Debug = false,
})

-- ============================
-- TAB: Combat
-- ============================
local CombatTab = Window:AddTab({ Title = "Combat", Icon = "sword" })

local CombatSection = CombatTab:AddSection({ Title = "Combat Options" })

CombatSection:AddToggle({
    Title = "Auto Attack",
    Desc = "Automatically sends hit requests",
    Default = false,
    Callback = function(Value)
        if Value then
            -- Start auto attack loop
            _G.AutoAttack = task.spawn(function()
                while _G.AutoAttackEnabled do
                    pcall(function()
                        game:GetService("ReplicatedStorage").CombatSystem.Remotes.RequestHit:FireServer()
                    end)
                    task.wait(0.1)
                end
            end)
            _G.AutoAttackEnabled = true
        else
            _G.AutoAttackEnabled = false
        end
    end,
})

CombatSection:AddButton({
    Title = "Fire Ability",
    Desc = "Fires ability request to server",
    Callback = function()
        pcall(function()
            local args = { [1] = 1 }
            game:GetService("ReplicatedStorage").AbilitySystem.Remotes.RequestAbility:FireServer(unpack(args))
        end)
    end,
})

CombatSection:AddSlider({
    Title = "Ability Index",
    Desc = "Which ability to use",
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        _G.AbilityIndex = Value
    end,
})

-- ============================
-- TAB: Player
-- ============================
local PlayerTab = Window:AddTab({ Title = "Player", Icon = "user" })

local MovementSection = PlayerTab:AddSection({ Title = "Movement" })

MovementSection:AddToggle({
    Title = "Speed Hack",
    Desc = "Increases walk speed",
    Default = false,
    Callback = function(Value)
        local Player = game:GetService("Players").LocalPlayer
        local Char = Player.Character or Player.CharacterAdded:Wait()
        if Value then
            Char.Humanoid.WalkSpeed = _G.SpeedValue or 50
        else
            Char.Humanoid.WalkSpeed = 16
        end
    end,
})

MovementSection:AddSlider({
    Title = "Walk Speed",
    Desc = "Set custom walk speed",
    Default = 50,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        _G.SpeedValue = Value
    end,
})

MovementSection:AddToggle({
    Title = "Infinite Jump",
    Desc = "Allows jumping in the air",
    Default = false,
    Callback = function(Value)
        _G.InfiniteJump = Value
        if Value then
            _G.InfiniteJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfiniteJump then
                    local Player = game:GetService("Players").LocalPlayer
                    local Char = Player.Character
                    if Char then
                        Char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            if _G.InfiniteJumpConn then
                _G.InfiniteJumpConn:Disconnect()
            end
        end
    end,
})

-- ============================
-- TAB: Misc
-- ============================
local MiscTab = Window:AddTab({ Title = "Misc", Icon = "settings" })

local MiscSection = MiscTab:AddSection({ Title = "Miscellaneous" })

MiscSection:AddButton({
    Title = "Rejoin",
    Desc = "Rejoins the current server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        TeleportService:Teleport(PlaceId)
    end,
})

MiscSection:AddButton({
    Title = "Copy UserID",
    Desc = "Copies your UserID to clipboard",
    Callback = function()
        local Player = game:GetService("Players").LocalPlayer
        setclipboard(tostring(Player.UserId))
        WindUI:Notify({
            Title = "Copied!",
            Content = "UserID copied to clipboard.",
            Duration = 3,
        })
    end,
})

-- Notification on load
WindUI:Notify({
    Title = "Hub Loaded",
    Content = "My Hub has been loaded successfully!",
    Duration = 5,
})
