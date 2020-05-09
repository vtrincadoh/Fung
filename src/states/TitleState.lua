TitleState = Class{__includes = BaseState}

local BUTTON_WIDTH = 120
local BUTTON_HEIGHT = 40

function TitleState:init()
    self.options = {
        ['play'] = nil,
        ['quit'] = nil
    }
    self.currOpt = 1
end

function TitleState:update(dt)
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
    --Título
    love.graphics.setFont(titleFont)
    love.graphics.setColor(love.math.colorFromBytes(COLORS['ball']))
    love.graphics.printf('FUNG', 2, 33, GAME_WIDTH, 'center')
    love.graphics.setColor(love.math.colorFromBytes(COLORS['dk-bckg']))
    --love.graphics.printf('FUNG', 1, 22, GAME_WIDTH, 'center')
    love.graphics.setColor(love.math.colorFromBytes(COLORS['wh']))
    love.graphics.printf('FUNG', 0, 32, GAME_WIDTH, 'center')

    --Botones
    drawButton('play', GAME_WIDTH/2 - BUTTON_WIDTH/2, 90)
    drawButton('quit', GAME_WIDTH/2 - BUTTON_WIDTH/2, 150)

    drawBounds()
end

function drawButton(text, x, y, color)
    prevColor = {love.graphics.getColor()}
    newColor = color or prevColor
    love.graphics.setFont(mediumFont)
    love.graphics.setColor(newColor)
    love.graphics.printf(text, x, y + BUTTON_HEIGHT/2, BUTTON_WIDTH, 'center')
    --love.graphics.setLineWidth(2)
    --love.graphics.rectangle('line', x, y, BUTTON_WIDTH, BUTTON_HEIGHT, BUTTON_HEIGHT/2, BUTTON_HEIGHT/2)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(prevColor)
end