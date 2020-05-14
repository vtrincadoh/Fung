Ball = Class{}

function Ball:init(x, y, vx, vy)
    --Pos
    self.x = x
    self.y = y

    --Radio
    self.r = 3.5

    --Vel
    self.vx = vx
    self.vy = vy

    --Spin (-)anti-clockwise, (+) clockwise
    self.spin = 0
    self.fallsign = 1
end

function Ball:draw()
    prevColor = {love.graphics.getColor()}
    love.graphics.setColor(love.math.colorFromBytes(BALL_COLOR[self.spin]))
    love.graphics.ellipse('fill', self.x, self.y, self.r, self.r)
    love.graphics.setColor(prevColor)
end

function Ball:update(dt)
    self.x = self.x + self.vx*dt
    self.vy = self.vy + FALL_FACTOR*self.fallsign*self.spin*dt
    self.y = self.y + self.vy*dt
end

function Ball:reset()
    angle = 2*math.pi*math.random()
    self.x = GAME_WIDTH/2
    self.y = GAME_HEIGHT/2
    self.vx = BALL_SPEED*math.cos(angle)
    self.vy = BALL_SPEED*math.sin(angle)
    self.spin = 0
end

function Ball:collides(paddle)
    if (self.x - self.r+1) > (paddle.x + paddle.w) or (self.x + self.r-1)<(paddle.x) then
        return false
    end
    if (self.y - self.r)>(paddle.y + paddle.h) or (self.y + self.r)<(paddle.y) then
        return false
    end
    return true
end