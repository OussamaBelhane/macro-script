# R6S G502 - Operator Cycle & Recoil Script

A premium Logitech G HUB Lua script designed to provide dynamic operator selection and responsive, smooth recoil control for Rainbow Six Siege on the Logitech G502.

---

## 🎯 Configuration & DPI Settings

> [!IMPORTANT]
> **Recommended Mouse DPI:** `1600 DPI`
>
> The recoil values in the script have been optimized specifically for a **1600 DPI** profile. If you use a different DPI, you may need to adjust the operator recoil profiles inside the script.

---

## 🛠️ Features

- **Master Recoil Toggle:** Quickly turn the script on or off dynamically.
- **Operator Profiles:** Built-in profiles for popular attackers and defenders:
  - **Attackers:** Ash (R4-C), Ace (AK-12), Iana (G36C), Twitch (F2)
  - **Defenders:** Mira (Vector), Fenrir (MP7), Valkyrie (MPX)
- **Smooth Dual-Movement Recoil:** Features a split-second secondary micro-adjustment loop for enhanced weapon stability.
- **Easy Cycle Controls:** Quickly toggle next/previous operator or switch attacker/defender pools using G502 mouse buttons.

---

## 🖱️ Button Mapping Reference

| Action | Mouse Button | Notes |
| :--- | :---: | :--- |
| **Fire Recoil** | `Left Click` + `Right Click` | Only activates when Master Toggle is **ON** and actively holding ADS (Right Click) |
| **Previous Operator** | `Button 4` | Cycles backward through the current active pool |
| **Next Operator** | `Button 5` | Cycles forward through the current active pool |
| **Switch to Attackers** | `Button 8` | Switches pool to Attackers and resets index |
| **Switch to Defenders** | `Button 7` | Switches pool to Defenders and resets index |
| **Master Toggle ON/OFF** | `Button 6` | Toggles recoil control functionality dynamically |

---

## 🚀 How to Install

1. Open **Logitech G HUB**.
2. Select your active Rainbow Six Siege profile.
3. Click **Scripting** (Lua).
4. Copy the complete code from [r6.lua](r6.lua) and paste it into the editor.
5. Save the script (`Ctrl + S`).
6. Set your mouse to **1600 DPI** and enjoy!
