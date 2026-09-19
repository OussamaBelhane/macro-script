-- ============================================
-- R6S G502 - Master Operator Recoil Script
-- G HUB Lua Script
-- ============================================

--todo
--ATTACKERS : THERMITE  ZERO LION NOMAD
--DEFENDERS : Smoke DOC ALIBI

EnablePrimaryMouseButtonEvents(true)

-- Master Lists
local ATTACKERS = { 
    "ASH", "ACE", "IANA", "TWITCH", "BUCK", 
     "THERMITE",  "MAVERICK", "ZERO", "LION", 
    "NOMAD"
}

local DEFENDERS = { 
    "MIRA", "FENRIR", "VALKYRIE", "SMOKE", "ELA", "LESION" 
    , "DOC"  , "ALIBI", 
    "KAPKAN", "THORN" 
}

-- Recoil Profiles (X/Y movement split across a 24ms delay loop)
local OPERATOR_PROFILES = {
    -- === ORIGINAL ATTACKERS ===
    ASH      = { name = "Ash",      weapon = "R4-C",      recoilX1 = 1,  recoilY1 = 15, recoilX2 = -2,  recoilY2 = 16 },
    ACE      = { name = "Ace",      weapon = "AK-12",     recoilX1 = -3, recoilY1 = 12, recoilX2 = 1,   recoilY2 = 15 },
    IANA     = { name = "Iana",     weapon = "G36C",      recoilX1 = 3,  recoilY1 = 14, recoilX2 = -2,  recoilY2 = 11 },
    TWITCH   = { name = "Twitch",   weapon = "F2",        recoilX1 = 2,  recoilY1 = 20, recoilX2 = -3,  recoilY2 = 17 },
    

    -- === NEW META ATTACKERS ===

    BUCK     = { name = "Buck",     weapon = "C8-SFW",    recoilX1 = 1,  recoilY1 = 13, recoilX2 = -1,  recoilY2 = 13 },
    THERMITE = { name = "Thermite", weapon = "556xi",     recoilX1 =2, recoilY1 = 4, recoilX2 = -1,   recoilY2 = 4 },
    MAVERICK = { name = "Maverick", weapon = "M4",        recoilX1 = 1,  recoilY1 = 11, recoilX2 = -2,  recoilY2 = 11 },
    ZERO     = { name = "Zero",     weapon = "SC3000K",   recoilX1 = -2, recoilY1 = 16, recoilX2 = 2,   recoilY2 = 14 },
    LION     = { name = "Lion",     weapon = "V308",      recoilX1 = -1, recoilY1 = 12, recoilX2 = 1,   recoilY2 = 11 },
    NOMAD    = { name = "Nomad",    weapon = "ARX200",    recoilX1 = 1,  recoilY1 = 14, recoilX2 = -2,  recoilY2 = 12 },

    -- === ORIGINAL DEFENDERS ===
    MIRA     = { name = "Mira",     weapon = "Vector",    recoilX1 = 2,  recoilY1 = 8,  recoilX2 = -2,  recoilY2 = 7 },
    FENRIR   = { name = "Fenrir",   weapon = "MP7",       recoilX1 = 2,  recoilY1 = 8,  recoilX2 = -1,  recoilY2 = 5 },
    VALKYRIE = { name = "Valkyrie", weapon = "MPX",       recoilX1 = 1,  recoilY1 = 6,  recoilX2 = -1,  recoilY2 = 4 },


    -- === NEW META DEFENDERS ===

    Vigile    = { name = "Vigile",    weapon = "SMG-12",    recoilX1 =4,  recoilY1 =13, recoilX2 = -1,  recoilY2 = 7 },
    SMOKE    = { name = "Smoke",    weapon = "SMG-11",    recoilX1 =4,  recoilY1 =13, recoilX2 = -1,  recoilY2 = 7 },
    ELA      = { name = "Ela",      weapon = "Scorpion",  recoilX1 = 4, recoilY1 = 7, recoilX2 = -1,   recoilY2 = 8 },
    LESION   = { name = "Lesion",   weapon = "T-5 SMG",   recoilX1 = 1,  recoilY1 = 5,  recoilX2 = -1,  recoilY2 = 5 },
    DOC      = { name = "Doc",      weapon = "MP5",       recoilX1 = -1, recoilY1 = 8,  recoilX2 = 1,   recoilY2 = 7 },
    ALIBI    = { name = "Alibi",    weapon = "Mx4 Storm", recoilX1 = -2, recoilY1 = 13, recoilX2 = 1,   recoilY2 = 11 },
    KAPKAN   = { name = "Kapkan",   weapon = "9x19VSN",   recoilX1 = 2,  recoilY1 = 4,  recoilX2 = -3,  recoilY2 = 5 },
    THORN    = { name = "Thorn",    weapon = "UZK50GI",   recoilX1 = 0, recoilY1 = 4, recoilX2 = 0,   recoilY2 = 5 },
}

-- State
local currentPool = ATTACKERS       
local currentIndex = 1              
local poolName = "ATTACK"
local recoilEnabled = false         

-- ============================================
-- Core Logic Functions
-- ============================================

local function applyOperator()
    local key = currentPool[currentIndex]
    local profile = OPERATOR_PROFILES[key]
    OutputLogMessage("[R6S] [%s] %s | %s | Recoil(Y:%d, Y2:%d)\n", 
        poolName, profile.name, profile.weapon, 
        profile.recoilY1, profile.recoilY2)
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

local function ApplySmoothRecoil(x1, y1, x2, y2)
    MoveMouseRelative(x1, y1)
    Sleep(10)
    MoveMouseRelative(x2, y2)
    Sleep(14)
end

-- ============================================
-- Event Listener (Button Mapping)
-- ============================================

function OnEvent(event, arg)
    if event == "MOUSE_BUTTON_PRESSED" then

        -- Left Click (1) Recoil Loop
        if arg == 1 then
            if recoilEnabled and IsMouseButtonPressed(3) then
                local key = currentPool[currentIndex]
                local profile = OPERATOR_PROFILES[key]
                
                repeat
                    ApplySmoothRecoil(profile.recoilX1, profile.recoilY1, profile.recoilX2, profile.recoilY2)
                until not IsMouseButtonPressed(1) or not IsMouseButtonPressed(3)
            end

        -- Buttons 4/5 = Cycle Operators
        elseif arg == 4 then cyclePrev()
        elseif arg == 5 then cycleNext()

        -- Buttons 8/7 = Switch Attack/Defense
        elseif arg == 8 then switchPool(ATTACKERS, "ATTACK")
        elseif arg == 7 then switchPool(DEFENDERS, "DEFENSE")

        -- Button 6 = Master Toggle
        elseif arg == 6 then
            recoilEnabled = not recoilEnabled
            local status = recoilEnabled and "ON" or "OFF"
            OutputLogMessage("[R6S] Master Recoil Toggle: %s\n", status)
        end
    end
end