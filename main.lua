require 'src/Dependencies'
local moonshine = require 'moonshine'

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

    --Post procesado
    --[[
    effect = moonshine(moonshine.effects.scanlines).chain(moonshine.effects.crt)
    effect.resize(push:getDimensions())
    effect.disable("scanlines")
    ]]--
    

    --Inicializar máquina de estados
    gStateMachine = StateMachine{
        ['title'] = function() return TitleState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end    
    }

    gStateMachine:change('play')

    --Tabla de entradas
    love.keyboard.keysPressed = {}
    
end

function love.keypressed(key)

    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
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

    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}

end

function love.draw()
    push:start() --acuérdate de empezar push en draw
    
    love.graphics.clear(love.math.colorFromBytes(23,24,67,255))

    love.graphics.rectangle('line', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN, GAME_HEIGHT-2*MARGIN,5,5)
    love.graphics.line(GAME_WIDTH/2, MARGIN, GAME_WIDTH/2,GAME_HEIGHT-MARGIN)

    gStateMachine:draw()
    
    push:finish() --y acuérdate de cerrarlo también
end

function displayScore(player1, player2)
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1.score), GAME_WIDTH/2 - 50, GAME_HEIGHT/3)
    love.graphics.print(tostring(player2.score), GAME_WIDTH/2 + 30, GAME_HEIGHT/3)
end