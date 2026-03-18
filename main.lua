-- [[ KHIEM ROBLOX V3.0 - PVP PRO ]] --

-- 1. CHỜ GAME LOAD
repeat wait() until game:IsLoaded()

-- 2. BIẾN TOÀN CỤC & VỊ TRÍ AN TOÀN
_G.Settings = {
    SelectTeam = "Pirates", 
    AutoBounty = true,
    MinHealthToRun = 50,
    MinHealthToBack = 75,
    GuiColor = Color3.fromRGB(0, 150, 255),
    SafeZonePos = CFrame.new(-480, 20, 715) -- Bạn có thể đổi tọa độ này thành Safe Zone bất kỳ
}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")

-- 3. CÁC HÀM TỐI ƯU HÓA

-- Hàm Click siêu tốc (Dùng RenderStepped để bỏ qua giới hạn wait)
local function UltraClick()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
end

-- Hàm di chuyển tức thời (Teleport thay vì Tween để né đòn)
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

-- 4. GIAO DIỆN (Giữ nguyên cấu trúc cũ nhưng đổi tên v3)
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

-- 5. VÒNG LẶP CHÍNH (PVP RE-STRUCTURED)
JoinTeam()
CreateKhiemGui()
_G.KhiemPrint("Khiêm Roblox v3.0 - Đã tối ưu Click & Tele!")

spawn(function()
    while true do
        task.wait()
        if _G.Settings.AutoBounty and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local MyHuman = LP.Character.Humanoid
            
            -- LOGIC CHẠY TRỐN (Sửa lỗi hồi máu)
            if (MyHuman.Health / MyHuman.MaxHealth) * 100 < _G.Settings.MinHealthToRun then
                _G.KhiemPrint("Máu nguy kịch! Trốn thoát...")
                while (MyHuman.Health / MyHuman.MaxHealth) * 100 < _G.Settings.MinHealthToBack do
                    -- Bay lên trời và liên tục dịch chuyển vị trí để khó bị nhắm
                    Teleport(CFrame.new(math.random(1000, 5000), 4000, math.random(1000, 5000)))
                    task.wait(0.5)
                end
                _G.KhiemPrint("Đã hồi phục, tiếp tục săn!")
            end

            -- LOGIC CHIẾN ĐẤU (Tele né đòn liên tục)
            local List = GetTargets()
            for _, Enemy in pairs(List) do
                if not _G.Settings.AutoBounty then break end
                
                while _G.Settings.AutoBounty and Enemy.Character and Enemy.Character:FindFirstChild("Humanoid") and Enemy.Character.Humanoid.Health > 0 do
                    local EnemyPart = Enemy.Character:FindFirstChild("HumanoidRootPart")
                    if EnemyPart then
                        EquipFruit()
                        
                        -- FAST CLICK (Chạy song song)
                        task.spawn(UltraClick)

                        -- NHẢY VỊ TRÍ: Giữa SafeZone (hoặc vị trí né) và kẻ địch
                        -- Nhịp 1: Tele đến sát kẻ địch để đánh
                        Teleport(EnemyPart.CFrame * CFrame.new(0, 0, 3))
                        task.wait(0.1) -- Đứng lại 0.1s để gây dame
                        
                        -- Nhịp 2: Tele ra vị trí an toàn hoặc lùi xa 50m để né chiêu
                        Teleport(EnemyPart.CFrame * CFrame.new(0, 50, 50))
                        task.wait(0.05)
                        
                        -- Nếu máu tụt bất ngờ trong lúc đánh
                        if (MyHuman.Health / MyHuman.MaxHealth) * 100 < _G.Settings.MinHealthToRun then break end
                    else
                        break
                    end
                end
            end
        end
    end
end)
