require 'src/dependencies'


function gaussian_curve(x,amp,prom,dsv)
    variacion = (x-prom)^2
    cts = -1/2*dsv^2
    return amp*math.exp(cts*variacion)
end


function love.load()
    
    love.graphics.setDefaultFilter('linear', 'nearest')
    --Seed
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('assets/font.ttf', 8)
    mediumFont = love.graphics.newFont('assets/font.ttf', 24)
    scoreFont = love.graphics.newFont('assets/font.ttf', 32)
    titleFont = love.graphics.newFont('assets/font.ttf', 60)
    love.graphics.setFont(mediumFont)

    sfx = {
        ['TitleSelect'] = love.audio.newSource('assets/sfx/TitleSelect.wav', 'static'),
        --['TitleEnter'] = love.audio.newSource('assets/sfx/'),
        ['HitPlayer1'] = love.audio.newSource('assets/sfx/HitPlayer1.wav', 'static'),
        ['HitPlayer2'] = love.audio.newSource('assets/sfx/HitPlayer2.wav', 'static'),
        ['HitWall'] = love.audio.newSource('assets/sfx/HitWall.wav', 'static'),
        ['goal'] = nil
    }
    love.audio.setVolume(0.8)


    -- Pa poner una resolución específica
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })

    --Post procesado
    
    effect = moonshine(moonshine.effects.glow).chain(moonshine.effects.scanlines).chain(moonshine.effects.crt)
    effect.resize(push:getDimensions())
    --effect.disable("glow")
    effect.params = {
        crt = {feather = 0},
        scanlines = {opacity = 0.05},
        glow = {strength = 0.8}
    }
    
    

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
    love.graphics.clear(love.math.colorFromBytes(3,15,3,255))
    effect(function()
    love.graphics.clear(love.math.colorFromBytes(COLORS['bckg']))

    gStateMachine:draw()
    
    end)
    displayFPS()
    push:finish() --y acuérdate de cerrarlo también
end

function drawBounds()
    prevColor = {love.graphics.getColor()}
    love.graphics.setColor(love.math.colorFromBytes(COLORS['bckg']))
    love.graphics.rectangle('fill',0,0,MARGIN,GAME_HEIGHT)
    love.graphics.rectangle('fill', GAME_WIDTH-MARGIN, 0, MARGIN, GAME_HEIGHT)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN, GAME_HEIGHT-2*MARGIN,5,5)
    love.graphics.setColor(prevColor)
end

function displayScore(player1, player2)
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1.score), GAME_WIDTH/2 - 50, GAME_HEIGHT/3)
    love.graphics.print(tostring(player2.score), GAME_WIDTH/2 + 30, GAME_HEIGHT/3)
end

function displayFPS()
    love.graphics.setFont(smallFont)
    prevColor = {love.graphics.getColor()}
    love.graphics.setColor(0,1,0,1)
    love.graphics.print('FPS: '..tostring(love.timer.getFPS()), 5, 5)
    love.graphics.setColor(prevColor)
end