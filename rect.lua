
function getPixRect(relRect)
    -- get the pixel rectangle of a relative (to the window size) rectangle
    local W = love.graphics.getWidth()
    local H = love.graphics.getHeight()
    return {math.ceil(relRect[1] * W), math.ceil(relRect[2] * H), math.ceil(relRect[3] * W), math.ceil(relRect[4] * H)}
end

function rectContains(relRect, x, y)
    -- returns true when (x, y) lies within the rectangle
    -- note that x, y are pixel coordinates, while relRect is relative
    local pixRect = getPixRect(relRect)
    return x >= pixRect[1] and y >= pixRect[2] and x < pixRect[1] + pixRect[3] and y < pixRect[2] + pixRect[4]
end
