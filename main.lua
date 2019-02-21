VERSION = "1.0-alpha"

camera = 
{
    x = 0,
    y = 0,
    speed = 10,
    dx = 0,
    dy = 0,
    zoom = 1,
    minZoom = 0.1,
    maxZoom = 4,
    zoomStep = 0.1,
    zoomSpeed = 0.1
    scrollPos = 0

    moveRight = function(dt)
        camera.dx = camera.x + camera.speed * dt
    end,

    moveLeft = function(dt)
        camera.dx = camera.x - camera.speed * dt
    end,

    moveDown = function(dt)
        camera.dy = camera.y + camera.speed * dt
    end,

    moveUp = function(dt)
        camera.dy = camera.y - camera.speed * dt
    end,

    stop = function(dt)
        camera.dx = 0
        camera.dy = 0
    end,

    resetZoom = function(dt)
        camera.zoom = 1
        camera.scrollPos = 0
    end

    getZoomAtPos = function(scroll)
        local scrollDir = 1
        if scroll < 0 then
            scrollDir = -1
        end

        return = 1 + math.floor(math.abs(scroll) * camera.zoomSpeed) * scrollDir * camera.zoomStep
    end

    move = function()
        camera.x = camera.x + camera.dx
        camera.y = camera.y + camera.dy
        camera.zoom = math.max(camera.minZoom, math.min(camera.maxZoom, camera.getZoomAtPos(camera.scrollPos)))
    end,
}

-- bind each key/button to a 2-tuple containing two tables in the format:
-- [0] = a function that takes dt as its first argument
-- [1] = a table containing the remaining arguments (or nil if no args)
-- the first table is for pressed event, the second is for released event
controls = {
    keyboard = {
        w = {{camera.moveUp}, {camera.stop}},
        a = {{camera.moveLeft}, {camera.stop}},
        s = {{camera.moveDown}, {camera.stop}},
        d = {{camera.moveRight}, {camera.stop}},
        lshift = {{function(dt) edgeSnap = false end}, {function(dt) edgeSnap = true end}},
        z = {{camera.resetZoom}, {}}
    },

    mouse = {
        l = {{click}, {}},
        r = {{deselect}, {}},
    },
}

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
end

function love.keyreleased(key)
end

function love.mousepressed(x, y, button)
    if controls.mouse[button] ~= nil then
        controls.mouse[button][1]
    end
end

function love.mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
    local newZoom = camera.getZoomAtPos(camera.scrollPos + y)
    if not(newZoom > camera.maxZoom or newZoom < camera.minZoom) then
        camera.scrollPos = camera.scrollPos + y
    end
end
