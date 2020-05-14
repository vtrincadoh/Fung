TitleState = Class{__includes = BaseState}

local highlighted = 1
local timer = 0
local alfa = 1
local humEnabled = true

function TitleState:update(dt)    
    if alfa > 0 then
        timer = timer + dt
        alfa = 1 - math.exp(5*(timer-3.5))
    end
    if  alfa < 0.95 and alfa > 0.8 then
        sfx['Startup']:play()
        hasPlayed = true
    end

    if hasPlayed and not sfx['Startup']:isPlaying() then
        sfx['Static']:setLooping(true)
        sfx['Static']:play()
    end
    if hasPlayed then
        if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') or love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
            highlighted = highlighted == 1 and 2 or 1
            sfx['TitleSelect']:play()
        end
        if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
            if highlighted == 1 then
                --sfx['TitleConfirm']:play()
                gStateMachine:change('play')
            elseif highlighted == 2 then
                sfx['Goodbye']:play()
                love.timer.sleep(0.5)
                love.event.quit()                
            end
        end
    end

    if love.keyboard.wasPressed('escape') then
        sfx['Goodbye']:play()     
        love.timer.sleep(0.5)
        love.event.quit()
    end

    if math.random() < 0.01 then
        titleOffset = 4
    else
        titleOffset = 0
    end

    --print(self.currOpt)
    
end     


function TitleState:draw()
    --Inicio
    --love.graphics.clear(love.math.colorFromBytes(51,47,38,255))
    --Título
    love.graphics.setFont(titleFont)
    love.graphics.setColor(love.math.colorFromBytes(COLORS['ball']))
    love.graphics.printf('FUNG', 3, 33, GAME_WIDTH, 'center')
    love.graphics.setColor(love.math.colorFromBytes(COLORS['dk-bckg']))
    love.graphics.printf('FUNG', 2, 33, GAME_WIDTH, 'center')
    love.graphics.setColor(love.math.colorFromBytes(COLORS['wh']))
    love.graphics.printf('FUNG', 0+titleOffset, 32, GAME_WIDTH, 'center')

    --Botones
    love.graphics.setFont(mediumFont)
    love.graphics.printf('play', 0, 110, GAME_WIDTH, 'center')
    love.graphics.printf('quit', 0, 150, GAME_WIDTH, 'center')
    --Selector(prueba)
    if highlighted == 1 then
        love.graphics.printf('>', -40, 110, GAME_WIDTH, 'center')
    elseif highlighted == 2 then
        love.graphics.printf('>', -40, 150, GAME_WIDTH, 'center')
    end

    --Margen
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN, GAME_HEIGHT-2*MARGIN,5,5)
    drawBounds({love.math.colorFromBytes(COLORS['bckg'])})
    --Splash
    if alfa > 0 then
        love.graphics.setColor(love.math.colorFromBytes(78,94,83,alfa*255))
        love.graphics.rectangle('fill', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN+8, GAME_HEIGHT-2*MARGIN+8)
        drawBounds({0,0,0,alfa})
    end
end

function TitleState:enter(introDisabled)
    if introDisabled then
        alfa = 0
    end
end

function TitleState:exit()
    gScoreP1 = 0
    gScoreP2 = 0
end