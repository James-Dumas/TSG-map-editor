require "camera.lua"

Map = {
}

function Map:new(fp)
  obj = {}
  local camera = Camera:new()

  setmetatable(obj, self)
  self.__index = self
  return obj
end
