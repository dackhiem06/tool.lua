-- [[ KHIEM ROBLOX - BLOX FRUITS ]] --

-- 1. CHỜ GAME LOAD
repeat wait() until game:IsLoaded()

-- 2. BIẾN TOÀN CỤC
_G.Settings = {
    SelectTeam = "Pirates", 
    AutoFarm = false,
    AutoBounty = false,      -- Bật/tắt săn người
    MinHealthToRun = 50,     -- Máu dưới 50% thì chạy
    MinHealthToBack = 75,    -- Máu trên 75% thì quay lại đánh
    Target = nil,            -- Mục tiêu hiện tại
    ShowGui = true,
    GuiColor = Color3.fromRGB(0, 150, 255) 
}

-- 3. CÁC HÀM HỖ TRỢ (Functions)

-- Hàm chọn phe
local function JoinTeam()
    pcall(function()
        if game:GetService("Players").LocalPlayer.Team == nil then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", _G.Settings.SelectTeam)
        end
    end)
end

-- Hàm tạo Giao diện
local function CreateKhiemGui()
    local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- 1. Hàm Tween (Di chuyển mượt mà)
local function TweenTo(Pos)
    local Distance = (LP.Character.HumanoidRootPart.Position - Pos.Position).Magnitude
    local Speed = 300 -- Tốc độ bay
    local Tween = game:GetService("TweenService"):Create(LP.Character.HumanoidRootPart, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear), {CFrame = Pos})
    Tween:Play()
    return Tween
end

-- 2. Hàm Click M1 siêu nhanh (1ms)
local function AutoClick()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(1280, 672))
end

-- 3. Hàm kiểm tra kẻ địch hợp lệ
local function GetTargets()
        -- 4. Hàm tự động cầm Trái Ác Quỷ
local function EquipFruit()
    local Character = LP.Character
    local Backpack = LP.Backpack
    
    -- Kiểm tra xem trên tay đã cầm Trái Ác Quỷ chưa
    for _, tool in pairs(Character:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Blox Fruit" or tool:FindFirstChild("EatRemote")) then
            return -- Đã cầm rồi thì thôi
        end
    end
    
    -- Nếu chưa cầm, tìm trong túi đồ (Backpack)
    for _, tool in pairs(Backpack:GetChildren()) do
        -- Blox Fruits định nghĩa Trái Ác Quỷ qua ToolTip hoặc các thuộc tính đặc trưng
        if tool:IsA("Tool") and (tool.ToolTip == "Blox Fruit" or tool:FindFirstChild("EatRemote")) then
            Character.Humanoid:EquipTool(tool)
            _G.KhiemPrint("Đã cầm: " .. tool.Name)
            break
        end
    end
end
    local Targets = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            -- Kiểm tra PvP và Safezone (Dựa trên folder Combat của game)
            if v.Character:FindFirstChild("CombatPD") or v.UserId % 2 == 0 then -- Kiểm tra tạm thời
                table.insert(Targets, v)
            end
        end
    end
    return Targets
end
    local ScreenGui = Instance.new("ScreenGui")
    local FloatingBtn = Instance.new("TextButton") -- Đổi thành TextButton để bắt sự kiện Click tốt hơn
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local LogPanel = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")

    ScreenGui.Name = "KhiemRobloxGui"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    -- Nút tròn nổi (Kích thước 45x45 cho vừa tay)
    FloatingBtn.Name = "FloatingBtn"
    FloatingBtn.Parent = ScreenGui
    FloatingBtn.BackgroundColor3 = _G.Settings.GuiColor
    FloatingBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
    FloatingBtn.Size = UDim2.new(0, 45, 0, 45)
    FloatingBtn.Text = "" -- Xóa chữ mặc định
    FloatingBtn.Active = true
    FloatingBtn.Draggable = true 

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = FloatingBtn
    
    UIStroke.Parent = FloatingBtn
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.4

    -- Bảng hiện Log
    LogPanel.Name = "LogPanel"
    LogPanel.Parent = ScreenGui -- Đưa ra ngoài ScreenGui để không bị lệ thuộc vị trí nút
    LogPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    LogPanel.BorderSizePixel = 0
    LogPanel.Position = UDim2.new(0.1, 55, 0.4, 0) -- Hiện cố định cạnh vị trí ban đầu của nút
    LogPanel.Size = UDim2.new(0, 260, 0, 180)
    LogPanel.Visible = false
    LogPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
    LogPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y

    UIListLayout.Parent = LogPanel
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    UIPadding.Parent = LogPanel
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 8)

    -- Thêm viền cho bảng Log
    local PanelStroke = Instance.new("UIStroke")
    PanelStroke.Parent = LogPanel
    PanelStroke.Color = _G.Settings.GuiColor
    PanelStroke.Thickness = 1

    -- Hàm Print của Khiêm
    _G.KhiemPrint = function(text)
        local Label = Instance.new("TextLabel")
        Label.Parent = LogPanel
        Label.Size = UDim2.new(1, -10, 0, 22)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamBold
        Label.Text = "> " .. tostring(text)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        LogPanel.CanvasPosition = Vector2.new(0, 9999)
    end

    -- SỰ KIỆN CLICK ĐỂ HIỆN BẢNG
    FloatingBtn.MouseButton1Click:Connect(function()
        LogPanel.Visible = not LogPanel.Visible
        -- Cập nhật vị trí bảng Log theo vị trí hiện tại của nút khi bấm
        LogPanel.Position = UDim2.new(0, FloatingBtn.AbsolutePosition.X + 55, 0, FloatingBtn.AbsolutePosition.Y - 50)
    end)
end

-- 4. THỰC THI
JoinTeam()
CreateKhiemGui()

_G.KhiemPrint("Khiêm Roblox Hub Loaded!")
_G.KhiemPrint("---------------------------")
_G.KhiemPrint("Phe: " .. _G.Settings.SelectTeam)

-- 5. VÒNG LẶP CHÍNH (PVP LOGIC)
spawn(function()
    while wait() do
        if _G.Settings.AutoBounty then
            local MyHuman = LP.Character:FindFirstChild("Humanoid")
            
            -- HỆ THỐNG HỒI MÁU (NÉ TRÁNH)
            if MyHuman and (MyHuman.Health / MyHuman.MaxHealth) * 100 < _G.Settings.MinHealthToRun then
                _G.KhiemPrint("Máu thấp! Đang bay lên cao hồi phục...")
                LP.Character.HumanoidRootPart.CFrame = CFrame.new(LP.Character.HumanoidRootPart.Position.X, 4000, LP.Character.HumanoidRootPart.Position.Z)
                repeat wait() until (MyHuman.Health / MyHuman.MaxHealth) * 100 > _G.Settings.MinHealthToBack
                _G.KhiemPrint("Máu đã ổn, quay lại trận chiến!")
            end

            -- HỆ THỐNG SĂN ĐUỔI
            local List = GetTargets()
            for _, Enemy in pairs(List) do
                if not _G.Settings.AutoBounty then break end
                
                _G.Settings.Target = Enemy
                _G.KhiemPrint("Đang nhắm vào: " .. Enemy.Name)

                while _G.Settings.AutoBounty and Enemy.Character and Enemy.Character.Humanoid.Health > 0 do
                    local EnemyPart = Enemy.Character:FindFirstChild("HumanoidRootPart")
                    if EnemyPart then
                        -- TWEEN ĐẾN SAU LƯNG ĐỐI THỦ
                        TweenTo(EnemyPart.CFrame * CFrame.new(0, 0, 3))
                        
                        -- [[ NEW ]] TỰ CẦM TRÁI ÁC QUỶ TRƯỚC KHI ĐÁNH
                        EquipFruit()
                        
                        -- SPAM CLICK 1ms
                        AutoClick()
                        
                        -- NÉ CHIÊU
                        if (LP.Character.HumanoidRootPart.Position - EnemyPart.Position).Magnitude < 10 then
                            LP.Character.HumanoidRootPart.CFrame = EnemyPart.CFrame * CFrame.new(0, 200, 0)
                            wait(0.5)
                        end
                    end
                    wait()
                end
                        -- Logic né: Bay lên cao 200m nếu đối thủ ở quá gần
                        if (LP.Character.HumanoidRootPart.Position - EnemyPart.Position).Magnitude < 10 then
                            -- Nhích nhẹ lên cao để tránh chiêu đánh lan
                            LP.Character.HumanoidRootPart.CFrame = EnemyPart.CFrame * CFrame.new(0, 200, 0)
                            wait(0.5)
                        end
                    end
                    wait()
                end
                _G.KhiemPrint("Đối thủ đã gục hoặc mất dấu!")
            end
        end
    end
end)
