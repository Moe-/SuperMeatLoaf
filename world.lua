require("tileloader")
require("broccoli")
require("item")
require("pan")
require("oven")
require("player")



class "World" {
	screenWidth = 0;
	screenHeight = 0;
}

gTileSize = 64

gLevelsets = {
--  file, width, height, meat, salt, onion, spice
		{"maps/level01.tmx", 20, 15, 4, 4, 4, 4}
}

function World:__init(width, height, level)
	self.screenWidth = width;
	self.screenHeight = height;
	
	--self.tiles, self.layers = TiledMap_Parse("maps/level01.tmx")
	--TiledMap_Load("maps/level01.tmx")
	local file = love.filesystem.read(gLevelsets[level][1])
	local start = string.find(file, "<data encoding=\"csv\">") + 21
	local endPos = string.find(file, "</data>") - 1
	local data = file:sub(start, endPos)
	--print(data)
	self.level = {}
	self.width = gLevelsets[level][2]
	self.height = gLevelsets[level][3]
	for word in string.gmatch(data, "%d+") do 
		table.insert(self.level, tonumber(word)) 
	end
	print(self.width, self.height, #self.level)
	
	self:loadGfx()
	
	self.items = {}
	for y = 0, self.height - 1 do
		for x = 0, self.width - 1 do
			local id = self.level[y * self.width + x + 1]
			if id == 1 then
				self.player = Player:new(x * gTileSize, y * gTileSize, gLevelsets[level][4], gLevelsets[level][5], gLevelsets[level][6], gLevelsets[level][7])
				self.level[y * self.width + x + 1] = 0
			elseif id == 2 then
				self.broccoli = Broccoli:new(x * gTileSize, y * gTileSize)
				self.level[y * self.width + x + 1] = 0
			elseif id == 9 then
				table.insert(self.items, Item:new(x * gTileSize, y * gTileSize, "salt")) 
				self.level[y * self.width + x + 1] = 0
			elseif id == 10 then
				table.insert(self.items, Item:new(x * gTileSize, y * gTileSize, "spice")) 
				self.level[y * self.width + x + 1] = 0
			elseif id == 11 then
				table.insert(self.items, Item:new(x * gTileSize, y * gTileSize, "meat")) 
				self.level[y * self.width + x + 1] = 0
			elseif id == 12 then
				table.insert(self.items, Item:new(x * gTileSize, y * gTileSize, "onion")) 
				self.level[y * self.width + x + 1] = 0
			elseif id == 3 then
				self.pan = Pan:new(x * gTileSize, y * gTileSize) 
				self.level[y * self.width + x + 1] = 0
			elseif id == 17 then
				self.oven = Oven:new(x * gTileSize, y * gTileSize)
				self.level[y * self.width + x + 1] = 0
			end
		end
	end
	
	self.gameState = "alive"
end

function World:update(dt)
	self.gameState = self.player:update(dt, self.level, self.width, self.height, self.broccoli, self.items, self.pan, self.gameState)
		
	self.broccoli:update(dt)
	self.pan:update(dt, self.oven)
end

function World:loadGfx()	
	self.imgTile = love.graphics.newImage("gfx/tilemap.png")
	self.quadTile = love.graphics.newQuad(0, 0, self.imgTile:getWidth(), self.imgTile:getHeight(), self.imgTile:getWidth(), self.imgTile:getHeight())
end

function World:draw()
	love.graphics.setColor(255, 255, 255)
	--love.graphics.print('Hello World!', 400, 300)
	
	local offsetX = 10 * gTileSize
	local offsetY = 1 * gTileSize
	
	for y = 0, self.height - 1 do
		for x = 0, self.width - 1 do
			local id = self.level[x + 1 + y * self.width]
			if id > 0 then
				local srcX = (id - 1) % 4
				local srcY = math.floor((id - 1) / 4)
				local quad = love.graphics.newQuad(srcX * gTileSize, srcY * gTileSize, gTileSize, gTileSize, self.imgTile:getWidth(), self.imgTile:getHeight())
				love.graphics.draw(self.imgTile, quad, (x + 10) * gTileSize, (y+1) * gTileSize)
				--print(srcX * gTileSize, srcY * gTileSize, gTileSize, gTileSize, "=>", (x + 11) * gTileSize, y * gTileSize)
			end
		end
	end
	
	self.player:draw(offsetX, offsetY, self.screenWidth, self.screenHeight)
	self.broccoli:draw(offsetX, offsetY)
	self.pan:draw(offsetX, offsetY)
	self.oven:draw(offsetX, offsetY)
	
	for i, v in pairs(self.items) do
		v:draw(offsetX, offsetY)
	end
	
	if self.gameState == "dead" then
		love.graphics.setColor(255, 0, 0, 255)
    love.graphics.print("You have lost the game", self.screenWidth/3, 250, 0, 2, 2)
	elseif self.gameState == "won" then
		love.graphics.setColor(0, 0, 255, 255)
    love.graphics.print("You have won the game", self.screenWidth/3, 250, 0, 2, 2)
		local salt, spice, onion, meat = self.player:getResult()
		salt = math.abs(salt - 1)
		spice = math.abs(spice - 1)
		onion = math.abs(onion - 1)
		meat = math.abs(meat - 1)
		local sum = salt + spice + onion + meat
		if sum < 0.2 then
			love.graphics.setColor(0, 255, 255, 255)
			love.graphics.print("and you made good recipe!", self.screenWidth/3, 350, 0, 2, 2)
		else
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.print("but your recipe sucks!", self.screenWidth/3, 350, 0, 2, 2)
		end
	end
--	love.graphics.draw(self.background)
end

function World:keyreleased(key)
--	for i, v in pairs(self.players) do
--		v:keyreleased(key)
--	end
	self.player:keyreleased(key)
end

function World:keypressed(key, scancode, isrepeat)
--	if self.gameOver then return end
--	for i, v in pairs(self.players) do
--		v:keypressed(key, scancode, isrepeat)
--	end
	self.player:keypressed(key, scancode, isrepeat)
end