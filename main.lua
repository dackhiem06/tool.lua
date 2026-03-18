-- [[ KHIEM ROBLOX - BLOX FRUITS ]] --

-- 1. CHỜ GAME LOAD
repeat wait() until game:IsLoaded()

-- 2. BIẾN TOÀN CỤC
_G.Settings = {
    SelectTeam = "Pirates", 
    AutoFarm = false,
    ShowGui = true,
    -- Đổi sang màu Xanh Dương Neon
    GuiColor = Color3.fromRGB(0, 150, 255) 
}

-- 3. CÁC HÀM HỖ TRỢ (Functions)

-- Hàm chọn phe
local function JoinTeam()
    local success, err = pcall(function()
        if game:GetService("Players").LocalPlayer.Team == nil then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", _G.Settings.SelectTeam)
        end
    end)
end

-- Hàm tạo Giao diện (Đã đưa ra ngoài để không bị lỗi)
local function CreateKhiemGui()
    local ScreenGui = Instance.new("ScreenGui")
    local FloatingBtn = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke") -- Thêm viền cho đẹp
    local LogPanel = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")

    ScreenGui.Name = "KhiemRobloxGui"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    -- Nút tròn nổi màu Xanh (Đã thu nhỏ)
    FloatingBtn.Name = "FloatingBtn"
    FloatingBtn.Parent = ScreenGui
    FloatingBtn.BackgroundColor3 = _G.Settings.GuiColor
    FloatingBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
    FloatingBtn.Size = UDim2.new(0, 40, 0, 40) -- Kích thước mới nhỏ gọn
    FloatingBtn.Active = true
    FloatingBtn.Draggable = true 

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = FloatingBtn
    
    -- Thêm viền trắng mờ cho nút
    UIStroke.Parent = FloatingBtn
    UIStroke.Thickness = 1.5 -- Giảm độ dày viền cho hợp với nút nhỏ
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.5

    -- Bảng hiện Log (Giao diện đen xanh)
    LogPanel.Name = "LogPanel"
    LogPanel.Parent = FloatingBtn
    LogPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20) 
    LogPanel.BackgroundTransparency = 0.2
    LogPanel.Position = UDim2.new(1.1, 0, -2, 0) -- Nhích lại gần nút hơn

    UIListLayout.Parent = LogPanel
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    UIPadding.Parent = LogPanel
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 10)

    -- Hàm Print riêng của Khiêm Roblox
    _G.KhiemPrint = function(text)
        local Label = Instance.new("TextLabel")
        Label.Parent = LogPanel
        Label.Size = UDim2.new(1, -10, 0, 25)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(200, 230, 255) -- Chữ xanh nhạt
        Label.TextSize = 14
        Label.Font = Enum.Font.GothamBold
        Label.Text = "[Khiêm Log]: " .. text
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Tự cuộn xuống dưới cùng
        LogPanel.CanvasPosition = Vector2.new(0, 9999)
    end

    -- Bấm nút hiện bảng
    FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            LogPanel.Visible = not LogPanel.Visible
        end
    end)
end

-- 4. THỰC THI
JoinTeam()
CreateKhiemGui()

_G.KhiemPrint("Chào mừng đến với Khiêm Roblox Hub!")
_G.KhiemPrint("Đang khởi tạo hệ thống...")
_G.KhiemPrint("Đã chọn phe: " .. _G.Settings.SelectTeam)

-- 5. VÒNG LẶP CHÍNH
spawn(function()
    while wait() do
        if _G.Settings.AutoFarm then
            -- Chỗ này để viết Auto Farm
        end
    end
end)
