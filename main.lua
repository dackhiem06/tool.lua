-- [[ KHIEM ROBLOX V3.5 - OPTIMIZED PVP ]] --

-- 1. CHỜ GAME LOAD
repeat task.wait() until game:IsLoaded()

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

-- 3. CÁC HÀM HỖ TRỢ

-- Hàm Click siêu tốc (Chạy độc lập)
spawn(function()
    while task.wait() do
        if _G.Settings.AutoBounty and LP.Character and LP.Character:FindFirstChild("Humanoid") then
            -- Chỉ click khi đang ở gần kẻ địch (dưới 50m) để tránh lỗi game
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
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = Pos
    end
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
        if tool:IsA("Tool") and (tool.ToolTip == "Blox Fruit" or tool:FindFirstChild("EatRemote")) then return end
    end
    for _, tool in pairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Blox Fruit" or tool:FindFirstChild("EatRemote")) then
            Character.Humanoid:EquipTool(tool)
            break
        end
    end
end

-- 4. GIAO DIỆN (Đã sửa lỗi hiển thị)
local function CreateKhiemGui()
    local ScreenGui = Instance.new("ScreenGui")
    local FloatingBtn = Instance.new("TextButton")
    local LogPanel = Instance.new("ScrollingFrame")
    ScreenGui.Name = "KhiemRobloxGui"
    ScreenGui.Parent = game:GetService("CoreGui")
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
    _G.KhiemPrint = function(text)
        local Label = Instance.new("TextLabel")
        Label.Parent = LogPanel
        Label.Size = UDim2.new(1, -10, 0, 22)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Text = "> " .. tostring(text)
        LogPanel.CanvasPosition = Vector2.new(0, 9999)
    end
    FloatingBtn.MouseButton1Click:Connect(function() LogPanel.Visible = not LogPanel.Visible end)
end

-- 5. VÒNG LẶP CHÍNH (FIXED LOGIC)
if LP.Team == nil then
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", _G.Settings.SelectTeam)
end
CreateKhiemGui()
_G.KhiemPrint("Khiêm Roblox v3.5 - Chiến đấu ngay!")

spawn(function()
    while task.wait() do
        if _G.Settings.AutoBounty and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local MyHuman = LP.Character.Humanoid
            
            -- KIỂM TRA MÁU (Hồi máu an toàn)
            if (MyHuman.Health / MyHuman.MaxHealth) * 100 < _G.Settings.MinHealthToRun then
                _G.KhiemPrint("Máu thấp! Đang né tránh...")
                repeat
                    -- Tele ngẫu nhiên trên trời để không ai bắn trúng
                    Teleport(CFrame.new(math.random(-5000, 5000), 4000, math.random(-5000, 5000)))
                    task.wait(0.3)
                until (MyHuman.Health / MyHuman.MaxHealth) * 100 >= _G.Settings.MinHealthToBack or not _G.Settings.AutoBounty
                _G.KhiemPrint("Hồi phục xong! Quay lại săn...")
            end

            -- QUÉT KẺ ĐỊCH
            local List = GetTargets()
            for _, Enemy in pairs(List) do
                if not _G.Settings.AutoBounty then break end
                _G.CurrentTarget = Enemy -- Gửi mục tiêu cho vòng lặp Click

                while _G.Settings.AutoBounty and Enemy.Character and Enemy.Character:FindFirstChild("Humanoid") and Enemy.Character.Humanoid.Health > 0 do
                    local EnemyPart = Enemy.Character:FindFirstChild("HumanoidRootPart")
                    if EnemyPart then
                        EquipFruit()
                        
                        -- KIỂM TRA MÁU TRONG KHI ĐANG ĐÁNH
                        if (MyHuman.Health / MyHuman.MaxHealth) * 100 < _G.Settings.MinHealthToRun then break end

                        -- NHẢY TELE (BLINK) ĐỂ NÉ ĐÒN
                        -- Nhịp 1: Áp sát sau lưng
                        Teleport(EnemyPart.CFrame * CFrame.new(0, 0, 3))
                        task.wait(0.1)
                        
                        -- Nhịp 2: Văng lên cao né chiêu
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
