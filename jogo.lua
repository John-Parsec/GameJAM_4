Jogo = Classe:extend()

--[[
States:
0 - Inicio do jogo pausado
1 - Jogo em progresso
2 - 
3 - Disco se movendo
]]

function Jogo:new()
    gameState = 0

    display = Display()
    areas = Jogo:createAreas()
    team = {Team(1), Team(2)}
    actualTeam = 1
    turn = 1

    forca = 1000 -- |1000 - 6000

    winner = 'none'

    self.bar = love.graphics.newImage('img/bar.png')
    self.grid = anim8.newGrid(30 , 70, self.bar:getWidth(), self.bar:getHeight())

    self.barAnimation = anim8.newAnimation(self.grid('1-5', 1), 0.1)
end

function Jogo:update(dt)
    print(gameState)
    -- Pré-jogo
    if gameState == 0 then
       if love.keyboard.isDown('space') then
            gameState = 1
       end
    end

    -- Jogo
    if gameState ~= 0 then
        for i, disc in ipairs(team[actualTeam].discs) do
            for j, area in ipairs(areas) do
                if disc.stoped and collided (disc, area) then
                    score = score + (20 * j)
                end
            end
        end
    end

    print(gameState)

    if gameState == 1 then
        if love.keyboard.isDown('z') then
            self.barAnimation:resume()
            gameState = 2
        end
    elseif gameState == 2 then
        if love.keyboard.isDown('x') then
            self.barAnimation:pause()
            team[actualTeam].discs[team[actualTeam].count].acceleration = Vetor(0, forca * self.barAnimation.position * -1)
            gameState = 3
        end
    end

    for i, disc in ipairs(team[1].discs) do
        for j, disc2 in ipairs(team[2].discs) do
            if collided(disc2, disc) then
                local direcao = (disc2.position - disc.position):norm()
                
                local newVel1 = direcao * disc.velocity:getmag()
                local newVel2 = -direcao * disc2.velocity:getmag()
                
                disc.velocity = newVel1
                disc2.velocity = newVel2
            end
        end
    end

    --Fim de jogo
    if turn > 1 then
        if team[1].score > team[2].score then
            winner = "Red"
        elseif team[2].score > team[1].score then
            winner = "Blue"
        else
            winner = 'Draw'
        end

        gameState = 5
    end
    
    team[actualTeam]:update(dt)
    display:update(dt)
    self.barAnimation:update(dt)
end

function Jogo:draw()
    display:draw()

    if gameState ~= 0 then
        team[actualTeam]:draw()
        --team[2]:draw()
    end

    if gameState == 2 then
        self.barAnimation:draw(self.bar, 15, 730)
    elseif gameState == 3 then
        self.barAnimation:draw(self.bar, 15, 730)
    end

end

function Jogo:createAreas()
    local areas = {}
    local radius = 81

    for i = 1, 4 do
        local area = {
            center = Vetor.new(60, 124),
            r = radius
          }
        table.insert(areas, area)
        radius = radius - 20
    end

    return areas
end


function collided(circle1, circle2)
  local distance = circle2.center:dist(circle1.center)
  local distanceMin = circle1.r + circle2.r

  if distance <= distanceMin then
    return true
  end

  return false
end