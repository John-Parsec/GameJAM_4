Display = Classe:extend()

function Display:new()
    self.background = love.graphics.newImage("img/map2.png")
    
    font = love.graphics.newFont("fonts/ThaleahFat.ttf", 16)
end

function Display:update(dt)
    
end

function Display:draw()

    local red = 147/255
    local green = 231/255
    local blue = 251/255

    love.graphics.setBackgroundColor(red, green, blue)
    
    -- Inicio do jogo
    if gameState == 0 then
        text = "Aperte ESPAÇO para começar"
        local x,y = love.graphics.getDimensions()
        local fx, fy = font.getWidth(font, text)/2, font.getHeight(font)/2
        love.graphics.setColor(0,0,0)
        love.graphics.print(text, x/2 - fx, y/2 - fy, 0, 1,1,0)
        love.graphics.setColor(255,255,255)
        
    elseif gameState ~= 0 then    
        love.graphics.draw(self.background, love.graphics.getWidth()/4, 0, 0)
    end
    
end