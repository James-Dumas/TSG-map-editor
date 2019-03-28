require "map"
VERSION = "1.0-alpha"

COLORS = {
    BG = {0, 0, 0},
    FG = {100, 100, 100},
    MENU = {180, 180, 180},
    TEXT_DARK = {10, 10, 10},
    TEXT_LIGHT = {240, 240, 240},
    TEXT_HIGHLIGHT = {220, 20, 20},
}

RECTS = {
    BG = {{0, 0, 1, 1}, COLORS.BG},
    MENU = {{0, 0, 0.25, 1}, COLORS.MENU},
}

states = {
    "noMapOpen",
    "mapOpen",
    "textInput"
}

selected = nil -- the selected object(s)
edgeSnap = true
sidebarOpen = true
openMap = nil

function love.load()
    love.window.setTitle("TSG Map Editor v" .. VERSION)
end

function love.update(dt)
end

function love.draw()
    for k, v in ipairs(RECTS) do
        love.graphics.setColor(v[2])
        love.graphics.rectangle("fill", unpack(realRect(v[1])))
    end
end

function love.keypressed(key)
    if controls.keyboard[key] ~= nil then
        local func = controls.keyboard[key][1]

        if func ~= nil then
            func()
        end
    end
end

function love.keyreleased(key)
    if controls.keyboard[key] ~= nil then
        local func = controls.keyboard[key][2]

        if func ~= nil then
            func()
        end
    end
end

function love.mousepressed(x, y, button)
    if controls.mouse[button] ~= nil then
        local func = controls.mouse[button][1]

        if func ~= nil then
            func(x, y)
        end
    end
end

function love.mousereleased(x, y, button)
    if controls.mouse[button] ~= nil then
        local func = controls.mouse[button][2]

        if func ~= nil then
            func(x, y)
        end
    end
end

function love.wheelmoved(x, y)
    if controls.mouse.scroll ~= nil then
        controls.mouse.scroll(y)
    end
end

function log(msg, show)
    io.write(msg .. "\n")
    -- TODO: display text on window
end

function realRect(rect)
    local W = love.graphics.getWidth()
    local H = love.graphics.getHeight()
    return {math.ceil(rect[1] * W), math.ceil(rect[2] * H), math.ceil(rect[3] * W), math.ceil(rect[4] * H)}
end

function setState(newState)
    state = newState
    controls = allControls[state]
end

function openMapDialog()
end

function cameraZoom(dist)
    local newZoom = camera.getZoomAtPos(camera.scrollPos + dist)
    if not(newZoom > camera.maxZoom or newZoom < camera.minZoom) then
        camera.scrollPos = camera.scrollPos + dist
    end
end

function toggleSidebar(open)
    if open == nil then
        sidebarOpen = not sidebarOpen
    else
        sidebarOpen = open
    end
end

-- bind each key/button to a 2-tuple containing functions unique to each state
-- the first function is for pressed event, the second is for released event
-- if there is no function for one of the events, use nil
-- keyboard keys' functions take no arguments
-- mouse buttons' functions take x, y
-- set mouse.scroll to a function that takes distance
allControls = {
    noMapOpen = {
        keyboard = {
            e = {toggleSidebar, nil},
            o = {openMapDialog, nil},
        },

        mouse = {
            l = {selectItem, nil},
            r = {openMenu, nil},
        },
    },

    mapOpen = {
        keyboard = {
            w = {function() camera:moveY(-1) end, function() camera:moveY(0) end},
            a = {function() camera:moveX(-1) end, function() camera:moveX(0) end},
            s = {function() camera:moveY(1) end, function() camera:moveY(0) end},
            d = {function() camera:moveX(1) end, function() camera:moveX(0) end},
            lshift = {function() edgeSnap = false end, function() edgeSnap = true end},
            z = {function() camera:resetZoom() end, nil},
            q = {deselect, nil},
            e = {toggleSidebar, nil},
            n = {newObject, nil},
            o = {openMapDialog, nil},
            p = {saveMap, nil},
        },

        mouse = {
            l = {selectItem, nil},
            r = {openMenu, nil},
            scroll = scrollHandler,
        },
    },

    textInput = {
        keyboard = {
            left = {textCursorLeft, nil},
            right = {textCursorRight, nil},
        },

        mouse = {
            l = {putTextCursor, nil},
            r = {putTextCursor, nil},
            scroll = scrollHandler,
        },
    },
}

clickActions = {

}

log("Initializing...")

setState("noMapOpen")

saveDirFile = "savedir"
fallbackSaveDir = "Documents/TSG Maps"

fileDelim = package.config:sub(1, 1)
if fileDelim == "/" then
    homeDir = "/home/" .. os.getenv("USER")
else
    homeDir = "C:\\Users\\" .. os.getenv("USERNAME")
end

if love.filesystem.getInfo(saveDirFile) ~= nil then
    local contents = love.filesystem.read(saveDirFile)
    local lineEnd = contents:find("\n") or contents:len()
    saveDir = homeDir .. fileDelim .. contents:sub(1, lineEnd) .. fileDelim
else
    log("Couldn't find file '" .. saveDirFile .. "'. Using default save directory.", true)
    saveDir = homeDir .. fileDelim .. fallbackSaveDir .. fileDelim
end

