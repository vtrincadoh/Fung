PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player1 = Paddle(MARGIN+5, GAME_HEIGHT/2 - PADDLE_HEIGHT/2, PADDLE_WIDTH, PADDLE_HEIGHT)
    self.player2 = Paddle(GAME_WIDTH-MARGIN-5-PADDLE_WIDTH, GAME_HEIGHT/2 - PADDLE_HEIGHT/2, PADDLE_WIDTH, PADDLE_HEIGHT)
    self.ball = Ball({})
    self.ball:reset()
end

function PlayState:update(dt)

    if love.keyboard.wasPressed('o') then
        self.ball:reset()
    end
     --Colisiones con paletas
     if self.ball:collides(self.player1) then

        self.ball.x = self.player1.x + self.player1.w + self.ball.r
        self.ball.vx = -self.ball.vx * 1.05
        sfx['HitPlayer1']:play()
        self.ball:speedToSpin(self.player1)
    end

    if self.ball:collides(self.player2) then
        self.ball.x = self.player2.x - self.ball.r
        self.ball.vx = -self.ball.vx * 1.05
        sfx['HitPlayer2']:play()
        self.ball:speedToSpin(self.player2)
    end

    --Condiciones de borde
    if (self.ball.y - self.ball.r) <= (MARGIN) then
        self.ball.y = MARGIN + self.ball.r
        self.ball.vy = -self.ball.vy
        sfx['HitWall']:play()
    end
    if (self.ball.y + self.ball.r) >= (GAME_HEIGHT-MARGIN) then
        self.ball.y = GAME_HEIGHT - MARGIN - self.ball.r
        self.ball.vy = -self.ball.vy 
        sfx['HitWall']:play()
    end
    
    if self.ball.x < MARGIN then
        self.player2.score = self.player2.score + 1
        self.ball:reset()
    end
    if self.ball.x > GAME_WIDTH - MARGIN then
        self.player1.score = self.player1.score + 1
        self.ball:reset()
    end


    --Input
    if love.keyboard.isDown('w') then
        self.player1.vy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        self.player1.vy = PADDLE_SPEED
    else
        self.player1.vy = 0
    end

    if love.keyboard.isDown('up') then
        self.player2.vy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        self.player2.vy = PADDLE_SPEED
    else
        self.player2.vy = 0
    end


    self.player1:update(dt)
    self.player2:update(dt)
    self.ball:update(dt)
end

function PlayState:draw()
    
    love.graphics.line(GAME_WIDTH/2, MARGIN, GAME_WIDTH/2,GAME_HEIGHT-MARGIN)
    --Mostrar puntaje
    displayScore(self.player1, self.player2)
    
    --Paddle
    self.player1:draw()
    self.player2:draw()

    --Pelota
    self.ball:draw() 

    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN, GAME_HEIGHT-2*MARGIN,5,5)
    drawBounds({love.math.colorFromBytes(COLORS['bckg'])})
end

