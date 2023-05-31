function love.load()
    Classe = require "libraries/classic"
    Vetor = require "libraries/vector"

    require "classes/team"
    require "display"
    require "jogo"

    jogo = Jogo()
end

function love.update(dt)
    jogo:update(dt)
end

function love.draw()
    jogo:draw()
end