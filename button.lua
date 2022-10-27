Button={}
Button.__index = Button

function Button:create(x, y,width, height, texter, command)
    local button = {}
    setmetatable(button, Button)

    button.x=x
    button.y=y
    button.width=width
    button.height=height
    button.texter=texter
    button.command=command



    return button
end

function Button:draw()
    love.graphics.setColor(.6,.6,.6)
    love.graphics.rectangle("fill", self.x, self.y,self.width, self.height)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.setColor(0,0,0)
    love.graphics.print(self.texter, self.x+(self.width-#self.texter*10)/2, self.y+self.height/2)
    love.graphics.setColor(255,255,255)
end

function Button:isinside(x,y)
    if (x>=self.x and x<=self.x+self.width and y>=self.y and y<=self.y+self.height) then
        return true
    end
    return false
end

function Button:getX()
    return self.x
end

function Button:getY()
    return self.y
end

function Button:getCommand()
    return self.command
end