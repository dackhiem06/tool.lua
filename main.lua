-- [[ KHIEM ROBLOX - BLOX FRUITS ]] --

-- 1. CHỜ GAME LOAD
repeat wait() until game:IsLoaded()

-- 2. BIẾN TOÀN CỤC
_G.Settings = {
    SelectTeam = "Pirates", 
    AutoFarm = false,
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

-- 5. VÒNG LẶP CHÍNH
spawn(function()
    while wait() do
        if _G.Settings.AutoFarm then
            -- Chờ code farm tiếp theo
        end
    end
end)
