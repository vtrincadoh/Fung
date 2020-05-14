GameOverState = Class{__includes = BaseState}

function GameOverState:enter(scoringPlayer)
    winningPlayer = scoringPlayer
    sfx['Fanfare']:play()
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('space') then
        gStateMachine:change('title', true)
    end
end

function GameOverState:draw()
    love.graphics.rectangle('line', MARGIN, MARGIN, GAME_WIDTH-2*MARGIN, GAME_HEIGHT-2*MARGIN,5,5)
    love.graphics.setFont(scoreFont)
    love.graphics.printf('PLAYER '..tostring(winningPlayer)..' WINS!', 0, MARGIN + 50, GAME_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('  press -space- to return to the title screen', 0, MARGIN + 100, GAME_WIDTH-MARGIN, 'center')
end