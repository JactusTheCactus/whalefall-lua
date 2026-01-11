-- function love.load() end
-- function love.update() end
function love.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Welcome to 'Whalefall'!", 50, 50)
	love.graphics.rectangle("fill", 100, 100, 100, 100)
end
function love.quit()
	print("Closing Whalefall...")
end
-- function love.resize() end
-- function love.keypressed() end
-- function love.mousepressed() end
-- function love.touchpressed() end
