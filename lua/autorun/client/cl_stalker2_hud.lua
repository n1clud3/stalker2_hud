-- by n1clud3 and PrikolMen:-b
local addonName = "Stalker2 HUD"

-- definitions for performance
local math_floor = math.floor
local math_min = math.min
local ScrW = ScrW
local ScrH = ScrH
local hook = hook
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local FrameTime = FrameTime
local Lerp = Lerp

local scrW, scrH = ScrW(), ScrH()
local screenPercentage = math_min( scrW, scrH ) / 100
hook.Add("OnScreenSizeChanged", addonName, function()
    scrW, scrH = ScrW(), ScrH()
    screenPercentage = math_min( scrW, scrH ) / 100
end)

local function ScreenPercentage( percentage )
    if (percentage) then
        return math_floor( screenPercentage * percentage )
    end

    return screenPercentage
end

local enableHud = CreateClientConVar("cl_stalker2hud_enable", "1", true, false, "Enables S.T.A.L.K.E.R. 2 HUD", 0, 1)

-- La Config 👍
-- In Scale Percents
local hudOffset = 5

local armorHeight = 0.6
local healthHeight = 1.2

-- In Pixels
local healthArmorOffset = 4
local hudWidth = 182

-- Colors :)
local bgColor = Color( 20, 20, 20, 220 )
local healthColor = Color( 190, 44, 54, 220 )
local healthBetweenColor = Color( 100, 44, 54, 110 )
local armorColor = Color( 60, 155, 155, 220 )
local armorBetweenColor = Color( 20, 70, 70, 110 )

hook.Add("RenderScene", addonName, function()
    hook.Remove( "RenderScene", addonName )
    
    local plyHealth, plyArmor = 0, 0
    local ply = LocalPlayer()

    hook.Add("HUDPaint", addonName, function()
        if not enableHud:GetBool() then return end
        local hw, hh = hudWidth, ScreenPercentage( healthHeight )
        local offset = ScreenPercentage( hudOffset )
        local hy = scrH - offset

        -- Health BG
        surface_SetDrawColor( bgColor )
        surface_DrawRect( offset, hy, hw, hh )

        plyHealth = Lerp( FrameTime() * 10, plyHealth, (ply:Health() / ply:GetMaxHealth()) * hw )
        plyArmor = Lerp( FrameTime() * 10, plyArmor, (ply:Armor() / ply:GetMaxHealth()) * hw )

        -- Health BetweenColor
        surface_SetDrawColor( healthBetweenColor )
        surface_DrawRect( offset + 1, hy + 1, plyHealth - 1, hh - 2 )

        -- Health FG
        surface_SetDrawColor( healthColor )
        surface_DrawRect( offset + 2, hy + 2, plyHealth - 3, hh - 4 )

        local ah = ScreenPercentage( armorHeight )
        local ay = hy - ah - healthArmorOffset

        if plyArmor < 1 then return end -- don't draw armor bar if player has no armor ＼（〇_ｏ）／
        -- Armor BG
        surface_SetDrawColor( bgColor )
        surface_DrawRect( offset, ay, hw, ah )

        -- Health BetweenColor
        surface_SetDrawColor( armorBetweenColor )
        surface_DrawRect( offset + 1, ay + 1, plyArmor - 1, ah - 2 )

        -- Armor FG
        surface_SetDrawColor( armorColor )
        surface_DrawRect( offset + 2, ay + 2, plyArmor - 3, ah - 4 )
    end)

    if not enableHud:GetBool() then
        hook.Remove("HUDPaint", addonName)
    end
end)

-- Disable default hud
do

    local hideElements = {
        ["CHudHealth"] = true,
        ["CHudBattery"] = true
    }

    hook.Add("HUDShouldDraw", addonName, function( name )
        if hideElements[ name ] and enableHud:GetBool() then
            return false
        end
    end)

end
