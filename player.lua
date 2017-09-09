class "Player" {
	posX = 0;
	posY = 0;
	
	speedX = 0;
	speedY = 0;
}

gPlayerSpeed = 128

function Player:__init(posX, posY, meat, salt, onion, spice)
	self.posX = posX
	self.posY = posY
	
	self.speedX = 0
	self.speedY = 0
	
	self.meatTarget = meat
	self.saltTarget = salt
	self.onionTarget = onion
	self.spiceTarget = spice
	
	self.meat = 0
	self.salt = 0
	self.onion = 0
	self.spice = 0
	
	self.size = gTileSize
	
	self.nextJump = 0
	
	self.testoutput = ""
	self.touchFloor = false
	self.inPan = false
	
	self.animFrame = 0
	
	self:loadGfx()
end

function Player:update(dt, level, width, height, broccoli, items, pan, gameState)
	if self.inPan then
		self.posX, self.posY = pan:getPos()
		self.posX = self.posX + gTileSize/2
		return "won"
	end
	
	if gameState ~= "alive" then
		return gameState
	end
	
	--if self.speedY ~= 0 or self.speedY > gPlayerSpeed then
	local factor = 1
	if self.speedY > gPlayerSpeed/2 then
		factor = 6
	elseif self.speedY > 0 then
		factor = 4
	elseif self.speedY > -gPlayerSpeed then
		factor = 1.5
	else
		factor = 1
	end
		self.speedY = self.speedY + 2 * dt * gPlayerSpeed * factor
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
	
	self.touchFloor = false
	checkX = self.posX
	checkY = self.posY
	if self.speedY >= 0 then
		checkY = checkY + self.size
	else
		checkY = checkY - self.size
	end
	checkTile = level[math.floor(checkX / gTileSize) + math.floor(checkY / gTileSize) * width + 1]	
	if checkTile == nil then
		self.speedY = 0
	elseif ((checkTile >= 5 and checkTile <= 8) or checkTile >= 25) and self.speedY > 0 then
		self.touchFloor = true
		self.speedY = 0
	end
	
	self.posX = self.posX + 2 * self.speedX * dt
	self.posY = self.posY + self.speedY * dt
	
	if self.posX < 0 then self.posX = 0 end
	if self.posX >= width * gTileSize then self.posX = width * gTileSize - 1 end
	if self.posY < 0 then self.posY = 0 end
	if self.posY >= height * gTileSize then self.posY = height * gTileSize - 1 end
	
	broccoli:addPos(self.posX, self.posY)
	
	for i, v in pairs(items) do
		local itemX, itemY = v:getPos()
		local distance = getDistance(self.posX, self.posY, itemX, itemY)
		if distance < gTileSize / 2 then
			local iType = v:getType()
			if iType == "salt" then
				self.salt = self.salt + 1
			elseif iType == "spice" then
				self.spice = self.spice + 1
			elseif iType == "meat" then
				self.meat = self.meat + 1
			elseif iType == "onion" then
				self.onion = self.onion + 1
			end
			table.remove(items, i)
		end
	end
	
	
	local brocX, brocY = broccoli:getPos()
	local distance = getDistance(self.posX, self.posY, brocX, brocY)
	if distance < gTileSize / 2 then
		return "dead"
	end
	
	local panX, panY = pan:getPos()
	distance = getDistance(self.posX, self.posY, panX, panY)
	if distance < gTileSize / 2 then
		self.inPan = true
		pan:setPlayerInside()
	end
	
	
	self.nextJump = self.nextJump - dt
	return "alive"
end
	
function Player:loadGfx()	
	self.imgTile = love.graphics.newImage("gfx/spr_sml.png")
	--self.quadTile = love.graphics.newQuad(0 * gTileSize, 0 * gTileSize, 2 * gTileSize, 2 * gTileSize, self.imgTile:getWidth(), self.imgTile:getHeight())
end

function Player:draw(offsetX, offsetY, screenWidth, screenHeight)
	local yGfx = 0
	if self.speedY == 0 then
		yGfx = 0
	elseif self.speedY > 0 then
		yGfx = 4
	elseif self.speedY < 0 then
		yGfx = 2
	end
	if self.speedX < 0 then
		yGfx = yGfx + 1
	end
	
	if self.inPan then
		yGfx = 0
		self.animFrame = 0
	end
	
	local scale = (self.meat + self.meatTarget) / (2 * self.meatTarget)
	local offset = (scale - 0.5) * gTileSize;
	local quadTile = love.graphics.newQuad(self.animFrame * 2 * gTileSize, yGfx * 2 * gTileSize, 2 * gTileSize, 2 * gTileSize, self.imgTile:getWidth(), self.imgTile:getHeight())
	love.graphics.draw(self.imgTile, quadTile, self.posX + offsetX, self.posY + offsetY, 0, scale, scale)
	
	love.graphics.print(self.testoutput, 400, 300)
	
	local stat = "Meat: " .. self.meat .. "/" .. self.meatTarget
	stat = stat .. "    Salt: " .. self.salt .. "/" .. self.saltTarget
	stat = stat .. "    Spice: " .. self.spice .. "/" .. self.spiceTarget
	stat = stat .. "    Onion: " .. self.onion .. "/" .. self.onionTarget
	love.graphics.print(stat, 50, screenHeight - 200)
	
	self.animFrame = (self.animFrame + 1) % 30
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

function Player:getResult()
	return self.salt / self.saltTarget, self.spice / self.spiceTarget, self.onion / self.onionTarget, self.meat / self.meatTarget
end
