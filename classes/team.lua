Team = Classe:extend()

function Team:new(teamColor)
    if teamColor == 1 then
        self.sprite = love.graphics.newImage('img/discRed.png')
    elseif teamColor == 2 then
        self.sprite = love.graphics.newImage('img/discBlue.png')
    end

    self.discs = Team:createDiscs()
    self.count = 1
end

function Team:update(dt)
    if gameState == 1 then
        local mouseX = love.mouse.getX()
        if mouseX >= love.graphics.getWidth()/4 and mouseX <= love.graphics.getWidth() - (love.graphics.getWidth()/4) then
            self.discs[self.count].position.x = love.mouse.getX()
        end
        self.discs[self.count].position.y = 800
    
    elseif gameState == 2 then
        if not self.discs[self.count].played then
            self.discs[self.count].velocity = self.discs[self.count].velocity + self.discs[self.count].acceleration * dt

            self.discs[self.count].played = true
        end

        self.discs[self.count].velocity = self.discs[self.count].velocity * (1 - self.discs[self.count].atrito * dt)

        self.discs[self.count].position = self.discs[self.count].position + self.discs[self.count].velocity * dt
        self.discs[self.count].center = Vetor(self.discs[self.count].position.x + 7, self.discs[self.count].position.y + 7)

        for i, disc in ipairs(self.discs) do
            if i ~= self.count and collided(self.discs[self.count], disc) then
                local direcao = (self.discs[self.count].position - disc.position):norm()
                
                local newVel1 = direcao * disc.velocity:getmag()
                local newVel2 = -direcao * self.discs[self.count].velocity:getmag()
                
                disc.velocity = newVel1
                self.discs[self.count].velocity = newVel2
            end
        end

        if self.discs[self.count].velocity:getmag() < 1 then
            self.discs[self.count].velocity = Vetor(0, 0)
            self.count = self.count + 1
            self.discs[self.count].stoped = true
            gameState = 1
        end
    end
end

function Team:draw()
    for i, disc in ipairs(self.discs) do
        love.graphics.draw(self.sprite, disc.position.x, disc.position.y, 0)
    end
end


function Team:createDiscs()
    local discs = {}
    
    local qtdeDiscs = 5
    local tamDisc = 15

    local larguraTela = love.graphics.getWidth()
    local alturaTela = love.graphics.getHeight()

    local espacamento = larguraTela / (qtdeDiscs + 1)

    for i = 1, qtdeDiscs do
        local disc = {
            position = Vetor(espacamento * i - tamDisc / 2, alturaTela - tamDisc),
            center = Vetor((espacamento * i - tamDisc / 2) + 7, (alturaTela - tamDisc) + 7),
            r = tamDisc/2,
            velocity = Vetor(0, 0),
            acceleration = Vetor(0, 0),
            atrito = 0.1,
            played = false,
            stoped = false
          }
        table.insert(discs, disc)
    end

    return discs
end