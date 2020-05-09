TitleState = Class{__includes = BaseState}

local BUTTON_WIDTH = 120
local BUTTON_HEIGHT = 40

function TitleState:init()
    self.options = {
        ['play'] = nil,
        ['quit'] = nil
    }
end

function TitleState:update(dt)

end

function TitleState:draw()
    love.graphics.setFont(titleFont)
    love.graphics.printf('FUNG', 0, 20, GAME_WIDTH, 'center')
    drawButton('play', GAME_WIDTH/2 - BUTTON_WIDTH/2, 100)
end

function drawButton(text, x, y)
    love.graphics.setFont(mediumFont)
    love.graphics.printf(text, x, y + BUTTON_HEIGHT/2, BUTTON_WIDTH, 'center')
    love.graphics.setLineWidth(2)
    love.graphics.rectangle('line', x, y, BUTTON_WIDTH, BUTTON_HEIGHT, BUTTON_HEIGHT/2, BUTTON_HEIGHT/2)
    love.graphics.setLineWidth(1)
end