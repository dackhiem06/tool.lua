-- [[ KHIEM ROBLOX - BLOX FRUITS ]] --

-- 1. CHỜ GAME LOAD
repeat wait() until game:IsLoaded()

-- 2. BIẾN TOÀN CỤC
_G.Settings = {
    SelectTeam = "Pirates", 
    AutoBounty = true, -- Bật sẵn để bạn test luôn
    MinHealthToRun = 50,
    MinHealthToBack = 75,
    GuiColor = Color3.fromRGB(0, 150, 255) 
}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- 3. CÁC HÀM HỖ TRỢ (Functions)

local function JoinTeam()
    pcall(function()
        if LP.Team == nil then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", _G.Settings.SelectTeam)
        end
    end)
end

local function TweenTo(Pos)
    local Distance = (LP.Character.HumanoidRootPart.Position - Pos.Position).Magnitude
    local Speed = 300 
    local Tween = game:GetService("TweenService"):Create(LP.Character.HumanoidRootPart, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear), {CFrame = Pos})
    Tween:Play()
    return Tween
end

local function AutoClick()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
end

local function GetTargets()
    local Targets = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            table.insert(Targets, v)
        end
    end
    return Targets
end

local function EquipFruit()
    local Character = LP.Character
    local Backpack = LP.Backpack
    for _, tool in pairs(Character:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Blox Fruit" or tool:FindFirstChild("EatRemote")) then
            return 
        end
    end
    for _, tool in pairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Blox Fruit" or tool:FindFirstChild("EatRemote")) then
            Character.Humanoid:EquipTool(tool)
            break
        end
    end
end

local function CreateKhiemGui()
    local ScreenGui = Instance.new("ScreenGui")
    local FloatingBtn = Instance.new("TextButton")
    local LogPanel = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")

    ScreenGui.Name = "KhiemRobloxGui"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    FloatingBtn.Name = "FloatingBtn"
    FloatingBtn.Parent = ScreenGui
    FloatingBtn.BackgroundColor3 = _G.Settings.GuiColor
    FloatingBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
    FloatingBtn.Size = UDim2.new(0, 45, 0, 45)
    FloatingBtn.Text = ""
    FloatingBtn.Active = true
    FloatingBtn.Draggable = true 
    Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(1, 0)

    LogPanel.Name = "LogPanel"
    LogPanel.Parent = ScreenGui
    LogPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    LogPanel.Position = UDim2.new(0.1, 55, 0.4, 0)
    LogPanel.Size = UDim2.new(0, 260, 0, 180)
    LogPanel.Visible = false
    LogPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    UIListLayout.Parent = LogPanel

    _G.KhiemPrint = function(text)
        local Label = Instance.new("TextLabel")
        Label.Parent = LogPanel
        Label.Size = UDim2.new(1, -10, 0, 22)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Text = "> " .. tostring(text)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        LogPanel.CanvasPosition = Vector2.new(0, 9999)
    end

    FloatingBtn.MouseButton1Click:Connect(function()
        LogPanel.Visible = not LogPanel.Visible
        LogPanel.Position = UDim2.new(0, FloatingBtn.AbsolutePosition.X + 55, 0, FloatingBtn.AbsolutePosition.Y - 50)
    end)
end

-- 4. THỰC THI
JoinTeam()
CreateKhiemGui()
_G.KhiemPrint("Khiêm Roblox Hub v2.0 Loaded!")

-- 5. VÒNG LẶP CHÍNH
spawn(function()
    while wait() do
        if _G.Settings.AutoBounty then
            pcall(function()
                local MyHuman = LP.Character:FindFirstChild("Humanoid")
                
                -- Hồi máu
                if MyHuman and (MyHuman.Health / MyHuman.MaxHealth) * 100 < _G.Settings.MinHealthToRun then
                    _G.KhiemPrint("Máu thấp! Đang chạy...")
                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(LP.Character.HumanoidRootPart.Position.X, 4000, LP.Character.HumanoidRootPart.Position.Z)
                    repeat wait() until (MyHuman.Health / MyHuman.MaxHealth) * 100 > _G.Settings.MinHealthToBack
                end

                -- Săn người
                local List = GetTargets()
                for _, Enemy in pairs(List) do
                    if not _G.Settings.AutoBounty then break end
                    while _G.Settings.AutoBounty and Enemy.Character and Enemy.Character.Humanoid.Health > 0 do
                        local EnemyPart = Enemy.Character:FindFirstChild("HumanoidRootPart")
                        if EnemyPart then
                            TweenTo(EnemyPart.CFrame * CFrame.new(0, 0, 5))
                            EquipFruit()
                            AutoClick()
                            -- Né chiêu
                            if (LP.Character.HumanoidRootPart.Position - EnemyPart.Position).Magnitude < 15 then
                                LP.Character.HumanoidRootPart.CFrame = EnemyPart.CFrame * CFrame.new(0, 150, 0)
                                wait(0.5)
                            end
                        end
                        wait()
                    end
                end
            end)
        end
    end
end)
