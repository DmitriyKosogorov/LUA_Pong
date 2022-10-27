Ball={}
Ball.__index = Ball

function Ball:create(location, size, velocity, norm_speed, minWidth, minHeight, maxWidth, maxHeight)
    local ball = {}
    setmetatable(ball, Ball)
    ball.location=location
    ball.size=size
    ball.norm_speed=norm_speed
    ball.saved_speed=norm_speed
    ball.velocity=velocity
    ball.minWidth=minWidth
    ball.maxWidth=maxWidth
    ball.minHeight=minHeight
    ball.maxHeight=maxHeight
    ball.baselocation=location

    ball.sound_pong=love.audio.newSource("resources/pong.wav", "static")
    ball.sound_coin=love.audio.newSource("resources/coin.wav", "static")

    if(ball.velocity:mag()<ball.norm_speed) then
        while(ball.velocity:mag()<ball.norm_speed) do
            ball.velocity.x=ball.velocity.x*1.1
            ball.velocity.y=ball.velocity.y*1.1
        end
    elseif(ball.velocity:mag()>ball.norm_speed) then
        while(ball.velocity:mag()>ball.norm_speed) do
            ball.velocity.x=ball.velocity.x*0.9
            ball.velocity.y=ball.velocity.y*0.9
        end
    end

    return ball
end

function Ball:draw()
    love.graphics.circle("fill", self.location.x, self.location.y, self.size)
end

function Ball:update()
    self.location:add(self.velocity)
end

function Ball:normalize_speed()
    if(self.velocity:mag()<self.norm_speed) then
        while(self.velocity:mag()<self.norm_speed) do
            self.velocity.x=self.velocity.x*1.1
            self.velocity.y=self.velocity.y*1.1
        end
    elseif(self.velocity:mag()>self.norm_speed) then
        while(self.velocity:mag()>self.norm_speed) do
            self.velocity.x=self.velocity.x*0.9
            self.velocity.y=self.velocity.y*0.9
        end
    end
end


function Ball:checkBoundaries()

    if self.location.y > self.maxHeight - self.size then
        self.location.y = self.maxHeight - self.size
        self.velocity.y = -1 * self.velocity.y
    elseif self.location.y < self.minHeight+self.size then
        self.location.y = self.minHeight+self.size
        self.velocity.y = -1 * self.velocity.y
    end
end

function Ball:checkArcanoid(arcanoid)

    if(arcanoid.stat=="R") then
        if(self.location.x+self.size>=arcanoid.x_center-arcanoid.width/2 and
         self.location.x<=arcanoid.x_center+arcanoid.width/2 and
          self.location.y>=arcanoid.y_center-arcanoid.height/2 and
           self.location.y<=arcanoid.y_center+arcanoid.height/2) then
            self.norm_speed=self.norm_speed+0.4
            self.velocity.x = self.location.x-arcanoid.x_center
            self.velocity.y = self.location.y-arcanoid.y_center
            self:normalize_speed()
            self.sound_pong:play()
        end
    end
    if(arcanoid.stat=="L") then
        if(self.location.x-self.size<=arcanoid.x_center+arcanoid.width/2 and
         self.location.x>=arcanoid.x_center-arcanoid.width/2 and
          self.location.y>=arcanoid.y_center-arcanoid.height/2 and
           self.location.y<=arcanoid.y_center+arcanoid.height/2) then
            self.norm_speed=self.norm_speed+0.6
            self.velocity.x = self.location.x-arcanoid.x_center
            self.velocity.y = self.location.y-arcanoid.y_center
            self:normalize_speed()
            self.sound_pong:play()
        end
    end
end

function Ball:restart()
    self.location=self.baselocation
    self.norm_speed=self.saved_speed
    self.velocity.x=love.math.random(2,3)
    self.velocity.y=love.math.random(-3,3)
    self:normalize_speed()
end

function Ball:giveRightPoint(arcanoid)
    if self.location.x > self.maxWidth - self.size then
        arcanoid.counter=arcanoid.counter+1
        self.sound_coin:play()
    end
end

function Ball:giveLeftPoint(arcanoid)
    if self.location.x < self.minWidth+self.size then
        arcanoid.counter=arcanoid.counter+1
        self.sound_coin:play()
    end
end

function Ball:startAgain()
    if self.location.x > self.maxWidth - self.size or self.location.x < self.minWidth+self.size then
        self.location.x=(self.minWidth+self.maxWidth)/2
        self.location.y=(self.minHeight+self.maxHeight)/2
        self.norm_speed=self.saved_speed
        self.velocity.x=love.math.random(2,3)
        self.velocity.y=love.math.random(-3,3)
        self:normalize_speed()
    end
end