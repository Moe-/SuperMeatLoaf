class "Oven" {
	posX = 0;
	posY = 0;
}

function Oven:__init(posX, posY)
	self.posX = posX
	self.posY = posY
	
	self:loadGfx()
end

function Oven:update(dt)

end
	
function Oven:loadGfx()	
	self.imgTile = love.graphics.newImage("gfx/tilemap.png")
	self.quadTile = love.graphics.newQuad(0 * gTileSize, 3 * gTileSize, 2 * gTileSize, 2 * gTileSize, self.imgTile:getWidth(), self.imgTile:getHeight())
end

function Oven:draw(offsetX, offsetY)
	love.graphics.draw(self.imgTile, self.quadTile, self.posX + offsetX - gTileSize, self.posY + offsetY - gTileSize)
end

function Oven:keyreleased(key)
--	for i, v in pairs(self.players) do
--		v:keyreleased(key)
--	end
end

function Oven:getPos()
	return self.posX, self.posY
end

function Oven:keypressed(key, scancode, isrepeat)
	--self.testoutput = self.speedY .. " " .. tostring(self.touchFloor)
--	if self.gameOver then return end
--	for i, v in pairs(self.players) do
--		v:keypressed(key, scancode, isrepeat)
--	end
end