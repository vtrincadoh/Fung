TitleState = Class{__includes = BaseState}

function TitleState:init()
    self.options = {
        ['play'] = nil,
        ['quit'] = nil
    }
    self.currOpt = 1
    self.a = 255
    self.t = 0
    sfx['Startup']:play()
end

function TitleState:update(dt)    
    if self.a > 0 then
        self.t = self.t + dt
        self.a = 1 - math.exp(4.5*(self.t-3))
    end

    effect.scanlines.opacity = map_range(self.a, 255, 0, 0, 0.05)

    if love.keyboard.wasPressed('o') then
        self.a = 255
        self.t = 0
    end

    if not sfx['Startup']:isPlaying() then
        sfx['Static']:setLooping(true)
        sfx['Static']:play()
    end
    if math.random() < 0.01 then
        titleOffset = 4
    else
        titleOffset = 0
    end
    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        self.currOpt = self.currOpt + 1
        sfx['TitleSelect']:play()
    end
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
        self.currOpt = self.currOpt - 1
        sfx['TitleSelect']:play()
    end
    
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
    love.graphics.printf('>', -40, 110, GAME_WIDTH, 'center')
    --Margen
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN, GAME_HEIGHT-2*MARGIN,5,5)
    drawBounds({love.math.colorFromBytes(COLORS['bckg'])})
    --Splash
    if self.a > 0 then
        --love.graphics.rer(love.math.colorFromBytes(0,0,0,self.a))
        love.graphics.setColor(love.math.colorFromBytes(78,94,83,self.a*255))
        love.graphics.rectangle('fill', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN+8, GAME_HEIGHT-2*MARGIN+8)
        drawBounds({0,0,0,self.a})
    end
end