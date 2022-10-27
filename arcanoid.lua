Arcanoid={}
Arcanoid.__index=Arcanoid

function Arcanoid:create(stat,width, height,x,y,speed,minHeight,maxHeight,controls)
    local arcanoid={}
    setmetatable(arcanoid, Arcanoid)
    arcanoid.stat=stat
    arcanoid.x_center=x
    arcanoid.y_center=y
    arcanoid.width=width
    arcanoid.height=height
    arcanoid.speed=speed
    arcanoid.minHeight=minHeight
    arcanoid.maxHeight=maxHeight
    arcanoid.controls=controls
    arcanoid.counter=0
    arcanoid.savedx=x
    arcanoid.savedy=y
    return arcanoid
end

function Arcanoid:draw()
    love.graphics.rectangle("fill", self.x_center-self.width/2, self.y_center-self.height/2,self.width, self.height)
end

function Arcanoid:move(direction)
    if(direction=="up" and self.y_center-(self.height/2)>=self.minHeight) then
        self.y_center=self.y_center-self.speed
    end
    if(direction=="down" and self.y_center+(self.height/2)<=self.maxHeight) then
        self.y_center=self.y_center+self.speed
    end

end

function Arcanoid:restart()
    self.x_center=self.savedx
    self.y_center=self.savedy
    self.counter=0
end