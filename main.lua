require 'src/dependencies'


function gaussian_curve(x,amp,prom,dsv)
    variacion = (x-prom)^2
    cts = -1/2*dsv^2
    return amp*math.exp(cts*variacion)
end


function love.load()
    
    love.graphics.setDefaultFilter('nearest', 'nearest')
    --Seed
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('font.ttf', 24)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    titleFont = love.graphics.newFont('font.ttf', 46)
    love.graphics.setFont(mediumFont)


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

    gStateMachine:change('title')

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
    love.graphics.clear(love.math.colorFromBytes(COLORS['bckg']))

    gStateMachine:draw()
    love.graphics.setColor(love.math.colorFromBytes(COLORS['bckg']))
    love.graphics.rectangle('fill',0,0,MARGIN,GAME_HEIGHT)
    love.graphics.rectangle('fill', GAME_WIDTH-MARGIN, 0, MARGIN, GAME_HEIGHT)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN, GAME_HEIGHT-2*MARGIN,5,5)

    displayFPS()

    push:finish() --y acuérdate de cerrarlo también
end

function displayScore(player1, player2)
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1.score), GAME_WIDTH/2 - 50, GAME_HEIGHT/3)
    love.graphics.print(tostring(player2.score), GAME_WIDTH/2 + 30, GAME_HEIGHT/3)
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0,1,0,1)
    love.graphics.print('FPS: '..tostring(love.timer.getFPS()), 5, 5)
    love.graphics.setColor(1,1,1,1)
end