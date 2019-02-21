Camera = {
    x = 0,
    y = 0,
    speed = 10,
    dx = 0,
    dy = 0,
    zoom = 1,
    minZoom = 0.1,
    maxZoom = 4,
    zoomStep = 0.1,
    zoomSpeed = 0.1,
    scrollPos = 0,
}

function Camera:new(x, y)
  obj = {}
  if x ~= nil and y ~= nil then
      obj.x = x
      obj.y = y
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Camera.moveRight(dt, self)
    self.dx = self.x + self.speed * dt
end

function Camera.moveLeft(dt, self)
    self.dx = self.x - self.speed * dt
end

function Camera.moveDown(dt, self)
    self.dy = self.y + self.speed * dt
end

function Camera.moveUp(dt, self)
    self.dy = self.y - self.speed * dt
end

function Camera.stop(dt, self)
    self.dx = 0
    self.dy = 0
end

function Camera.resetZoom(dt, self)
    self.zoom = 1
    self.scrollPos = 0
end

function Camera:getZoomAtPos(scroll)
    local scrollDir = 1
    if scroll < 0 then
        scrollDir = -1
    end

    return = 1 + math.floor(math.abs(scroll) * self.zoomSpeed) * scrollDir * self.zoomStep
end

function Camera:move()
    self.x = self.x + self.dx
    self.y = self.y + self.dy
    self.zoom = math.max(self.minZoom, math.min(self.maxZoom, self.getZoomAtPos(self.scrollPos)))
end

