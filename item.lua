class "Item" {
	posX = 0;
	posY = 0;
}

function Item:__init(posX, posY, itemType)
	self.posX = posX
	self.posY = posY
	self.itemType = itemType
	
	self:loadGfx()
end

function Item:update(dt)
	self.posX = self.nextX[1]
	self.posY = self.nextY[1]
	table.remove(self.nextX, 1)
	table.remove(self.nextY, 1)
end
	
function Item:loadGfx()	
	self.imgTile = love.graphics.newImage("gfx/tilemap.png")
	local idx = 0
	if self.itemType == "salt" then
		idx = 0
	elseif self.itemType == "spice" then
		idx = 1
	elseif self.itemType == "meat" then
		idx = 2
	elseif self.itemType == "onion" then
		idx = 3
	end
	self.quadTile = love.graphics.newQuad(idx * gTileSize, 2 * gTileSize, gTileSize, gTileSize, self.imgTile:getWidth(), self.imgTile:getHeight())
end

function Item:draw(offsetX, offsetY)
	love.graphics.draw(self.imgTile, self.quadTile, self.posX + offsetX, self.posY + offsetY)
end

function Item:keyreleased(key)
--	for i, v in pairs(self.players) do
--		v:keyreleased(key)
--	end
end

function Item:getPos()
	return self.posX, self.posY
end

function Item:getType()
	return self.itemType
end

function Item:keypressed(key, scancode, isrepeat)
	--self.testoutput = self.speedY .. " " .. tostring(self.touchFloor)
--	if self.gameOver then return end
--	for i, v in pairs(self.players) do
--		v:keypressed(key, scancode, isrepeat)
--	end
end