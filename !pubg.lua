-- ============================================
-- PUBG G502 - Master Weapon Recoil Script
-- G HUB Lua Script
-- ============================================

EnablePrimaryMouseButtonEvents(true)

-- Master Lists
local AR = { "M762", "AUG", "M416", "AKM" }
local DMR = { "MK14" }
local SMG = { "UMP45", "JS9", "P90" }

-- Pool Configuration
local CATEGORIES = {
    { name = "AR", list = AR },
    { name = "DMR", list = DMR },
    { name = "SMG", list = SMG }
}

-- Recoil Profiles (X/Y movement split across a 24ms delay loop)
-- Note: Values are placeholders. You will need to tune them for your PUBG sensitivity.
local WEAPON_PROFILES = {
    -- === ARs ===
    M762     = { name = "Beryl M762", recoilX1 = -1, recoilY1 = 8, recoilX2 = 2,  recoilY2 = 7 },
    AUG      = { name = "AUG",        recoilX1 = 1,  recoilY1 = 6, recoilX2 = -1, recoilY2 = 6 },
    M416     = { name = "M416",       recoilX1 = -2, recoilY1 = 5, recoilX2 = 2,  recoilY2 = 7  },
    AKM      = { name = "AKM",        recoilX1 = 1,  recoilY1 = 6, recoilX2 = -2, recoilY2 = 6 },

    -- === DMRs ===
    MK14     = { name = "Mk14",       recoilX1 = 1,  recoilY1 = 8, recoilX2 = -1, recoilY2 = 9 },

    -- === SMGs ===
    UMP45    = { name = "UMP45",      recoilX1 = -1, recoilY1 = 4,  recoilX2 = 1,  recoilY2 = 4  },
    JS9      = { name = "JS9",        recoilX1 = 1,  recoilY1 = 4,  recoilX2 = -1, recoilY2 = 3  },
    P90      = { name = "P90",        recoilX1 = -1, recoilY1 = 4,  recoilX2 = 1,  recoilY2 = 5  },
}

-- State Variables
local currentCategoryIndex = 1
local currentPool = CATEGORIES[currentCategoryIndex].list       
local poolName = CATEGORIES[currentCategoryIndex].name
local currentIndex = 1              
local recoilEnabled = false         

-- ============================================
-- Core Logic Functions
-- ============================================

local function applyWeapon()
    local key = currentPool[currentIndex]
    local profile = WEAPON_PROFILES[key]
    OutputLogMessage("[PUBG] [%s] %s \n", 
        poolName, profile.name, profile.recoilY1, profile.recoilY2)
end

local function cycleNext()
    currentIndex = currentIndex + 1
    if currentIndex > #currentPool then
        currentIndex = 1
    end
    applyWeapon()
end

local function cyclePrev()
    currentIndex = currentIndex - 1
    if currentIndex < 1 then
        currentIndex = #currentPool
    end
    applyWeapon()
end

local function cycleCategory(direction)
    currentCategoryIndex = currentCategoryIndex + direction
    
    -- Loop categories
    if currentCategoryIndex > #CATEGORIES then
        currentCategoryIndex = 1
    elseif currentCategoryIndex < 1 then
        currentCategoryIndex = #CATEGORIES
    end

    -- Update state
    currentPool = CATEGORIES[currentCategoryIndex].list
    poolName = CATEGORIES[currentCategoryIndex].name
    currentIndex = 1 -- Reset to first weapon in new category
    
    OutputLogMessage("[PUBG] Switched Category to: %s\n", poolName)
    applyWeapon()
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

        -- Left Click (1) + Right Click (3) Recoil Loop
        if arg == 1 then
            if recoilEnabled and IsMouseButtonPressed(3) then
                local key = currentPool[currentIndex]
                local profile = WEAPON_PROFILES[key]

                repeat
                    ApplySmoothRecoil(profile.recoilX1, profile.recoilY1, profile.recoilX2, profile.recoilY2)
                until not IsMouseButtonPressed(1) or not IsMouseButtonPressed(3)
            end

        -- Buttons 4/5 = Cycle Weapons inside current category (e.g. M416 -> Beryl)
        elseif arg == 4 then cyclePrev()
        elseif arg == 5 then cycleNext()

        -- Buttons 8/7 = Cycle Weapon Categories (AR <-> DMR <-> SMG)
        elseif arg == 8 then cycleCategory(1)
        elseif arg == 7 then cycleCategory(-1)

        -- Button 6 = Master Toggle
        elseif arg == 6 then
            recoilEnabled = not recoilEnabled
            local status = recoilEnabled and "ON" or "OFF"
            OutputLogMessage("[PUBG] Master Recoil Toggle: %s\n", status)
        end
    end
end