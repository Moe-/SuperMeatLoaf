class "World" {
	screenWidth = 0;
	screenHeight = 0;
}

function World:__init(width, height)
	self.screenWidth = width;
	self.screenHeight = height;
end

function World:update(dt)
	
end

function World:loadGfx()	
	self.imgHuman = love.graphics.newImage("gfx/human.png")
	self.quadHuman = love.graphics.newQuad(0, 0, self.imgHuman:getWidth(), self.imgHuman:getHeight(), self.imgHuman:getWidth(), self.imgHuman:getHeight())
end

function World:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.print('Hello World!', 400, 300)
--	love.graphics.draw(self.background)
end

function World:keyreleased(key)
--	for i, v in pairs(self.players) do
--		v:keyreleased(key)
--	end
end

function World:keypressed(key, scancode, isrepeat)
--	if self.gameOver then return end
--	for i, v in pairs(self.players) do
--		v:keypressed(key, scancode, isrepeat)
--	end
end