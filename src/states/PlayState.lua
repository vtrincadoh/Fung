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
        self.ball.vx = -self.ball.vx

        if self.player1.vy < 0 then
            self.ball.spin = self.ball.spin + 1
        elseif self.player1.vy > 0 then
            self.ball.spin = self.ball.spin - 1
        end
        self.ball.fallsign = 1
        sfx['HitPlayer1']:play()
    end

    if self.ball:collides(self.player2) then
        self.ball.x = self.player2.x - self.ball.r
        self.ball.vx = -self.ball.vx
        
        if self.player2.vy < 0 then
            self.ball.spin = self.ball.spin - 1
        elseif self.player2.vy > 0 then
            self.ball.spin = self.ball.spin + 1
        end

        self.ball.fallsign = -1

        sfx['HitPlayer2']:play()
    end

    --Acotar spin de la pelota
    if self.ball.spin > 2 then
        self.ball.spin = 2
    elseif self.ball.spin < -2 then
        self.ball.spin = -2
    end

    --Condiciones de borde
    if (self.ball.y - self.ball.r) <= (MARGIN) then
        self.ball.y = MARGIN + self.ball.r
        self.ball.vy = -0.8*self.ball.vy
        self.ball.vx = self.ball.vx - BORDER_FRICTION*self.ball.spin

        --disminuir spin
        if self.ball.spin ~= 0 and self.ball.vx > 0 then
            self.ball.spin = self.ball.spin + 1
        elseif self.ball.spin ~= 0 and self.ball.vx < 0 then
            self.ball.spin = self.ball.spin - 1
        end
        sfx['HitWall']:play()
    end
    if (self.ball.y + self.ball.r) >= (GAME_HEIGHT-MARGIN) then
        self.ball.y = GAME_HEIGHT - MARGIN - self.ball.r
        self.ball.vy = -0.8*self.ball.vy 
        self.ball.vx = self.ball.vx + BORDER_FRICTION*self.ball.spin
        if self.ball.spin ~= 0 and self.ball.vx > 0 then
            self.ball.spin = self.ball.spin -1
        elseif self.ball.spin ~= 0 and self.ball.vx < 0 then
            self.ball.spin = self.ball.spin + 1
        end
        sfx['HitWall']:play()
    end
    
    if self.ball.x < MARGIN then
        gScoreP2 = gScoreP2 + 1
        gStateMachine:change('serve', 2)
    end
    if self.ball.x > GAME_WIDTH - MARGIN then
        gScoreP1 = gScoreP1 + 1
        gStateMachine:change('serve', 1)
        self.ball:reset()
    end


    --Input
    if love.keyboard.wasPressed('escape') then
        --gStateMachine:change('menu')
        love.event.quit()
    end

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
    displayScore(gScoreP1, gScoreP2)
    
    --Paddle
    self.player1:draw()
    self.player2:draw()

    --Pelota
    self.ball:draw() 

    love.graphics.rectangle('line', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN, GAME_HEIGHT-2*MARGIN,5,5)
    drawBounds({love.math.colorFromBytes(COLORS['bckg'])})
    --gDebugArgs = {['FPS'] = love.timer.getFPS(), ['Spin'] = self.ball.spin}
end

