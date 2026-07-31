local espModule = {}

espModule.Settings = {
    Enabled = true,
    Enemy = {
        Enabled = true,
        BoxEnabled = true,
        BoxType = "Corner",
        Thickness = 1,
        Names = true,
        Distance = true,
        Tool = true,
        HealthBar = true,
        HealthText = true,
        TextSize = 10,
        Skeleton = false,
        SkeletonThickness = 1,
        Chams = false,
        ChamsFillTransparency = 0.5,
        ChamsOutlineTransparency = 0,
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(255, 80, 80),
        TextColor = Color3.fromRGB(255, 255, 255),
        HealthTop = Color3.fromRGB(0, 255, 100),
        HealthBottom = Color3.fromRGB(255, 40, 40),
        SkeletonColor = Color3.fromRGB(255, 80, 80),
        ChamsFillColor = Color3.fromRGB(255, 80, 80),
        ChamsOutlineColor = Color3.fromRGB(255, 80, 80),
        TracerColor = Color3.fromRGB(255, 80, 80),
    },
    Teammate = {
        Enabled = true,
        BoxEnabled = true,
        BoxType = "Corner",
        Thickness = 1,
        Names = true,
        Distance = true,
        Tool = true,
        HealthBar = true,
        HealthText = true,
        TextSize = 10,
        Skeleton = true,
        SkeletonThickness = 0.1,
        Chams = true,
        ChamsFillTransparency = 0.1,
        ChamsOutlineTransparency = 0,
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(0, 180, 255),
        TextColor = Color3.fromRGB(180, 230, 255),
        HealthTop = Color3.fromRGB(0, 200, 255),
        HealthBottom = Color3.fromRGB(30, 80, 140),
        SkeletonColor = Color3.fromRGB(0, 180, 255),
        ChamsFillColor = Color3.fromRGB(0, 180, 255),
        ChamsOutlineColor = Color3.fromRGB(0, 180, 255),
        TracerColor = Color3.fromRGB(0, 180, 255),
    },
    AI = {
        Enabled = true,
        BoxEnabled = true,
        BoxType = "Corner",
        Thickness = 1,
        Names = true,
        Distance = true,
        Tool = true,
        HealthBar = true,
        HealthText = true,
        TextSize = 10,
        Skeleton = false,
        SkeletonThickness = 1,
        Chams = false,
        ChamsFillTransparency = 0.5,
        ChamsOutlineTransparency = 0,
        Tracers = false,
        TracerThickness = 1,
        TracerOrigin = "Bottom",
        LineColor = Color3.fromRGB(255, 200, 50),
        TextColor = Color3.fromRGB(255, 255, 255),
        HealthTop = Color3.fromRGB(0, 255, 100),
        HealthBottom = Color3.fromRGB(255, 40, 40),
        SkeletonColor = Color3.fromRGB(255, 200, 50),
        ChamsFillColor = Color3.fromRGB(255, 200, 50),
        ChamsOutlineColor = Color3.fromRGB(255, 200, 50),
        TracerColor = Color3.fromRGB(255, 200, 50),
    },
}

espModule._drawings = {}
espModule._highlights = {}
espModule._isRunning = false
espModule._connections = {}

local cloneref = cloneref or function(...) return ... end
local GetService = setmetatable({}, {
    __index = function(self, key)
        return cloneref(game:GetService(key))
    end
})

local Services = {
    RunService = GetService.RunService,
    Players = GetService.Players,
    UserInputService = GetService.UserInputService,
    CoreGui = GetService.CoreGui,
    WorkSpace = GetService.Workspace,
}
Services.CurrentCamera = Services.WorkSpace.CurrentCamera
Services.LocalPlayer = Services.Players.LocalPlayer

local PixelFont = nil
local function loadFont()
    local FONT_URL = "https://raw.githubusercontent.com/i77lhm/storage/main/fonts/smallest_pixel-7.ttf"
    local ok, data = pcall(game.HttpGet, game, FONT_URL)
    if ok and data and #data > 100 then
        local f = Drawing.new("Font")
        f.Data = data
        PixelFont = f
    end
end

local function isTeammate(player)
    if not player or player == Services.LocalPlayer then return false end
    if player.Team and player.Team == Services.LocalPlayer.Team then
        return true
    end
    local character = player.Character
    if character and character:FindFirstChild("SquadBillboard") then
        return true
    end
    return false
end

local function Create(type, props)
    local obj = Drawing.new(type)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

local function CreateEntityESP(entity)
    if espModule._drawings[entity] then return end
    
    local function MakeBone()
        return {
            Outline = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            Line = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        }
    end
    
    local segs = {}
    for i = 1, 64 do
        segs[i] = Create("Square", {Filled = true, Visible = false, ZIndex = 4})
    end
    
    espModule._drawings[entity] = {
        FullOutline = {
            Top = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            Bottom = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            Left = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            Right = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
        },
        Full = {
            Top = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Bottom = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Left = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            Right = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        },
        CornerOutline = {
            TL1 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            TL2 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            TR1 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            TR2 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BL1 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BL2 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BR1 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
            BR2 = Create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 1}),
        },
        Corner = {
            TL1 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TL2 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TR1 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            TR2 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BL1 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BL2 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BR1 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
            BR2 = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        },
        HealthBGOutline = Create("Square", {Filled = false, Thickness = 1, Color = Color3.new(0, 0, 0), Visible = false, ZIndex = 2}),
        HealthBG = Create("Square", {Filled = true, Color = Color3.fromRGB(15, 15, 15), Visible = false, ZIndex = 3}),
        HealthSegments = segs,
        HealthText = Create("Text", {Center = false, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = PixelFont or Drawing.Fonts.Monospace, Visible = false, ZIndex = 5}),
        NameText = Create("Text", {Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = PixelFont or Drawing.Fonts.Monospace, Visible = false, ZIndex = 5}),
        DistanceText = Create("Text", {Center = false, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = PixelFont or Drawing.Fonts.Monospace, Visible = false, ZIndex = 5}),
        ToolText = Create("Text", {Center = true, Outline = true, OutlineColor = Color3.new(0, 0, 0), Size = 10, Color = Color3.new(1, 1, 1), Font = PixelFont or Drawing.Fonts.Monospace, Visible = false, ZIndex = 5}),
        Tracer = Create("Line", {Thickness = 1, Color = Color3.new(1, 1, 1), Visible = false, ZIndex = 2}),
        Skeleton = {
            HeadTorso = MakeBone(),
            TorsoHip = MakeBone(),
            HipL = MakeBone(),
            HipR = MakeBone(),
            LLeg = MakeBone(),
            RLeg = MakeBone(),
            LArm = MakeBone(),
            RArm = MakeBone(),
            LFore = MakeBone(),
            RFore = MakeBone(),
        }
    }
end

local function HideESP(data)
    for _, v in pairs(data.FullOutline) do v.Visible = false end
    for _, v in pairs(data.Full) do v.Visible = false end
    for _, v in pairs(data.CornerOutline) do v.Visible = false end
    for _, v in pairs(data.Corner) do v.Visible = false end
    data.HealthBG.Visible = false
    data.HealthBGOutline.Visible = false
    for i = 1, #data.HealthSegments do
        data.HealthSegments[i].Visible = false
    end
    data.HealthText.Visible = false
    data.NameText.Visible = false
    data.DistanceText.Visible = false
    data.ToolText.Visible = false
    data.Tracer.Visible = false
    for _, bone in pairs(data.Skeleton) do
        bone.Outline.Visible = false
        bone.Line.Visible = false
    end
end

local function RemoveESP(entity)
    local data = espModule._drawings[entity]
    if not data then return end
    for _, v in pairs(data.FullOutline) do v:Remove() end
    for _, v in pairs(data.Full) do v:Remove() end
    for _, v in pairs(data.CornerOutline) do v:Remove() end
    for _, v in pairs(data.Corner) do v:Remove() end
    data.HealthBG:Remove()
    data.HealthBGOutline:Remove()
    for i = 1, #data.HealthSegments do
        data.HealthSegments[i]:Remove()
    end
    data.HealthText:Remove()
    data.NameText:Remove()
    data.DistanceText:Remove()
    data.ToolText:Remove()
    data.Tracer:Remove()
    for _, bone in pairs(data.Skeleton) do
        bone.Outline:Remove()
        bone.Line:Remove()
    end
    espModule._drawings[entity] = nil
    if espModule._highlights[entity] then
        espModule._highlights[entity]:Destroy()
        espModule._highlights[entity] = nil
    end
end

local function ProcessEntity(entity)
    if entity == Services.LocalPlayer then return end
    local character
    local isPlayer = false
    if typeof(entity) == "Instance" and entity:IsA("Player") then
        isPlayer = true
        character = entity.Character
    else
        character = entity
    end
    if not character then return end
    
    if isPlayer then
        local inRaid = entity:FindFirstChild("InRaid")
        if not inRaid or not inRaid:IsA("BoolValue") or not inRaid.Value then
            if espModule._drawings[entity] then
                HideESP(espModule._drawings[entity])
                if espModule._highlights[entity] then espModule._highlights[entity].Enabled = true end
            end
            return
        end
    end
    
    CreateEntityESP(entity)
    local data = espModule._drawings[entity]
    local cfg
    if isPlayer then
        local teammate = isTeammate(entity)
        cfg = teammate and espModule.Settings.Teammate or espModule.Settings.Enemy
    else
        cfg = espModule.Settings.AI
    end
    
    if not cfg.Enabled then
        HideESP(data)
        if espModule._highlights[entity] then espModule._highlights[entity].Enabled = false end
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local Camera = Services.WorkSpace.CurrentCamera
    local viewport = Camera.ViewportSize
    
    if not (hrp and humanoid and humanoid.Health > 0) then
        HideESP(data)
        if espModule._highlights[entity] then espModule._highlights[entity].Enabled = false end
        return
    end
    
    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if not onScreen or hrpPos.Z <= 0 then
        HideESP(data)
        if espModule._highlights[entity] then espModule._highlights[entity].Enabled = false end
        return
    end
    
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local validParts = 0
    
    for _, partName in ipairs({"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "Torso", "LeftHand", "RightHand", "LeftFoot", "RightFoot", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            local cf = part.CFrame
            local s = part.Size * 0.5
            local corners = {
                cf * Vector3.new(-s.X, -s.Y, -s.Z),
                cf * Vector3.new(-s.X, -s.Y, s.Z),
                cf * Vector3.new(-s.X, s.Y, -s.Z),
                cf * Vector3.new(-s.X, s.Y, s.Z),
                cf * Vector3.new( s.X, -s.Y, -s.Z),
                cf * Vector3.new( s.X, -s.Y, s.Z),
                cf * Vector3.new( s.X, s.Y, -s.Z),
                cf * Vector3.new( s.X, s.Y, s.Z),
            }
            for _, c in ipairs(corners) do
                local sp = Camera:WorldToViewportPoint(c)
                if sp.Z > 0 then
                    validParts = validParts + 1
                    if sp.X < minX then minX = sp.X end
                    if sp.Y < minY then minY = sp.Y end
                    if sp.X > maxX then maxX = sp.X end
                    if sp.Y > maxY then maxY = sp.Y end
                end
            end
        end
    end
    
    if validParts == 0 then
        HideESP(data)
        return
    end
    
    local x = math.floor(minX + 0.5)
    local y = math.floor(minY + 0.5)
    local sx = math.max(math.floor(maxX - minX + 0.5), 6)
    local sy = math.max(math.floor(maxY - minY + 0.5), 6)
    local rawStuds = (Camera.CFrame.Position - hrp.Position).Magnitude
    local meters = math.floor(rawStuds / 2.81 + 0.5)
    
    for _, v in pairs(data.FullOutline) do v.Visible = false end
    for _, v in pairs(data.Full) do v.Visible = false end
    for _, v in pairs(data.CornerOutline) do v.Visible = false end
    for _, v in pairs(data.Corner) do v.Visible = false end
    
    if cfg.BoxEnabled then
        if cfg.BoxType == "Full" then
            data.FullOutline.Top.From = Vector2.new(x - 1, y)
            data.FullOutline.Top.To = Vector2.new(x + sx + 1, y)
            data.FullOutline.Top.Visible = true
            data.FullOutline.Bottom.From = Vector2.new(x - 1, y + sy)
            data.FullOutline.Bottom.To = Vector2.new(x + sx + 1, y + sy)
            data.FullOutline.Bottom.Visible = true
            data.FullOutline.Left.From = Vector2.new(x, y - 1)
            data.FullOutline.Left.To = Vector2.new(x, y + sy + 1)
            data.FullOutline.Left.Visible = true
            data.FullOutline.Right.From = Vector2.new(x + sx, y - 1)
            data.FullOutline.Right.To = Vector2.new(x + sx, y + sy + 1)
            data.FullOutline.Right.Visible = true
            
            data.Full.Top.From = Vector2.new(x, y)
            data.Full.Top.To = Vector2.new(x + sx, y)
            data.Full.Top.Color = cfg.LineColor
            data.Full.Top.Thickness = cfg.Thickness
            data.Full.Top.Visible = true
            data.Full.Bottom.From = Vector2.new(x, y + sy)
            data.Full.Bottom.To = Vector2.new(x + sx, y + sy)
            data.Full.Bottom.Color = cfg.LineColor
            data.Full.Bottom.Thickness = cfg.Thickness
            data.Full.Bottom.Visible = true
            data.Full.Left.From = Vector2.new(x, y)
            data.Full.Left.To = Vector2.new(x, y + sy)
            data.Full.Left.Color = cfg.LineColor
            data.Full.Left.Thickness = cfg.Thickness
            data.Full.Left.Visible = true
            data.Full.Right.From = Vector2.new(x + sx, y)
            data.Full.Right.To = Vector2.new(x + sx, y + sy)
            data.Full.Right.Color = cfg.LineColor
            data.Full.Right.Thickness = cfg.Thickness
            data.Full.Right.Visible = true
        else
            local len = math.clamp(0.22 + (rawStuds / 400) * 0.18, 0.22, 0.38)
            local cw = math.max(2, math.floor(sx * len + 0.5))
            local ch = math.max(2, math.floor(sy * len + 0.5))
            
            data.CornerOutline.TL1.From = Vector2.new(x - 1, y)
            data.CornerOutline.TL1.To = Vector2.new(x + cw + 1, y)
            data.CornerOutline.TL1.Visible = true
            data.CornerOutline.TL2.From = Vector2.new(x, y - 1)
            data.CornerOutline.TL2.To = Vector2.new(x, y + ch + 1)
            data.CornerOutline.TL2.Visible = true
            data.CornerOutline.TR1.From = Vector2.new(x + sx + 1, y)
            data.CornerOutline.TR1.To = Vector2.new(x + sx - cw - 1, y)
            data.CornerOutline.TR1.Visible = true
            data.CornerOutline.TR2.From = Vector2.new(x + sx, y - 1)
            data.CornerOutline.TR2.To = Vector2.new(x + sx, y + ch + 1)
            data.CornerOutline.TR2.Visible = true
            data.CornerOutline.BL1.From = Vector2.new(x - 1, y + sy)
            data.CornerOutline.BL1.To = Vector2.new(x + cw + 1, y + sy)
            data.CornerOutline.BL1.Visible = true
            data.CornerOutline.BL2.From = Vector2.new(x, y + sy + 1)
            data.CornerOutline.BL2.To = Vector2.new(x, y + sy - ch - 1)
            data.CornerOutline.BL2.Visible = true
            data.CornerOutline.BR1.From = Vector2.new(x + sx + 1, y + sy)
            data.CornerOutline.BR1.To = Vector2.new(x + sx - cw - 1, y + sy)
            data.CornerOutline.BR1.Visible = true
            data.CornerOutline.BR2.From = Vector2.new(x + sx, y + sy + 1)
            data.CornerOutline.BR2.To = Vector2.new(x + sx, y + sy - ch - 1)
            data.CornerOutline.BR2.Visible = true
            
            data.Corner.TL1.From = Vector2.new(x, y)
            data.Corner.TL1.To = Vector2.new(x + cw, y)
            data.Corner.TL1.Color = cfg.LineColor
            data.Corner.TL1.Thickness = cfg.Thickness
            data.Corner.TL1.Visible = true
            data.Corner.TL2.From = Vector2.new(x, y)
            data.Corner.TL2.To = Vector2.new(x, y + ch)
            data.Corner.TL2.Color = cfg.LineColor
            data.Corner.TL2.Thickness = cfg.Thickness
            data.Corner.TL2.Visible = true
            data.Corner.TR1.From = Vector2.new(x + sx, y)
            data.Corner.TR1.To = Vector2.new(x + sx - cw, y)
            data.Corner.TR1.Color = cfg.LineColor
            data.Corner.TR1.Thickness = cfg.Thickness
            data.Corner.TR1.Visible = true
            data.Corner.TR2.From = Vector2.new(x + sx, y)
            data.Corner.TR2.To = Vector2.new(x + sx, y + ch)
            data.Corner.TR2.Color = cfg.LineColor
            data.Corner.TR2.Thickness = cfg.Thickness
            data.Corner.TR2.Visible = true
            data.Corner.BL1.From = Vector2.new(x, y + sy)
            data.Corner.BL1.To = Vector2.new(x + cw, y + sy)
            data.Corner.BL1.Color = cfg.LineColor
            data.Corner.BL1.Thickness = cfg.Thickness
            data.Corner.BL1.Visible = true
            data.Corner.BL2.From = Vector2.new(x, y + sy)
            data.Corner.BL2.To = Vector2.new(x, y + sy - ch)
            data.Corner.BL2.Color = cfg.LineColor
            data.Corner.BL2.Thickness = cfg.Thickness
            data.Corner.BL2.Visible = true
            data.Corner.BR1.From = Vector2.new(x + sx, y + sy)
            data.Corner.BR1.To = Vector2.new(x + sx - cw, y + sy)
            data.Corner.BR1.Color = cfg.LineColor
            data.Corner.BR1.Thickness = cfg.Thickness
            data.Corner.BR1.Visible = true
            data.Corner.BR2.From = Vector2.new(x + sx, y + sy)
            data.Corner.BR2.To = Vector2.new(x + sx, y + sy - ch)
            data.Corner.BR2.Color = cfg.LineColor
            data.Corner.BR2.Thickness = cfg.Thickness
            data.Corner.BR2.Visible = true
        end
    end
    
    if cfg.HealthBar then
        local barX = x - 5
        local barW = 2
        data.HealthBGOutline.Size = Vector2.new(barW + 2, sy + 2)
        data.HealthBGOutline.Position = Vector2.new(barX - 1, y - 1)
        data.HealthBGOutline.Visible = true
        data.HealthBG.Size = Vector2.new(barW, sy)
        data.HealthBG.Position = Vector2.new(barX, y)
        data.HealthBG.Visible = true
        
        local segCount = #data.HealthSegments
        local segH = sy / segCount
        local hp = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
        local threshold = hp * segCount
        
        for i = 1, segCount do
            local seg = data.HealthSegments[i]
            if i <= threshold then
                seg.Size = Vector2.new(barW, segH + 0.6)
                seg.Position = Vector2.new(barX, y + sy - (segH * i))
                seg.Color = cfg.HealthBottom:Lerp(cfg.HealthTop, i / segCount)
                seg.Visible = true
            else
                seg.Visible = false
            end
        end
        
        if cfg.HealthText then
            local hpVal = math.floor(humanoid.Health + 0.5)
            data.HealthText.Text = tostring(hpVal)
            data.HealthText.Size = cfg.TextSize
            data.HealthText.Font = PixelFont or Drawing.Fonts.Monospace
            local tw = data.HealthText.TextBounds.X
            local fillH = sy * hp
            local minClamp = y - 2
            local maxClamp = math.max(minClamp, y + sy - 10)
            local ty = math.clamp(y + sy - fillH - 5, minClamp, maxClamp)
            data.HealthText.Position = Vector2.new(barX - 3 - tw, ty)
            data.HealthText.Color = Color3.new(1, 1, 1)
            data.HealthText.Visible = true
        else
            data.HealthText.Visible = false
        end
    else
        data.HealthBG.Visible = false
        data.HealthBGOutline.Visible = false
        for i = 1, #data.HealthSegments do
            data.HealthSegments[i].Visible = false
        end
        data.HealthText.Visible = false
    end
    
    if cfg.Names then
        local name = isPlayer and entity.DisplayName or character.Name
        data.NameText.Text = name
        data.NameText.Size = cfg.TextSize
        data.NameText.Font = PixelFont or Drawing.Fonts.Monospace
        data.NameText.Color = cfg.TextColor
        data.NameText.Position = Vector2.new(x + sx * 0.5, y - 14)
        data.NameText.Visible = true
    else
        data.NameText.Visible = false
    end
    
    if cfg.Distance then
        data.DistanceText.Text = "[" .. tostring(meters) .. "m]"
        data.DistanceText.Size = cfg.TextSize
        data.DistanceText.Font = PixelFont or Drawing.Fonts.Monospace
        data.DistanceText.Color = cfg.TextColor
        data.DistanceText.Position = Vector2.new(x + sx + 4, y - 1)
        data.DistanceText.Visible = true
    else
        data.DistanceText.Visible = false
    end
    
    if cfg.Tool then
        local tool = character:FindFirstChildOfClass("Tool")
        data.ToolText.Text = tool and tool.Name or "None"
        data.ToolText.Size = cfg.TextSize
        data.ToolText.Font = PixelFont or Drawing.Fonts.Monospace
        data.ToolText.Color = cfg.TextColor
        data.ToolText.Position = Vector2.new(x + sx * 0.5, y + sy + 2)
        data.ToolText.Visible = true
    else
        data.ToolText.Visible = false
    end
    
    if cfg.Tracers then
        local from
        if cfg.TracerOrigin == "Bottom" then
            from = Vector2.new(viewport.X * 0.5, viewport.Y)
        elseif cfg.TracerOrigin == "Top" then
            from = Vector2.new(viewport.X * 0.5, 0)
        else
            from = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
        end
        data.Tracer.From = from
        data.Tracer.To = Vector2.new(x + sx * 0.5, y + sy)
        data.Tracer.Color = cfg.TracerColor
        data.Tracer.Thickness = cfg.TracerThickness
        data.Tracer.Visible = true
    else
        data.Tracer.Visible = false
    end
    
    if cfg.Skeleton then
        local function DrawBone(bone, p1n, p2n)
            local p1 = character:FindFirstChild(p1n)
            local p2 = character:FindFirstChild(p2n)
            if p1 and p2 then
                local s1, v1 = Camera:WorldToViewportPoint(p1.Position)
                local s2, v2 = Camera:WorldToViewportPoint(p2.Position)
                if v1 and v2 and s1.Z > 0 and s2.Z > 0 then
                    local a = Vector2.new(s1.X, s1.Y)
                    local b = Vector2.new(s2.X, s2.Y)
                    bone.Outline.From = a
                    bone.Outline.To = b
                    bone.Outline.Thickness = cfg.SkeletonThickness + 2
                    bone.Outline.Visible = true
                    bone.Line.From = a
                    bone.Line.To = b
                    bone.Line.Color = cfg.SkeletonColor
                    bone.Line.Thickness = cfg.SkeletonThickness
                    bone.Line.Visible = true
                    return
                end
            end
            bone.Outline.Visible = false
            bone.Line.Visible = false
        end
        DrawBone(data.Skeleton.HeadTorso, "Head", "UpperTorso")
        DrawBone(data.Skeleton.TorsoHip, "UpperTorso", "LowerTorso")
        DrawBone(data.Skeleton.HipL, "LowerTorso", "LeftUpperLeg")
        DrawBone(data.Skeleton.HipR, "LowerTorso", "RightUpperLeg")
        DrawBone(data.Skeleton.LLeg, "LeftUpperLeg", "LeftLowerLeg")
        DrawBone(data.Skeleton.RLeg, "RightUpperLeg", "RightLowerLeg")
        DrawBone(data.Skeleton.LArm, "UpperTorso", "LeftUpperArm")
        DrawBone(data.Skeleton.RArm, "UpperTorso", "RightUpperArm")
        DrawBone(data.Skeleton.LFore, "LeftUpperArm", "LeftLowerArm")
        DrawBone(data.Skeleton.RFore, "RightUpperArm", "RightLowerArm")
    else
        for _, bone in pairs(data.Skeleton) do
            bone.Outline.Visible = false
            bone.Line.Visible = false
        end
    end
    
    if cfg.Chams then
        local hl = espModule._highlights[entity]
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "ESPHighlight"
            hl.Parent = Services.CoreGui
            espModule._highlights[entity] = hl
        end
        hl.Adornee = character
        hl.FillColor = cfg.ChamsFillColor
        hl.OutlineColor = cfg.ChamsOutlineColor
        hl.FillTransparency = cfg.ChamsFillTransparency
        hl.OutlineTransparency = cfg.ChamsOutlineTransparency
        hl.Enabled = true
    else
        if espModule._highlights[entity] then
            espModule._highlights[entity].Enabled = false
        end
    end
end

local function espLoop()
    local Camera = Services.WorkSpace.CurrentCamera
    local viewport = Camera.ViewportSize
    
    if not espModule.Settings.Enabled then
        for _, data in pairs(espModule._drawings) do HideESP(data) end
        for _, hl in pairs(espModule._highlights) do
            if hl then hl.Enabled = false end
        end
        return
    end
    
    for _, player in ipairs(Services.Players:GetPlayers()) do
        if player == Services.LocalPlayer then continue end
        ProcessEntity(player)
    end
    
    local botsFolder = Services.WorkSpace:FindFirstChild("IngameBots")
    if botsFolder then
        for _, bot in ipairs(botsFolder:GetChildren()) do
            ProcessEntity(bot)
        end
    end
end

function espModule:Start()
    if self._isRunning then return end
    self._isRunning = true
    
    loadFont()
    
    self._connections.PlayerRemoving = Services.Players.PlayerRemoving:Connect(RemoveESP)
    self._connections.RenderStepped = Services.RunService.RenderStepped:Connect(espLoop)
    
    local botsFolder = Services.WorkSpace:FindFirstChild("IngameBots")
    if botsFolder then
        self._connections.BotRemoving = botsFolder.ChildRemoved:Connect(RemoveESP)
    end
end

function espModule:Stop()
    if not self._isRunning then return end
    self._isRunning = false
    
    for _, conn in pairs(self._connections) do
        conn:Disconnect()
    end
    self._connections = {}
    
    for entity, data in pairs(self._drawings) do
        RemoveESP(entity)
    end
    self._drawings = {}
    self._highlights = {}
end

function espModule:Restart()
    self:Stop()
    self:Start()
end

function espModule:UpdateSettings(newSettings)
    local function merge(t1, t2)
        for k, v in pairs(t2) do
            if type(v) == "table" and type(t1[k]) == "table" then
                merge(t1[k], v)
            else
                t1[k] = v
            end
        end
    end
    merge(self.Settings, newSettings)
end

function espModule:GetSettings()
    return self.Settings
end

function espModule:Toggle()
    if self._isRunning then
        self:Stop()
    else
        self:Start()
    end
end

return espModule
