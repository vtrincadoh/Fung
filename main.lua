require 'src/dependencies'

--Post procesado
crt = moonshine(moonshine.effects.scanlines)
.chain(moonshine.effects.crt)

crt.params = {
    crt = {feather = 0},
    scanlines = {opacity = 0.05},
}  

chromasep = moonshine(moonshine.effects.chromasep)
chromasep.params = {
    chromasep = {radius = 0.8, angle = 0},
}

humEnabled = true

gDebugArgs = {}

function love.load()
    
    love.graphics.setDefaultFilter('linear', 'nearest')
    --Seed
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('assets/font.ttf', 8)
    mediumFont = love.graphics.newFont('assets/font.ttf', 18)
    scoreFont = love.graphics.newFont('assets/font.ttf', 32)
    titleFont = love.graphics.newFont('assets/font.ttf', 60)
    love.graphics.setFont(mediumFont)

    sfx = {
        ['TitleSelect'] = love.audio.newSource('assets/sfx/TitleSelect.wav', 'static'),
        --['TitleEnter'] = love.audio.newSource('assets/sfx/'),
        ['HitPlayer1'] = love.audio.newSource('assets/sfx/HitPlayer1.wav', 'static'),
        ['HitPlayer2'] = love.audio.newSource('assets/sfx/HitPlayer2.wav', 'static'),
        ['HitWall'] = love.audio.newSource('assets/sfx/HitWall.wav', 'static'),
        ['Goal'] = love.audio.newSource('assets/sfx/Goal.wav', 'static'),
        ['Startup'] = love.audio.newSource('assets/sfx/Startup.wav', 'static'),
        ['Static'] = love.audio.newSource('assets/sfx/Static.wav', 'static'),
        ['Fanfare'] = love.audio.newSource('assets/sfx/Fanfare.wav', 'static'),
        ['Goodbye'] = love.audio.newSource('assets/sfx/Goodbye.wav', 'static')
    }
    love.audio.setVolume(0.8)
    sfx['Goal']:setVolume(0.1)
    sfx['Fanfare']:setVolume(0.1)
    sfx['Goodbye']:setVolume(0.1)

    -- Pa poner una resolución específica
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = true,
        resizable = false
    })

    crt.resize(push:getDimensions())

    --Inicializar máquina de estados
    gStateMachine = StateMachine{
        ['title'] = function() return TitleState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['gameover'] = function() return GameOverState() end
    }

    gStateMachine:change('title')
    introDisabled = false

    --Tabla de entradas
    love.keyboard.keysPressed = {}
    
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'h' then
        sfx['Static']:setLooping(false)
        sfx['Static']:pause()
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

    if love.keyboard.wasPressed('h') then
        if humEnabled then
            humEnabled = false
        else
            humEnabled = true
        end
    end
    
    if hasPlayed and humEnabled then
        sfx['Static']:play()
    else
        sfx['Static']:stop()
    end
    love.keyboard.keysPressed = {}

end

function love.draw()    
    push:start() --acuérdate de empezar push en draw
    chromasep(function()
    crt(function()
        love.graphics.clear(love.math.colorFromBytes(COLORS['bckg']))
        gStateMachine:draw()
    end)
    end)
    displayDebug(gDebugArgs)
    push:finish() --y acuérdate de cerrarlo también
end

function drawBounds(color)
    prevColor = {love.graphics.getColor()}
    love.graphics.setColor(color)
    love.graphics.rectangle('fill',0,0,GAME_WIDTH, MARGIN)
    love.graphics.rectangle('fill',0,0,MARGIN,GAME_HEIGHT)
    love.graphics.rectangle('fill', 0, GAME_HEIGHT-MARGIN, GAME_WIDTH, MARGIN)
    love.graphics.rectangle('fill', GAME_WIDTH-MARGIN, 0, MARGIN, GAME_HEIGHT)
    --love.graphics.setColor(1,1,1,1)
    --love.graphics.rectangle('line', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN, GAME_HEIGHT-2*MARGIN,5,5)
    love.graphics.setColor(prevColor)
end

function displayScore(score1, score2)
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(score1), GAME_WIDTH/2 - 50, GAME_HEIGHT/3)
    love.graphics.print(tostring(score2), GAME_WIDTH/2 + 30, GAME_HEIGHT/3)
end

function displayDebug(gDebugArgs)
    iterator = 0
    love.graphics.setFont(smallFont)
    prevColor = {love.graphics.getColor()}
    love.graphics.setColor(0,1,0,1)
    for k, pair in pairs(gDebugArgs) do
        love.graphics.print(k..': '..pair, 5, 5 + iterator * 10)
        iterator = iterator +1
    end
    love.graphics.setColor(prevColor)
end
function map_range(s, a1, a2, b1, b2)
    return b1 + (s-a1)*(b2-b1)/(a2-a1)
end

function love.resize(w,h)
    push:resize(w,h)
end
