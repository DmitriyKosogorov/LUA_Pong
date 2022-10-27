require("arcanoid")
require("ball")
require("vector")
require("button")

local game={state={
    menu=true,
    running1=false,
    running2=false,
    victory=false,
    defeat=false
}}

local message=""
local wincount=3

function love.load()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    
    local button_width=300
    local start_height=200

    victory_sound=love.audio.newSource("resources/victory.wav", "static")
    defeat_sound=love.audio.newSource("resources/gameover.wav", "static")

    ismoved=false

    up=false
    down=false

    buttons={[1]=Button:create((width-button_width)/2,start_height,button_width,100,"1 player mode","1pm"),
            [2]=Button:create((width-button_width)/2,start_height+150,button_width,100,"2 player mode","2pm"),
            [3]=Button:create((width-button_width)/2,start_height+300,button_width,100,"exit","quit")}
    chosen_button=1



    border={[0]=10,[1]=10,[2]=width-20,[3]=height-20}

    love.graphics.setLineWidth(5)

    
    local velocity = Vector:create(love.math.random(1,2), love.math.random(-2,2))
    local location = Vector:create(width/2, height/2)
    ball=Ball:create(location,10,velocity,5,border[0], border[1], border[2], border[3])
    main_arcanoid=Arcanoid:create("R",20,80,width-100,(border[3]+border[1])/2,5,border[1],border[3], "UD")
    add_arcanoid=Arcanoid:create("L",20,80,100,(border[3]+border[1])/2,5,border[1],border[3], "WS")

end

function love.update(dt)
    if(game.state.menu) then
        if(love.keyboard.isDown("return")) then
            if(buttons[chosen_button]:getCommand()=="quit") then
                love.event.quit()
            elseif(buttons[chosen_button]:getCommand()=="1pm") then
                main_arcanoid:restart()
                add_arcanoid:restart()
                ball:restart()
                game.state.menu=false
                game.state.running1=true
            elseif(buttons[chosen_button]:getCommand()=="2pm") then
                main_arcanoid:restart()
                add_arcanoid:restart()
                ball:restart()
                game.state.menu=false
                game.state.running2=true
            end
        end
        if(ismoved==true) then
            ismoved=false
            love.timer.sleep(0.5)
        end
        if(down and chosen_button<#buttons)then
            chosen_button=chosen_button+1
            ismoved=true
            down=false
        end
        if(up and chosen_button>1)then
            chosen_button=chosen_button-1
            ismoved=true
            up=false
            --love.timer.sleep(1)
        end
 
    end
    --//========================================================================================================================
    if(game.state.running1 or game.state.running2) then
        ball:giveRightPoint(main_arcanoid)
        ball:giveLeftPoint(add_arcanoid)
        ball:startAgain()
        ball:checkBoundaries()
        ball:checkArcanoid(main_arcanoid)
        ball:checkArcanoid(add_arcanoid)
        ball:update()

        if love.keyboard.isDown("escape") then
            game.state.running1=false
            game.state.running2=false
            game.state.menu=true
        end

        if(add_arcanoid.counter>=wincount) then
            game.state.running1=false
            game.state.running2=false
            game.state.victory=true
            message="You Win!"
        end

        if(main_arcanoid.counter>=wincount) then
            game.state.running1=false
            game.state.running2=false
            game.state.defeat=true
            message="You Lose!!!"
        end

        if love.keyboard.isDown("up") then
            main_arcanoid:move("up")
        end

        if love.keyboard.isDown("down") then
            main_arcanoid:move("down")
        end
        if(game.state.running1) then
            if(ball.location.y>add_arcanoid.y_center+add_arcanoid.height/2) then
                add_arcanoid:move("down")
            elseif (ball.location.y<add_arcanoid.y_center-add_arcanoid.height/2) then
                add_arcanoid:move("up")
            end
        else
            if love.keyboard.isDown("w") then
                add_arcanoid:move("up")
            end
    
            if love.keyboard.isDown("s") then
                add_arcanoid:move("down")
            end
        end
    end
    --//========================================================================================================================
    if(game.state.victory or game.state.defeat)then
        if love.keyboard.isDown("escape") then
            game.state.victory=false
            game.state.defeat=false
            game.state.menu=true
        end
        if(game.state.victory)then
            if not victory_sound:isPlaying( ) then
                love.audio.play(victory_sound)
            end
        else
            if not defeat_sound:isPlaying( ) then
                love.audio.play(defeat_sound)
            end
        end      
    end
end

function love.draw()
    if(game.state.menu) then
        love.graphics.setFont(love.graphics.newFont(12))
        love.graphics.print("controls: Up,Down,w,s,Enter,Escape", 0, 0)
        love.graphics.setFont(love.graphics.newFont(80))
        love.graphics.print("nedoPong", 200, 50)
        for i, v in pairs(buttons) do
            v:draw()
        end
        love.graphics.circle("fill", 100, buttons[chosen_button]:getY()+buttons[chosen_button].height/2, 20) 
    end
    --//========================================================================================================================
    if(game.state.running1 or game.state.running2) then
        main_arcanoid:draw()
        add_arcanoid:draw()
        ball:draw()
        lineStipple((border[0]+border[2])/2,border[1],(border[0]+border[2])/2,border[3],30,10)
        love.graphics.rectangle("line", border[0], border[1], border[2], border[3])
        love.graphics.setFont(love.graphics.newFont(40))
        love.graphics.print(add_arcanoid.counter, ((border[0]+border[2])/2)+30,border[1]+30)
        love.graphics.print(main_arcanoid.counter, ((border[0]+border[2])/2)-60,border[1]+30)
    end
    --//========================================================================================================================
    if(game.state.victory or game.state.defeat)then
        love.graphics.setFont(love.graphics.newFont(60))
        love.graphics.print(message, 100,100)
    end
end

function lineStipple( x1, y1, x2, y2, dash, gap )
    local dash = dash or 10
    local gap  = dash + (gap or 10)

    local steep = math.abs(y2-y1) > math.abs(x2-x1)
    if steep then
        x1, y1 = y1, x1
        x2, y2 = y2, x2
    end
    if x1 > x2 then
        x1, x2 = x2, x1
        y1, y2 = y2, y1
    end

    local dx = x2 - x1
    local dy = math.abs( y2 - y1 )
    local err = dx / 2
    local ystep = (y1 < y2) and 1 or -1
    local y = y1
    local maxX = x2
    local pixelCount = 0
    local isDash = true
    local lastA, lastB, a, b

    for x = x1, maxX do
        pixelCount = pixelCount + 1
        if (isDash and pixelCount == dash) or (not isDash and pixelCount == gap) then
            pixelCount = 0
            isDash = not isDash
            a = steep and y or x
            b = steep and x or y
            if lastA then
                love.graphics.line( lastA, lastB, a, b )
                lastA = nil
                lastB = nil
            else
                lastA = a
                lastB = b
            end
        end

        err = err - dy
        if err < 0 then
            y = y + ystep
            err = err + dx
        end
    end
end

function love.keypressed(key)
    if(key=="up") then
        up=true
    end
    if(key=="down") then
        down=true
    end
end
