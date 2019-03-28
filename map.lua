require "camera"

Map = {
}

function Map:new(fp)
  obj = {}
  local camera = Camera:new()

  if fp ~= nil then
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end
