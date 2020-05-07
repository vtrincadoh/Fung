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
end

function Ball:draw()
    love.graphics.setColor(love.math.colorFromBytes(0xff,0x7f,0,0xff))
    love.graphics.ellipse('fill', self.x, self.y, self.r, self.r)
end

function Ball:update(dt)
    self.x = self.x + self.vx*dt
    self.y = self.y + self.vy*dt
end

function Ball:applySpin(paddle)
    dspeed = math.abs(paddle.vy -self.vy)
    if paddle.vy < 0 then
    self.spin = self.spin - (dspeed)/self.r
end

function Ball:reset()
    angle = 2*math.pi*math.random()
    self.x = GAME_WIDTH/2
    self.y = GAME_HEIGHT/2
    self.vx = BALL_SPEED*math.cos(angle)
    self.vy = BALL_SPEED*math.sin(angle)
end

function Ball:collides(paddle)
    if (self.x - self.r) > (paddle.x + paddle.w) or (self.x + self.r)<(paddle.x) then
        return false
    end
    if (self.y - self.r)>(paddle.y + paddle.h) or (self.y + self.r)<(paddle.y) then
        return false
    end
    return true
end