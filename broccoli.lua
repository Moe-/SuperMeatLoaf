class "Broccoli" {
	posX = 0;
	posY = 0;
	
	speedX = 0;
	speedY = 0;
}

gPlayerSpeed = 128

function Broccoli:__init(posX, posY)
	self.posX = posX
	self.posY = -200
	
	self.nextX = {}
	self.nextY = {}
	for i = 1, 60 do
		table.insert(self.nextX, self.posX)
		table.insert(self.nextY, self.posY)
	end
	
	self:loadGfx()
end

function Broccoli:update(dt)
	self.posX = self.nextX[1]
	self.posY = self.nextY[1]
	table.remove(self.nextX, 1)
	table.remove(self.nextY, 1)
end
	
function Broccoli:loadGfx()	
	self.imgTile = love.graphics.newImage("gfx/tilemap.png")
	self.quadTile = love.graphics.newQuad(1 * gTileSize, 0 * gTileSize, gTileSize, gTileSize, self.imgTile:getWidth(), self.imgTile:getHeight())
end

function Broccoli:draw(offsetX, offsetY)
	love.graphics.draw(self.imgTile, self.quadTile, self.posX + offsetX, self.posY + offsetY)
end

function Broccoli:keyreleased(key)
--	for i, v in pairs(self.players) do
--		v:keyreleased(key)
--	end
end

function Broccoli:addPos(x, y)
	table.insert(self.nextX, x)
	table.insert(self.nextY, y)
end

function Broccoli:getPos()
	return self.posX, self.posY
end

function Broccoli:keypressed(key, scancode, isrepeat)
	--self.testoutput = self.speedY .. " " .. tostring(self.touchFloor)
--	if self.gameOver then return end
--	for i, v in pairs(self.players) do
--		v:keypressed(key, scancode, isrepeat)
--	end
end