-- ============================================
-- PUBG G502 - Master Weapon Recoil Script (Per-Scope Manual Tuning)
-- G HUB Lua Script
-- ============================================

EnablePrimaryMouseButtonEvents(true)

-- Master Lists
local Holo = { "M762", "AUG", "M416", "AKM", "UMP45"}
local x2 = { "M762", "AUG", "M416", "AKM"}
local x3 = { "M762", "AUG", "M416", "AKM"}

-- Pool Configuration
local CATEGORIES = {
    { name = "Holo", list = Holo },
    { name = "x2", list = x2 },
    { name = "x3", list = x3 }
}

-- Recoil Profiles (Fully Separated Scopes)
-- You can now change the x1, y1, x2, y2 for EACH scope independently.
local WEAPON_PROFILES = {
    M762 = { 
        name = "Beryl M762", 
        Holo = { x1 = -1, y1 = 6,  x2 = 1,  y2 = 6 },
        x2   = { x1 = -2, y1 = 8, x2 = 2,  y2 = 9 }, -- Edit these for x2
        x3   = { x1 = -2, y1 = 11, x2 = 2,  y2 = 11 }  -- Edit these for x3
    },
    AUG = { 
        name = "AUG",        
        Holo = { x1 = 1, y1 = 5,  x2 = -1, y2 = 6 },
        x2   = { x1 = 2, y1 = 7, x2 = -2, y2 = 7 },
        x3   = { x1 = 2, y1 = 10, x2 = -2, y2 = 10 }
    },
    M416 = { 
        name = "M416",       
        Holo = { x1 = -1, y1 = 5,  x2 = 1, y2 = 5 },
        x2   = { x1 = -1, y1 = 7,  x2 = 1, y2 = 7 },
        x3   = { x1 = -1, y1 = 10, x2 = 1, y2 = 10 }
    },
    AKM = { 
        name = "AKM",        
        Holo = { x1 = 1, y1 = 6,  x2 = -2, y2 = 6 },
        x2   = { x1 = 2, y1 = 11, x2 = -3, y2 = 11 },
        x3   = { x1 = 2, y1 = 16, x2 = -4, y2 = 16 }
    },
    UMP45 = { 
        name = "UMP45",      
        Holo = { x1 = -1, y1 = 4, x2 = 1, y2 = 4 }
        -- UMP45 is only in your Holo list.
    }
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
    local scopeData = profile[poolName] -- This automatically pulls the Holo, x2, or x3 numbers
    
    if scopeData then
        OutputLogMessage("[PUBG] [%s] %s | Recoil(Y1:%d, Y2:%d)\n\n", 
            poolName, profile.name, scopeData.y1, scopeData.y2)
    end
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

    OutputLogMessage("[PUBG] Switched Scope Category to: %s\n", poolName)
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
                local scopeData = profile[poolName] -- Get the specific numbers for the current scope

                if scopeData then
                    repeat
                        ApplySmoothRecoil(scopeData.x1, scopeData.y1, scopeData.x2, scopeData.y2)
                    until not IsMouseButtonPressed(1) or not IsMouseButtonPressed(3)
                end
            end

        -- Buttons 4/5 = Cycle Weapons inside current category
        elseif arg == 4 then cyclePrev()
        elseif arg == 5 then cycleNext()

        -- Buttons 8/7 = Cycle Weapon Categories (Holo <-> x2 <-> x3)
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