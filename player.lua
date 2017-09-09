class "Player" {
	posX = 0;
	posY = 0;
	
	speedX = 0;
	speedY = 0;
}

gPlayerSpeed = 128

function Player:__init(posX, posY)
	self.posX = posX
	self.posY = posY
	
	self.speedX = 0
	self.speedY = 0
	
	self.size = gTileSize
	
	self.nextJump = 0
	
	self.testoutput = ""
	self.touchFloor = false
	
	self:loadGfx()
end

function Player:update(dt, level, width, height, broccoli)
	--if self.speedY ~= 0 or self.speedY > gPlayerSpeed then
		self.speedY = self.speedY + 2 * dt * gPlayerSpeed
	--end
	
	local checkX = self.posX
	if self.speedX > 0 then
		checkX = checkX + self.size/2
	elseif self.speedX < 0 then
		checkX = checkX - self.size/2
	end
	local checkY = self.posY
	local checkTile = level[math.floor(checkX / gTileSize) + math.floor(checkY / gTileSize) * width + 1]
	if (checkTile >= 5 and checkTile <= 8) or checkTile >= 25 then
		self.speedX = -self.speedX
	end
	
	checkX = self.posX
	checkY = self.posY + self.size/2
	checkTile = level[math.floor(checkX / gTileSize) + math.floor(checkY / gTileSize) * width + 1]
	
		--self.testoutput = checkX .. " " .. checkY .. " => " .. math.floor(checkX / gTileSize) .. " " .. math.floor(checkY / gTileSize) .. " => " .. (math.floor(checkX / gTileSize) + math.floor(checkY / gTileSize) * width + 1) .. " " .. checkTile
	
	self.touchFloor = false
	if ((checkTile >= 5 and checkTile <= 8) or checkTile >= 25) and self.speedY > 0 then
		self.touchFloor = true
		self.speedY = 0
	end
	
	self.posX = self.posX + self.speedX * dt
	self.posY = self.posY + self.speedY * dt
	
	if self.posX < 0 then self.posX = 0 end
	if self.posX >= width * gTileSize then self.posX = width * gTileSize - 1 end
	if self.posY < 0 then self.posY = 0 end
	if self.posY >= height * gTileSize then self.posY = height * gTileSize - 1 end
	
	broccoli:addPos(self.posX, self.posY)
	
	local brocX, brocY = broccoli:getPos()
	local distance = getDistance(self.posX, self.posY, brocX, brocY)
	if distance < gTileSize / 2 then
		self.testoutput = "DEAD " .. distance
	else
		self.testoutput = "ALIVE " .. distance
	end
	
	self.nextJump = self.nextJump - dt
end
	
function Player:loadGfx()	
	self.imgTile = love.graphics.newImage("gfx/tilemap.png")
	self.quadTile = love.graphics.newQuad(0 * gTileSize, 0 * gTileSize, gTileSize, gTileSize, self.imgTile:getWidth(), self.imgTile:getHeight())
end

function Player:draw(offsetX, offsetY)
	love.graphics.draw(self.imgTile, self.quadTile, self.posX + offsetX, self.posY + offsetY)
	
	love.graphics.print(self.testoutput, 400, 300)
end

function Player:keyreleased(key)
--	for i, v in pairs(self.players) do
--		v:keyreleased(key)
--	end
end

function Player:keypressed(key, scancode, isrepeat)
	--self.testoutput = self.speedY .. " " .. tostring(self.touchFloor)
	print(tostring(self.touchFloor))
	if key == "w" and self.touchFloor == true then
		self.speedY = - 2 * gPlayerSpeed
		--self.nextJump = 2
	elseif key == "a" then
		self.speedX = -gPlayerSpeed
	elseif key == "d" then
		self.speedX = gPlayerSpeed
	end
--	if self.gameOver then return end
--	for i, v in pairs(self.players) do
--		v:keypressed(key, scancode, isrepeat)
--	end
end