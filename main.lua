require("utils")
require("world")

gWorld = nil

function init()
	gWorld = World:new(1920,1080, 1)	
	math.randomseed(4)
end

function love.load()
	init()
end

function love.update(dt)
	gWorld:update(dt)
end

function love.draw()
	gWorld:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "t" then
			init()
		elseif key == "f4" then
			local screenshot = love.graphics.newScreenshot();
			screenshot:encode('png', os.time() .. '.png');
		end
		
		gWorld:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
	gWorld:keyreleased(key)
end

function love.mousepressed(x, y, button)
	
end

function love.mousereleased(x, y, button)
	
end

function love.mousemoved(x, y, dx, dy)
	
end

function love.wheelmoved(x, y)

end
