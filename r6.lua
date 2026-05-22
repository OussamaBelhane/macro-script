-- ============================================
-- R6S G502 - Operator Cycle & Recoil Script
-- G HUB Lua Script
-- ============================================

-- Must be enabled to detect Left Clicks for the recoil loop
EnablePrimaryMouseButtonEvents(true)

local ATTACKERS = { "ASH", "ACE", "IANA", "TWITCH" }
local DEFENDERS = { "MIRA", "FENRIR", "VALKYRIE" }

-- Adjust your X and Y recoil values for BOTH movements here.
-- Movement 1 happens first, Movement 2 happens a split second later.
local OPERATOR_PROFILES = {
    ASH      = { name = "Ash",      weapon = "R4-C",   recoilX1 = 1,  recoilY1 = 15, recoilX2 = -2,  recoilY2 = 16 },
    ACE      = { name = "Ace",      weapon = "AK-12",  recoilX1 = -3, recoilY1 = 12, recoilX2 = 1,  recoilY2 = 15 },
    IANA     = { name = "Iana",     weapon = "G36C", recoilX1 = 3,  recoilY1 = 14, recoilX2 = -2,  recoilY2 = 11 },
    TWITCH   = { name = "Twitch",   weapon = "F2",     recoilX1 = 2,  recoilY1 = 20, recoilX2 = -3,  recoilY2 = 17 },
    MIRA     = { name = "Mira",     weapon = "Vector", recoilX1 = 2,  recoilY1 = 8, recoilX2 = -2,  recoilY2 = 7 },
    FENRIR   = { name = "Fenrir",   weapon = "MP7",    recoilX1 = 2,  recoilY1 = 8, recoilX2 = -1,  recoilY2 = 5 },
    VALKYRIE = { name = "Valkyrie", weapon = "MPX",    recoilX1 = 1,  recoilY1 = 6, recoilX2 = -1,  recoilY2 = 4 },
}

-- State
local currentPool = ATTACKERS       -- start on attack side
local currentIndex = 1              -- position in pool
local poolName = "ATTACK"
local recoilEnabled = false         -- Master toggle state

-- ============================================
-- Helper functions
-- ============================================

local function applyOperator()
    local key = currentPool[currentIndex]
    local profile = OPERATOR_PROFILES[key]
    OutputLogMessage("[R6S] [%s] %s | %s | Recoil 1(X:%d, Y:%d) | Recoil 2(X:%d, Y:%d)\n", 
        poolName, profile.name, profile.weapon, 
        profile.recoilX1, profile.recoilY1, 
        profile.recoilX2, profile.recoilY2)
end

local function cycleNext()
    currentIndex = currentIndex + 1
    if currentIndex > #currentPool then
        currentIndex = 1
    end
    applyOperator()
end

local function cyclePrev()
    currentIndex = currentIndex - 1
    if currentIndex < 1 then
        currentIndex = #currentPool
    end
    applyOperator()
end

local function switchPool(pool, name)
    currentPool = pool
    poolName = name
    currentIndex = 1
    applyOperator()
    OutputLogMessage("[R6S] Switched to %s pool\n", name)
end

-- Double recoil function for weapon stability using distinct X/Y values
local function ApplySmoothRecoil(x1, y1, x2, y2)
    MoveMouseRelative(x1, y1)
    Sleep(10)
    MoveMouseRelative(x2, y2)
    Sleep(14)
end

-- ============================================
-- BUTTON MAP:
--   Left Click + Right Click = Fire Recoil (if enabled)
--   Button 4 = Previous operator
--   Button 5 = Next operator
--   Button 8 = Switch to ATTACK pool
--   Button 7 = Switch to DEFENSE pool
--   Button 6 = TOGGLE RECOIL ON/OFF
-- ============================================

function OnEvent(event, arg)

    if event == "MOUSE_BUTTON_PRESSED" then

        -- Left Click (1) Recoil Loop
        if arg == 1 then
            -- Only run recoil if it's turned ON and we are holding ADS (Right Click = 3)
            if recoilEnabled and IsMouseButtonPressed(3) then
                local key = currentPool[currentIndex]
                local profile = OPERATOR_PROFILES[key]
                
                repeat
                    ApplySmoothRecoil(profile.recoilX1, profile.recoilY1, profile.recoilX2, profile.recoilY2)
                -- The loop stops if you let go of Left Click (1) OR Right Click (3)
                until not IsMouseButtonPressed(1) or not IsMouseButtonPressed(3)
            end

        -- Button 4 → previous operator
        elseif arg == 4 then
            cyclePrev()

        -- Button 5 → next operator
        elseif arg == 5 then
            cycleNext()

        -- Button 8 → attack pool
        elseif arg == 8 then
            switchPool(ATTACKERS, "ATTACK")

        -- Button 7 → defense pool
        elseif arg == 7 then
            switchPool(DEFENDERS, "DEFENSE")

        -- Button 6 → Toggle Recoil ON / OFF
        elseif arg == 6 then
            recoilEnabled = not recoilEnabled
            local status = recoilEnabled and "ON" or "OFF"
            OutputLogMessage("[R6S] Master Recoil Toggle: %s\n", status)
        end

    end

end