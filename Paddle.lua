Paddle = Class{}



function Paddle:init(x, y, w, h)
    self.x = x
    self.y = y

    self.w = w
    self.h = h
    
    self.vy = 0

    self.score = 0
end

function Paddle:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

function Paddle:update(dt)
    if self.vy < 0 then
        self.y = math.max(MARGIN, self.y + self.vy*dt)
    else 
        self.y = math.min(GAME_HEIGHT - MARGIN - self.h, self.y + self.vy*dt)
    end
end
