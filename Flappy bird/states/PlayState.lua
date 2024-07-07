PlayState = Class{__includes = BaseState}


PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24


function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    --random spawn time for pipes
    self.SpawnTimer = math.random(2,4)

    -- score
    self.score = 0

    -- initialize our last y value for next gaps 
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20

end


function PlayState:update(dt)
    
    if scrolling then
    -- update timer for pipe spawn
    self.timer = self.timer + dt

    if self.timer >  self.SpawnTimer then
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y))

        -- reset timer and randomizer
        self.timer = 0
        self.SpawnTimer = math.random(2,4)
    end


    -- for every pair of pipes
    for k, pair in pairs(self.pipePairs) do
        --score if bird goes past but ignore if it has already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- bird update with jump and gravity
    self.bird:update(dt)

    -- collision between bird and the pipes
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then

                sounds['hurt']:play()
                sounds['explosion']:play()
                gStateMachine:change('score', {score = self.score})
            end
        end
    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['hurt']:play()
        sounds['explosion']:play()
        gStateMachine:change('score', {score = self.score})
    end

end
end



function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

function PlayState:enter()
    -- is restarting
    scrolling = true
end

function PlayState:exit()
    -- if death or other state
    scrolling = false
end

