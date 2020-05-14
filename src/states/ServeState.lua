ServeState = Class{__includes = PlayState}

function ServeState:enter(scoringPlayer)
    if gScoreP1 == 10 or gScoreP2 == 10 then
        gStateMachine:change('gameover', scoringPlayer)
    end
    self.player1.y = GAME_HEIGHT/2 - self.player1.h/2
    self.player2.y = GAME_HEIGHT/2 - self.player2.h/2
    self.ball:reset()
    serves = scoringPlayer == 1 and 2 or 1
    serveKey = serves == 1 and 'lshift' or 'rshift'
end

function ServeState:update(dt)
    if love.keyboard.wasPressed('escape') then
        --gStateMachine:change('menu')
        love.event.quit()
    end

    if love.keyboard.wasPressed(serveKey) then
        gStateMachine:change('play', serves)
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
    if love.keyboard.wasPressed('space') then
        --
    end
end

function ServeState:draw()
    love.graphics.line(GAME_WIDTH/2, MARGIN+60, GAME_WIDTH/2,GAME_HEIGHT-MARGIN)
    --Mostrar puntaje
    displayScore(gScoreP1, gScoreP2)
    
    --Paddle
    self.player1:draw()
    self.player2:draw()

    --Pelota
    self.ball:draw() 

    love.graphics.rectangle('line', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN, GAME_HEIGHT-2*MARGIN,5,5)
    drawBounds({love.math.colorFromBytes(COLORS['bckg'])})
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Player '..serves..' serves', 0, MARGIN + 5, GAME_WIDTH, 'center')
    love.graphics.printf('Press -'..serveKey..'- to serve', 0, MARGIN + 25, GAME_WIDTH, 'center')
    --gDebugArgs = {['FPS'] = love.timer.getFPS(), ['Spin'] = self.ball.spin}
end