class "Pan" {
	posX = 0;
	posY = 0;
}

function Pan:__init(posX, posY)
	self.posX = posX
	self.posY = posY
	
	self.playerInside = false
	self:loadGfx()
end

function Pan:update(dt, oven)
	if self.playerInside then
		local ovenX, ovenY = oven:getPos()
		local distance = getDistance(ovenX, ovenY, self.posX, self.posY)
		if distance > gTileSize / 2 then
			self.posX = self.posX + dt * gTileSize * (ovenX - self.posX) / distance;
			self.posY = self.posY + dt * gTileSize * (ovenY - self.posY) / distance;
		else
			self.posX = ovenX;
			self.posY = ovenY;
		end
	end
end
	
function Pan:loadGfx()	
	self.imgTile = love.graphics.newImage("gfx/tilemap.png")
	self.quadTile = love.graphics.newQuad(2 * gTileSize, 0 * gTileSize, 2 * gTileSize, gTileSize, self.imgTile:getWidth(), self.imgTile:getHeight())
end

function Pan:draw(offsetX, offsetY)
	love.graphics.draw(self.imgTile, self.quadTile, self.posX + offsetX, self.posY + offsetY)
end

function Pan:keyreleased(key)
--	for i, v in pairs(self.players) do
--		v:keyreleased(key)
--	end
end

function Pan:getPos()
	return self.posX, self.posY
end

function Pan:setPlayerInside()
	self.playerInside = true
end

function Pan:keypressed(key, scancode, isrepeat)
	--self.testoutput = self.speedY .. " " .. tostring(self.touchFloor)
--	if self.gameOver then return end
--	for i, v in pairs(self.players) do
--		v:keypressed(key, scancode, isrepeat)
--	end
end