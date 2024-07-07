PipePair = Class{}


math.randomseed(os.time()) -- random initialize

function PipePair:init(y)
 
    self.x = VIRTUAL_WIDTH + 32

    -- y value is for the top pipe
    self.y = y

    -- instantiate two pipes that belong to this pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y + 30),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + math.random(90, 150))     
    }

    -- if this pair can be be removed from the scene
    self.remove = false
    self.scored = false
end

function PipePair:update(dt)

    if scrolling then
    -- remove the pipe from the scene if it's beyond the left edge of the screen,
    -- else move it from right to left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true

    end

end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end