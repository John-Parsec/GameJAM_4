Jogo = Classe:extend()

--[[
States:
0 - Inicio do jogo pausado
1 - Jogo em progresso
2 - Disco se movendo
]]

function Jogo:new()
    gameState = 0
    score = 0

    display = Display()
    areas = Jogo:createAreas()
    team1 = Team(1)

    forca = 1000 -- |1000 - 6000
end

function Jogo:update(dt)

    -- Pré-jogo
    if gameState == 0 then
       if love.keyboard.isDown('space') then
            gameState = 1
       end
    end

    -- Jogo
    if gameState ~= 0 then
        for i, disc in ipairs(team1.discs) do
            for j, area in ipairs(areas) do
                if disc.stoped and collided (disc, area) then
                    score = score + (20 * j)
                end
            end
        end
    end

    print(score)

    if gameState == 1 then
        if love.keyboard.isDown('z') then
            team1.discs[team1.count].acceleration = Vetor(0, forca * -1)
            gameState = 2
        end
    end
    
    team1:update(dt)
    display:update(dt)
end

function Jogo:draw()
    display:draw()

    if gameState ~= 0 then
        team1:draw()
    elseif gameState == 2 then
        
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