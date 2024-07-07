Bird = Class{}

local GRAVITY = 3

function Bird:init()
    -- load bird image 
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- bird pos in mid screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    if scrolling then
    -- apply gravity to velocity
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then --jump
        self.dy = -1
        sounds['jump']:play()
    end

    -- apply  velocity to y pos
    self.y = self.y + self.dy
end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end