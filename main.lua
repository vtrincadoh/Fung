--Inclusiones
Class = require 'class'
push = require 'push'
require 'Paddle'
require 'Ball'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleState'
require 'states/ServeState'

--Constantes
WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 720

GAME_WIDTH = 360
GAME_HEIGHT = 240

MARGIN = 15

PADDLE_WIDTH = 10
PADDLE_HEIGHT = 40

BALL_SPEED = 100

PADDLE_SPEED = 150
--Fin constantes

function gaussian_curve(x,amp,prom,dsv)
    variacion = (x-prom)^2
    cts = -1/2*dsv^2
    return amp*math.exp(cts*variacion)
end


function love.load()
    
    love.graphics.setDefaultFilter('nearest', 'nearest')

    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(scoreFont)


    -- Pa poner una resolución específica
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })
    
   --Inicializa los objetos 
    math.randomseed(os.time())
    player1 = Paddle(MARGIN+5, GAME_HEIGHT/2 - PADDLE_HEIGHT/2, PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(GAME_WIDTH-MARGIN-5-PADDLE_WIDTH, GAME_HEIGHT/2 - PADDLE_HEIGHT/2, PADDLE_WIDTH, PADDLE_HEIGHT)

    ball = Ball({})
    ball:reset()
    print(math.deg(angle))

    --Inicializar máquina de estados
    gStateMachine = StateMachine{
        ['title'] = function() return TitleState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end    
    }

    gStateMachine:change('title')

    --Tabla de entradas
    love.keyboard.keysPressed = {}
    
end

function love.keypressed(key)

    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
    if key == 'o' then
        ball:reset()
    end

end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)

    --Colisiones con paletas
    if ball:collides(player1) then
        ball.x = player1.x + player1.w + ball.r
        ball.vx = -ball.vx * 1.05
        ball:applySpin(player1)
    end

    if ball:collides(player2) then
        ball.x = player2.x - ball.r
        ball.vx = -ball.vx * 1.05
        ball:applySpin(player2)
    end

    --Condiciones de borde
    if (ball.y - ball.r) <= (MARGIN) then
        ball.y = MARGIN + ball.r
        ball.vy = -ball.vy
    end
    if (ball.y + ball.r) >= (GAME_HEIGHT-MARGIN) then
        ball.y = GAME_HEIGHT - MARGIN - ball.r
        ball.vy = -ball.vy 
    end
    
    if ball.x < MARGIN then
        player2.score = player2.score + 1
        ball:reset()
    end
    if ball.x > GAME_WIDTH - MARGIN then
        player1.score = player1.score + 1
        ball:reset()
    end


    --Input
    if love.keyboard.isDown('w') then
        player1.vy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.vy = PADDLE_SPEED
    else
        player1.vy = 0
    end

    if love.keyboard.isDown('up') then
        player2.vy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.vy = PADDLE_SPEED
    else
        player2.vy = 0
    end


    player1:update(dt)
    player2:update(dt)
    ball:update(dt)
    print(ball.spin)

    love.keyboard.keysPressed = {}

end

function love.draw()
    push:start() --acuérdate de empezar push en draw
    love.graphics.clear(love.math.colorFromBytes(23,24,67,255))

    love.graphics.rectangle('line', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN, GAME_HEIGHT-2*MARGIN,5,5)
    love.graphics.line(GAME_WIDTH/2, MARGIN, GAME_WIDTH/2,GAME_HEIGHT-MARGIN)

    --Mostrar puntaje
    displayScore()

    --Paddle
    player1:draw()
    player2:draw()

    --Pelota
    ball:draw()

    push:finish() --y acuérdate de cerrarlo también
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1.score), GAME_WIDTH/2 - 50, GAME_HEIGHT/3)
    love.graphics.print(tostring(player2.score), GAME_WIDTH/2 + 30, GAME_HEIGHT/3)
end