local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/sigmaboyozz/Traianhsang/refs/heads/main/Orion_Red.lua"))()

-- === TẠO CỬA SỔ ===
local Window = OrionLib:MakeWindow({
    Name = "Dragon Blox Full 2 V1.11",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "DragonBloxFull2_AutoSave",
    ConfigFile = "MainConfig"
})

local Tab = Window:MakeTab({
    Name = "Smart+Anti Band",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Tab1 = Window:MakeTab({
    Name = "Auto Farm👑",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Tab2 = Window:MakeTab({
    Name = "Dungeon",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Tab3 = Window:MakeTab({
    Name = "Auto Skill",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Tab4 = Window:MakeTab({
    Name = "Anti lag",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})


-- =========================================================
-- AUTO SET BOSS - STABLE / AUTO RESTART / AUTO SAVE
-- =========================================================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local BossFolder = workspace:WaitForChild("World Mobs"):WaitForChild("Boss Mobs")

local TweenSpeed = 200

local AutoMeta = false
local AutoPainsHurts = false
local AutoZero = false

local MetaTween = nil
local PainsHurtsTween = nil
local ZeroTween = nil

local MetaRunId = 0
local PainsHurtsRunId = 0
local ZeroRunId = 0

-- =========================================================
-- NÚT Ở TRÊN
-- =========================================================

Tab1:AddToggle({
    Name = "Auto set Meta",
    Default = false,
    Save = true,
    Flag = "AutoMeta",
    Callback = function(Value)
        AutoMeta = Value
        MetaRunId += 1

        if not Value and MetaTween then
            pcall(function()
                MetaTween:Cancel()
            end)
            MetaTween = nil
        end

        if Value then
            local MyRun = MetaRunId

            task.spawn(function()
                while AutoMeta and MyRun == MetaRunId do
                    local Success, Err = pcall(function()
                        -- META CHROMEST -> META COOLEST -> META AMYTHEST
                        local BossData = {
                            {
                                Name = "Meta Chromest",
                                Position = CFrame.new(
                                    -2949.98657, 44.359993, 113.719284,
                                    1, 0, 0, 0, 1, 0, 0, 0, 1
                                )
                            },
                            {
                                Name = "Meta Coolest",
                                Position = CFrame.new(
                                    -1997.33386, 80.0019531, -2640.44287,
                                    1, 0, 0, 0, 1, 0, 0, 0, 1
                                )
                            },
                            {
                                Name = "Meta Amythest",
                                Position = CFrame.new(
                                    1344.54321, 75.0019531, -2866.45361,
                                    1, 0, 0, 0, 1, 0, 0, 0, 1
                                )
                            }
                        }

                        local CurrentIndex = 1

                        local function GetAliveRoot()
                            while AutoMeta and MyRun == MetaRunId do
                                local Character = Player.Character
                                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                                local Root = Character and Character:FindFirstChild("HumanoidRootPart")

                                if Humanoid and Root and Humanoid.Health > 0 and Root.Parent then
                                    return Root
                                end

                                task.wait(0.5)
                            end
                        end

                        local function MoveTo(Target)
                            while AutoMeta and MyRun == MetaRunId do
                                local Root = GetAliveRoot()
                                if not Root then return false end

                                local Distance = (Root.Position - Target.Position).Magnitude
                                if Distance <= 3 then
                                    return true
                                end

                                local Tween = TweenService:Create(
                                    Root,
                                    TweenInfo.new(
                                        math.max(Distance / TweenSpeed, 0.05),
                                        Enum.EasingStyle.Linear
                                    ),
                                    {CFrame = Target}
                                )

                                MetaTween = Tween
                                Tween:Play()

                                while AutoMeta
                                    and MyRun == MetaRunId
                                    and Root.Parent
                                    and Player.Character == Root.Parent
                                    and Tween.PlaybackState == Enum.PlaybackState.Playing do
                                    task.wait(0.1)
                                end

                                pcall(function()
                                    Tween:Cancel()
                                end)

                                if not AutoMeta or MyRun ~= MetaRunId then
                                    return false
                                end

                                -- reset hoặc bị hủy tween thì tự lấy Root mới và tween lại
                                task.wait(0.2)
                            end

                            return false
                        end

                        while AutoMeta and MyRun == MetaRunId do
                            local Data = BossData[CurrentIndex]

                            if not MoveTo(Data.Position) then
                                break
                            end

                            -- Chờ boss spawn và chết, không bao giờ tự dừng
                            local BossWasAlive = false

                            while AutoMeta and MyRun == MetaRunId do
                                local Boss = BossFolder:FindFirstChild(Data.Name)
                                local Humanoid = Boss and Boss:FindFirstChildOfClass("Humanoid")

                                if Boss and Humanoid then
                                    if Humanoid.Health > 0 then
                                        BossWasAlive = true
                                    elseif BossWasAlive or Humanoid.Health <= 0 then
                                        break
                                    end
                                end

                                task.wait(0.3)
                            end

                            if not AutoMeta or MyRun ~= MetaRunId then
                                break
                            end

                            task.wait(2)

                            if AutoMeta and MyRun == MetaRunId then
                                CurrentIndex += 1
                                if CurrentIndex > #BossData then
                                    CurrentIndex = 1
                                end
                            end
                        end
                    end)

                    if not Success then
                        warn("Auto Meta restarted:", Err)
                    end

                    if AutoMeta and MyRun == MetaRunId then
                        task.wait(1)
                    end
                end
            end)
        end
    end
})

Tab1:AddToggle({
    Name = "Auto Pains + Hurts",
    Default = false,
    Save = true,
    Flag = "AutoPainsHurts",
    Callback = function(Value)
        AutoPainsHurts = Value
        PainsHurtsRunId += 1

        if not Value and PainsHurtsTween then
            pcall(function()
                PainsHurtsTween:Cancel()
            end)
            PainsHurtsTween = nil
        end

        if Value then
            local MyRun = PainsHurtsRunId

            task.spawn(function()
                while AutoPainsHurts and MyRun == PainsHurtsRunId do
                    local Success, Err = pcall(function()
                        local BossData = {
                            {
                                Name = "Pains",
                                Position = CFrame.new(
                                    5435.41064, 502.409637, 741.838013,
                                    1, 0, 0, 0, 1, 0, 0, 0, 1
                                )
                            },
                            {
                                Name = "Hurts",
                                Position = CFrame.new(
                                    2733.07642, 101.598831, 426.639465,
                                    1, 0, 0, 0, 1, 0, 0, 0, 1
                                )
                            }
                        }

                        local CurrentIndex = 1

                        local function GetAliveRoot()
                            while AutoPainsHurts and MyRun == PainsHurtsRunId do
                                local Character = Player.Character
                                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                                local Root = Character and Character:FindFirstChild("HumanoidRootPart")

                                if Humanoid and Root and Humanoid.Health > 0 and Root.Parent then
                                    return Root
                                end

                                task.wait(0.5)
                            end
                        end

                        local function MoveTo(Target)
                            while AutoPainsHurts and MyRun == PainsHurtsRunId do
                                local Root = GetAliveRoot()
                                if not Root then return false end

                                local Distance = (Root.Position - Target.Position).Magnitude
                                if Distance <= 3 then
                                    return true
                                end

                                local Tween = TweenService:Create(
                                    Root,
                                    TweenInfo.new(
                                        math.max(Distance / TweenSpeed, 0.05),
                                        Enum.EasingStyle.Linear
                                    ),
                                    {CFrame = Target}
                                )

                                PainsHurtsTween = Tween
                                Tween:Play()

                                while AutoPainsHurts
                                    and MyRun == PainsHurtsRunId
                                    and Root.Parent
                                    and Player.Character == Root.Parent
                                    and Tween.PlaybackState == Enum.PlaybackState.Playing do
                                    task.wait(0.1)
                                end

                                pcall(function()
                                    Tween:Cancel()
                                end)

                                if not AutoPainsHurts or MyRun ~= PainsHurtsRunId then
                                    return false
                                end

                                task.wait(0.2)
                            end

                            return false
                        end

                        while AutoPainsHurts and MyRun == PainsHurtsRunId do
                            local Data = BossData[CurrentIndex]

                            if not MoveTo(Data.Position) then
                                break
                            end

                            local BossWasAlive = false

                            while AutoPainsHurts and MyRun == PainsHurtsRunId do
                                local Boss = BossFolder:FindFirstChild(Data.Name)
                                local Humanoid = Boss and Boss:FindFirstChildOfClass("Humanoid")

                                if Boss and Humanoid then
                                    if Humanoid.Health > 0 then
                                        BossWasAlive = true
                                    elseif BossWasAlive or Humanoid.Health <= 0 then
                                        break
                                    end
                                end

                                task.wait(0.3)
                            end

                            if not AutoPainsHurts or MyRun ~= PainsHurtsRunId then
                                break
                            end

                            task.wait(2)

                            if AutoPainsHurts and MyRun == PainsHurtsRunId then
                                CurrentIndex += 1
                                if CurrentIndex > #BossData then
                                    CurrentIndex = 1
                                end
                            end
                        end
                    end)

                    if not Success then
                        warn("Auto Pains + Hurts restarted:", Err)
                    end

                    if AutoPainsHurts and MyRun == PainsHurtsRunId then
                        task.wait(1)
                    end
                end
            end)
        end
    end
})

Tab1:AddToggle({
    Name = "Auto set Zero",
    Default = false,
    Save = true,
    Flag = "AutoZero",
    Callback = function(Value)
        AutoZero = Value
        ZeroRunId += 1

        if not Value and ZeroTween then
            pcall(function()
                ZeroTween:Cancel()
            end)
            ZeroTween = nil
        end

        if Value then
            local MyRun = ZeroRunId

            task.spawn(function()
                while AutoZero and MyRun == ZeroRunId do
                    local Success, Err = pcall(function()
                        local TargetPosition = CFrame.new(
                            2204.00586, 45.5981483, -4348.96826,
                            1, 0, 0, 0, 1, 0, 0, 0, 1
                        )

                        while AutoZero and MyRun == ZeroRunId do
                            local Character = Player.Character
                            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                            local Root = Character and Character:FindFirstChild("HumanoidRootPart")

                            if not Humanoid or not Root or Humanoid.Health <= 0 or not Root.Parent then
                                task.wait(0.5)
                                continue
                            end

                            local Distance = (Root.Position - TargetPosition.Position).Magnitude

                            if Distance > 3 then
                                local Tween = TweenService:Create(
                                    Root,
                                    TweenInfo.new(
                                        math.max(Distance / TweenSpeed, 0.05),
                                        Enum.EasingStyle.Linear
                                    ),
                                    {CFrame = TargetPosition}
                                )

                                ZeroTween = Tween
                                Tween:Play()

                                while AutoZero
                                    and MyRun == ZeroRunId
                                    and Root.Parent
                                    and Player.Character == Root.Parent
                                    and Tween.PlaybackState == Enum.PlaybackState.Playing do
                                    task.wait(0.1)
                                end

                                pcall(function()
                                    Tween:Cancel()
                                end)
                            else
                                task.wait(0.5)
                            end
                        end
                    end)

                    if not Success then
                        warn("Auto Zero restarted:", Err)
                    end

                    if AutoZero and MyRun == ZeroRunId then
                        task.wait(1)
                    end
                end
            end)
        end
    end
})


local AutoPickup = false

Tab1:AddToggle({
    Name = "Auto pickup Support Farm full set",
    Default = false,
    Flag = "AutoSave_Toggle_1",
    Save = true,
    Callback = function(Value)
        AutoPickup = Value

        if Value then
            task.spawn(function()
                while AutoPickup do
                    local Player = game.Players.LocalPlayer
                    local Character = Player.Character
                    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

                    if Root then
                        for _, v in ipairs(workspace:GetDescendants()) do
                            if not AutoPickup then
                                break
                            end

                            if v:IsA("ProximityPrompt") then
                                local Part = v.Parent

                                if Part and Part:IsA("BasePart") then
                                    if (Root.Position - Part.Position).Magnitude <= 100 then
                                        fireproximityprompt(v)
                                    end
                                end
                            end
                        end
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


local Player = Players.LocalPlayer
local FloatEnabled = false
local FloatConnection
local BV

local function removeFloat()
    if FloatConnection then
        FloatConnection:Disconnect()
        FloatConnection = nil
    end

    if BV then
        BV:Destroy()
        BV = nil
    end
end

local function setupFloat(Character)
    removeFloat()

    local Root = Character:WaitForChild("HumanoidRootPart", 5)
    if not Root then return end

    BV = Instance.new("BodyVelocity")
    BV.Name = "ContinuousFloat"
    BV.MaxForce = Vector3.new(0, math.huge, 0)
    BV.Velocity = Vector3.zero
    BV.Parent = Root

    FloatConnection = RunService.Heartbeat:Connect(function()
        if FloatEnabled and BV and BV.Parent and Root.Parent then
            BV.Velocity = Vector3.zero
        end
    end)
end

Tab1:AddToggle({
    Name = "Anti Fall Support Tween",
    Default = false,
    Flag = "AutoSave_Toggle_2",
    Save = true,
    Callback = function(Value)
        FloatEnabled = Value

        if Value then
            local Character = Player.Character
            if Character then
                setupFloat(Character)
            end
        else
            removeFloat()
        end
    end
})

Player.CharacterAdded:Connect(function(Character)
    task.wait(0.5)

    if FloatEnabled then
        setupFloat(Character)
    end
end)
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer




-- GUI chứa nút Skill
local Gui = Instance.new("ScreenGui")
Gui.Name = "Skill126Gui"
Gui.ResetOnSpawn = false
Gui.Enabled = false
Gui.Parent = LP:WaitForChild("PlayerGui")

local SkillButton = Instance.new("TextButton")
SkillButton.Name = "Skill126Button"
SkillButton.Size = UDim2.new(0, 150, 0, 50)
SkillButton.Position = UDim2.new(0.5, -75, 0.8, 0)
SkillButton.BackgroundTransparency = 0.1
SkillButton.Text = "Time stop"
SkillButton.TextSize = 18
SkillButton.TextColor3 = Color3.new(1, 1, 1)
SkillButton.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = SkillButton

-- Bấm nút Skill
SkillButton.MouseButton1Click:Connect(function()
	local args = {
		{
			Camera = CFrame.new(
				74.2727279663086, 251.0009002685547, -28.747745513916016,
				-0.9511321783065796, -0.044049736112356186, 0.3056260347366333,
				0, 0.9897724390029907, 0.14265543222427368,
				-0.308784157037735, 0.13568417727947235, -0.9414043426513672
			),

			SkillId = "126",
			Began = true,

			CFrame = CFrame.new(
				70.45240020751953, 247.81771850585938, -16.98019027709961,
				1, 0, 0,
				0, 1, 0,
				0, 0, 1
			),

			["Typ\208\181"] = 1,

			Aim = vector.create(
				70.45240020751953,
				247.81771850585938,
				-66.98019409179688
			)
		}
	}

	RS:WaitForChild("Remotes")
		:WaitForChild("SkillRemote")
		:FireServer(unpack(args))
end)

-- Toggle ON/OFF
Tab1:AddToggle({
	Name = "Time stop wis",
	Default = false,
    Save = true,
    Flag = "AutoSave_Toggle_3",

	Callback = function(Value)
		Gui.Enabled = Value
	end
})
local AutoSkill = false

Tab:AddToggle({
    Name = "Auto M1",
    Default = true,
    Flag = "AutoSave_Toggle_4",
    Save = true,
    Callback = function(Value)
        AutoSkill = Value

        if Value then
            task.spawn(function()
                while AutoSkill do
                    local args = {
                        [1] = {
                            ["Camera"] = CFrame.new(
                                1436.56982421875,
                                610.5719604492188,
                                -2926.40576171875,
                                0.4276675879955292,
                                0.8082790374755859,
                                -0.404704213142395,
                                0,
                                0.44771331548690796,
                                0.8941771984100342,
                                0.9039360880851746,
                                -0.38241061568260193,
                                0.19147247076034546
                            ),

                            ["SkillId"] = "1",

                            ["Began"] = true,

                            ["CFrame"] = CFrame.new(
                                1441.628662109375,
                                597.61474609375,
                                -2928.799072265625,
                                0.4534393846988678,
                                -9.274389611846345e-08,
                                -0.891287088394165,
                                2.6512436690495633e-08,
                                1,
                                -9.056802241502737e-08,
                                0.891287088394165,
                                1.7436915911162032e-08,
                                0.4534393846988678
                            ),

                            ["Typ\208\181"] = 1,

                            ["Aim"] = Vector3.new(
                                1486.1929931640625,
                                597.61474609375,
                                -2951.470947265625
                            )
                        }
                    }

                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Remotes")
                        :WaitForChild("SkillRemote")
                        :FireServer(unpack(args))

                    task.wait(0.151)
                end
            end)
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local WorldMobs = workspace:WaitForChild("World Mobs")
local SkillRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SkillRemote")

local AuraEnabled = false

local function GetRandomMob()
    local Character = Player.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return nil
    end

    local Mobs = {}

    for _, Mob in ipairs(WorldMobs:GetDescendants()) do
        if Mob:IsA("Model") then
            local Humanoid = Mob:FindFirstChildOfClass("Humanoid")
            local MobRoot = Mob:FindFirstChild("HumanoidRootPart")
                or Mob.PrimaryPart
                or Mob:FindFirstChildWhichIsA("BasePart")

            if Humanoid and MobRoot and Humanoid.Health > 0 then
                local Distance = (Root.Position - MobRoot.Position).Magnitude

                if Distance <= 400 then
                    table.insert(Mobs, Mob)
                end
            end
        end
    end

    if #Mobs > 0 then
        return Mobs[math.random(1, #Mobs)]
    end

    return nil
end

Tab:AddToggle({
    Name = "Aura Kill Energy Blast V2",
    Default = true,
    Save = true,
    Flag = "AutoSave_Toggle_5",
    Callback = function(Value)
        AuraEnabled = Value

        if AuraEnabled then
            task.spawn(function()
                while AuraEnabled do
                    task.wait(0.16)

                    local Character = Player.Character
                    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

                    if Root then
                        local RandomMob = GetRandomMob()

                        if RandomMob then
                            local MobRoot = RandomMob:FindFirstChild("HumanoidRootPart")
                                or RandomMob.PrimaryPart
                                or RandomMob:FindFirstChildWhichIsA("BasePart")

                            if MobRoot then
                                local TargetPosition = MobRoot.Position

                                local SkillCFrame = CFrame.lookAt(
                                    Root.Position,
                                    Vector3.new(
                                        TargetPosition.X,
                                        Root.Position.Y,
                                        TargetPosition.Z
                                    )
                                )

                                local args = {
                                    [1] = {
                                        ["Camera"] = CFrame.lookAt(
                                            workspace.CurrentCamera.CFrame.Position,
                                            TargetPosition
                                        ),
                                        ["SkillId"] = "101",
                                        ["Began"] = true,
                                        ["CFrame"] = SkillCFrame,
                                        ["Typ\208\181"] = 1,
                                        ["Aim"] = TargetPosition
                                    }
                                }

                                SkillRemote:FireServer(unpack(args))
                            end
                        end
                    end
                end
            end)
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

local WorldMobs = workspace:WaitForChild("World Mobs")

local LockedOnChanged = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_knit@1.4.7")
    :WaitForChild("knit")
    :WaitForChild("Services")
    :WaitForChild("SkillManager")
    :WaitForChild("RE")
    :WaitForChild("LockedOnChanged")

local AutoLockRandomMob = false

local function GetRandomMob()
    local Character = Player.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return nil
    end

    local ValidMobs = {}

    for _, Mob in ipairs(WorldMobs:GetDescendants()) do
        if Mob:IsA("Model") then
            local Humanoid = Mob:FindFirstChildOfClass("Humanoid")

            local MobRoot = Mob:FindFirstChild("HumanoidRootPart")
                or Mob.PrimaryPart
                or Mob:FindFirstChildWhichIsA("BasePart")

            if Humanoid and MobRoot and Humanoid.Health > 0 then
                local Distance = (Root.Position - MobRoot.Position).Magnitude

                if Distance <= 400 then
                    table.insert(ValidMobs, Mob)
                end
            end
        end
    end

    if #ValidMobs > 0 then
        return ValidMobs[math.random(1, #ValidMobs)]
    end

    return nil
end

Tab:AddToggle({
    Name = "Auto Lock Random Mob",
    Default = true,
    Save = true,
    Flag = "AutoSave_Toggle_6",
    Callback = function(Value)
        AutoLockRandomMob = Value

        if Value then
            task.spawn(function()
                while AutoLockRandomMob do
                    local RandomMob = GetRandomMob()

                    if RandomMob then
                        LockedOnChanged:FireServer(RandomMob)
                    end

                    task.wait(0.4)
                end
            end)
        end
    end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

local WorldMobs = workspace:WaitForChild("World Mobs")
local EventMobs = WorldMobs:WaitForChild("Event Mobs")

local SkillRemote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("SkillRemote")

local LockedOnChanged = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_knit@1.4.7")
    :WaitForChild("knit")
    :WaitForChild("Services")
    :WaitForChild("SkillManager")
    :WaitForChild("RE")
    :WaitForChild("LockedOnChanged")

local AutoZaja = false
local CurrentTween = nil

local function GetZaja()
    local Zaja = EventMobs:FindFirstChild("Zaja")

    if not Zaja then
        return nil
    end

    local Humanoid = Zaja:FindFirstChildOfClass("Humanoid")

    local Root = Zaja:FindFirstChild("HumanoidRootPart")
        or Zaja.PrimaryPart
        or Zaja:FindFirstChildWhichIsA("BasePart")

    if not Humanoid or not Root or Humanoid.Health <= 0 then
        return nil
    end

    return Zaja, Humanoid, Root
end

local function GetDistancePosition(PlayerRoot, ZajaRoot)
    local Direction = PlayerRoot.Position - ZajaRoot.Position

    if Direction.Magnitude <= 0.1 then
        Direction = Vector3.new(0, 0, 1)
    else
        Direction = Direction.Unit
    end

    local Position = ZajaRoot.Position + (Direction * 500)

    return CFrame.lookAt(
        Position,
        Vector3.new(
            ZajaRoot.Position.X,
            Position.Y,
            ZajaRoot.Position.Z
        )
    )
end

local function TweenToZaja(PlayerRoot, ZajaRoot)
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end

    local TargetCFrame = GetDistancePosition(PlayerRoot, ZajaRoot)

    local Distance = (PlayerRoot.Position - TargetCFrame.Position).Magnitude
    local Time = Distance / 220

    CurrentTween = TweenService:Create(
        PlayerRoot,
        TweenInfo.new(
            math.max(Time, 0.05),
            Enum.EasingStyle.Linear
        ),
        {
            CFrame = TargetCFrame
        }
    )

    CurrentTween:Play()
end

Tab1:AddToggle({
    Name = "Auto kill Zaja",
    Default = false,
    Save = true,
    Flag = "AutoSave_Toggle_7",
    Callback = function(Value)
        AutoZaja = Value

        if not Value then
            if CurrentTween then
                CurrentTween:Cancel()
                CurrentTween = nil
            end

            return
        end

        -- Luồng di chuyển
        task.spawn(function()
            while AutoZaja do
                local Character = Player.Character
                local PlayerRoot = Character
                    and Character:FindFirstChild("HumanoidRootPart")

                local Zaja, Humanoid, ZajaRoot = GetZaja()

                if PlayerRoot and Zaja and Humanoid.Health > 0 then
                    local Distance = (
                        PlayerRoot.Position - ZajaRoot.Position
                    ).Magnitude

                    -- Chỉ tween lại khi không giữ đúng khoảng cách
                    if math.abs(Distance - 500) > 25 then
                        TweenToZaja(PlayerRoot, ZajaRoot)
                    end
                else
                    if CurrentTween then
                        CurrentTween:Cancel()
                        CurrentTween = nil
                    end
                end

                task.wait(0.3)
            end
        end)

        -- Luồng LockOn
        task.spawn(function()
            while AutoZaja do
                local Zaja = GetZaja()

                if Zaja then
                    LockedOnChanged:FireServer(Zaja)
                end

                task.wait(0.2)
            end
        end)

        -- Luồng bắn Skill 101
        task.spawn(function()
            while AutoZaja do
                local Character = Player.Character
                local PlayerRoot = Character
                    and Character:FindFirstChild("HumanoidRootPart")

                local Zaja, Humanoid, ZajaRoot = GetZaja()

                if PlayerRoot and Zaja and ZajaRoot then
                    local TargetPosition = ZajaRoot.Position

                    local args = {
                        [1] = {
                            ["Camera"] = CFrame.lookAt(
                                workspace.CurrentCamera.CFrame.Position,
                                TargetPosition
                            ),

                            ["SkillId"] = "101",
                            ["Began"] = true,

                            ["CFrame"] = CFrame.lookAt(
                                PlayerRoot.Position,
                                Vector3.new(
                                    TargetPosition.X,
                                    PlayerRoot.Position.Y,
                                    TargetPosition.Z
                                )
                            ),

                            ["Typ\208\181"] = 1,

                            ["Aim"] = TargetPosition
                        }
                    }

                    SkillRemote:FireServer(unpack(args))
                end

                task.wait(0.18)
            end
        end)
    end
})
Tab2:AddToggle({
    Name = "Kill Dungeon Atom Droid mecha🌳",
    Default = true,
    Save = true,
    Flag = "AutoSave_Toggle_8",

    Callback = function(Value)

        _G.AutoAllMobsRunning = Value

        if not Value then
            return
        end

        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")

        local Player = Players.LocalPlayer
        local TWEEN_SPEED = 400

        local SkillRemote = ReplicatedStorage
            :WaitForChild("Remotes")
            :WaitForChild("SkillRemote")

        --------------------------------------------------
        -- SKILLS
        --------------------------------------------------

        local Skills = {

            ["104"] = {
                Camera = CFrame.new(
                    -421.05010986328125, 1358.7010498046875, -167.4876708984375,
                    -0.9965898394584656, 0.03109595738351345, -0.07643166929483414,
                    0, 0.9262738823890686, 0.37685126066207886,
                    0.08251520266247319, 0.37556612491607666, -0.923115074634552
                ),
                CFrame = CFrame.new(
                    -420.0947265625, 1352.2103271484375, -155.94873046875,
                    -0.9929859042167664, -6.088890724953444e-09, -0.11823264509439468,
                    -5.839831396237116e-11, 1, -5.10087723171182e-08,
                    0.11823264509439468, -5.064408625798933e-08, -0.9929859042167664
                ),
                Aim = Vector3.new(
                    -414.18310546875,
                    1352.2103271484375,
                    -106.2994384765625
                )
            },

            ["106"] = {
                Camera = CFrame.new(
                    -423.82562255859375, 1359.05078125, -224.40838623046875,
                    -0.994903028011322, 0.04082212969660759, -0.09220409393310547,
                    0, 0.9143902063369751, 0.40483400225639343,
                    0.10083670914173126, 0.4027705788612366, -0.909729540348053
                ),
                CFrame = CFrame.new(
                    -422.6730651855469, 1352.2103271484375, -213.03677368164062,
                    -0.9981904029846191, 1.1716121406379898e-09, -0.06013282388448715,
                    -6.026284360416412e-09, 1, 1.1951860301451234e-07,
                    0.06013282388448715, 1.1966470481183933e-07, -0.9981904029846191
                ),
                Aim = Vector3.new(
                    -419.6664123535156,
                    1352.2103271484375,
                    -163.12725830078125
                )
            },

            ["111"] = {
                Camera = CFrame.new(
                    -413.5762939453125, 1360.6148681640625, -164.30728149414062,
                    -0.7885639071464539, -0.32590368390083313, 0.5214917659759521,
                    0, 0.8480192422866821, 0.5299654603004456,
                    -0.6149526834487915, 0.4179116487503052, -0.6687174439430237
                ),
                CFrame = CFrame.new(
                    -420.0949401855469, 1352.2103271484375, -155.9483184814453,
                    -0.9929867386817932, -4.879508352928497e-09, -0.11822597682476044,
                    -1.740200483713039e-10, 1, -3.981112328688141e-08,
                    0.11822597682476044, -3.9511341753950546e-08, -0.9929867386817932
                ),
                Aim = Vector3.new(
                    -414.18365478515625,
                    1352.2103271484375,
                    -106.29898071289062
                )
            },

            ["116"] = {
                Camera = CFrame.new(
                    -463.2796325683594, 1368.5244140625, -188.75462341308594,
                    -0.9105014204978943, 0.09759669750928879, -0.40182340145111084,
                    0, 0.9717476963996887, 0.23602250218391418,
                    0.4135059118270874, 0.21489882469177246, -0.8847776651382446
                ),
                CFrame = CFrame.new(
                    -438.53564453125, 1352.2103271484375, -134.2706756591797,
                    -0.9998703002929688, 1.277434691360213e-08, -0.016104556620121002,
                    1.150396045090929e-08, 1, 7.897634191067482e-08,
                    0.016104556620121002, 7.878083607693043e-08, -0.9998703002929688
                ),
                Aim = Vector3.new(
                    -437.73040771484375,
                    1352.2103271484375,
                    -84.27716064453125
                )
            }
        }

        --------------------------------------------------
        -- WORLD MOBS
        --------------------------------------------------

        local function GetWorldMobs()

            local WorldMobs =
                workspace:FindFirstChild("World Mobs")

            if not WorldMobs then
                return {}
            end

            local Result = {}

            for _, Mob in ipairs(
                WorldMobs:GetDescendants()
            ) do

                if Mob:IsA("Model") then

                    local Humanoid =
                        Mob:FindFirstChildOfClass("Humanoid")

                    local Root =
                        Mob:FindFirstChild("HumanoidRootPart")
                        or Mob.PrimaryPart
                        or Mob:FindFirstChildWhichIsA("BasePart")

                    if Humanoid
                        and Root
                        and Humanoid.Health > 0
                    then

                        table.insert(Result, Mob)

                    end
                end
            end

            return Result
        end

        --------------------------------------------------
        -- ROOT
        --------------------------------------------------

        local function GetRoot()

            local Character = Player.Character

            if not Character then
                return nil
            end

            return Character:FindFirstChild(
                "HumanoidRootPart"
            )
        end

        --------------------------------------------------
        -- MOB ROOT
        --------------------------------------------------

        local function GetMobRoot(Mob)

            if not Mob or not Mob.Parent then
                return nil
            end

            return Mob:FindFirstChild(
                "HumanoidRootPart"
            )
            or Mob.PrimaryPart
            or Mob:FindFirstChildWhichIsA("BasePart")
        end

        --------------------------------------------------
        -- TWEEN
        --------------------------------------------------

        local function TweenTo(Root, Position)

            if not _G.AutoAllMobsRunning then
                return nil
            end

            if not Root or not Root.Parent then
                return nil
            end

            local Distance =
                (Root.Position - Position).Magnitude

            local Time =
                math.max(
                    Distance / TWEEN_SPEED,
                    0.05
                )

            local Tween =
                TweenService:Create(
                    Root,
                    TweenInfo.new(
                        Time,
                        Enum.EasingStyle.Linear
                    ),
                    {
                        CFrame =
                            CFrame.new(Position)
                    }
                )

            Tween:Play()

            return Tween
        end

        --------------------------------------------------
        -- CHECK TRÊN ĐẦU MOB
        --------------------------------------------------

        local function IsAboveMob(Mob)

            local Root = GetRoot()
            local MobRoot = GetMobRoot(Mob)

            if not Root or not MobRoot then
                return false
            end

            local Horizontal =
                Vector3.new(
                    Root.Position.X - MobRoot.Position.X,
                    0,
                    Root.Position.Z - MobRoot.Position.Z
                ).Magnitude

            local Height =
                Root.Position.Y -
                MobRoot.Position.Y

            return
                Horizontal <= 8
                and Height >= 3
                and Height <= 10
        end

        --------------------------------------------------
        -- GIỮ TRÊN ĐẦU MOB
        --------------------------------------------------

        local function StayAboveMob(
            Mob,
            Root,
            Duration
        )

            local StartTime = tick()

            while
                _G.AutoAllMobsRunning
                and Mob
                and Mob.Parent
                and Root
                and Root.Parent
                and tick() - StartTime < Duration
            do

                local MobRoot =
                    GetMobRoot(Mob)

                if MobRoot then

                    local Position =
                        MobRoot.Position
                        + Vector3.new(0, 5.5, 0)

                    Root.CFrame =
                        CFrame.new(
                            Position,
                            MobRoot.Position
                        )

                    Root.AssemblyLinearVelocity =
                        Vector3.zero

                    Root.AssemblyAngularVelocity =
                        Vector3.zero
                end

                task.wait()
            end
        end

        --------------------------------------------------
        -- SKILL BUSY
        --------------------------------------------------

        local function IsSkillBusy(SkillId)

            local Characters =
                workspace:FindFirstChild(
                    "Characters"
                )

            if not Characters then
                return false
            end

            for _, Character in ipairs(
                Characters:GetChildren()
            ) do

                local Status =
                    Character:FindFirstChild(
                        "Status"
                    )

                local SkillAction =
                    Status
                    and Status:FindFirstChild(
                        "SkillAction"
                    )

                if SkillAction
                    and SkillAction:FindFirstChild(
                        SkillId
                    )
                then
                    return true
                end
            end

            return false
        end

        --------------------------------------------------
        -- RANDOM SKILL
        --------------------------------------------------

        task.spawn(function()

            while _G.AutoAllMobsRunning do

                -- Trên đầu mob = không skill
                if IsAboveMob(
                    GetWorldMobs()[1]
                ) then

                    task.wait(0.1)
                    continue
                end

                local Available = {}

                for SkillId, _ in pairs(Skills) do

                    if not IsSkillBusy(SkillId) then
                        table.insert(
                            Available,
                            SkillId
                        )
                    end
                end

                if #Available == 0 then

                    task.wait(0.05)
                    continue
                end

                local SkillId =
                    Available[
                        math.random(
                            1,
                            #Available
                        )
                    ]

                local Data =
                    Skills[SkillId]

                local args = {
                    [1] = {
                        ["Camera"] = Data.Camera,
                        ["SkillId"] = SkillId,
                        ["Began"] = true,
                        ["CFrame"] = Data.CFrame,
                        ["Typ\208\181"] = 1,
                        ["Aim"] = Data.Aim
                    }
                }

                pcall(function()
                    SkillRemote:FireServer(
                        unpack(args)
                    )
                end)

                task.wait(0.1)

                args[1].Began = false

                pcall(function()
                    SkillRemote:FireServer(
                        unpack(args)
                    )
                end)

                task.wait(0.1)
            end
        end)

        --------------------------------------------------
        -- AUTO TWEEN ALL MOBS
        --------------------------------------------------

        task.spawn(function()

            local CompletedMobs = {}

            while _G.AutoAllMobsRunning do

                local Mobs =
                    GetWorldMobs()

                if #Mobs == 0 then

                    task.wait(0.5)
                    continue
                end

                local Target = nil

                -- Ưu tiên mob chưa xử lý
                for _, Mob in ipairs(Mobs) do

                    if not CompletedMobs[Mob] then

                        Target = Mob
                        break
                    end
                end

                -- Nếu đã xử lý hết thì reset
                if not Target then

                    CompletedMobs = {}

                    Target = Mobs[1]
                end

                if not Target
                    or not Target.Parent
                then

                    task.wait(0.2)
                    continue
                end

                local Root =
                    GetRoot()

                local MobRoot =
                    GetMobRoot(Target)

                if not Root
                    or not MobRoot
                then

                    task.wait(0.2)
                    continue
                end

                --------------------------------------------------
                -- 150 STUDS
                --------------------------------------------------

                local FarPosition =
                    MobRoot.Position
                    - MobRoot.CFrame.LookVector
                    * 150

                local Tween1 =
                    TweenTo(
                        Root,
                        FarPosition
                    )

                if Tween1 then
                    Tween1.Completed:Wait()
                end

                if not _G.AutoAllMobsRunning then
                    break
                end

                --------------------------------------------------
                -- CHỜ 3 GIÂY
                --------------------------------------------------

                task.wait(3)

                if not Target.Parent then
                    continue
                end

                --------------------------------------------------
                -- LÊN ĐẦU
                --------------------------------------------------

                MobRoot =
                    GetMobRoot(Target)

                if MobRoot then

                    local TopPosition =
                        MobRoot.Position
                        + Vector3.new(0, 5.5, 0)

                    local Tween2 =
                        TweenTo(
                            Root,
                            TopPosition
                        )

                    if Tween2 then
                        Tween2.Completed:Wait()
                    end

                    if not _G.AutoAllMobsRunning then
                        break
                    end

                    --------------------------------------------------
                    -- TRÊN ĐẦU 4 GIÂY
                    --------------------------------------------------

                    StayAboveMob(
                        Target,
                        Root,
                        4
                    )
                end

                if not _G.AutoAllMobsRunning then
                    break
                end

                if not Target.Parent then
                    continue
                end

                --------------------------------------------------
                -- QUAY VỀ 150 STUDS
                --------------------------------------------------

                MobRoot =
                    GetMobRoot(Target)

                if MobRoot then

                    local BackPosition =
                        MobRoot.Position
                        - MobRoot.CFrame.LookVector
                        * 150

                    local Tween3 =
                        TweenTo(
                            Root,
                            BackPosition
                        )

                    if Tween3 then
                        Tween3.Completed:Wait()
                    end
                end

                --------------------------------------------------
                -- ĐÁNH DẤU ĐÃ XỬ LÝ
                --------------------------------------------------

                CompletedMobs[Target] = true

                --------------------------------------------------
                -- CHỜ 3 GIÂY
                --------------------------------------------------

                task.wait(3)
            end
        end)
    end
})
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

--==================================================
-- SETTINGS
--==================================================

local Speed = 16
local Walking = false
local TargetVisual = nil

-- MỞ SẴN
local AutoWalk = true

--==================================================
-- RANDOM MOVEMENT
--==================================================

local RandomDirection = Vector3.zero
local RandomTimer = 0
local RandomMode = "Forward"

local function NewRandomAction()

    local Roll = math.random(1, 100)

    if Roll <= 55 then

        RandomMode = "Forward"

    elseif Roll <= 75 then

        RandomMode = "Side"

        local Side =
            math.random(0, 1) == 0 and -1 or 1

        RandomDirection =
            Vector3.new(Side, 0, 0)

    elseif Roll <= 90 then

        RandomMode = "Circle"

    else

        RandomMode = "Rotate"
    end

    RandomTimer =
        math.random(4, 12) / 10
end

NewRandomAction()

--==================================================
-- RANDOM AUTO WALK
--==================================================

RunService.RenderStepped:Connect(function(dt)

    if not AutoWalk then
        return
    end

    if not Walking or not TargetVisual then
        return
    end

    local Character = LocalPlayer.Character

    local Humanoid =
        Character and
        Character:FindFirstChildOfClass("Humanoid")

    local HRP =
        Character and
        Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid or not HRP then
        return
    end

    if not TargetVisual.Parent then
        return
    end

    Humanoid.WalkSpeed = Speed

    local ToTarget =
        TargetVisual.Position - HRP.Position

    local Distance =
        ToTarget.Magnitude

    if Distance <= 5 then

        Humanoid:Move(Vector3.zero, false)

        return
    end

    RandomTimer -= dt

    if RandomTimer <= 0 then
        NewRandomAction()
    end

    -- Hướng tới Visual
    local Forward = ToTarget.Unit

    -- Hướng ngang
    local Right =
        Vector3.new(
            -Forward.Z,
            0,
            Forward.X
        )

    local MoveDirection

    if RandomMode == "Forward" then

        MoveDirection = Forward

    elseif RandomMode == "Side" then

        MoveDirection = (
            Forward +
            Right *
            RandomDirection.X *
            0.7
        ).Unit

    elseif RandomMode == "Circle" then

        MoveDirection = (
            Forward +
            Right *
            math.sin(os.clock() * 3) *
            0.8
        ).Unit

    elseif RandomMode == "Rotate" then

        -- Quay tại chỗ
        Humanoid:Move(Vector3.zero, false)

        HRP.CFrame =
            HRP.CFrame *
            CFrame.Angles(
                0,
                math.rad(100) * dt,
                0
            )

        return
    end

    Humanoid:Move(MoveDirection, false)

end)

--==================================================
-- STOP
--==================================================

local function StopWalking()

    Walking = false
    TargetVisual = nil

    local Character =
        LocalPlayer.Character

    local Humanoid =
        Character and
        Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid:Move(Vector3.zero, false)
    end

end

--==================================================
-- ORION TOGGLE
--==================================================

Tab3:AddToggle({
    Name = "Auto Next areaV2",
    Default = true,

    Callback = function(Value)

        AutoWalk = Value

        if not Value then

            StopWalking()

        else

            NewRandomAction()

        end

    end
})

--==================================================
-- SPEED SLIDER
--==================================================

Tab:AddSlider({
    Name = "Auto Marco.Speed",
    Min = 1,
    Max = 100,
    Default = 16,
    Increment = 1,

    ValueName = "Speed",

    Callback = function(Value)

        Speed = Value

    end
})

--==================================================
-- MAIN LOOP
--==================================================

task.spawn(function()

    while task.wait(0.1) do

        -- OFF = không làm gì
        if not AutoWalk then
            StopWalking()
            continue
        end

        --==================================================
        -- CHECK SERVER PLAYER
        --==================================================

        if #Players:GetPlayers() >= 2 then

            StopWalking()

            TeleportService:Teleport(
                game.PlaceId,
                LocalPlayer
            )

            break
        end

        --==================================================
        -- CHECK DUNGEON
        --==================================================

        local Dungeon =
            Workspace:FindFirstChild("Dungeon")

        local Stages =
            Dungeon and
            Dungeon:FindFirstChild("Stages")

        local Stage0 =
            Stages and
            Stages:FindFirstChild("0")

        local NextArea =
            Stage0 and
            Stage0:FindFirstChild("NextArea")

        local Container =
            NextArea and
            NextArea:FindFirstChild("Container")

        local Visual =
            Container and
            Container:FindFirstChild("Visual")

        if not Visual then

            StopWalking()

            continue
        end

        --==================================================
        -- CHECK ATOM MAX
        --==================================================

        local WorldMobs =
            Workspace:FindFirstChild("World Mobs")

        local EventMobs =
            WorldMobs and
            WorldMobs:FindFirstChild("Event Mobs")

        local AtomMax =
            EventMobs and
            EventMobs:FindFirstChild("Atom Max")

        if AtomMax then

            StopWalking()

            continue
        end

        --==================================================
        -- WALK RANDOM TO VISUAL
        --==================================================

        if Visual:IsA("BasePart") then

            TargetVisual = Visual
            Walking = true

            local Character =
                LocalPlayer.Character

            local HRP =
                Character and
                Character:FindFirstChild(
                    "HumanoidRootPart"
                )

            if HRP then

                local Distance =
                    (Visual.Position - HRP.Position).Magnitude

                if Distance <= 5 then

                    Walking = false

                    local Humanoid =
                        Character:FindFirstChildOfClass(
                            "Humanoid"
                        )

                    if Humanoid then
                        Humanoid:Move(
                            Vector3.zero,
                            false
                        )
                    end

                    -- Đợi trước khi interact
                    task.wait(0.8)

                    -- Kiểm tra lại toggle
                    if not AutoWalk then

                        TargetVisual = nil

                        continue
                    end

                    -- Kiểm tra player
                    if #Players:GetPlayers() >= 2 then

                        TargetVisual = nil

                        TeleportService:Teleport(
                            game.PlaceId,
                            LocalPlayer
                        )

                        break
                    end

                    -- Kiểm tra Visual
                    if not Visual.Parent then

                        TargetVisual = nil

                        continue
                    end

                    -- Kiểm tra Atom Max lần nữa
                    WorldMobs =
                        Workspace:FindFirstChild(
                            "World Mobs"
                        )

                    EventMobs =
                        WorldMobs and
                        WorldMobs:FindFirstChild(
                            "Event Mobs"
                        )

                    AtomMax =
                        EventMobs and
                        EventMobs:FindFirstChild(
                            "Atom Max"
                        )

                    if AtomMax then

                        TargetVisual = nil

                        continue
                    end

                    --==================================================
                    -- INTERACT
                    --==================================================

                    local Pad =
                        NextArea:FindFirstChild(
                            "DungeonNextAreaPad"
                        )

                    local RE =
                        Pad and
                        Pad:FindFirstChild("RE")

                    local Interact =
                        RE and
                        RE:FindFirstChild("Interact")

                    if Interact then
                        Interact:FireServer()
                    end

                    TargetVisual = nil

                end
            end
        end
    end

end)

--==================================================
-- INIT
--==================================================

OrionLib:Init()



getgenv().AutoStart = false

Tab2:AddToggle({
    Name = "Auto Start",
    Default = true,
    Save = true,
    Flag = "AutoSave_Toggle_10",
    Callback = function(Value)
        getgenv().AutoStart = Value

        task.spawn(function()
            local started = false

            local Bosses = {
                "Garriot",
                "Great Droid",
                "Atom Max",
                "Mecha Soldier"
            }

            while getgenv().AutoStart do
                task.wait(1)

                local eventMobs = workspace:FindFirstChild("World Mobs")
                    and workspace["World Mobs"]:FindFirstChild("Event Mobs")

                if eventMobs then
                    for _, bossName in ipairs(Bosses) do
                        local boss = eventMobs:FindFirstChild(bossName)

                        if boss then
                            local humanoid = boss:FindFirstChildOfClass("Humanoid")

                            if humanoid then
                                -- Boss còn sống
                                if humanoid.Health > 0 then
                                    started = true
                                end

                                -- Boss đã chết
                                if started and humanoid.Health <= 0 then
                                    started = false

                                    pcall(function()
                                        game:GetService("StarterGui"):SetCore(
                                            "SendNotification",
                                            {
                                                Title = "Auto Start",
                                                Text = bossName .. " đã chết, đang start...",
                                                Duration = 5
                                            }
                                        )
                                    end)

                                    task.wait(5.04)

                                    if getgenv().AutoStart then
                                        game:GetService("ReplicatedStorage")
                                            :WaitForChild("Packages")
                                            :WaitForChild("_Index")
                                            :WaitForChild("sleitnick_knit@1.4.7")
                                            :WaitForChild("knit")
                                            :WaitForChild("Services")
                                            :WaitForChild("DungeonLobbyService")
                                            :WaitForChild("RF")
                                            :WaitForChild("StartDungeon")
                                            :InvokeServer()
                                    end

                                    break
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
})
--// ================= AUTO PHÊ PHA V2 =================

local AutoPhePha = false

Tab3:AddToggle({
    Name = "Auto Phê Pha V2",
    Default = true,
    Save = true,
    Flag = "AutoSave_Toggle_11",
    Callback = function(Value)
        AutoPhePha = Value

        task.spawn(function()
            while AutoPhePha do
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local charFolder = workspace:FindFirstChild("Characters")

                    if charFolder then
                        local char = charFolder:FindFirstChild(player.Name)

                        if char and not char:FindFirstChild("Mode") then
                            local args = {
                                {
                                    Camera = CFrame.new(
                                        -28.790475845336914,
                                        298.4656677246094,
                                        -91.82173156738281,
                                        0.8630251884460449,
                                        0.06684061139822006,
                                        -0.5007192492485046,
                                        0,
                                        0.9912075996398926,
                                        0.1323155164718628,
                                        0.5051608085632324,
                                        -0.11419162154197693,
                                        0.855437159538269
                                    ),

                                    SkillId = "10",
                                    Began = true,

                                    CFrame = CFrame.new(
                                        -20.313318252563477,
                                        294.6113586425781,
                                        -106.30424499511719,
                                        0.863025426864624,
                                        0.06684055924415588,
                                        -0.5007189512252808,
                                        -8.083265612413015e-09,
                                        0.9912076592445374,
                                        0.1323154717683792,
                                        0.5051605105400085,
                                        -0.11419161409139633,
                                        0.8554373979568481
                                    ),

                                    ["Typе"] = 1,

                                    Aim = vector.create(
                                        4.722629547119141,
                                        287.9955749511719,
                                        -149.07611083984375
                                    )
                                }
                            }

                            game:GetService("ReplicatedStorage")
                                :WaitForChild("Remotes")
                                :WaitForChild("SkillRemote")
                                :FireServer(unpack(args))
                        end
                    end
                end)

                task.wait(1.5)
            end
        end)
    end
})


--// ================= AUTO CHỌN WEAPON =================

local SelectedTool = 2
local AutoEquipTools = true

local Dropdown = Tab3:AddDropdown({
    Name = "Auto equiptools Weaponslot",
    Default = "2",
    Save = true,
    Flag = "AutoSave_Dropdown_12",
    Options = {"1", "2", "3", "4", "5", "6"},
    Callback = function(Value)
        SelectedTool = tonumber(Value)
    end
})

Tab3:AddToggle({
    Name = "Auto EquipTools",
    Default = true,
    Save = true,
    Flag = "AutoSave_Toggle_13",
    Callback = function(Value)
        AutoEquipTools = Value

        if Value then
            task.spawn(function()
                while AutoEquipTools do
                    local args = {
                        SelectedTool
                    }

                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Packages")
                        :WaitForChild("_Index")
                        :WaitForChild("sleitnick_knit@1.4.7")
                        :WaitForChild("knit")
                        :WaitForChild("Services")
                        :WaitForChild("ToolService")
                        :WaitForChild("RE")
                        :WaitForChild("UpdatePlayerToolbarSelection")
                        :FireServer(unpack(args))

                    task.wait(3.2)
                end
            end)
        end
    end
})


--// ================= HỒI SINH TẠI VỊ TRÍ ĐÃ CHẾT =================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local RespawnAtDeath = false
local LastDeathPosition

Tab3:AddToggle({
    Name = "Hồi sinh tại vị trí đã chết [💨]",
    Default = false,
    Save = true,
    Flag = "AutoSave_Toggle_14",
    Callback = function(Value)
        RespawnAtDeath = Value
    end
})

local function SetupCharacter(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    local HRP = Character:WaitForChild("HumanoidRootPart")

    Humanoid.Died:Connect(function()
        if RespawnAtDeath then
            LastDeathPosition = HRP.CFrame
        end
    end)
end

if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(Character)
    SetupCharacter(Character)

    if RespawnAtDeath and LastDeathPosition then
        local HRP = Character:WaitForChild("HumanoidRootPart")

        task.wait(0.2)

        HRP.CFrame = LastDeathPosition
    end
end)
local ReturnToWorld = game:GetService("ReplicatedStorage")
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_knit@1.4.7")
    :WaitForChild("knit")
    :WaitForChild("Services")
    :WaitForChild("DungeonService")
    :WaitForChild("RF")
    :WaitForChild("ReturnToWorld")

local AutoReturnToWorld = true

-- Tạo Toggle theo Orion
Tab:AddToggle({
    Name = "Auto Return To World",
    Default = true,
    Callback = function(Value)
        AutoReturnToWorld = Value

        if Value then
            task.spawn(function()
                while AutoReturnToWorld do
                    task.wait(600) -- 10 phút

                    -- Kiểm tra lại sau khi đợi để tránh tắt rồi vẫn chạy
                    if not AutoReturnToWorld then
                        break
                    end

                    pcall(function()
                        ReturnToWorld:InvokeServer()
                    end)
                end
            end)
        end
    end
})


        local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

local SkillRemote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("SkillRemote")

local AutoDestroySmart = false

--------------------------------------------------
-- CHECK CÓ MOB CÒN SỐNG
--------------------------------------------------

local function HasMobs()
    local WorldMobs = workspace:FindFirstChild("World Mobs")

    if not WorldMobs then
        return false
    end

    for _, Mob in ipairs(WorldMobs:GetDescendants()) do
        if Mob:IsA("Model") then
            local Humanoid = Mob:FindFirstChildOfClass("Humanoid")

            if Humanoid and Humanoid.Health > 0 then
                return true
            end
        end
    end

    return false
end

--------------------------------------------------
-- CHECK LORD DESTROYER
--------------------------------------------------

local function HasLordDestroyer()
    local Stats = Player:FindFirstChild("Stats")
    local GamePasses = Stats and Stats:FindFirstChild("GamePasses")

    local LordDestroyer = GamePasses
        and GamePasses:FindFirstChild("Lord Destroyer")

    if not LordDestroyer then
        return false
    end

    local Value = LordDestroyer.Value

    return Value == true
        or Value == "Yes"
        or Value == "yes"
        or Value == 1
end

--------------------------------------------------
-- CHECK SKILL 108 ĐANG DÙNG
--------------------------------------------------

local function IsSkill108Busy()
    local Characters = workspace:FindFirstChild("Characters")

    if not Characters then
        return false
    end

    local Character = Characters:FindFirstChild(Player.Name)

    local Status = Character
        and Character:FindFirstChild("Status")

    local SkillAction = Status
        and Status:FindFirstChild("SkillAction")

    return SkillAction
        and SkillAction:FindFirstChild("108")
        ~= nil
end

--------------------------------------------------
-- FIRE SKILL 108
--------------------------------------------------

local function FireSkill108()
    if not HasMobs() then
        return false
    end

    if not HasLordDestroyer() then
        return false
    end

    if IsSkill108Busy() then
        return false
    end

    local args = {
        {
            Camera = CFrame.new(
                74.2727279663086,
                251.0009002685547,
                -28.747745513916016,

                -0.9511321783065796,
                -0.044049736112356186,
                0.3056260347366333,

                0,
                0.9897724390029907,
                0.14265543222427368,

                -0.308784157037735,
                0.13568417727947235,
                -0.9414043426513672
            ),

            SkillId = "108",
            Began = true,

            CFrame = CFrame.new(
                70.45240020751953,
                247.81771850585938,
                -16.98019027709961
            ),

            ["Typ\208\181"] = 1,

            Aim = Vector3.new(
                70.45240020751953,
                247.81771850585938,
                -66.98019409179688
            )
        }
    }

    pcall(function()
        SkillRemote:FireServer(unpack(args))
    end)

    return true
end

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

Tab3:AddToggle({
    Name = "Auto destory Smart",
    Default = true,
    Callback = function(Value)
        AutoDestroySmart = Value

        if Value then
            task.spawn(function()
                while AutoDestroySmart do
                    FireSkill108()
                    task.wait(0.5)
                end
            end)
        end
    end
})
local DAMAGE = 999999999
local INTERVAL = 1.2

local OneHit = true
local LoopRunning = false

local function GetAtomMax()
    local worldMobs = workspace:FindFirstChild("World Mobs")
    if not worldMobs then return nil end

    local eventMobs = worldMobs:FindFirstChild("Event Mobs")
    if not eventMobs then return nil end

    return eventMobs:FindFirstChild("Atom Max")
end

local function StartOneHitLoop()
    if LoopRunning then return end
    LoopRunning = true

    task.spawn(function()
        while OneHit do
            local atomMax = GetAtomMax()

            if atomMax then
                local humanoid = atomMax:FindFirstChildOfClass("Humanoid")

                if humanoid and humanoid.Health > 0 then
                    pcall(function()
                        humanoid:TakeDamage(DAMAGE)
                        humanoid.Health = math.max(
                            0,
                            humanoid.Health - DAMAGE
                        )
                    end)

                    print(
                        "Đã dame " ..
                        DAMAGE ..
                        " | HP còn lại: " ..
                        math.floor(humanoid.Health)
                    )
                end
            end

            task.wait(INTERVAL)
        end

        LoopRunning = false
    end)
end

Tab3:AddToggle({
    Name = "One Hit",
    Default = true,
    Callback = function(Value)
        OneHit = Value

        if Value then
            StartOneHitLoop()
        end
    end
})

-- Bật sẵn khi chạy script
StartOneHitLoop()

OrionLib:Init()
