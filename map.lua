require "camera"

Map = {}

function Map:new(fp)
  obj = {}
  self.camera = Camera:new()
  self.fp = fp

  setmetatable(obj, self)
  self.__index = self
  return obj
end
