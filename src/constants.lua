--Constantes
WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 720

GAME_WIDTH = 360
GAME_HEIGHT = 240

MARGIN = 15

PADDLE_WIDTH = 10
PADDLE_HEIGHT = 40

BALL_SPEED = 80
BORDER_FRICTION = 80
FALL_FACTOR = 50

PADDLE_SPEED = 150

--[[ Combinaciín preferida
    ['bckg'] = {23, 24, 67, 255},
    ['ball'] = {0xFF, 0x7F, 0, 255}
]]--
COLORS = {
    ['k'] = {0,0,0,255},
    ['wh'] = {255,255,255,255},
    ['bckg'] = {23, 24, 67, 255},
    ['dk-bckg'] = {7,8,33,120},
    ['ball'] = {0xFF, 0x7F, 0, 255}
}

BALL_COLOR = {
    [-3] = {0,0,0,0},
    [-2] = {160, 0, 0, 255},
    [-1] = {208, 127, 0, 255},
    [0] = {0xFF, 0xFF, 0, 255},
    [1] = {127, 208, 0, 255},
    [2] = {0, 160, 0, 255},
    [3] = {0,0,0,0}
}
