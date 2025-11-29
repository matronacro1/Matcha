--[[
    Matcha Input Library v1.0
    Complete keyboard/mouse automation
]]

local Input = {}

-- Adjustable delays (seconds)
Input.Delay = {
    Key = 0.015,        -- between press/release
    Between = 0.015,    -- between key taps
    Short = 0.1,        -- short pause
    Medium = 0.2,       -- medium pause
    Long = 0.35         -- for windows to open
}

-- All Virtual Key Codes
Input.VK = {
    -- Letters A-Z
    A=0x41, B=0x42, C=0x43, D=0x44, E=0x45, F=0x46, G=0x47,
    H=0x48, I=0x49, J=0x4A, K=0x4B, L=0x4C, M=0x4D, N=0x4E,
    O=0x4F, P=0x50, Q=0x51, R=0x52, S=0x53, T=0x54, U=0x55,
    V=0x56, W=0x57, X=0x58, Y=0x59, Z=0x5A,
    
    -- Numbers 0-9
    N0=0x30, N1=0x31, N2=0x32, N3=0x33, N4=0x34,
    N5=0x35, N6=0x36, N7=0x37, N8=0x38, N9=0x39,
    
    -- Function keys
    F1=0x70, F2=0x71, F3=0x72, F4=0x73, F5=0x74, F6=0x75,
    F7=0x76, F8=0x77, F9=0x78, F10=0x79, F11=0x7A, F12=0x7B,
    
    -- Modifiers
    SHIFT=0x10, LSHIFT=0xA0, RSHIFT=0xA1,
    CTRL=0x11, LCTRL=0xA2, RCTRL=0xA3,
    ALT=0x12, LALT=0xA4, RALT=0xA5,
    LWIN=0x5B, RWIN=0x5C,
    
    -- Special keys
    ENTER=0x0D, TAB=0x09, SPACE=0x20, BACKSPACE=0x08,
    ESC=0x1B, DELETE=0x2E, INSERT=0x2D, HOME=0x24,
    END=0x23, PAGEUP=0x21, PAGEDOWN=0x22,
    CAPSLOCK=0x14, NUMLOCK=0x90, PRINTSCREEN=0x2C,
    
    -- Arrow keys
    LEFT=0x25, UP=0x26, RIGHT=0x27, DOWN=0x28,
    
    -- Numpad
    NUM0=0x60, NUM1=0x61, NUM2=0x62, NUM3=0x63, NUM4=0x64,
    NUM5=0x65, NUM6=0x66, NUM7=0x67, NUM8=0x68, NUM9=0x69,
    MULTIPLY=0x6A, ADD=0x6B, SUBTRACT=0x6D, DECIMAL=0x6E, DIVIDE=0x6F,
    
    -- Punctuation keys
    SEMICOLON=0xBA, EQUALS=0xBB, COMMA=0xBC, MINUS=0xBD,
    PERIOD=0xBE, SLASH=0xBF, BACKTICK=0xC0, LBRACKET=0xDB,
    BACKSLASH=0xDC, RBRACKET=0xDD, QUOTE=0xDE
}

-- Character map: char -> {vk, needsShift}
Input.CharMap = {
    -- Lowercase
    a={0x41,false}, b={0x42,false}, c={0x43,false}, d={0x44,false},
    e={0x45,false}, f={0x46,false}, g={0x47,false}, h={0x48,false},
    i={0x49,false}, j={0x4A,false}, k={0x4B,false}, l={0x4C,false},
    m={0x4D,false}, n={0x4E,false}, o={0x4F,false}, p={0x50,false},
    q={0x51,false}, r={0x52,false}, s={0x53,false}, t={0x54,false},
    u={0x55,false}, v={0x56,false}, w={0x57,false}, x={0x58,false},
    y={0x59,false}, z={0x5A,false},
    
    -- Uppercase
    A={0x41,true}, B={0x42,true}, C={0x43,true}, D={0x44,true},
    E={0x45,true}, F={0x46,true}, G={0x47,true}, H={0x48,true},
    I={0x49,true}, J={0x4A,true}, K={0x4B,true}, L={0x4C,true},
    M={0x4D,true}, N={0x4E,true}, O={0x4F,true}, P={0x50,true},
    Q={0x51,true}, R={0x52,true}, S={0x53,true}, T={0x54,true},
    U={0x55,true}, V={0x56,true}, W={0x57,true}, X={0x58,true},
    Y={0x59,true}, Z={0x5A,true},
    
    -- Numbers
    ["0"]={0x30,false}, ["1"]={0x31,false}, ["2"]={0x32,false},
    ["3"]={0x33,false}, ["4"]={0x34,false}, ["5"]={0x35,false},
    ["6"]={0x36,false}, ["7"]={0x37,false}, ["8"]={0x38,false},
    ["9"]={0x39,false},
    
    -- Symbols (no shift)
    [" "]={0x20,false}, ["`"]={0xC0,false}, ["-"]={0xBD,false},
    ["="]={0xBB,false}, ["["]={0xDB,false}, ["]"]={0xDD,false},
    ["\\"]={0xDC,false}, [";"]={0xBA,false}, ["'"]={0xDE,false},
    [","]={0xBC,false}, ["."]={0xBE,false}, ["/"]={0xBF,false},
    
    -- Symbols (with shift)
    ["~"]={0xC0,true}, ["!"]={0x31,true}, ["@"]={0x32,true},
    ["#"]={0x33,true}, ["$"]={0x34,true}, ["%"]={0x35,true},
    ["^"]={0x36,true}, ["&"]={0x37,true}, ["*"]={0x38,true},
    ["("]={0x39,true}, [")"]={0x30,true}, ["_"]={0xBD,true},
    ["+"]={0xBB,true}, ["{"]={0xDB,true}, ["}"]={0xDD,true},
    ["|"]={0xDC,true}, [":"]={0xBA,true}, ['"']={0xDE,true},
    ["<"]={0xBC,true}, [">"]={0xBE,true}, ["?"]={0xBF,true}
}

----------------------------------------------------------------
-- CORE FUNCTIONS
----------------------------------------------------------------

-- Tap key (press + release)
function Input.tap(vk)
    keypress(vk)
    wait(Input.Delay.Key)
    keyrelease(vk)
    wait(Input.Delay.Between)
end

-- Hold key down
function Input.hold(vk)
    keypress(vk)
end

-- Release key
function Input.release(vk)
    keyrelease(vk)
end

-- Key combo (Ctrl+C, Alt+F4, etc)
function Input.combo(...)
    local keys = {...}
    for i = 1, #keys do
        keypress(keys[i])
        wait(Input.Delay.Key)
    end
    for i = #keys, 1, -1 do
        keyrelease(keys[i])
        wait(Input.Delay.Key)
    end
end

-- Type single character
function Input.char(c)
    local map = Input.CharMap[c]
    if not map then return end
    if map[2] then Input.hold(Input.VK.SHIFT) end
    Input.tap(map[1])
    if map[2] then Input.release(Input.VK.SHIFT) end
end

-- Type string
function Input.type(str)
    for i = 1, #str do
        Input.char(str:sub(i, i))
    end
end

----------------------------------------------------------------
-- COMMON SHORTCUTS
----------------------------------------------------------------

function Input.enter() Input.tap(Input.VK.ENTER) end
function Input.esc() Input.tap(Input.VK.ESC) end
function Input.tab() Input.tap(Input.VK.TAB) end
function Input.space() Input.tap(Input.VK.SPACE) end
function Input.backspace() Input.tap(Input.VK.BACKSPACE) end

function Input.copy() Input.combo(Input.VK.CTRL, Input.VK.C) end
function Input.paste() Input.combo(Input.VK.CTRL, Input.VK.V) end
function Input.cut() Input.combo(Input.VK.CTRL, Input.VK.X) end
function Input.undo() Input.combo(Input.VK.CTRL, Input.VK.Z) end
function Input.redo() Input.combo(Input.VK.CTRL, Input.VK.Y) end
function Input.selectAll() Input.combo(Input.VK.CTRL, Input.VK.A) end
function Input.save() Input.combo(Input.VK.CTRL, Input.VK.S) end
function Input.closeWindow() Input.combo(Input.VK.ALT, Input.VK.F4) end

----------------------------------------------------------------
-- WINDOWS HELPERS
----------------------------------------------------------------

-- Open Start/Search
function Input.openSearch()
    Input.tap(Input.VK.LWIN)
    wait(Input.Delay.Long)
end

-- Open Run dialog
function Input.openRun()
    Input.openSearch()
    Input.type("run")
    wait(Input.Delay.Medium)
    Input.enter()
    wait(Input.Delay.Medium)
end

-- Run command via Run dialog
function Input.run(cmd)
    Input.openRun()
    Input.type(cmd)
    wait(Input.Delay.Short)
    Input.enter()
end

-- Search & open app
function Input.search(query)
    Input.openSearch()
    Input.type(query)
    wait(Input.Delay.Medium)
    Input.enter()
end

----------------------------------------------------------------
-- MOUSE HELPERS
----------------------------------------------------------------

function Input.click() mouse1click() end
function Input.rightClick() mouse2click() end
function Input.doubleClick() mouse1click() wait(0.05) mouse1click() end
function Input.moveTo(x, y) mousemoveabs(x, y) end
function Input.moveBy(dx, dy) mousemoverel(dx, dy) end
function Input.scroll(n) mousescroll(n) end

function Input.clickAt(x, y)
    Input.moveTo(x, y)
    wait(Input.Delay.Short)
    Input.click()
end

----------------------------------------------------------------
-- SPEED PRESETS
----------------------------------------------------------------

function Input.setSpeed(mode)
    if mode == "fast" then
        Input.Delay = {Key=0.01, Between=0.01, Short=0.08, Medium=0.15, Long=0.25}
    elseif mode == "normal" then
        Input.Delay = {Key=0.02, Between=0.02, Short=0.1, Medium=0.2, Long=0.35}
    elseif mode == "slow" then
        Input.Delay = {Key=0.04, Between=0.04, Short=0.2, Medium=0.4, Long=0.6}
    end
end

-- Initialize (disable Roblox input capture)
function Input.init()
    setrobloxinput(false)
end

return Input
