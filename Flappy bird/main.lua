push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

require 'PipePair'

--game states
require 'StateMachine'

require 'states/BaseState'
require 'states/PlayState'
require 'states/CountdownState'
require 'states/ScoreState'
require 'states/TitleScreenState'

--screen dim
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual dim, best for this art style
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


--medals
bronze = love.graphics.newImage('bronze.png')
silver = love.graphics.newImage('silver.png')
gold = love.graphics.newImage('gold.png')


-- graphics.newImage(name)
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

--scroll
local backgroundScroll = 0
local groundScroll = 0

-- parallax speed 
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

--point where it loops
local BACKGROUND_LOOPING_POINT = 413 -- x axis point

--pause scrolling when dying
 scrolling = true

 --pause var
 paused = false

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())-- random seed

    -- app window title
    love.window.setTitle('Dans Flappy Bird')

    --Fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    --sounds table
     sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['pause'] = love.audio.newSource('pause.wav', 'static'),
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')

    }

     -- start looping music
    sounds['music']:setLooping(true)
    sounds['music']:play()


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    --state machine initialize
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    --table of keys
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key) --function to check if key pressed is in table
    
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end

    if  gStateMachine:is('play') then 
        if key == 'p' then
            if paused == false then
                scrolling = false
                paused = true
                sounds['pause']:play()
                sounds['music']:pause()

            elseif paused == true then
                scrolling = true
                paused = false
                sounds['pause']:play()
                sounds['music']:play()
            
            end
        end
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
    if scrolling then
        --background speed * dt and looping after loop point
        -- ground speed * dt and looping after loop point
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

   
end
    --state machine to play
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {} --reset table
end

function love.draw()
    push:start()

     love.graphics.draw(background, -backgroundScroll, 0)

     gStateMachine:render()

     love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    if paused == true then 
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Game is paused', 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press P to unpause', 0, 160, VIRTUAL_WIDTH, 'center')
    end

    push:finish()
end

