-- by n1clud3 and PrikolMen:-b

local addonName = 'Stalker2 HUD'

local math_floor = math.floor
local math_min = math.min
local ScrW = ScrW
local ScrH = ScrH
local hook = hook

local scrW, scrH = ScrW(), ScrH()
local screenPercentage = math_min( scrW, scrH ) / 100
hook.Add('OnScreenSizeChanged', addonName, function()
    scrW, scrH = ScrW(), ScrH()
    screenPercentage = math_min( scrW, scrH ) / 100
end)

local function ScreenPercentage( percentage )
    if (percentage) then
        return math_floor( screenPercentage * percentage )
    end

    return screenPercentage
end

-- La Config 👍
-- In Scale Percents
--local hudWidth = 16.9
local hudOffset = 5

local armorHeight = 0.6
local healthHeight = 1.2

-- In Pixels
local healthArmorOffset = 4
local hudWidth = 182

-- Colors :)
local alpha = 220
local bg = Color( 20, 20, 20, alpha )
local health = Color( 190, 44, 54, alpha )
local armor = Color( 60, 155, 155, alpha )

local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local FrameTime = FrameTime
local Lerp = Lerp

hook.Add('RenderScene', addonName, function()
    hook.Remove( 'RenderScene', addonName )

    local plyHealth, plyArmor = 0, 0
    local ply = LocalPlayer()

    hook.Add('HUDPaint', addonName, function()
        local hw, hh = hudWidth, ScreenPercentage( healthHeight )
        local offset = ScreenPercentage( hudOffset )
        local hy = scrH - offset

        -- Health BG
        surface_SetDrawColor( bg )
        surface_DrawRect( offset, hy, hw, hh )

        plyHealth = Lerp( FrameTime() * 10, plyHealth, (ply:Health() / ply:GetMaxHealth()) * hw )
        plyArmor = Lerp( FrameTime() * 10, plyArmor, (ply:Armor() / ply:GetMaxHealth()) * hw )

        -- Health FG
        surface_SetDrawColor( health )
        surface_DrawRect( offset + 1, hy + 1, plyHealth - 1, hh - 2 )

        local ah = ScreenPercentage( armorHeight )
        local ay = hy - ah - healthArmorOffset

        if plyArmor < 1 then return end
        -- Armor BG
        surface_SetDrawColor( bg )
        surface_DrawRect( offset, ay, hw, ah )

        -- Armor FG
        surface_SetDrawColor( armor )
        surface_DrawRect( offset + 1, ay + 1, plyArmor - 1, ah - 2 )
    end)

end)

-- Disable default hud
do

    local hideElements = {
        ['CHudHealth'] = true,
        ['CHudBattery'] = true
    }

    hook.Add('HUDShouldDraw', addonName, function( name )
        if hideElements[ name ] then
            return false
        end
    end)

end
