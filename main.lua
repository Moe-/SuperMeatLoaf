require("utils")
require("world")

gWorld = nil
gNextLevel = 1
gGameState = 0
gMenuColor = 0
gMenuDir = 1

function init()
	gWorld = World:new(1920,1080, gNextLevel)	
	math.randomseed(4)
end

function love.load()
	init()
end

function love.update(dt)
	if gGameState == 0 then
		gMenuColor = gMenuColor + gMenuDir
		if gMenuColor > 255 then
			gMenuColor = 255
			gMenuDir = -1
		elseif gMenuColor < 0 then
			gMenuColor = 0
			gMenuDir = 0
		end
	elseif gGameState == 1 then
		gWorld:update(dt)
	end
end

function love.draw()
	if gGameState == 0 then
		love.graphics.setColor(gMenuColor, 255 - gMenuColor, 0, 255)
    love.graphics.print("Press space to start", 1920/3, 500, 0, 4, 4)
	elseif gGameState == 1 then
		gWorld:draw()
	end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "t" then
			if gWorld ~= nil then
				gNextLevel = gWorld:getNextLevel()
			end
			init()
		elseif key == "space" then
			gGameState = 1
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
