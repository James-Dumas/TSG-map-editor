require "map.lua"
VERSION = "1.0-alpha"

maps = {}

states = {
    "noMapOpen",
    "mapOpen",
    "textInput"
}

-- bind each key/button to a 2-tuple containing two tables in the format:
-- [0] = a function that takes dt as its first argument
-- [1] = a table containing the remaining arguments (or nil if no args)
-- the first table is for pressed event, the second is for released event
-- if there is no function for one of the events, place an empty table
allControls = {
    noMapOpen = {
        keyboard = {
        },

        mouse = {
            l = {{click}, {}},
            r = {{deselect}, {}},
        },
    },

    mapOpen = {
        keyboard = {
            w = {{map.camera.moveUp, {map.camera}}, {map.camera.stop, {map.camera}}},
            a = {{map.camera.moveLeft, {map.camera}}, {map.camera.stop, {map.camera}}},
            s = {{map.camera.moveDown, {map.camera}}, {map.camera.stop, {map.camera}}},
            d = {{map.camera.moveRight, {map.camera}}, {map.camera.stop, {map.camera}}},
            lshift = {{function(dt) edgeSnap = false end}, {function(dt) edgeSnap = true end}},
            z = {{map.camera.resetZoom, {map.camera}}, {}}
        },

        mouse = {
            l = {{click}, {}},
            r = {{deselect}, {}},
        },
    },

    textInput = {
        keyboard = {
            left = {{textCursorLeft, false}, {}},
            right = {{textCursorRight, false}, {}},
        },

        mouse = {
            l = {{saveTextInput}, {}},
            r = {{saveTextInput}, {}},
        },
    },
}

controls = allControls.noMapOpen
selected = nil -- the selected object
edgeSnap = true

function love.load()
    love.window.setTitle("TSG Map Editor v" .. VERSION)
end

function love.update(dt)
end

function love.draw()
end

function love.keypressed(key)
    if controls.keyboard[key] ~= nil then
        local func = controls.keyboard[key][0][0]
        local args = controls.keyboard[key][0][1]

        if func ~= nil then
            if args == nil then
                func(dt)
            else
                func(dt, unpack(args))
            end
        end
    end
end

function love.keyreleased(key)
    if controls.keyboard[key] ~= nil then
        local func = controls.keyboard[key][1][0]
        local args = controls.keyboard[key][1][1]

        if func ~= nil then
            if args == nil then
                func(dt)
            else
                func(dt, unpack(args))
            end
        end
    end
end

function love.mousepressed(x, y, button)
    if controls.mouse[button] ~= nil then
        local func = controls.mouse[button][0][0]
        local args = controls.mouse[button][0][1]

        if func ~= nil then
            if args == nil then
                func(dt, x, y)
            else
                func(dt, x, y, unpack(args))
            end
        end
    end
end

function love.mousereleased(x, y, button)
    if controls.mouse[button] ~= nil then
        local func = controls.mouse[button][1][0]
        local args = controls.mouse[button][1][1]

        if func ~= nil then
            if args == nil then
                func(dt, x, y)
            else
                func(dt, x, y, unpack(args))
            end
        end
    end
end

function love.wheelmoved(x, y)
    local newZoom = camera.getZoomAtPos(camera.scrollPos + y)
    if not(newZoom > camera.maxZoom or newZoom < camera.minZoom) then
        camera.scrollPos = camera.scrollPos + y
    end
end
