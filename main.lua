-- [[ KHIEM ROBLOX V3.6 - FIX AUTO TEAM ]] --

-- 1. CHỜ GAME LOAD
if not game:IsLoaded() then game.Loaded:Wait() end

-- 2. BIẾN TOÀN CỤC
_G.Settings = {
    SelectTeam = "Pirates", 
    AutoBounty = true,
    MinHealthToRun = 50,
    MinHealthToBack = 75,
    GuiColor = Color3.fromRGB(0, 150, 255)
}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- 3. HÀM CHỌN PHE (Cải tiến: Chạy vòng lặp cho đến khi vào được team)
local function AutoJoinTeam()
    spawn(function()
        while task.wait(1) do
            -- Kiểm tra nếu chưa có phe hoặc phe là Neutral
            if LP.Team == nil or LP.Team.Name == "Neutral" then
                pcall(function()
                    -- Gửi lệnh chọn phe đến server
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", _G.Settings.SelectTeam)
                end)
            else
                -- Nếu đã vào phe thành công thì dừng vòng lặp này
                break 
            end
        end
    end)
end

-- 4. CÁC HÀM HỖ TRỢ CHIẾN ĐẤU (Giữ nguyên logic v3.5)
spawn(function()
    while task.wait() do
        if _G.Settings.AutoBounty and LP.Character and LP.Character:FindFirstChild("Humanoid") then
            local Target = _G.CurrentTarget
            if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                local Dist = (LP.Character.HumanoidRootPart.Position - Target.Character.HumanoidRootPart.Position).Magnitude
                if Dist < 60 then
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                end
            end
        end
    end
end)

local function Teleport(Pos)
    pcall(function()
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = Pos
        end
    end)
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
    if not Character then return end
    for _, tool in pairs(Character:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Blox Fruit" or tool:FindFirstChild("EatRemote")) then return end
    end
    for _, tool in pairs(LP.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Blox Fruit" or tool:FindFirstChild("EatRemote")) then
            Character.Humanoid:EquipTool(tool)
            break
        end
    end
end

-- 5. GIAO DIỆN
local function CreateKhiemGui()
    local ScreenGui = Instance.new("ScreenGui")
    local FloatingBtn = Instance.new("TextButton")
    local LogPanel = Instance.new("ScrollingFrame")
    ScreenGui.Name = "KhiemRobloxGui"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false
    
    FloatingBtn.Parent = ScreenGui
    FloatingBtn.BackgroundColor3 = _G.Settings.GuiColor
    FloatingBtn.Size = UDim2.new(0, 45, 0, 45)
    FloatingBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
    FloatingBtn.Draggable = true
    Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(1, 0)
    
    LogPanel.Parent = ScreenGui
    LogPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    LogPanel.Position = UDim2.new(0.1, 55, 0.4, 0)
    LogPanel.Size = UDim2.new(0, 260, 0, 180)
    LogPanel.Visible = false
    LogPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", LogPanel)

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
    FloatingBtn.MouseButton1Click:Connect(function() LogPanel.Visible = not LogPanel.Visible end)
end

-- 6. THỰC THI CHÍNH
AutoJoinTeam() -- Gọi hàm chọn phe liên tục
CreateKhiemGui()
_G.KhiemPrint("Khiêm Roblox v3.6 - Fix Auto Team!")

spawn(function()
    while task.wait() do
        if _G.Settings.AutoBounty and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local MyHuman = LP.Character.Humanoid
            
            -- KIỂM TRA MÁU (Hồi máu)
            if (MyHuman.Health / MyHuman.MaxHealth) * 100 < _G.Settings.MinHealthToRun then
                _G.KhiemPrint("Máu thấp! Đang né tránh...")
                repeat
                    Teleport(CFrame.new(math.random(-5000, 5000), 4000, math.random(-5000, 5000)))
                    task.wait(0.5)
                until (MyHuman.Health / MyHuman.MaxHealth) * 100 >= _G.Settings.MinHealthToBack or not _G.Settings.AutoBounty
                _G.KhiemPrint("Tiếp tục săn đuổi!")
            end

            -- CHIẾN ĐẤU
            local List = GetTargets()
            for _, Enemy in pairs(List) do
                if not _G.Settings.AutoBounty then break end
                _G.CurrentTarget = Enemy

                while _G.Settings.AutoBounty and Enemy.Character and Enemy.Character:FindFirstChild("Humanoid") and Enemy.Character.Humanoid.Health > 0 do
                    local EnemyPart = Enemy.Character:FindFirstChild("HumanoidRootPart")
                    if EnemyPart then
                        EquipFruit()
                        if (MyHuman.Health / MyHuman.MaxHealth) * 100 < _G.Settings.MinHealthToRun then break end

                        -- Blink chiến đấu
                        Teleport(EnemyPart.CFrame * CFrame.new(0, 0, 3))
                        task.wait(0.1)
                        Teleport(EnemyPart.CFrame * CFrame.new(math.random(-20, 20), 50, math.random(-20, 20)))
                        task.wait(0.05)
                    else
                        break
                    end
                end
                _G.CurrentTarget = nil
            end
        end
    end
end)
